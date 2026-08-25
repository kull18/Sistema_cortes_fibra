import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../database/pending_event_dao.dart';
import '../database/pending_photo_dao.dart';
import '../api/i_api.dart';
import '../api/api_exception.dart';

class EventSyncService {
  final IApi api;
  final PendingEventDao pendingEventDao;
  final PendingPhotoDao pendingPhotoDao;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  EventSyncService({
    required this.api, 
    required this.pendingEventDao,
    required this.pendingPhotoDao,
  });

  /// Debe llamarse una vez, al iniciar la app, para escuchar cambios de conectividad.
  void startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        syncAll();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _syncStatusController.close();
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await _syncPendingEvents();
      await _syncPendingPhotos();
    } finally {
      _isSyncing = false;
      _syncStatusController.add(SyncStatus.idle());
    }
  }

  Future<void> _syncPendingEvents() async {
    final pending = await pendingEventDao.getAllPending();
    if (pending.isEmpty) return;

    _syncStatusController.add(SyncStatus.syncing(total: pending.length, completed: 0));

    int completed = 0;
    for (final event in pending) {
      final localId = event['local_id'] as String;
      await pendingEventDao.markAsSyncing(localId);

      try {
        final result = await api.createEvent(
          originOfficeId: event['origin_office_id'] as int,
          destinationOfficeId: event['destination_office_id'] as int,
          latitude: event['latitude'] as double,
          longitude: event['longitude'] as double,
          locationMethod: event['location_method'] as String,
          accuracy: event['accuracy'] as double?,
          fieldReference: event['field_reference'] as String?,
          description: event['description'] as String,
        );

        final realEventId = result['id'] as int;

        // Punto clave: libera las fotos que estaban esperando este evento
        await pendingPhotoDao.linkPhotosToRealEvent(localId, realEventId);

        await pendingEventDao.deleteSynced(localId);
        completed++;
        _syncStatusController.add(SyncStatus.syncing(total: pending.length, completed: completed));
      } on ApiException catch (e) {
        await pendingEventDao.markAsFailed(localId, e.message);
      } on NetworkException {
        _syncStatusController.add(SyncStatus.error('Se perdió la conexión durante la sincronización de eventos'));
        break; 
      }
    }
  }

  Future<void> _syncPendingPhotos() async {
    final readyPhotos = await pendingPhotoDao.getReadyToUpload();
    if (readyPhotos.isEmpty) return;

    for (final photo in readyPhotos) {
      final localId = photo['local_id'] as String;
      final eventId = photo['real_event_id'] as int;
      final filePath = photo['local_file_path'] as String;
      final file = File(filePath);

      if (!await file.exists()) {
        await pendingPhotoDao.markAsFailed(localId, 'Archivo local no encontrado');
        continue;
      }

      await pendingPhotoDao.markAsSyncing(localId);

      try {
        final uploadUrlResult = await api.getEventPhotoUploadUrl(
          eventId: eventId,
          filename: filePath.split('/').last,
          contentHash: photo['content_hash'] as String,
        );

        if (uploadUrlResult['already_exists'] != true) {
          await _uploadFileToS3(uploadUrlResult['upload_url'] as String, file);
        }

        await api.createEventPhoto(
          eventId: eventId,
          objectKey: uploadUrlResult['object_key'] as String,
          label: photo['label'] as String?,
          sizeBytes: photo['size_bytes'] as int,
        );

        await pendingPhotoDao.deleteSynced(localId);
        if (await file.exists()) {
          await file.delete();
        }
      } on ApiException catch (e) {
        await pendingPhotoDao.markAsFailed(localId, e.message);
      } on NetworkException {
        _syncStatusController.add(SyncStatus.error('Se perdió la conexión durante la sincronización de fotos'));
        break;
      }
    }
  }

  Future<void> _uploadFileToS3(String uploadUrl, File file) async {
    final response = await http.put(
      Uri.parse(uploadUrl),
      body: await file.readAsBytes(),
      headers: {'Content-Type': 'image/jpeg'},
    );

    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al subir imagen a S3',
      );
    }
  }
}

class SyncStatus {
  final bool isSyncing;
  final int total;
  final int completed;
  final String? errorMessage;

  SyncStatus._({
    required this.isSyncing,
    this.total = 0,
    this.completed = 0,
    this.errorMessage,
  });

  factory SyncStatus.idle() => SyncStatus._(isSyncing: false);
  factory SyncStatus.syncing({required int total, required int completed}) =>
      SyncStatus._(isSyncing: true, total: total, completed: completed);
  factory SyncStatus.error(String message) =>
      SyncStatus._(isSyncing: false, errorMessage: message);
}
