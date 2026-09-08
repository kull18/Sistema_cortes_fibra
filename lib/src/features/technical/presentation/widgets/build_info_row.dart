
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class BuildInfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const BuildInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/$icon',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}