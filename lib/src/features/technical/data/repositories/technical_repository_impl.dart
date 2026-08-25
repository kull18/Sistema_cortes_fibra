import 'package:sistema_cortes_fibra/src/core/api/api_exception.dart';
import 'package:sistema_cortes_fibra/src/core/database/event_local_dao.dart';
import 'package:sistema_cortes_fibra/src/core/database/central_office_local_dao.dart';

import '../../domain/entities/unread_count_entity.dart';
import '../../domain/entities/central_office_entity.dart';
import '../../domain/repositories/technical_repository.dart';
import '../../domain/entities/fiber_event.dart';
import '../../domain/entities/notification_entity.dart';
import '../datasources/technical_remote_datasource.dart';
import '../datasources/mappers/technical_mapper.dart';

class TechnicalRepositoryImpl implements TechnicalRepository {
  final TechnicalRemoteDataSource remoteDataSource;
  final EventLocalDao eventLocalDao;
  final CentralOfficeLocalDao centralOfficeLocalDao;

  TechnicalRepositoryImpl({
    required this.remoteDataSource,
    required this.eventLocalDao,
    required this.centralOfficeLocalDao,
  });

  @override
  Future<List<FiberEvent>> getEvents({String? status}) async {
    try {
      final models = await remoteDataSource.getEvents(status: status);
      // Actualizar caché local (persistimos los modelos convertidos a Map)
      await eventLocalDao.replaceAll(models.map((m) => m.toJson()).toList());
      return models.map((model) => TechnicalMapper.toFiberEventEntity(model)).toList();
    } on NetworkException {
      // Sin red: caemos al caché local
      final cached = await eventLocalDao.getCachedEvents(status: status);
      return cached.map((json) => TechnicalMapper.toFiberEventEntity(TechnicalMapper.toEventModel(json))).toList();
    }
  }

  @override
  Future<FiberEvent> getEvent(int eventId) async {
    try {
      final model = await remoteDataSource.getEvent(eventId);
      return TechnicalMapper.toFiberEventEntity(model);
    } on NetworkException {
      // Podríamos buscar uno individual en el caché si fuera necesario
      final cached = await eventLocalDao.getCachedEvents();
      final eventJson = cached.firstWhere(
        (e) => e['id'] == eventId,
        orElse: () => throw const NetworkException('Evento no encontrado en el caché local'),
      );
      return TechnicalMapper.toFiberEventEntity(TechnicalMapper.toEventModel(eventJson));
    }
  }

  @override
  Future<UnreadCountEntity> getUnreadNotificationsCount() async {
    try {
      final model = await remoteDataSource.getUnreadNotificationsCount();
      return TechnicalMapper.toUnreadCountEntity(model);
    } on NetworkException {
      return const UnreadCountEntity(unreadCount: 0);
    }
  }

  @override
  Future<List<CentralOfficeEntity>> listCentralOffices() async {
    try {
      final data = await remoteDataSource.listCentralOffices();
      // Sincronizar centrales completas cada vez que hay red
      await centralOfficeLocalDao.replaceAll(data);
      return data.map((json) => CentralOfficeEntity.fromJson(json)).toList();
    } on NetworkException {
      final cached = await centralOfficeLocalDao.getCachedOffices();
      return cached.map((json) => CentralOfficeEntity.fromJson(json)).toList();
    }
  }

  @override
  Future<CentralOfficeEntity> getCentralOffice(int officeId) async {
    try {
      final data = await remoteDataSource.getCentralOffice(officeId);
      return CentralOfficeEntity.fromJson(data);
    } on NetworkException {
      final cached = await centralOfficeLocalDao.getCachedOffice(officeId);
      if (cached != null) return CentralOfficeEntity.fromJson(cached);
      throw const NetworkException('Central no encontrada en el caché local');
    }
  }

  @override
  Future<CentralOfficeEntity> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    final data = await remoteDataSource.createCentralOffice(
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
    return CentralOfficeEntity.fromJson(data);
  }

  @override
  Future<CentralOfficeEntity> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  }) async {
    final data = await remoteDataSource.updateCentralOffice(
      officeId: officeId,
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
    return CentralOfficeEntity.fromJson(data);
  }

  @override
  Future<void> deleteCentralOffice(int officeId) async {
    await remoteDataSource.deleteCentralOffice(officeId);
  }

  @override
  Future<FiberEvent> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  }) async {
    final model = await remoteDataSource.createEvent(
      originOfficeId: originOfficeId,
      destinationOfficeId: destinationOfficeId,
      latitude: latitude,
      longitude: longitude,
      locationMethod: locationMethod,
      accuracy: accuracy,
      fieldReference: fieldReference,
      description: description,
    );
    return TechnicalMapper.toFiberEventEntity(model);
  }

  @override
  Future<FiberEvent> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  }) async {
    final data = await remoteDataSource.updateEvent(
      eventId: eventId,
      status: status,
      description: description,
      fieldReference: fieldReference,
    );
    return TechnicalMapper.toFiberEventEntity(TechnicalMapper.toEventModel(data));
  }

  @override
  Future<Map<String, dynamic>> getEventPhotoUploadUrl({
    required int eventId,
    required String filename,
    required String contentHash,
  }) {
    return remoteDataSource.getEventPhotoUploadUrl(
      eventId: eventId,
      filename: filename,
      contentHash: contentHash,
    );
  }

  @override
  Future<void> createEventPhoto({
    required int eventId,
    required String objectKey,
    String? label,
    int? sizeBytes,
  }) {
    return remoteDataSource.createEventPhoto(
      eventId: eventId,
      objectKey: objectKey,
      label: label,
      sizeBytes: sizeBytes,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> listEventPhotos(int eventId) {
    return remoteDataSource.listEventPhotos(eventId);
  }

  @override
  Future<List<Map<String, dynamic>>> listEventComments(int eventId) {
    return remoteDataSource.listEventComments(eventId);
  }

  @override
  Future<Map<String, dynamic>> createEventComment(int eventId, String content) {
    return remoteDataSource.createEventComment(eventId, content);
  }

  @override
  Future<void> deleteEventComment(int commentId) {
    return remoteDataSource.deleteEventComment(commentId);
  }

  @override
  Future<List<NotificationEntity>> listNotifications() async {
    final data = await remoteDataSource.listNotifications();
    return data.map((json) => NotificationEntity.fromJson(json)).toList();
  }

  @override
  Future<void> markNotificationAsRead(int notificationId) {
    return remoteDataSource.markNotificationAsRead(notificationId);
  }
}
