/// Contrato abstracto de todos los endpoints de la API de SCF.
/// Cada metodo retorna un Map<String, dynamic> (el JSON decodificado).
/// Cuando el endpoint responde una lista, viene envuelta como {'data': [...]}.
abstract class IApi {
  // ---------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------

  /// POST /auth/login
  Future<Map<String, dynamic>> login({
    required String technicianCode,
    required String password,
  });

  /// POST /auth/logout
  Future<Map<String, dynamic>> logout();

  /// POST /auth/change-password
  Future<Map<String, dynamic>> changePassword({required String newPassword});

  /// POST /auth/forgot-password
  Future<Map<String, dynamic>> forgotPassword({required String technicianCode});

  // ---------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------

  /// POST /users/bulk
  Future<Map<String, dynamic>> bulkCreateUsers({required List<String> phones});

  /// GET /users
  Future<Map<String, dynamic>> listUsers();

  /// GET /users/me/profile-photo-upload-url
  Future<Map<String, dynamic>> getProfilePhotoUploadUrl({required String filename});

  /// PATCH /users/me/complete-profile
  Future<Map<String, dynamic>> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  });

  // ---------------------------------------------------------------------
  // Central Offices
  // ---------------------------------------------------------------------

  /// POST /central-offices
  Future<Map<String, dynamic>> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  });

  /// GET /central-offices
  Future<Map<String, dynamic>> listCentralOffices();

  /// GET /central-offices/{id}
  Future<Map<String, dynamic>> getCentralOffice({required int officeId});

  /// PATCH /central-offices/{id}
  Future<Map<String, dynamic>> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  });

  /// DELETE /central-offices/{id}
  Future<Map<String, dynamic>> deleteCentralOffice({required int officeId});

  // ---------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------

  /// POST /events
  Future<Map<String, dynamic>> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod, // "GPS" | "MAP"
    double? accuracy,
    String? fieldReference,
    required String description,
  });

  /// GET /events?status=&reported_by=
  Future<Map<String, dynamic>> listEvents({String? status, String? reportedBy});

  /// GET /events/{id}
  Future<Map<String, dynamic>> getEvent({required int eventId});

  /// PATCH /events/{id}
  Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  });

  // ---------------------------------------------------------------------
  // Event Photos
  // ---------------------------------------------------------------------

  /// GET /event-photos/upload-url
  Future<Map<String, dynamic>> getEventPhotoUploadUrl({
    required int eventId,
    required String filename,
    required String contentHash,
  });

  /// POST /event-photos
  Future<Map<String, dynamic>> createEventPhoto({
    required int eventId,
    required String objectKey,
    String? label,
    int? sizeBytes,
  });

  /// GET /event-photos/event/{event_id}
  Future<Map<String, dynamic>> listEventPhotos({required int eventId});

  // ---------------------------------------------------------------------
  // Event Comments
  // ---------------------------------------------------------------------

  /// POST /event-comments
  Future<Map<String, dynamic>> createEventComment({
    required int eventId,
    required String content,
  });

  /// GET /event-comments/event/{event_id}
  Future<Map<String, dynamic>> listEventComments({required int eventId});

  /// DELETE /event-comments/{id}
  Future<Map<String, dynamic>> deleteEventComment({required int commentId});

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------

  /// GET /notifications
  Future<Map<String, dynamic>> listNotifications();

  /// GET /notifications/unread-count
  Future<Map<String, dynamic>> getUnreadCount();

  /// PATCH /notifications/{id}/read
  Future<Map<String, dynamic>> markNotificationAsRead({required int notificationId});

  /// POST /notifications/device-token
  Future<Map<String, dynamic>> registerDeviceToken({required String playerId});

  Future<Map<String, dynamic>> registerDevice({String? deviceLabel});
  Future<Map<String, dynamic>> deviceLogin({required String deviceToken});
}
