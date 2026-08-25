class CentralOfficeEntity {
  final int id;
  final String prefix;
  final String name;
  final String city;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CentralOfficeEntity({
    required this.id,
    required this.prefix,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CentralOfficeEntity.fromJson(Map<String, dynamic> json) {
    return CentralOfficeEntity(
      id: json['id'],
      prefix: json['prefix'],
      name: json['name'],
      city: json['city'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefix': prefix,
      'name': name,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
