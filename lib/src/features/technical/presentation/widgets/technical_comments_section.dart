import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/technical_comment.dart';
import 'technical_comment_tile.dart';

class TechnicalCommentsSection extends StatelessWidget {
  final List<TechnicalComment> comments;

  const TechnicalCommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.2)),
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.2)),
                ),
                child: Icon(Icons.comment_outlined, size: 20, color: colors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comentarios Técnicos (${comments.length})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Bitácora de campo y observaciones',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
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
