import 'dart:io';
import '../entities/unread_count_entity.dart';
import '../entities/central_office_entity.dart';
import '../entities/fiber_event.dart';
import '../entities/notification_entity.dart';

abstract class TechnicalRepository {
  Future<List<FiberEvent>> getEvents({String? status});
  Future<FiberEvent> getEvent(int eventId);
  Future<UnreadCountEntity> getUnreadNotificationsCount();

  // Central Offices
  Future<List<CentralOfficeEntity>> listCentralOffices();
  Future<CentralOfficeEntity> getCentralOffice(int officeId);
  Future<CentralOfficeEntity> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  });
  Future<CentralOfficeEntity> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  });
  Future<void> deleteCentralOffice(int officeId);

  // Events
  Future<FiberEvent> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  });

  Future<FiberEvent> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  });

  // Photos
  Future<Map<String, dynamic>> getEventPhotoUploadUrl({
    required int eventId,
    required String filename,
    required String contentHash,
  });

  Future<void> createEventPhoto({
    required int eventId,
    required String objectKey,
    String? label,
    int? sizeBytes,
  });

  Future<void> attachPhoto({
    required File imageFile,
    String? realEventId,
    String? pendingEventLocalId,
    String? label,
  });

  Future<List<Map<String, dynamic>>> listEventPhotos(int eventId);

  // Comments
  Future<List<Map<String, dynamic>>> listEventComments(int eventId);
  Future<Map<String, dynamic>> createEventComment(int eventId, String content);
  Future<void> deleteEventComment(int commentId);

  // Notifications
  Future<List<NotificationEntity>> listNotifications();
  Future<void> markNotificationAsRead(int notificationId);
}
