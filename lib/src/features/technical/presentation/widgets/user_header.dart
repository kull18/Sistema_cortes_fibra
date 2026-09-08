import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/widgets/user_avatar.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String id;
  final String? imageUrl;

  const UserHeader({
    super.key,
    required this.name,
    required this.id,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = context.responsiveValue<double>(
      small: 64.0,
      medium: 80.0,
    );
    final titleFontSize = context.responsiveValue<double>(
      small: 18.0,
      medium: 22.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(
                imageUrl: imageUrl,
                size: avatarSize,
                showStatusDot: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      id,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.borderSubtle, thickness: 0.5),
        ],
      ),
    );
  }
}
