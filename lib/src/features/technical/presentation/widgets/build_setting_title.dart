
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class BuildSettingTitle extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final  String title;
  final  String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const BuildSettingTitle({
    super.key,
    this.icon,
    this.iconData,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged
  });



  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: icon != null
                ? SvgPicture.asset(
              'assets/icons/$icon',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
            )
                : Icon(iconData, size: 16, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
            width: 44,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: AppColors.primaryBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}