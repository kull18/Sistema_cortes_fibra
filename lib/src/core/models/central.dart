/// Modelo de Central según sección 4 del documento de diseño.
/// Compartido entre Directorio de Centrales, Reportar Evento y Detalle de Evento.
class Central {
  final String id;
  final String prefix;
  final String cityLabel;
  final double? latitude;
  final double? longitude;

  const Central({
    required this.id,
    required this.prefix,
    required this.cityLabel,
    this.latitude,
    this.longitude,
  });
}