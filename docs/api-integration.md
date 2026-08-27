# Integración con la API

## Contrato

`core/api/i_api.dart` define un contrato abstracto `IApi` con un método por endpoint del backend. Todos los métodos:
- Regresan `Future<Map<String, dynamic>>` — nunca modelos tipados directamente en esta capa (el mapeo a `Model`/`Entity` ocurre en `data/mappers` y `data/repositories`, no aquí).
- Si el endpoint del backend responde un array JSON, `ApiService` lo envuelve automáticamente en `{'data': [...]}` para mantener el contrato uniforme.

## Implementación

`core/api/api_service.dart` (`ApiService implements IApi`) usa `package:http`.

```
final api = ApiService(baseUrl: ApiConfig.baseUrl);
api.setAuthToken(token); // tras login o al restaurar sesion
```

### Manejo de errores

Dos excepciones distintas, deliberadamente separadas:

```
class ApiException implements Exception {
  final int statusCode;
  final String message; // viene de {"detail": "..."} del backend
}

class NetworkException implements Exception {
  final String message; // sin conexion, timeout, host inalcanzable
}
```

`ApiException` = el servidor respondió con un error (401, 403, 404, 409, 429, 5xx). `NetworkException` = la petición nunca llegó al servidor. La UI y la capa de sincronización offline distinguen ambos casos de forma distinta (ver [offline-sync.md](offline-sync.md)).

## Configuración de entorno

```
class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
}
```

```bash
flutter run --dart-define=API_BASE_URL=https://scf-api.shop
```

## Inventario de endpoints por dominio

### Auth
| Método `IApi` | Endpoint |
|---|---|
| `login` | `POST /auth/login` |
| `logout` | `POST /auth/logout` |
| `changePassword` | `POST /auth/change-password` |
| `registerDevice` | `POST /auth/register-device` |
| `deviceLogin` | `POST /auth/device-login` |
| `forgotPassword` | `POST /auth/forgot-password` |

### Users
| Método `IApi` | Endpoint |
|---|---|
| `bulkCreateUsers` | `POST /users/bulk` (uso administrativo) |
| `listUsers` | `GET /users` (uso administrativo) |
| `getProfilePhotoUploadUrl` | `GET /users/me/profile-photo-upload-url` |
| `completeProfile` | `PATCH /users/me/complete-profile` |

### Central Offices
| Método `IApi` | Endpoint |
|---|---|
| `createCentralOffice` | `POST /central-offices` |
| `listCentralOffices` | `GET /central-offices` |
| `getCentralOffice` | `GET /central-offices/{id}` |
| `updateCentralOffice` | `PATCH /central-offices/{id}` |
| `deleteCentralOffice` | `DELETE /central-offices/{id}` |

### Events
| Método `IApi` | Endpoint |
|---|---|
| `createEvent` | `POST /events` |
| `listEvents` | `GET /events?status=&reported_by=` |
| `getEvent` | `GET /events/{id}` |
| `updateEvent` | `PATCH /events/{id}` |

### Event Photos
| Método `IApi` | Endpoint |
|---|---|
| `getEventPhotoUploadUrl` | `GET /event-photos/upload-url` |
| `createEventPhoto` | `POST /event-photos` |
| `listEventPhotos` | `GET /event-photos/event/{id}` |

### Event Comments
| Método `IApi` | Endpoint |
|---|---|
| `createEventComment` | `POST /event-comments` |
| `listEventComments` | `GET /event-comments/event/{id}` |
| `deleteEventComment` | `DELETE /event-comments/{id}` |

### Notifications
| Método `IApi` | Endpoint |
|---|---|
| `listNotifications` | `GET /notifications` |
| `getUnreadCount` | `GET /notifications/unread-count` |
| `markNotificationAsRead` | `PATCH /notifications/{id}/read` |
| `registerDeviceToken` | `POST /notifications/device-token` (OneSignal) |

## Subida de archivos (S3, fuera de `IApi`)

Las fotos (evento y perfil) nunca pasan por el backend — se suben directo a S3 con una URL prefirmada, obtenida primero vía `IApi`. El `PUT` a esa URL es una llamada HTTP directa, **sin** el header `Authorization` de la API (la autenticación va embebida en la firma de la propia URL):

```
await http.put(
  Uri.parse(uploadUrl),
  body: await imageFile.readAsBytes(),
  headers: {'Content-Length': (await imageFile.length()).toString()},
);
```

**Diferencia importante entre fotos de evento y foto de perfil:**

| | Fotos de evento | Foto de perfil |
|---|---|---|
| Requiere `content_hash` (SHA-256) | Sí | No |
| Deduplicación (`already_exists`) | Sí | No |

## Errores comunes por código HTTP

| Código | Origen típico |
|---|---|
| 401 | Token ausente, inválido, expirado o revocado |
| 403 | Rol insuficiente, cuenta inactiva, o acción sobre recurso ajeno |
| 404 | Recurso no encontrado |
| 409 | Violación de unicidad (ej. prefijo de central duplicado) |
| 413 | Body de request excede el límite |
| 429 | Rate limit excedido (login, alta masiva) |
| 500 | Error no previsto del servidor |