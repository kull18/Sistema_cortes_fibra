import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class PendingPhotoDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, dynamic> pendingPhoto) async {
    final db = await _dbHelper.database;
    await db.insert('pending_photos', pendingPhoto);
  }

  /// Fotos listas para subir: o ya tienen real_event_id, o su evento
  /// padre ya termino de sincronizar (ver linkPhotosToRealEvent).
  Future<List<Map<String, dynamic>>> getReadyToUpload() async {
    final db = await _dbHelper.database;
    return db.query(
      'pending_photos',
      where: "status IN ('PENDING_SYNC', 'FAILED') AND real_event_id IS NOT NULL",
      orderBy: 'created_at ASC',
    );
  }

  /// Cuando un evento offline sincroniza y obtiene su id real, esto
  /// "libera" sus fotos encoladas para que puedan subir.
  Future<void> linkPhotosToRealEvent(String pendingEventLocalId, int realEventId) async {
    final db = await _dbHelper.database;
    await db.update(
      'pending_photos',
      {'real_event_id': realEventId},
      where: 'pending_event_local_id = ?',
      whereArgs: [pendingEventLocalId],
    );
  }

  Future<void> markAsSyncing(String localId) async {
    final db = await _dbHelper.database;
    await db.update('pending_photos', {'status': 'SYNCING'},
        where: 'local_id = ?', whereArgs: [localId]);
  }

  Future<void> markAsFailed(String localId, String error) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
      UPDATE pending_photos
      SET status = 'FAILED', last_error = ?, last_attempt_at = ?, attempt_count = attempt_count + 1
      WHERE local_id = ?
    ''', [error, DateTime.now().toIso8601String(), localId]);
  }

  Future<void> deleteSynced(String localId) async {
    final db = await _dbHelper.database;
    await db.delete('pending_photos', where: 'local_id = ?', whereArgs: [localId]);
  }

  Future<int> countPending() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM pending_photos WHERE status IN ('PENDING_SYNC', 'FAILED')",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
