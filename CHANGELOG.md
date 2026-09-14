# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

## [Unreleased]

### Added
- Capa de integración con la API (`core/api/`): contrato `IApi`, implementación `ApiService` (`package:http`), `ApiException`/`NetworkException`.
- Screens iniciales maquetadas y componentizadas: Login, Home, Reportar Evento, Confirmación de Registro, Eventos, Notificaciones, Perfil — con widgets compartidos centralizados en `core/widgets/` (`AppTopBar`, `DetailTopBar`, `AppBottomNavBar`, `ConnectivityBadge`, `NotificationBell`, `UserAvatar`, `NumberedSectionCard`).
- Autenticación: login normal, cambio de contraseña obligatorio en primer acceso, completar perfil tras el primer login.
- Login biométrico basado en `device_token` opaco y revocable (no en la contraseña real del usuario), con `local_auth` + `flutter_secure_storage`.
- Flujo de "Olvidé mi contraseña" con manejo de UI que preserva la no-enumeración de usuarios del backend.
- Integración de Google Maps (`google_maps_flutter`) y GPS (`geolocator`) para el selector de ubicación en Reportar Evento, con `LocationPickerMap` (marcador arrastrable, toque para seleccionar).
- Subida de evidencia fotográfica y foto de perfil directo a S3 mediante URLs prefirmadas (flujo de 3 pasos), sin pasar el binario por el backend.
- Deduplicación por hash SHA-256 en fotos de evento (no aplicada a foto de perfil, decisión consciente).
- Pantalla "Mis Eventos", consumiendo el filtro `?reported_by=me` agregado al backend.
- Endpoint `GET /events/{id}` consumido para la pantalla de Detalle de Evento (galería de fotos, hilo de comentarios, cambio de estado).
- CRUD completo de Centrales de red desde la app.
- Base de datos local con `sqflite` (`core/database/`) para caché de solo-lectura (eventos, centrales, fotos-metadata) con estrategia cache-aside.
- Cola de escritura offline (`pending_events`, `pending_photos`) para reportar eventos y adjuntar fotos sin conexión, con sincronización automática al recuperar señal (`connectivity_plus` + `EventSyncService`).
- Encadenamiento de sincronización: las fotos en cola de un evento offline se liberan automáticamente para subir en cuanto ese evento obtiene su ID real del servidor.
- Documentación del proyecto dividida en `docs/` (architecture, screens, api-integration, authentication, offline-sync, maps, development).

### Changed
- `UserPreferences` migrado de `shared_preferences` a `flutter_secure_storage`: `getUser()` y `hasUser` pasaron de síncronos a `Future`, requiriendo `await` en todos los llamadores.
- Diseño de login biométrico cambiado de "guardar contraseña cifrada localmente" a "token de dispositivo opaco emitido por el backend" — reduce el impacto de un dispositivo comprometido a un token revocable, no la credencial real.
- `EventResponse` del backend ahora incluye `origin_office`/`destination_office` como objetos anidados (`{id, prefix, name, city}`) en vez de solo IDs planos — elimina la necesidad de cruzar manualmente contra `GET /central-offices` en el cliente para resolver prefijos de central en las tarjetas de evento.

### Fixed
- `SecureCredentialStorage` corregido de `shared_preferences` (texto plano) a `flutter_secure_storage` (cifrado por el OS) tras evaluar el riesgo de exponer el `device_token` sin cifrar.
- `_uri()` en `ApiService`: error de null-safety en el uso de `removeWhere` sobre un `Map` potencialmente nulo, y bug de lógica donde el filtrado de `null` ocurría después de convertir a `String` (podía eliminar por error un valor legítimo igual al texto `"null"`).

### Known limitations / Pending
- Sin pruebas automatizadas (widget tests / unit tests de providers y usecases).
- Sin paginación en listados (`GET /events`, `GET /users`) — a vigilar conforme crezca el volumen de eventos.
- Rol `ADMIN` (alta masiva de usuarios) no tiene pantallas propias en la app; se opera vía Swagger/API directamente.
- Resolución de conflictos de sincronización offline es mínima (sin merge de ediciones concurrentes) — aceptable dado que los eventos offline son siempre creaciones nuevas, no actualizaciones.