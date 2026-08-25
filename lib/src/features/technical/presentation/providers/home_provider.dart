import 'package:flutter/material.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/get_unread_notifications_count_usecase.dart';
import '../../domain/entities/fiber_event.dart';
import '../widgets/event_filter_chips.dart';
import '../../../../core/database/event_local_dao.dart';

class HomeProvider extends ChangeNotifier {
  final GetEventsUseCase _getEventsUseCase;
  final GetUnreadNotificationsCountUseCase _getUnreadNotificationsCountUseCase;
  final EventLocalDao _eventLocalDao = EventLocalDao();

  HomeProvider({
    required GetEventsUseCase getEventsUseCase,
    required GetUnreadNotificationsCountUseCase getUnreadNotificationsCountUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        _getUnreadNotificationsCountUseCase = getUnreadNotificationsCountUseCase;

  List<FiberEvent> _events = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  EventFilter _selectedFilter = EventFilter.todos;
  DateTime? _lastSyncTime;

  List<FiberEvent> get events => _events;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  EventFilter get selectedFilter => _selectedFilter;
  DateTime? get lastSyncTime => _lastSyncTime;

  void setFilter(EventFilter filter) {
    _selectedFilter = filter;
    fetchEvents(); // Recargar con filtro
  }

  Future<void> initHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.wait([
      fetchEvents(silent: true),
      fetchUnreadCount(silent: true),
      _updateLastSyncTime(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEvents({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      String? status;
      if (_selectedFilter == EventFilter.activos) status = 'ACTIVE';
      if (_selectedFilter == EventFilter.atendidos) status = 'RESOLVED';

      _events = await _getEventsUseCase(status: status);
      await _updateLastSyncTime();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchUnreadCount({bool silent = false}) async {
    try {
      final entity = await _getUnreadNotificationsCountUseCase();
      _unreadCount = entity.unreadCount;
      if (!silent) notifyListeners();
    } catch (e) {
      debugPrint('Error fetching unread count: $e');
    }
  }

  Future<void> _updateLastSyncTime() async {
    _lastSyncTime = await _eventLocalDao.getLastSyncTime();
    notifyListeners();
  }
}
