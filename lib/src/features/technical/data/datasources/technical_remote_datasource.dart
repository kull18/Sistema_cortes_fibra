import '../../../../core/api/i_api.dart';
import 'models/unread_count_model.dart';
import 'models/event_model.dart';

abstract class TechnicalRemoteDataSource {
  Future<List<EventModel>> getEvents({String? status});
  Future<EventModel> getEvent(int eventId);
  Future<UnreadCountModel> getUnreadNotificationsCount();

  // Central Offices
  Future<List<Map<String, dynamic>>> listCentralOffices();
  Future<Map<String, dynamic>> getCentralOffice(int officeId);
  Future<Map<String, dynamic>> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  });
  Future<Map<String, dynamic>> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  });
  Future<void> deleteCentralOffice(int officeId);

  // Events & Photos
  Future<EventModel> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  });
  Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  });

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

  Future<List<Map<String, dynamic>>> listEventPhotos(int eventId);

  // Comments
  Future<List<Map<String, dynamic>>> listEventComments(int eventId);
  Future<Map<String, dynamic>> createEventComment(int eventId, String content);
  Future<void> deleteEventComment(int commentId);

  // Notifications
  Future<List<Map<String, dynamic>>> listNotifications();
  Future<void> markNotificationAsRead(int notificationId);
}

class TechnicalRemoteDataSourceImpl implements TechnicalRemoteDataSource {
  final IApi api;

  TechnicalRemoteDataSourceImpl({required this.api});

  @override
  Future<List<EventModel>> getEvents({String? status}) async {
    final response = await api.listEvents(status: status);
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => EventModel.fromJson(json)).toList();
  }

  @override
  Future<EventModel> getEvent(int eventId) async {
    final response = await api.getEvent(eventId: eventId);
    return EventModel.fromJson(response);
  }

  @override
  Future<UnreadCountModel> getUnreadNotificationsCount() async {
    final response = await api.getUnreadCount();
    return UnreadCountModel.fromJson(response);
  }

  @override
  Future<List<Map<String, dynamic>>> listCentralOffices() async {
    final response = await api.listCentralOffices();
    final List<dynamic> data = response['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> getCentralOffice(int officeId) async {
    return await api.getCentralOffice(officeId: officeId);
  }

  @override
  Future<Map<String, dynamic>> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    return await api.createCentralOffice(
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<Map<String, dynamic>> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  }) async {
    return await api.updateCentralOffice(
      officeId: officeId,
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> deleteCentralOffice(int officeId) async {
    await api.deleteCentralOffice(officeId: officeId);
  }

  @override
  Future<EventModel> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  }) async {
    final response = await api.createEvent(
      originOfficeId: originOfficeId,
      destinationOfficeId: destinationOfficeId,
      latitude: latitude,
      longitude: longitude,
      locationMethod: locationMethod,
      accuracy: accuracy,
      fieldReference: fieldReference,
      description: description,
    );
    return EventModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  }) async {
    return await api.updateEvent(
      eventId: eventId,
      status: status,
      description: description,
      fieldReference: fieldReference,
    );
  }

  @override
  Future<Map<String, dynamic>> getEventPhotoUploadUrl({
    required int eventId,
    required String filename,
    required String contentHash,
  }) async {
    return await api.getEventPhotoUploadUrl(
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
  }) async {
    await api.createEventPhoto(
      eventId: eventId,
      objectKey: objectKey,
      label: label,
      sizeBytes: sizeBytes,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> listEventPhotos(int eventId) async {
    final response = await api.listEventPhotos(eventId: eventId);
    final List<dynamic> data = response['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> listEventComments(int eventId) async {
    final response = await api.listEventComments(eventId: eventId);
    final List<dynamic> data = response['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> createEventComment(int eventId, String content) async {
    return await api.createEventComment(eventId: eventId, content: content);
  }

  @override
  Future<void> deleteEventComment(int commentId) async {
    await api.deleteEventComment(commentId: commentId);
  }

  @override
  Future<List<Map<String, dynamic>>> listNotifications() async {
    final response = await api.listNotifications();
    final List<dynamic> data = response['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> markNotificationAsRead(int notificationId) async {
    await api.markNotificationAsRead(notificationId: notificationId);
  }
}
