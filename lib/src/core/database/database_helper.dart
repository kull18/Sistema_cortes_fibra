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
      version: 4,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createPendingEventsTable(db);
    }
    if (oldVersion < 3) {
      await _createPendingPhotosTable(db);
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE events ADD COLUMN reported_by_technician_code TEXT');
      await db.execute('ALTER TABLE events ADD COLUMN reported_by_full_name TEXT');
    }
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
        reported_by_technician_code TEXT,
        reported_by_full_name TEXT,
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

    // Cola de eventos pendientes (Offline sync)
    await _createPendingEventsTable(db);
    
    // Cola de fotos pendientes (Offline sync)
    await _createPendingPhotosTable(db);

    await db.execute('CREATE INDEX idx_events_status ON events (status)');
    await db.execute('CREATE INDEX idx_events_reported_at ON events (reported_at DESC)');
    await db.execute('CREATE INDEX idx_event_photos_event_id ON event_photos (event_id)');
  }

  Future<void> _createPendingEventsTable(Database db) async {
    await db.execute('''
      CREATE TABLE pending_events (
        local_id TEXT PRIMARY KEY,
        origin_office_id INTEGER NOT NULL,
        destination_office_id INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        location_method TEXT NOT NULL,
        accuracy REAL,
        field_reference TEXT,
        description TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'PENDING_SYNC',
        created_at TEXT NOT NULL,
        last_attempt_at TEXT,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      )
    ''');
  }

  Future<void> _createPendingPhotosTable(Database db) async {
    await db.execute('''
      CREATE TABLE pending_photos (
        local_id TEXT PRIMARY KEY,
        pending_event_local_id TEXT,
        real_event_id INTEGER,
        local_file_path TEXT NOT NULL,
        content_hash TEXT NOT NULL,
        label TEXT,
        size_bytes INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'PENDING_SYNC',
        created_at TEXT NOT NULL,
        last_attempt_at TEXT,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT,
        FOREIGN KEY (pending_event_local_id) REFERENCES pending_events (local_id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
