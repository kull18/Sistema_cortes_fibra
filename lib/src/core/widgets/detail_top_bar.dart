import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme_extensions.dart';
import 'app_header_actions.dart';

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
    final colors = context.colors;

    return Container(
      color: colors.background,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon: SvgPicture.asset(
              'assets/icons/ic_arrow_left.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (actions != null) ...actions!,
          const SizedBox(width: 8),
          AppHeaderActions(
            isOnline: isOnline,
            notificationCount: notificationCount,
            userImageUrl: avatarUrl,
            onNotificationTap: onNotificationTap,
            onAvatarTap: onAvatarTap,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
