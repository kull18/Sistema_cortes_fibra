import '../../../domain/entities/unread_count_entity.dart';

class UnreadCountModel extends UnreadCountEntity {
  const UnreadCountModel({required super.unreadCount});

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) {
    return UnreadCountModel(
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
