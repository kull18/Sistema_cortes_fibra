import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/user_avatar.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String id;

  const UserHeader({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              const UserAvatar(
                imageUrl: null,
                size: 80,
                showStatusDot: true,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
