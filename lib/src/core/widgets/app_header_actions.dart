import 'package:flutter/material.dart';
import 'connectivity_badge.dart';
import 'notification_bell.dart';
import 'user_avatar.dart';

class AppHeaderActions extends StatelessWidget {
  final bool isOnline;
  final int notificationCount;
  final String? userImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const AppHeaderActions({
    super.key,
    this.isOnline = true,
    this.notificationCount = 0,
    this.userImageUrl,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConnectivityBadge(isOnline: isOnline),
        const SizedBox(width: 16),
        NotificationBell(
          count: notificationCount,
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onAvatarTap,
          child: UserAvatar(
            imageUrl: userImageUrl,
            size: 32,
            showStatusDot: true,
          ),
        ),
      ],
    );
  }
}
