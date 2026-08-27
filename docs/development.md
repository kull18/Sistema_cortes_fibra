# Desarrollo

## Requisitos

- Flutter SDK (canal stable)
- Android Studio (emulador Android) y/o Xcode (simulador iOS)
- Cuenta de Google Cloud con Maps SDK habilitado (ver [maps.md](maps.md))
- Acceso a la [API de SCF](../scf/README.md) corriendo (local o `https://scf-api.shop`)

## Setup local

```bash
git clone <url-del-repo>
cd scf-app
flutter pub get
```

### Variables de entorno

La URL base de la API se pasa por `--dart-define`, no por archivo `.env`:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8000   # backend local
flutter run --dart-define=API_BASE_URL=https://scf-api.shop     # backend en producción
```

Si no se pasa el flag, `ApiConfig.baseUrl` usa el `defaultValue` definido en `core/api/api_config.dart` — confirma que apunte a donde esperas antes de correr.

### Assets

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/icons/
    - assets/images/
  fonts:
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono-Bold.ttf
```

Los íconos SVG (set Lucide, MIT license) se descargan de `https://unpkg.com/lucide-static@latest/icons/<nombre>.svg` y se colocan en `assets/icons/`.

### Configuración nativa adicional

- **Google Maps**: API key en `AndroidManifest.xml` (Android) y `AppDelegate.swift` (iOS) — ver [maps.md](maps.md).
- **OneSignal**: `OneSignal.initialize(appId)` en `main.dart`.
- **Biometría**: permisos `USE_BIOMETRIC` (Android) y `NSFaceIDUsageDescription` (iOS).

Ninguna de estas credenciales va en el repositorio — pide al equipo los valores reales para tu entorno de desarrollo.

## Correr la app

```bash
flutter run --dart-define=API_BASE_URL=https://scf-api.shop
```

Para un dispositivo/emulador específico:

```bash
flutter devices
flutter run -d <device-id> --dart-define=API_BASE_URL=https://scf-api.shop
```

## Convención de ramas

Mismo esquema que el backend:

| Prefijo | Uso | Ejemplo |
|---|---|---|
| `feature/` | Nueva funcionalidad | `feature/offline-sync` |
| `fix/` | Corrección de bug | `fix/biometric-token-refresh` |
| `docs/` | Solo documentación | `docs/update-screens` |
| `refactor/` | Cambios internos sin alterar comportamiento | `refactor/repository-pattern` |
| `chore/` | Mantenimiento, dependencias | `chore/upgrade-google-maps` |

Una rama por feature/fix. La documentación se actualiza en la misma rama donde vive el cambio que documenta.

## Convención de commits

```
tipo(alcance opcional): descripción corta en imperativo
```

```
feat(reportar): add offline queue for event creation
fix(auth): clear device_token on 401 from device-login
docs: document offline sync architecture
refactor(events): extract EventSyncService from provider
chore(deps): upgrade google_maps_flutter to 2.9.0
```

## Arquitectura: dónde va cada cosa

Ver [architecture.md](architecture.md) para el detalle completo. Resumen rápido:

- **Nuevo endpoint a consumir** → agrega el método a `IApi` y su implementación en `ApiService` (`core/api/`).
- **Nueva regla de negocio** → `domain/usecases/` de la feature correspondiente.
- **Nuevo campo que la API recibe/regresa** → ajusta el `Model` en `data/datasources/models/` y su `Mapper`.
- **Nuevo estado de pantalla** → el `Provider` de la feature (`presentation/providers/`).
- **Widget usado en 2+ pantallas** → `core/widgets/`; si es de una sola pantalla, `features/<feature>/presentation/widgets/`.
- **Nueva tabla de caché/cola offline** → `core/database/`, siguiendo el patrón DAO existente (ver [offline-sync.md](offline-sync.md)).

## Reglas de estilo específicas del proyecto

- Los métodos de `IApi` siempre regresan `Map<String, dynamic>` — el mapeo a modelos tipados ocurre en capas superiores (`data/mappers`), nunca en `ApiService`.
- Arrays JSON crudos del backend se envuelven en `{'data': [...]}` por `ApiService`, para que el contrato de retorno sea siempre un `Map`.
- El almacenamiento de datos sensibles (`device_token`, sesión de usuario) usa `flutter_secure_storage`, nunca `shared_preferences` — decisión evaluada explícitamente por el riesgo de exponer datos en texto plano.
- Las llamadas `PUT` directas a S3 (subida de fotos) nunca llevan el header `Authorization` de la API — la autenticación va en la firma de la URL prefirmada.
- Un `NetworkException` en la creación de un evento/foto no debe mostrarse como error genérico — debe encolarse localmente (ver [offline-sync.md](offline-sync.md)) y comunicarse como "guardado, se enviará después", no como fallo.