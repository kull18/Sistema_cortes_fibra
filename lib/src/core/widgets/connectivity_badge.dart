import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';

class ConnectivityBadge extends StatelessWidget {
  final bool isOnline;

  const ConnectivityBadge({super.key, this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    final statusColor = isOnline ? AppColors.statusGreen : AppColors.statusRed;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.connectivityBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isOnline
              ? AppColors.borderSubtle.withOpacity(0.3)
              : AppColors.statusRed.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_wifi.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                statusColor,
                BlendMode.srcIn,
              ),
            ),
            if (!isOnline)
              Transform.rotate(
                angle: -0.785, // Aproximadamente 45 grados en radianes
                child: Container(
                  width: 2,
                  height: 18,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(1),
                    // Pequeño borde blanco para que la línea se note más sobre el SVG
                    border: Border.all(color: AppColors.connectivityBg, width: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}