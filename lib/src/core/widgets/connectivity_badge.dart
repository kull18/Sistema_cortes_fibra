import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';

class ConnectivityBadge extends StatelessWidget {
  final bool isOnline;

  const ConnectivityBadge({super.key, this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.connectivityBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/wifi.svg',
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            isOnline ? AppColors.statusGreen : AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
