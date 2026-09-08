class EventModel {
  final int id;
  final String type;
  final OfficeModel originOffice;
  final OfficeModel destinationOffice;
  final double latitude;
  final double longitude;
  final String locationMethod;
  final double? accuracy;
  final double? distanceToOrigin;
  final double? distanceToDestination;
  final String? fieldReference;
  final String description;
  final String status;
  final ReportedByModel reportedBy;
  final DateTime reportedAt;
  final List<Map<String, dynamic>> photos;

  EventModel({
    required this.id,
    required this.type,
    required this.originOffice,
    required this.destinationOffice,
    required this.latitude,
    required this.longitude,
    required this.locationMethod,
    this.accuracy,
    this.distanceToOrigin,
    this.distanceToDestination,
    this.fieldReference,
    required this.description,
    required this.status,
    required this.reportedBy,
    required this.reportedAt,
    this.photos = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final eventJson = (json.containsKey('data') && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final reportedByJson = eventJson['reported_by'];
    final ReportedByModel reportedByModel;
    if (reportedByJson is Map<String, dynamic>) {
      reportedByModel = ReportedByModel.fromJson(reportedByJson);
    } else if (eventJson['reported_by_id'] != null) {
      reportedByModel = ReportedByModel(
        id: eventJson['reported_by_id'] is int ? eventJson['reported_by_id'] : int.tryParse(eventJson['reported_by_id'].toString()) ?? 0,
        technicianCode: '',
        fullName: null,
      );
    } else {
      reportedByModel = ReportedByModel(
        id: 0,
        technicianCode: '',
        fullName: null,
      );
    }

    final rawPhotos = eventJson['photos'] as List<dynamic>? ?? [];
    final photoList = rawPhotos.map((p) {
      if (p is Map) {
        final map = Map<String, dynamic>.from(p);
        return <String, dynamic>{
          'id': map['id'],
          'event_id': map['event_id'],
          'url': map['url']?.toString() ?? '',
          'label': map['label']?.toString(),
          'size_bytes': map['size_bytes'],
          'uploaded_at': map['uploaded_at']?.toString(),
        };
      }
      return <String, dynamic>{};
    }).where((p) => p.isNotEmpty).toList();

    return EventModel(
      id: eventJson['id'],
      type: eventJson['type'],
      originOffice: OfficeModel.fromJson(eventJson['origin_office']),
      destinationOffice: OfficeModel.fromJson(eventJson['destination_office']),
      latitude: (eventJson['latitude'] as num).toDouble(),
      longitude: (eventJson['longitude'] as num).toDouble(),
      locationMethod: eventJson['location_method'],
      accuracy: eventJson['accuracy'] != null ? (eventJson['accuracy'] as num).toDouble() : null,
      distanceToOrigin: eventJson['distance_to_origin'] != null ? (eventJson['distance_to_origin'] as num).toDouble() : null,
      distanceToDestination: eventJson['distance_to_destination'] != null ? (eventJson['distance_to_destination'] as num).toDouble() : null,
      fieldReference: eventJson['field_reference'],
      description: eventJson['description'],
      status: eventJson['status'],
      reportedBy: reportedByModel,
      reportedAt: DateTime.parse(eventJson['reported_at']),
      photos: photoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'origin_office': originOffice.toJson(),
      'destination_office': destinationOffice.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'location_method': locationMethod,
      'accuracy': accuracy,
      'distance_to_origin': distanceToOrigin,
      'distance_to_destination': distanceToDestination,
      'field_reference': fieldReference,
      'description': description,
      'status': status,
      'reported_by': reportedBy.toJson(),
      'reported_at': reportedAt.toIso8601String(),
      'photos': photos,
    };
  }
}

class ReportedByModel {
  final int id;
  final String technicianCode;
  final String? fullName;

  ReportedByModel({
    required this.id,
    required this.technicianCode,
    this.fullName,
  });

  factory ReportedByModel.fromJson(Map<String, dynamic> json) {
    return ReportedByModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      technicianCode: json['technician_code']?.toString() ?? json['technicianCode']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'technician_code': technicianCode,
      'full_name': fullName,
    };
  }

  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      return fullName!;
    }
    if (technicianCode.trim().isNotEmpty) {
      return technicianCode;
    }
    return 'Técnico';
  }
}

class OfficeModel {
  final int id;
  final String prefix;
  final String name;
  final String city;

  OfficeModel({
    required this.id,
    required this.prefix,
    required this.name,
    required this.city,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    return OfficeModel(
      id: json['id'],
      prefix: json['prefix'],
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefix': prefix,
      'name': name,
      'city': city,
    };
  }
}
