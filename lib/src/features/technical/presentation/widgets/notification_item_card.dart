import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';

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
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUnread ? colors.primaryBlueSoft : colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread ? colors.primaryBlue : colors.borderSubtle.withValues(alpha: 0.3),
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
                    decoration: BoxDecoration(
                      color: colors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    id,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: colors.textSecondary.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      time.startsWith('Fecha:') ? time : 'Fecha: $time',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: colors.borderSubtle),
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
                    color: colors.primaryBlueSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/$icon',
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary.withValues(alpha: 0.8),
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
                            colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.primaryBlue,
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
          Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: colors.borderSubtle),
          // Actions: Mark as read, Delete, View
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                if (isUnread)
                  GestureDetector(
                    onTap: onMarkAsRead,
                    child: Row(
                      children: [
                        Icon(Icons.check, size: 18, color: colors.primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Marcar leída',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryBlue,
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
                        colorFilter: ColorFilter.mode(colors.statusGreen, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Leído',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.statusGreen,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                if (onView != null)
                  TextButton.icon(
                    onPressed: onView,
                    icon: Icon(Icons.arrow_forward, size: 16, color: colors.primaryBlue),
                    label: Text(
                      'Ver evento',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryBlue,
                      ),
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
