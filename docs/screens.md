
# Screens

Inventario de pantallas diseñadas/implementadas, sus componentes principales y qué endpoints consume cada una (ver [api-integration.md](api-integration.md) para el detalle de cada endpoint).

## Login

- Campos: Ficha de Técnico (`technician_code`), Contraseña.
- Acciones: Iniciar sesión, ¿Olvidó su clave? (`ForgotPasswordDialog`), Acceso Rápido por Biometría (condicional, solo si hay `device_token` guardado y el dispositivo soporta biometría).
- Tras login exitoso: ofrece enrolar biometría (`BiometricEnrollmentDialog`) antes de navegar.
- Navegación posterior según flags de la respuesta: `must_change_password` → Cambiar Contraseña; si no, `profile_completed` → Completar Perfil; si no, → Home.
- Endpoints: `POST /auth/login`, `POST /auth/device-login`, `POST /auth/register-device`, `POST /auth/forgot-password`.

## Home

- `WelcomeHeroCard`: saludo con nombre (de sesión local, no de API).
- `QuickAccessSection`: accesos a Mapa General, Centrales, Historial.
- `EventsSection`: últimos eventos con `EventFilterChips` (Todos / Activos / Atendidos).
- Endpoints: `GET /events?status=`, `GET /notifications/unread-count`.

## Reportar Evento

- Paso 1 — Selección de Tramo de Red: selectores Origen/Destino (`CentralChipSelector`), botón Invertir.
- Paso 2 — Ubicación: toggle GPS/Manual (`LocationModeToggle`), mapa real (`LocationPickerMap`, Google Maps), slider de ajuste, campo de referencia libre.
- Paso 3 — Diagnóstico: tipo de evento fijo (bloqueado, siempre Corte de Fibra), descripción técnica.
- Paso 4 — Evidencias Fotográficas: adjuntar fotos (flujo de 3 pasos con S3 presigned URLs + hash SHA-256 para deduplicación).
- Envío offline: si no hay conexión, el evento se guarda en cola local (`pending_events`) en vez de fallar — ver [offline-sync.md](offline-sync.md).
- Endpoints: `GET /central-offices`, `POST /events`, `GET /event-photos/upload-url`, `POST /event-photos`.

## Confirmación de Registro

- Muestra folio, tramo, ubicación, tipo de incidente, hora — **sin llamadas de red propias**, usa el objeto devuelto por `POST /events` más la sesión local para "Reportado Por".
- Acciones: Ver Lista de Eventos, Volver a Inicio, Reportar Otro Corte de Fibra.

## Eventos (lista general)

- Filtros: Todos / Activos / Atendidos (chips), mapeados a `status=ACTIVE` / `status=RESOLVED`.
- Endpoints: `GET /events?status=`, `GET /notifications/unread-count`.

## Mis Eventos

- Misma UI que Eventos, filtrado a los reportados por el usuario actual.
- Endpoint: `GET /events?status=&reported_by=me`.

## Detalle de Evento

- Info del evento (tramo, ubicación, distancias, descripción, estado).
- Galería de fotos, con opción de adjuntar más.
- Hilo de comentarios: listar, agregar, eliminar (solo comentarios propios).
- Cambio de estado del evento (Activo → Atendido → Cerrado).
- Endpoints: `GET /events/{id}`, `GET /event-photos/event/{id}`, `GET /event-photos/upload-url` + `POST /event-photos`, `GET /event-comments/event/{id}`, `POST /event-comments`, `DELETE /event-comments/{id}`, `PATCH /events/{id}`.

## Centrales

- CRUD completo: listar, ver detalle, crear, editar, eliminar.
- Endpoints: `GET /central-offices`, `GET /central-offices/{id}`, `POST /central-offices`, `PATCH /central-offices/{id}`, `DELETE /central-offices/{id}`.

## Notificaciones

- Lista de notificaciones con estado leído/no leído, tipo (`EVENT_CREATED`, `EVENT_COMMENT`, `EVENT_STATUS_CHANGED`), navegación al evento relacionado si aplica.
- Endpoints: `GET /notifications`, `GET /notifications/unread-count`, `PATCH /notifications/{id}/read`.
- Registro de dispositivo para push (OneSignal) ocurre aparte, una vez tras login: `POST /notifications/device-token`.

## Completar Perfil

- Campos: nombre completo (obligatorio), correo, puesto de trabajo, foto de perfil (todos opcionales salvo nombre).
- Subida de foto: mismo patrón de presigned URL que fotos de evento, **sin** deduplicación por hash (decisión consciente, distinta a fotos de evento).
- Endpoints: `GET /users/me/profile-photo-upload-url`, `PATCH /users/me/complete-profile`.

## Cambiar Contraseña

- Se muestra de forma forzada si `must_change_password: true` viene en la respuesta de login.
- Endpoint: `POST /auth/change-password`.

## Widgets compartidos (`core/widgets/`)

| Widget | Uso |
|---|---|
| `AppTopBar` | Header de Home/Eventos/Centrales/Notificaciones/Perfil: logo, conectividad, campana, avatar |
| `DetailTopBar` | Header con botón de regreso, para screens de detalle/formulario |
| `AppBottomNavBar` | Navegación inferior (Inicio, Reportar, Eventos, Perfil) |
| `ConnectivityBadge` | Indicador de estado de red en el header |
| `NotificationBell` | Campana con contador de no leídas |
| `UserAvatar` | Avatar con indicador de estado online |
| `NumberedSectionCard` | Tarjeta con encabezado numerado, usada en formularios multi-paso |