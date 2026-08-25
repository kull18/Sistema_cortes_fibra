enum NotificationType { eventCreated, eventComment, eventStatusChanged, unknown }

class NotificationEntity {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final int? relatedEventId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.relatedEventId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: _mapType(json['type']),
      relatedEventId: json['related_event_id'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static NotificationType _mapType(String type) {
    switch (type) {
      case 'EVENT_CREATED':
        return NotificationType.eventCreated;
      case 'EVENT_COMMENT':
        return NotificationType.eventComment;
      case 'EVENT_STATUS_CHANGED':
        return NotificationType.eventStatusChanged;
      default:
        return NotificationType.unknown;
    }
  }
}
