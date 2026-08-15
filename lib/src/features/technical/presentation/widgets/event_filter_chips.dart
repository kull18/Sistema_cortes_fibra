import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

enum EventFilter { todos, activos, atendidos }

class EventFilterChips extends StatelessWidget {
  final EventFilter selected;
  final ValueChanged<EventFilter> onChanged;

  const EventFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip('Todos', EventFilter.todos),
          const SizedBox(width: 8),
          _chip('Activos', EventFilter.activos),
          const SizedBox(width: 8),
          _chip('Atendidos', EventFilter.atendidos),
        ],
      ),
    );
  }

  Widget _chip(String label, EventFilter value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}