import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';
import 'connectivity_badge.dart';
import 'notification_bell.dart';
import 'user_avatar.dart';

/// Header compartido por todas las screens autenticadas del área técnica.
/// Contiene: logo + nombre de app, badge de conectividad, notificaciones y avatar.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String appTitle;
  final bool isOnline;
  final int notificationCount;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const AppTopBar({
    super.key,
    this.appTitle = 'FiberTech Ops',
    this.isOnline = true,
    this.notificationCount = 0,
    this.avatarUrl,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    // Usamos SafeArea aquí para asegurar que el contenido no choque con el notch
    // independientemente de cómo se use este widget.
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryBlueSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_network_node.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryBlue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                appTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ConnectivityBadge(isOnline: isOnline),
            const SizedBox(width: 12),
            NotificationBell(
              count: notificationCount,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onAvatarTap,
              child: UserAvatar(imageUrl: avatarUrl, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
