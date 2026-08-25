import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class EventLocalDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Reemplaza el cache completo de eventos.
  Future<void> replaceAll(List<Map<String, dynamic>> events) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.delete('events');
      await txn.delete('event_photos');

      for (final event in events) {
        final originOffice = event['origin_office'] as Map<String, dynamic>;
        final destinationOffice = event['destination_office'] as Map<String, dynamic>;

        await txn.insert('events', {
          'id': event['id'],
          'type': event['type'],
          'origin_office_id': originOffice['id'],
          'destination_office_id': destinationOffice['id'],
          'latitude': event['latitude'],
          'longitude': event['longitude'],
          'location_method': event['location_method'],
          'accuracy': event['accuracy'],
          'distance_to_origin': event['distance_to_origin'],
          'distance_to_destination': event['distance_to_destination'],
          'field_reference': event['field_reference'],
          'description': event['description'],
          'status': event['status'],
          'reported_by_id': event['reported_by_id'],
          'reported_at': event['reported_at'],
          'synced_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        final photos = event['photos'] as List<dynamic>? ?? [];
        for (final photo in photos) {
          await txn.insert('event_photos', {
            'id': photo['id'],
            'event_id': event['id'],
            'label': photo['label'],
            'size_bytes': photo['size_bytes'],
            'uploaded_at': photo['uploaded_at'],
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
  }

  /// Trae los eventos cacheados reconstruyendo la forma anidada.
  Future<List<Map<String, dynamic>>> getCachedEvents({String? status}) async {
    final db = await _dbHelper.database;

    final events = await db.query(
      'events',
      where: status != null ? 'status = ?' : null,
      whereArgs: status != null ? [status] : null,
      orderBy: 'reported_at DESC',
    );

    final result = <Map<String, dynamic>>[];

    for (final event in events) {
      final originOffice = await db.query(
        'central_offices',
        where: 'id = ?',
        whereArgs: [event['origin_office_id']],
      );
      final destinationOffice = await db.query(
        'central_offices',
        where: 'id = ?',
        whereArgs: [event['destination_office_id']],
      );
      final photos = await db.query(
        'event_photos',
        where: 'event_id = ?',
        whereArgs: [event['id']],
      );

      // Reconstruct the nested structure to match API response
      final Map<String, dynamic> reconstructed = Map<String, dynamic>.from(event);
      reconstructed['origin_office'] = originOffice.isNotEmpty ? originOffice.first : null;
      reconstructed['destination_office'] = destinationOffice.isNotEmpty ? destinationOffice.first : null;
      reconstructed['photos'] = photos;
      
      result.add(reconstructed);
    }

    return result;
  }

  Future<DateTime?> getLastSyncTime() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT MAX(synced_at) as last_sync FROM events',
    );
    final lastSync = result.first['last_sync'] as String?;
    return lastSync != null ? DateTime.parse(lastSync) : null;
  }
}
