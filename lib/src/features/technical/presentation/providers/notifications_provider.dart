import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/list_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';

class NotificationsProvider extends ChangeNotifier {
  final ListNotificationsUseCase listNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  NotificationsProvider({
    required this.listNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  });

  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await listNotificationsUseCase.execute();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await markNotificationAsReadUseCase.execute(notificationId);
      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationEntity(
          id: _notifications[index].id,
          title: _notifications[index].title,
          body: _notifications[index].body,
          type: _notifications[index].type,
          relatedEventId: _notifications[index].relatedEventId,
          isRead: true,
          createdAt: _notifications[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }
}
