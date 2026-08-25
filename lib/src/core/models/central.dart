class Central {
  final String id;
  final String prefix;
  final String cityLabel;
  final double latitude;
  final double longitude;

  const Central({
    required this.id,
    required this.prefix,
    required this.cityLabel,
    required this.latitude,
    required this.longitude,
  });

  factory Central.fromEntity(dynamic entity) {
    return Central(
      id: entity.id.toString(),
      prefix: entity.prefix,
      cityLabel: entity.city,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
