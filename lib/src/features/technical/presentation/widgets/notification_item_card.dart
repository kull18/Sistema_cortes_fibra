import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class NotificationItemCard extends StatelessWidget {
  final String id;
  final String time;
  final String title;
  final String description;
  final String location;
  final String icon;
  final bool isUnread;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const NotificationItemCard({
    super.key,
    required this.id,
    required this.time,
    required this.title,
    required this.description,
    required this.location,
    required this.icon,
    this.isUnread = false,
    this.onMarkAsRead,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF0F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread ? AppColors.primaryBlue : AppColors.borderSubtle.withOpacity(0.3),
          width: isUnread ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header: ID and Time
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                if (isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E9EA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
                  ),
                  child: Text(
                    id,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.textSecondary.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
          // Content: Icon, Title, Description, Location
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1F21),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/$icon',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_layers.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
          // Actions: Mark as read, Delete, View
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                if (isUnread)
                  GestureDetector(
                    onTap: onMarkAsRead,
                    child: Row(
                      children: const [
                        Icon(Icons.check, size: 18, color: AppColors.primaryBlue),
                        SizedBox(width: 6),
                        Text(
                          'Marcar leída',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_double_check.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(AppColors.statusGreen, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Leído',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.statusGreen,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: SvgPicture.asset(
                    'assets/icons/ic_trash.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8), // Reducido el espacio entre botones
                ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8E9EA),
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.borderSubtle.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Ver',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
