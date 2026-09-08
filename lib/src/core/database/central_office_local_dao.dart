import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class CentralOfficeLocalDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> replaceAll(List<Map<String, dynamic>> offices) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.delete('central_offices');
      for (final office in offices) {
        await txn.insert('central_offices', {
          'id': office['id'],
          'prefix': office['prefix'],
          'name': office['name'],
          'city': office['city'],
          'latitude': office['latitude'],
          'longitude': office['longitude'],
          'synced_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCachedOffices() async {
    final db = await _dbHelper.database;
    return db.query('central_offices', orderBy: 'prefix ASC');
  }

  Future<Map<String, dynamic>?> getCachedOffice(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'central_offices',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
