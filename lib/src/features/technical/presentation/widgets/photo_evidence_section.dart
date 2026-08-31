import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/numbered_section_card.dart';
import '../../domain/entities/photo_evidence.dart';
import 'photo_evidence_tile.dart';

class PhotoEvidenceSection extends StatelessWidget {
  final List<PhotoEvidence> evidences;
  final VoidCallback onAttach;
  final ValueChanged<PhotoEvidence> onDelete;

  const PhotoEvidenceSection({
    super.key,
    required this.evidences,
    required this.onAttach,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return NumberedSectionCard(
      stepNumber: 4,
      title: 'Evidencias Fotográficas',
      subtitle: 'Fotografías de respaldo (${evidences.length} adjuntadas)',
      iconAssetPath: 'assets/icons/ic_camera.svg',
      iconColor: AppColors.primaryBlue,
      iconBackgroundColor: AppColors.primaryBlueSoft,
      trailing: OutlinedButton.icon(
        onPressed: onAttach,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 32),
          side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2)),
          shape: const StadiumBorder(),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryBlue,
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(AppColors.primaryBlue.withOpacity(0.05)),
        ),
        icon: SvgPicture.asset(
          'assets/icons/ic_paperclip.svg',
          width: 14,
          height: 14,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBlue,
            BlendMode.srcIn,
          ),
        ),
        label: const Text(
          'Adjuntar',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: evidences.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Aún no hay fotografías adjuntas.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: evidences
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PhotoEvidenceTile(
                          evidence: e,
                          onDelete: () => onDelete(e),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
