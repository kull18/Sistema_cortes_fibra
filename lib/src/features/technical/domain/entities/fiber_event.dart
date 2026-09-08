import 'reported_by.dart';

enum FiberEventStatus { activo, atendido, cerrado, pendiente }

class FiberEvent {
  final String id;
  final int? rawId;
  final String title;
  final String description;
  final String originPrefix;
  final String destinationPrefix;
  final String kmReference;
  final String location;
  final String timeLabel;
  final String reporterName;
  final ReportedBy? reportedBy;
  final FiberEventStatus status;
  final double? latitude;
  final double? longitude;
  final double? distanceToOrigin;
  final double? distanceToDestination;
  final List<Map<String, dynamic>> photos;

  const FiberEvent({
    required this.id,
    this.rawId,
    required this.title,
    required this.description,
    required this.originPrefix,
    required this.destinationPrefix,
    required this.kmReference,
    required this.location,
    required this.timeLabel,
    required this.reporterName,
    this.reportedBy,
    required this.status,
    this.latitude,
    this.longitude,
    this.distanceToOrigin,
    this.distanceToDestination,
    this.photos = const [],
  });

  String get reporterDisplay {
    if (reportedBy != null && reportedBy!.displayName.trim().isNotEmpty) {
      return reportedBy!.displayName;
    }
    if (reporterName.trim().isNotEmpty) {
      return reporterName;
    }
    return 'Técnico';
  }
}
