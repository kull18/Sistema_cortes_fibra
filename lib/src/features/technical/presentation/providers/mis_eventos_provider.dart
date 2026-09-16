import 'package:flutter/material.dart';
import 'package:sistema_cortes_fibra/src/core/api/api_exception.dart';
import '../../domain/entities/fiber_event.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/update_event_usecase.dart';
import '../widgets/event_filter_chips.dart';

class MisEventosProvider extends ChangeNotifier {
  final GetEventsUseCase getEventsUseCase;
  final UpdateEventUseCase updateEventUseCase;

  MisEventosProvider({
    required this.getEventsUseCase,
    required this.updateEventUseCase,
  });

  List<FiberEvent> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  EventFilter _selectedFilter = EventFilter.todos;

  List<FiberEvent> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  EventFilter get selectedFilter => _selectedFilter;

  void setFilter(EventFilter filter) {
    _selectedFilter = filter;
    fetchMyEvents();
  }

  Future<void> fetchMyEvents({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      String? status;
      if (_selectedFilter == EventFilter.activos) status = 'ACTIVE';
      if (_selectedFilter == EventFilter.atendidos) status = 'RESOLVED';
      if (_selectedFilter == EventFilter.cerrados) status = 'CLOSED';

      _events = await getEventsUseCase(status: status, reportedBy: 'me');
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> markAsResolved(int eventId) async {
    try {
      await updateEventUseCase.execute(eventId: eventId, status: 'RESOLVED');
      await fetchMyEvents(silent: true);
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        _errorMessage = 'Solo quien reportó este evento puede cambiar su estado.';
      } else {
        _errorMessage = e.message;
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
