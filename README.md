# SCF App (Sistema de Cortes de Fibra)

Aplicación móvil Flutter para que técnicos de campo reporten cortes de fibra óptica, adjunten evidencia fotográfica, comenten eventos y reciban notificaciones en tiempo real. La app está diseñada para funcionar en condiciones extremas de campo con soporte robusto para modo offline.

## Características Principales

- **Reporte Offline**: Cola de sincronización local para eventos y fotos. Si no hay señal, los datos se guardan en SQLite y se sincronizan automáticamente al recuperar conexión.
- **Evidencia Fotográfica**: Captura de fotos con persistencia local y subida optimizada a S3 mediante hashes SHA-256 para evitar duplicados.
- **UI Moderna**: Estados de carga elegantes mediante esqueletos (Skeletonizer) y diseño basado en Material 3.
- **Seguridad**: Autenticación biométrica y almacenamiento seguro de tokens.
- **Geolocalización**: Registro preciso de incidentes mediante GPS o selección manual sobre mapa.

## Stack Tecnológico

- **Flutter / Dart**
- **Gestión de Estado**: `provider` para lógica de negocio y estado de la UI.
- **Base de Datos Local**: `sqflite` (SQLite) para la cola de sincronización y caché.
- **Conectividad**: `connectivity_plus` para detección de red en tiempo real.
- **UI/UX**: `skeletonizer` para loading states y `flutter_svg` para iconografía vectorial.
- **Seguridad**: `local_auth` (Biometría) y `flutter_secure_storage`.
- **Utilidades**: `uuid` para IDs locales, `crypto` para hashing y `path_provider` para gestión de archivos.

## Arquitectura

El proyecto sigue una estructura inspirada en **Clean Architecture**, organizada por capas dentro de cada feature:

```
lib/
├── src/
│   ├── core/
│   │   ├── api/          # Contratos y cliente HTTP
│   │   ├── database/     # Helpers de SQLite y DAOs
│   │   ├── sync/         # Servicio de sincronización offline
│   │   ├── widgets/      # Componentes compartidos (Globales)
│   │   └── app_routes.dart
│   │
│   └── features/
│       └── technical/    # Feature principal de técnicos
│           ├── data/     # Repositorios, DataSources y Mappers
│           ├── domain/   # Entidades y Casos de Uso
│           └── presentation/
│               ├── providers/ # Lógica de estado
│               ├── screens/   # Pantallas
│               └── widgets/   # Componentes específicos
│
└── main.dart
```

## Flujo de Sincronización Offline

1. **Captura**: El técnico reporta un evento o foto sin señal.
2. **Persistencia**: Los datos se guardan en las tablas `pending_events` y `pending_photos`. Las imágenes se copian al almacenamiento persistente del dispositivo.
3. **Monitoreo**: `EventSyncService` escucha cambios en la conectividad.
4. **Sincronización**: Al recuperar red, se procesan primero los eventos (para obtener IDs reales) y luego las fotos vinculadas, limpiando la memoria local tras el éxito.

## Setup

1. **Dependencias**:
   ```bash
   flutter pub get
   ```

2. **Variables de Entorno**:
   Crea un archivo `.env` en la raíz con:
   ```env
   API_BASE_URL=https://tu-api-url.com
   ```

3. **Ejecución**:
   ```bash
   flutter run
   ```
