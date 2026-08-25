import '../../../domain/entities/fiber_event.dart';

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
  final int reportedById;
  final DateTime reportedAt;

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
    required this.reportedById,
    required this.reportedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      type: json['type'],
      originOffice: OfficeModel.fromJson(json['origin_office']),
      destinationOffice: OfficeModel.fromJson(json['destination_office']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationMethod: json['location_method'],
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
      distanceToOrigin: json['distance_to_origin'] != null ? (json['distance_to_origin'] as num).toDouble() : null,
      distanceToDestination: json['distance_to_destination'] != null ? (json['distance_to_destination'] as num).toDouble() : null,
      fieldReference: json['field_reference'],
      description: json['description'],
      status: json['status'],
      reportedById: json['reported_by_id'],
      reportedAt: DateTime.parse(json['reported_at']),
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
      'reported_by_id': reportedById,
      'reported_at': reportedAt.toIso8601String(),
    };
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
