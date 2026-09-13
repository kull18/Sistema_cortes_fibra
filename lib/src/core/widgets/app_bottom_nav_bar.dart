import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../theme/theme_extensions.dart';

enum AppTab { inicio, centrales, reportar, eventos, perfil }

/// Bottom navigation compartida entre Home, Centrales, Reportar, Eventos y Perfil.
class AppBottomNavBar extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.user?.role == 'ADMIN';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                iconPath: 'assets/icons/ic_home.svg',
                label: 'Inicio',
                isSelected: currentTab == AppTab.inicio,
                onTap: () => onTabSelected(AppTab.inicio),
              ),
              if (isAdmin)
                _NavItem(
                  iconPath: 'assets/icons/ic_layers.svg',
                  label: 'Centrales',
                  isSelected: currentTab == AppTab.centrales,
                  onTap: () => onTabSelected(AppTab.centrales),
                ),
              _NavItem(
                iconPath: 'assets/icons/ic_plus.svg',
                label: 'Reportar',
                isSelected: currentTab == AppTab.reportar,
                onTap: () => onTabSelected(AppTab.reportar),
              ),
              _NavItem(
                iconPath: 'assets/icons/ic_vital_signs.svg',
                label: 'Eventos',
                isSelected: currentTab == AppTab.eventos,
                onTap: () => onTabSelected(AppTab.eventos),
              ),
              _NavItem(
                iconPath: 'assets/icons/ic_user.svg',
                label: 'Perfil',
                isSelected: currentTab == AppTab.perfil,
                onTap: () => onTabSelected(AppTab.perfil),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isSelected ? colors.primaryBlue : colors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
