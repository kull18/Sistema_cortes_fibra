# SCF App (Sistema de Cortes de Fibra)

Aplicación móvil Flutter para que técnicos de campo reporten cortes de fibra óptica, adjunten evidencia fotográfica, comenten eventos y reciban notificaciones en tiempo real. Consume la [API de SCF](../scf/README.md).

## Stack

- Flutter / Dart
- `StatefulWidget` para manejo de estado (sin gestor de estado externo por ahora)
- `flutter_svg` — íconos vectoriales
- `onesignal_flutter` — notificaciones push
- `crypto` — hash SHA-256 de imágenes antes de subirlas a S3
- Backend: FastAPI + PostgreSQL/PostGIS (ver repo del backend)

## Arquitectura

Organización por feature, con widgets compartidos centralizados en `core/`:

```
lib/
├── core/
│   ├── theme/
│   │   └── app_colors.dart
│   └── widgets/
│       ├── app_top_bar.dart
│       ├── detail_top_bar.dart
│       ├── app_bottom_nav_bar.dart
│       ├── connectivity_badge.dart
│       ├── notification_bell.dart
│       ├── user_avatar.dart
│       └── numbered_section_card.dart
│
├── features/
│   └── technical/
│       ├── login/
│       ├── home/
│       ├── reportar/
│       └── perfil/
│           ├── models/
│           ├── screens/
│           └── widgets/
│
└── main.dart
```

**Regla:** un widget vive en `core/widgets/` solo si se usa en 2+ screens (ej. el header, el bottom nav). Si es específico de una sola pantalla, va en `features/<feature>/widgets/`.

## Setup

```bash
flutter pub get
```

### Assets

Agrega en `pubspec.yaml`:

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

Los íconos SVG usados (`Lucide`, MIT license) se descargan de `https://unpkg.com/lucide-static@latest/icons/<nombre>.svg` y se guardan en `assets/icons/`.