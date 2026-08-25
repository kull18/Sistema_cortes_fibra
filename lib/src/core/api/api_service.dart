import 'dart:convert';
import 'package:http/http.dart' as http;

import 'i_api.dart';
import 'api_exception.dart';

class ApiService implements IApi {
  final String baseUrl;
  String? _authToken;

  ApiService({required this.baseUrl});

  /// Se llama tras un login exitoso, o al restaurar sesion desde storage.
  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    Map<String, String>? cleanQuery;

    if (query != null) {
      final filtered = Map<String, dynamic>.from(query)
        ..removeWhere((key, value) => value == null);
      cleanQuery = filtered.map((key, value) => MapEntry(key, value.toString()));
    }

    return Uri.parse('$baseUrl$path').replace(queryParameters: cleanQuery);
  }

  Future<Map<String, dynamic>> _send(
      String method,
      Uri uri, {
        Map<String, dynamic>? body,
      }) async {
    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: _headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: _headers, body: jsonEncode(body ?? {}));
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: _headers, body: jsonEncode(body ?? {}));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: _headers);
          break;
        default:
          throw ArgumentError('Unsupported method: $method');
      }
    } catch (e) {
      throw NetworkException(e.toString());
    }

    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return {};

      final decoded = jsonDecode(response.body);

      // Los endpoints de listado devuelven un array JSON crudo;
      // lo envolvemos para cumplir el contrato "todo regresa un Map".
      if (decoded is List) return {'data': decoded};
      if (decoded is Map<String, dynamic>) return decoded;

      return {'data': decoded};
    }

    String message = 'Error desconocido';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['detail'] != null) {
        message = decoded['detail'].toString();
      }
    } catch (_) {
      message = response.reasonPhrase ?? message;
    }

    throw ApiException(statusCode: statusCode, message: message);
  }

  // ---------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> login({
    required String technicianCode,
    required String password,
  }) {
    return _send('POST', _uri('/auth/login'), body: {
      'technician_code': technicianCode,
      'password': password,
    });
  }

  @override
  Future<Map<String, dynamic>> logout() {
    return _send('POST', _uri('/auth/logout'));
  }

  @override
  Future<Map<String, dynamic>> changePassword({required String newPassword}) {
    return _send('POST', _uri('/auth/change-password'), body: {
      'new_password': newPassword,
    });
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String technicianCode}) {
    return _send('POST', _uri('/auth/forgot-password'), body: {
      'technician_code': technicianCode,
    });
  }

  @override
  Future<Map<String, dynamic>> registerDevice({String? deviceLabel}) {
    return _send('POST', _uri('/auth/register-device'), body: {
      if (deviceLabel != null) 'device_label': deviceLabel,
    });
  }

  @override
  Future<Map<String, dynamic>> deviceLogin({required String deviceToken}) {
    return _send('POST', _uri('/auth/device-login'), body: {
      'device_token': deviceToken,
    });
  }

  // ---------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> bulkCreateUsers({required List<String> phones}) {
    return _send('POST', _uri('/users/bulk'), body: {
      'users': phones.map((p) => {'phone': p}).toList(),
    });
  }

  @override
  Future<Map<String, dynamic>> listUsers() {
    return _send('GET', _uri('/users'));
  }

  @override
  Future<Map<String, dynamic>> getProfilePhotoUploadUrl({required String filename}) {
    return _send('GET', _uri('/users/me/profile-photo-upload-url', {'filename': filename}));
  }

  @override
  Future<Map<String, dynamic>> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  }) {
    return _send('PATCH', _uri('/users/me/complete-profile'), body: {
      'full_name': fullName,
      if (email != null) 'email': email,
      if (jobTitle != null) 'job_title': jobTitle,
      if (profilePhotoKey != null) 'profile_photo_key': profilePhotoKey,
    });
  }

  // ---------------------------------------------------------------------
  // Central Offices
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> createCentralOffice({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  }) {
    return _send('POST', _uri('/central-offices'), body: {
      'prefix': prefix,
      'name': name,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<Map<String, dynamic>> listCentralOffices() {
    return _send('GET', _uri('/central-offices'));
  }

  @override
  Future<Map<String, dynamic>> getCentralOffice({required int officeId}) {
    return _send('GET', _uri('/central-offices/$officeId'));
  }

  @override
  Future<Map<String, dynamic>> updateCentralOffice({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  }) {
    return _send('PATCH', _uri('/central-offices/$officeId'), body: {
      if (prefix != null) 'prefix': prefix,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  @override
  Future<Map<String, dynamic>> deleteCentralOffice({required int officeId}) {
    return _send('DELETE', _uri('/central-offices/$officeId'));
  }

  // ---------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> createEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  }) {
    return _send('POST', _uri('/events'), body: {
      'origin_office_id': originOfficeId,
      'destination_office_id': destinationOfficeId,
      'latitude': latitude,
      'longitude': longitude,
      'location_method': locationMethod,
      if (accuracy != null) 'accuracy': accuracy,
      if (fieldReference != null) 'field_reference': fieldReference,
      'description': description,
    });
  }

  @override
  Future<Map<String, dynamic>> listEvents({String? status}) {
    return _send('GET', _uri('/events', status != null ? {'status': status} : null));
  }

  @override
  Future<Map<String, dynamic>> getEvent({required int eventId}) {
    return _send('GET', _uri('/events/$eventId'));
  }

  @override
  Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  }) {
    return _send('PATCH', _uri('/events/$eventId'), body: {
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (fieldReference != null) 'field_reference': fieldReference,
    });
  }

  // ---------------------------------------------------------------------
  // Event Photos
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getEventPhotoUploadUrl({
    required int eventId,
    required String filename,
    required String contentHash,
  }) {
    return _send(
      'GET',
      _uri('/event-photos/upload-url', {
        'event_id': eventId,
        'filename': filename,
        'content_hash': contentHash,
      }),
    );
  }

  @override
  Future<Map<String, dynamic>> createEventPhoto({
    required int eventId,
    required String objectKey,
    String? label,
    int? sizeBytes,
  }) {
    return _send('POST', _uri('/event-photos'), body: {
      'event_id': eventId,
      'object_key': objectKey,
      if (label != null) 'label': label,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
    });
  }

  @override
  Future<Map<String, dynamic>> listEventPhotos({required int eventId}) {
    return _send('GET', _uri('/event-photos/event/$eventId'));
  }

  // ---------------------------------------------------------------------
  // Event Comments
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> createEventComment({
    required int eventId,
    required String content,
  }) {
    return _send('POST', _uri('/event-comments'), body: {
      'event_id': eventId,
      'content': content,
    });
  }

  @override
  Future<Map<String, dynamic>> listEventComments({required int eventId}) {
    return _send('GET', _uri('/event-comments/event/$eventId'));
  }

  @override
  Future<Map<String, dynamic>> deleteEventComment({required int commentId}) {
    return _send('DELETE', _uri('/event-comments/$commentId'));
  }

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> listNotifications() {
    return _send('GET', _uri('/notifications'));
  }

  @override
  Future<Map<String, dynamic>> getUnreadCount() {
    return _send('GET', _uri('/notifications/unread-count'));
  }

  @override
  Future<Map<String, dynamic>> markNotificationAsRead({required int notificationId}) {
    return _send('PATCH', _uri('/notifications/$notificationId/read'));
  }

  @override
  Future<Map<String, dynamic>> registerDeviceToken({required String playerId}) {
    return _send('POST', _uri('/notifications/device-token'), body: {
      'player_id': playerId,
    });
  }
}
