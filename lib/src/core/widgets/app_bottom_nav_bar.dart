import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';

enum AppTab { inicio, reportar, eventos, perfil }

/// Bottom navigation compartida entre Home, Reportar, Eventos y Perfil.
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                iconPath: 'assets/icons/casa.svg',
                label: 'Inicio',
                isSelected: currentTab == AppTab.inicio,
                onTap: () => onTabSelected(AppTab.inicio),
              ),
              _NavItem(
                iconPath: 'assets/icons/mas.svg',
                label: 'Reportar',
                isSelected: currentTab == AppTab.reportar,
                onTap: () => onTabSelected(AppTab.reportar),
              ),
              _NavItem(
                iconPath: 'assets/icons/signos_vitales.svg',
                label: 'Eventos',
                isSelected: currentTab == AppTab.eventos,
                onTap: () => onTabSelected(AppTab.eventos),
              ),
              _NavItem(
                iconPath: 'assets/icons/persona.svg',
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
    // Al estar seleccionado se pinta de negro, sino gris.
    final color = isSelected ? Colors.black : const Color(0xFF6B7280);

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
