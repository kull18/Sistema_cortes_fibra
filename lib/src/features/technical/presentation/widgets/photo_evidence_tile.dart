import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../models/photo_evidence.dart';

class PhotoEvidenceTile extends StatelessWidget {
  final PhotoEvidence evidence;
  final VoidCallback onDelete;

  const PhotoEvidenceTile({
    super.key,
    required this.evidence,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: evidence.localPath != null
                ? Image.asset(
              evidence.localPath!,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            )
                : Container(
              width: 44,
              height: 44,
              color: AppColors.primaryBlueSoft,
              child: SvgPicture.asset(
                'assets/icons/ic_camera.svg',
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evidence.label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${evidence.timeLabel} \u00b7 ${evidence.sizeLabel}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: SvgPicture.asset(
              'assets/icons/ic_trash.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.statusRed,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
