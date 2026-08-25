import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'scf_local.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Centrales
    await db.execute('''
      CREATE TABLE central_offices (
        id INTEGER PRIMARY KEY,
        prefix TEXT NOT NULL,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        synced_at TEXT NOT NULL
      )
    ''');

    // Eventos
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        origin_office_id INTEGER NOT NULL,
        destination_office_id INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        location_method TEXT NOT NULL,
        accuracy REAL,
        distance_to_origin REAL NOT NULL,
        distance_to_destination REAL NOT NULL,
        field_reference TEXT,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        reported_by_id INTEGER NOT NULL,
        reported_at TEXT NOT NULL,
        synced_at TEXT NOT NULL,
        FOREIGN KEY (origin_office_id) REFERENCES central_offices (id),
        FOREIGN KEY (destination_office_id) REFERENCES central_offices (id)
      )
    ''');

    // Fotos (Metadata)
    await db.execute('''
      CREATE TABLE event_photos (
        id INTEGER PRIMARY KEY,
        event_id INTEGER NOT NULL,
        label TEXT,
        size_bytes INTEGER,
        uploaded_at TEXT NOT NULL,
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_events_status ON events (status)');
    await db.execute('CREATE INDEX idx_events_reported_at ON events (reported_at DESC)');
    await db.execute('CREATE INDEX idx_event_photos_event_id ON event_photos (event_id)');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
