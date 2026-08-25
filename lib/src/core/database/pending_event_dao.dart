import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class PendingEventDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insert(Map<String, dynamic> pendingEvent) async {
    final db = await _dbHelper.database;
    await db.insert('pending_events', pendingEvent);
  }

  Future<List<Map<String, dynamic>>> getAllPending() async {
    final db = await _dbHelper.database;
    return db.query(
      'pending_events',
      where: "status IN (?, ?)",
      whereArgs: ['PENDING_SYNC', 'FAILED'],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markAsSyncing(String localId) async {
    final db = await _dbHelper.database;
    await db.update(
      'pending_events',
      {'status': 'SYNCING'},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> markAsFailed(String localId, String error) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
      UPDATE pending_events
      SET status = 'FAILED', last_error = ?, last_attempt_at = ?, attempt_count = attempt_count + 1
      WHERE local_id = ?
    ''', [error, DateTime.now().toIso8601String(), localId]);
  }

  Future<void> deleteSynced(String localId) async {
    final db = await _dbHelper.database;
    await db.delete('pending_events', where: 'local_id = ?', whereArgs: [localId]);
  }

  Future<int> countPending() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM pending_events WHERE status IN ('PENDING_SYNC', 'FAILED')",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
