
# Arquitectura

App móvil Flutter, organizada por feature con una capa `core/` compartida. Dentro de cada feature se sigue una separación inspirada en Clean Architecture: `domain` (entidades, contratos, casos de uso), `data` (fuentes de datos, repositorios concretos, mappers) y `presentation` (providers, screens, widgets).

## Estructura de carpetas

```
lib/
├── core/
│   ├── theme/
│   │   └── app_colors.dart
│   ├── widgets/                    # compartidos entre 2+ screens
│   │   ├── app_top_bar.dart
│   │   ├── detail_top_bar.dart
│   │   ├── app_bottom_nav_bar.dart
│   │   ├── connectivity_badge.dart
│   │   ├── notification_bell.dart
│   │   ├── user_avatar.dart
│   │   └── numbered_section_card.dart
│   ├── api/
│   │   ├── i_api.dart               # contrato abstracto de la API
│   │   ├── api_service.dart         # implementacion (package:http)
│   │   └── api_exception.dart       # ApiException / NetworkException
│   ├── auth/
│   │   ├── biometric_auth_service.dart
│   │   └── secure_credential_storage.dart
│   ├── preferences/
│   │   └── user_preferences.dart    # sesion de usuario persistida
│   ├── location/
│   │   └── location_service.dart    # GPS via Geolocator
│   ├── database/                    # cache local + cola offline (sqflite)
│   │   ├── database_helper.dart
│   │   ├── event_local_dao.dart
│   │   ├── central_office_local_dao.dart
│   │   ├── pending_event_dao.dart
│   │   └── pending_photo_dao.dart
│   └── sync/
│       └── event_sync_service.dart  # sincronizacion automatica al recuperar conexion
│
└── features/
    └── technical/
        ├── auth/            # login, biometria, forgot password, change password
        ├── home/
        ├── reportar/        # reportar evento + confirmacion
        ├── eventos/         # lista de eventos, mis eventos, detalle
        ├── centrales/
        ├── notificaciones/
        └── perfil/          # complete profile, foto de perfil
```

Cada feature sigue este patrón interno (ejemplo con `auth`):

```
features/technical/auth/
├── domain/
│   ├── entities/
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart      # contrato abstracto
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       ├── change_password_usecase.dart
│       ├── register_device_usecase.dart
│       ├── device_login_usecase.dart
│       └── forgot_password_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── models/
│   │       └── user_model.dart
│   ├── mappers/
│   │   └── user_mapper.dart
│   └── repositories/
│       └── auth_repository_impl.dart
└── presentation/
    ├── providers/
    │   └── auth_provider.dart
    ├── screens/
    │   └── login_screen.dart
    └── widgets/
        ├── forgot_password_dialog.dart
        └── biometric_enrollment_dialog.dart
```

## Regla de ubicación de widgets

Un widget vive en `core/widgets/` **solo si se usa en 2 o más screens** (header, bottom nav, badges). Si es específico de una sola pantalla, va en `features/<feature>/presentation/widgets/`.

## Manejo de estado

`Provider` + `ChangeNotifier`. Cada feature con estado propio tiene un `Provider` (ej. `AuthProvider`, `EventProvider`) que:
- Expone getters de estado (`isLoading`, `errorMessage`, datos cargados).
- Orquesta llamadas a uno o más `UseCase`.
- Llama `notifyListeners()` tras cada cambio relevante.

## Patrón UseCase

Cada caso de uso es una clase con un único método `call()`, recibe el `Repository` (abstracto) por constructor:

```
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> call({required String technicianCode, required String password}) {
    return repository.login(technicianCode: technicianCode, password: password);
  }
}
```

## Patrón Repository

El `Repository` es una interfaz abstracta en `domain/repositories/`, implementada en `data/repositories/*_impl.dart`. La implementación:
1. Llama al `RemoteDataSource` (que a su vez llama `IApi`).
2. Mapea el `Map<String, dynamic>` crudo a un `Model` (DTO) y luego a una `Entity` de dominio.
3. Sincroniza almacenamiento local relevante (sesión, cache offline) cuando aplica.