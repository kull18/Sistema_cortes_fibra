import 'package:flutter/material.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';

class CentralChipSelector extends StatelessWidget {
  final List<Central> options;
  final Central? selected;
  final Color accentColor;
  final ValueChanged<Central> onSelected;

  const CentralChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.accentColor = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64, // Altura fija para el carrusel horizontal
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        padding: const EdgeInsets.symmetric(vertical: 2),
        itemBuilder: (context, index) {
          final central = options[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildChip(central),
          );
        },
      ),
    );
  }

  Widget _buildChip(Central central) {
    final isSelected = selected?.id == central.id;

    return GestureDetector(
      onTap: () => onSelected(central),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 105, // Ancho fijo para mantener consistencia en el carrusel
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          border: Border.all(
            color: isSelected ? accentColor : AppColors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              central.prefix,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              central.cityLabel,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}