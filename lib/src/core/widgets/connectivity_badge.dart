import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme_extensions.dart';

class ConnectivityBadge extends StatelessWidget {
  final bool isOnline;

  const ConnectivityBadge({super.key, this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statusColor = isOnline ? colors.statusGreen : colors.statusRed;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colors.connectivityBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isOnline
              ? colors.borderSubtle.withValues(alpha: 0.3)
              : colors.statusRed.withValues(alpha: 0.2),
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
                    border: Border.all(color: colors.connectivityBg, width: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
