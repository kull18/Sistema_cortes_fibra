import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_header_actions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';

class EventDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String folio;
  final VoidCallback onBack;

  const EventDetailAppBar({
    super.key,
    required this.folio,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.background,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Detalle de Evento',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Folio #$folio',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppHeaderActions(
              isOnline: true,
              notificationCount: homeProvider.unreadCount,
              userImageUrl: user?.profilePhotoUrl,
              onNotificationTap: () => Navigator.pushNamed(context, '/notifications'),
              onAvatarTap: () => Navigator.pushNamed(context, '/perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
