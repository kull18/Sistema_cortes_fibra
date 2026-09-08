import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../domain/entities/fiber_event.dart';
import 'event_card.dart';
import 'event_filter_chips.dart';

class EventsSection extends StatelessWidget {
  final List<FiberEvent> events;
  final EventFilter selectedFilter;
  final ValueChanged<EventFilter> onChangedFilter;
  final VoidCallback onVerTodos;
  final ValueChanged<FiberEvent> onEventTap;

  const EventsSection({
    super.key,
    required this.events,
    required this.selectedFilter,
    required ValueChanged<EventFilter> onFilterChanged,
    required this.onVerTodos,
    required this.onEventTap,
  }) : onChangedFilter = onFilterChanged;

  List<FiberEvent> get _filteredEvents {
    switch (selectedFilter) {
      case EventFilter.activos:
        return events.where((e) => e.status == FiberEventStatus.activo).toList();
      case EventFilter.atendidos:
        return events.where((e) => e.status == FiberEventStatus.atendido).toList();
      case EventFilter.todos:
        return events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_alarm.svg',
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      AppColors.statusRed,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'ÚLTIMOS EVENTOS REGISTRADOS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onVerTodos,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver todos (${events.length})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/ic_arrow_right.svg',
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        EventFilterChips(selected: selectedFilter, onChanged: onChangedFilter),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No hay eventos en esta categoría.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = filtered[index];
              return EventCard(
                event: event,
                onVerDetalle: () => onEventTap(event),
              );
            },
          ),
      ],
    );
  }
}
