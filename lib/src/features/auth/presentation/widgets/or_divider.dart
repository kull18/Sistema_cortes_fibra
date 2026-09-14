import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class OrDivider extends StatelessWidget {
  final String label;

  const OrDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: colors.borderSubtle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: colors.borderSubtle),
          ),
        ],
      ),
    );
  }
}
