import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme_extensions.dart';
import 'app_header_actions.dart';

/// Header compartido por todas las screens autenticadas del área técnica.
/// Contiene: logo + nombre de app y las acciones globales (Wifi, Notif, Perfil).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String appTitle;
  final String? subtitle;
  final bool isOnline;
  final int notificationCount;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const AppTopBar({
    super.key,
    this.appTitle = 'FiberTech Ops',
    this.subtitle,
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
    final colors = context.colors;

    return SafeArea(
      bottom: false,
      child: Container(
        color: colors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primaryBlueSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_network_node.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    colors.primaryBlue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            AppHeaderActions(
              isOnline: isOnline,
              notificationCount: notificationCount,
              userImageUrl: avatarUrl,
              onNotificationTap: onNotificationTap,
              onAvatarTap: onAvatarTap,
            ),
          ],
        ),
      ),
    );
  }
}
