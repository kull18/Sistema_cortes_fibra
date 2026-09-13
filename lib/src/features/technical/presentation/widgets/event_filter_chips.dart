import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

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
          _chip(context, 'Todos', EventFilter.todos),
          const SizedBox(width: 8),
          _chip(context, 'Activos', EventFilter.activos),
          const SizedBox(width: 8),
          _chip(context, 'Atendidos', EventFilter.atendidos),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, EventFilter value) {
    final colors = context.colors;
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryBlue : colors.surface,
          border: Border.all(
            color: isSelected ? colors.primaryBlue : colors.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
