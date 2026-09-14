# SCF App (Sistema de Cortes de Fibra)

Aplicación móvil Flutter para que técnicos de campo reporten cortes de fibra óptica, adjunten evidencia fotográfica, comenten eventos y reciban notificaciones en tiempo real — incluso sin conexión a internet.

## Documentación

| Documento | Contenido |
|---|---|
| [Arquitectura](docs/architecture.md) | Estructura por feature, Clean Architecture, Provider, patrón UseCase/Repository |
| [Screens](docs/screens.md) | Inventario de pantallas, componentes y endpoints que usa cada una |
| [Integración con la API](docs/api-integration.md) | Contrato `IApi`, manejo de errores, inventario completo de endpoints |
| [Trabajo sin conexión](docs/offline-sync.md) | Caché local, cola de sincronización de eventos y fotos offline |
| [Maquetado](docs/mockups.md) | Capturas de referencia del diseño de cada pantalla (Visily) |
## Stack

- Flutter / Dart
- `provider` para manejo de estado
- `http` para consumo de API
- `flutter_secure_storage` — sesión y credenciales biométricas cifradas
- `google_maps_flutter` + `geolocator` — selección de ubicación
- `sqflite` — caché local y cola de sincronización offline
- `connectivity_plus` — detección de reconexión para sync automático
- `local_auth` — login biométrico
- `onesignal_flutter` — notificaciones push
- `image_picker` + `crypto` — evidencia fotográfica con hash SHA-256

## Setup

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=
```

Ver [docs/architecture.md](docs/architecture.md) para la estructura de carpetas completa y [docs/api-integration.md](docs/api-integration.md) para la configuración de la capa de red.

### Assets

```yaml
flutter:
  assets:
    - assets/icons/
    - assets/images/
  fonts:
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono-Bold.ttf
```

Íconos SVG (Lucide, MIT license): `https://unpkg.com/lucide-static@latest/icons/<nombre>.svg`.

## Convenciones

Ver [docs/development.md](docs/development.md) para convenciones de ramas, commits y estructura de PRs.
 