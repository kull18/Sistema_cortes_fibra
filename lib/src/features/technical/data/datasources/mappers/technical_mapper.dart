import '../../../domain/entities/unread_count_entity.dart';
import '../../../domain/entities/fiber_event.dart';
import '../models/unread_count_model.dart';
import '../models/event_model.dart';

class TechnicalMapper {
  static UnreadCountEntity toUnreadCountEntity(UnreadCountModel model) {
    return UnreadCountEntity(unreadCount: model.unreadCount);
  }

  static FiberEvent toFiberEventEntity(EventModel model) {
    return FiberEvent(
      id: 'EV-${model.reportedAt.year}-${model.id.toString().padLeft(3, '0')}',
      title: model.type == 'FIBER_CUT' ? 'Corte Total de Fibra Monomodo' : 'Incidencia de Red',
      description: model.description,
      originPrefix: model.originOffice.prefix,
      destinationPrefix: model.destinationOffice.prefix,
      kmReference: 'Km ${model.distanceToOrigin?.toStringAsFixed(1) ?? '0.0'}',
      location: model.fieldReference ?? '${model.originOffice.city} - ${model.destinationOffice.city}',
      timeLabel: _formatTimeLabel(model.reportedAt),
      reporterName: 'ID: ${model.reportedById}', // El backend no devuelve el nombre directamente aquí
      status: _mapStatus(model.status),
    );
  }

  static FiberEventStatus _mapStatus(String status) {
    switch (status) {
      case 'ACTIVE':
        return FiberEventStatus.activo;
      case 'RESOLVED':
        return FiberEventStatus.atendido;
      case 'CLOSED':
        return FiberEventStatus.cerrado;
      default:
        return FiberEventStatus.pendiente;
    }
  }

  static String _formatTimeLabel(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static EventModel toEventModel(Map<String, dynamic> map) {
    return EventModel.fromJson(map);
  }
}
