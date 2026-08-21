import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class SecuritySection extends StatelessWidget {
  final VoidCallback onChangePassword;

  const SecuritySection({super.key, required this.onChangePassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_shield_check.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Seguridad',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle, thickness: 0.5),
          Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              dense: true,
              leading: SvgPicture.asset(
                'assets/icons/ic_key.svg',
                width: 20,
                height: 20,
              ),
              title: const Text(
                'Cambiar Contraseña de Acceso',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: onChangePassword,
            ),
          ),
        ],
      ),
    );
  }
}
