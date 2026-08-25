import 'package:flutter/material.dart';
import '../../domain/entities/fiber_event.dart';
import '../../domain/entities/technical_comment.dart';
import '../../domain/usecases/get_event_usecase.dart';
import '../../domain/usecases/update_event_usecase.dart';
import '../../domain/usecases/list_event_photos_usecase.dart';
import '../../domain/usecases/list_event_comments_usecase.dart';
import '../../domain/usecases/create_event_comment_usecase.dart';
import '../../domain/usecases/delete_event_comment_usecase.dart';

class EventDetailProvider extends ChangeNotifier {
  final GetEventUseCase getEventUseCase;
  final UpdateEventUseCase updateEventUseCase;
  final ListEventPhotosUseCase listEventPhotosUseCase;
  final ListEventCommentsUseCase listEventCommentsUseCase;
  final CreateEventCommentUseCase createEventCommentUseCase;
  final DeleteEventCommentUseCase deleteEventCommentUseCase;

  EventDetailProvider({
    required this.getEventUseCase,
    required this.updateEventUseCase,
    required this.listEventPhotosUseCase,
    required this.listEventCommentsUseCase,
    required this.createEventCommentUseCase,
    required this.deleteEventCommentUseCase,
  });

  FiberEvent? _event;
  FiberEvent? get event => _event;

  List<Map<String, dynamic>> _photos = [];
  List<Map<String, dynamic>> get photos => _photos;

  List<TechnicalComment> _comments = [];
  List<TechnicalComment> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadEventDetail(String folio) async {
    final eventId = int.tryParse(folio.split('-').last);
    if (eventId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        getEventUseCase.execute(eventId),
        listEventPhotosUseCase.execute(eventId),
        listEventCommentsUseCase.execute(eventId),
      ]);

      _event = results[0] as FiberEvent;
      _photos = results[1] as List<Map<String, dynamic>>;
      
      final rawComments = results[2] as List<Map<String, dynamic>>;
      _comments = rawComments.map((c) {
        final author = c['author'] as Map<String, dynamic>;
        final createdAt = DateTime.parse(c['created_at']);
        return TechnicalComment(
          userName: author['full_name'],
          userRole: 'Técnico', // Podrías expandir esto si el backend lo da
          userAvatar: '',
          timeAgo: _formatTimeLabel(createdAt),
          exactTime: '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}',
          content: c['content'],
        );
      }).toList();

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment(String content) async {
    if (_event == null) return false;
    final eventId = int.parse(_event!.id.split('-').last);

    try {
      await createEventCommentUseCase.execute(eventId, content);
      await loadEventDetail(_event!.id); // Reload to get the new comment with author info
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> changeStatus(FiberEventStatus newStatus) async {
    if (_event == null) return false;
    final eventId = int.parse(_event!.id.split('-').last);

    String statusStr;
    switch (newStatus) {
      case FiberEventStatus.activo: statusStr = 'ACTIVE'; break;
      case FiberEventStatus.atendido: statusStr = 'RESOLVED'; break;
      case FiberEventStatus.cerrado: statusStr = 'CLOSED'; break;
      default: return false;
    }

    try {
      _event = await updateEventUseCase.execute(eventId: eventId, status: statusStr);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  String _formatTimeLabel(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inMinutes < 60) return '${difference.inMinutes} min';
    if (difference.inHours < 24) return '${difference.inHours} h';
    return '${dateTime.day}/${dateTime.month}';
  }
}
