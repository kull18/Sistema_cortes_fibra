import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../models/technical_comment.dart';
import 'technical_comment_tile.dart';

class TechnicalCommentsSection extends StatelessWidget {
  final List<TechnicalComment> comments;

  const TechnicalCommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
                ),
                child: const Icon(Icons.comment_outlined, size: 20, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Comentarios Técnicos (3)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Bitácora de campo y observaciones',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...comments.map((c) => TechnicalCommentTile(comment: c)),
        ],
      ),
    );
  }
}
