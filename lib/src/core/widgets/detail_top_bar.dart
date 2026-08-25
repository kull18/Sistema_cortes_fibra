import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';
import 'connectivity_badge.dart';
import 'notification_bell.dart';
import 'user_avatar.dart';

/// Header con botón de regreso + título, compartido por todas las screens
/// de detalle/formulario (Reportar, Ubicación, Confirmar, Detalle de Evento...).
class DetailTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool isOnline;
  final int notificationCount;
  final String? avatarUrl;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final List<Widget>? actions;

  const DetailTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.isOnline = true,
    this.notificationCount = 0,
    this.avatarUrl,
    this.onBack,
    this.onNotificationTap,
    this.onAvatarTap,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon: SvgPicture.asset(
              'assets/icons/ic_arrow_left.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (actions != null) ...actions!,
          const SizedBox(width: 8),
          ConnectivityBadge(isOnline: isOnline),
          const SizedBox(width: 12),
          NotificationBell(count: notificationCount, onTap: onNotificationTap),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onAvatarTap,
            child: UserAvatar(imageUrl: avatarUrl, size: 32),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
