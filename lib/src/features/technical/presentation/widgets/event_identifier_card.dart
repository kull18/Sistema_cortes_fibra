import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';

class EventIdentifierCard extends StatelessWidget {
  final String folio;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const EventIdentifierCard({
    super.key,
    required this.folio,
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: colors.cardHeaderBg,
            width: double.infinity,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_file.svg',
                  width: 18,
                  colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Text(
                  'IDENTIFICADOR ÚNICO DE EVENTO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.primaryBlue.withValues(alpha: 0.3), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NÚMERO DE FOLIO',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              folio,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onCopy,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_copy.svg',
                                width: 16,
                                colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Copiar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onShare,
                        child: SvgPicture.asset(
                          'assets/icons/ic_share.svg',
                          width: 22,
                          colorFilter: ColorFilter.mode(colors.textSecondary, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Guarde este identificador para dar seguimiento con el Centro de Control.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 1.4,
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
