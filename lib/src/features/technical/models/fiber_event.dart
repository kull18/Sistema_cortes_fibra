enum FiberEventStatus { activo, atendido, pendiente }

class FiberEvent {
  final String id;
  final String title;
  final String originPrefix;
  final String destinationPrefix;
  final String kmReference;
  final String location;
  final String timeLabel;
  final FiberEventStatus status;

  const FiberEvent({
    required this.id,
    required this.title,
    required this.originPrefix,
    required this.destinationPrefix,
    required this.kmReference,
    required this.location,
    required this.timeLabel,
    required this.status,
  });
}