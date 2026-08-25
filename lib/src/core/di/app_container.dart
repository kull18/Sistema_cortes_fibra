import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../api/api_service.dart';
import '../api/biometric_auth_service.dart';
import '../api/i_api.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';
import '../preferences/user_preferences.dart';
import '../database/event_local_dao.dart';
import '../database/central_office_local_dao.dart';
import '../database/pending_event_dao.dart';
import '../database/pending_photo_dao.dart';
import '../sync/event_sync_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/technical/data/datasources/technical_remote_datasource.dart';
import '../../features/technical/data/repositories/technical_repository_impl.dart';

class AppContainer {
  static final AppContainer _instance = AppContainer._internal();
  factory AppContainer() => _instance;
  AppContainer._internal();

  // Infraestructura
  static final IApi _api = ApiService(
    baseUrl: dotenv.env['API_BASE_URL'] ?? '',
  );
  static final StorageService _storage = StorageService();
  static final UserService _userService = UserService(_storage);
  static final BiometricAuthService _biometricAuth = BiometricAuthService();

  // DAOs Locales
  static final EventLocalDao _eventLocalDao = EventLocalDao();
  static final CentralOfficeLocalDao _centralOfficeLocalDao = CentralOfficeLocalDao();
  static final PendingEventDao _pendingEventDao = PendingEventDao();
  static final PendingPhotoDao _pendingPhotoDao = PendingPhotoDao();

  // Services
  late final EventSyncService _syncService;

  // Data Sources
  static final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl(
    api: _api,
  );
  
  static final TechnicalRemoteDataSource _technicalRemoteDataSource = TechnicalRemoteDataSourceImpl(
    api: _api,
  );

  // Repositories
  static final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(
    remoteDataSource: _authRemoteDataSource,
    storageService: _storage,
    userService: _userService,
    api: _api,
  );

  static final TechnicalRepositoryImpl _technicalRepository = TechnicalRepositoryImpl(
    remoteDataSource: _technicalRemoteDataSource,
    eventLocalDao: _eventLocalDao,
    centralOfficeLocalDao: _centralOfficeLocalDao,
    pendingEventDao: _pendingEventDao,
    pendingPhotoDao: _pendingPhotoDao,
  );

  /// Inicialización asíncrona para restaurar la sesión persistida
  Future<void> init() async {
    // Inicializar el servicio de sincronización
    _syncService = EventSyncService(
      api: _api, 
      pendingEventDao: _pendingEventDao,
      pendingPhotoDao: _pendingPhotoDao,
    );
    _syncService.startListening();
    _syncService.syncAll(); // Intento inicial (eventos y fotos)

    // 1. Restaurar token en ApiService para que los siguientes requests estén autorizados
    final token = await _storage.getToken();
    if (token != null && _api is ApiService) {
      (_api as ApiService).setAuthToken(token);
    }

    // 2. Restaurar datos del usuario en UserService para que la UI sepa quién está logueado
    final savedUser = await UserPreferences.getUser();
    if (savedUser != null) {
      _userService.setCurrentUser(savedUser);
    }
  }

  // Getters
  IApi get api => _api;
  StorageService get storage => _storage;
  UserService get userService => _userService;
  BiometricAuthService get biometricAuth => _biometricAuth;
  AuthRepositoryImpl get authRepository => _authRepository;
  TechnicalRepositoryImpl get technicalRepository => _technicalRepository;
  EventSyncService get syncService => _syncService;
}
