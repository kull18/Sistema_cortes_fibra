# SCF App (Sistema de Cortes de Fibra)

Aplicación móvil construida en **Flutter** para que los técnicos de telecomunicaciones y fibra óptica en campo gestionen y reporten incidencias de corte de fibra, adjunten evidencia fotográfica de alta resolución, ubiquen geográficamente eventos y centrales con Google Maps y reciban notificaciones push en tiempo real — con soporte para operación sin conexión (*offline-first*).

---

## Documentación

| Documento | Contenido |
|---|---|
| [Arquitectura](docs/architecture.md) | Estructura modular por feature, Clean Architecture, Provider, patrón UseCase/Repository |
| [Screens](docs/screens.md) | Inventario de pantallas, componentes visuales y endpoints asociados |
| [Integración con la API](docs/api-integration.md) | Contrato `IApi`, manejo de excepciones centralizado, inventario completo de endpoints |
| [Trabajo sin conexión](docs/offline-sync.md) | Base de datos SQLite local, cola de sincronización de eventos y fotos offline |
| [Maquetado](docs/mockups.md) | Capturas de referencia del diseño y flujos de usuario (Visily) |
| [Desarrollo](docs/development.md) | Guía de setup local, convención de ramas y formato de commits |

---

## Stack Tecnológico

- **Framework**: Flutter 3.x / Dart (canal stable)
- **Gestión de Estado**: `provider` (arquitectura reactiva desacoplada por casos de uso)
- **Capa de Red**: `http` con cliente personalizado `ApiService` (soporte de interceptores, refresco y 401 unificado)
- **Mapas y Geolocalización**: `google_maps_flutter` + `geolocator` (marcadores interactivos, cálculo de distancias y ubicación GPS de alta precisión)
- **Seguridad y Sesión**: `flutter_secure_storage` (cifrado en reposo para tokens JWT y device tokens)
- **Biometría**: `local_auth` (inicio de sesión por huella dactilar / Face ID con token de dispositivo)
- **Soporte Offline**: `sqflite` (persistencia local) + `connectivity_plus` (detección automática de reconexión)
- **Notificaciones Push**: `onesignal_flutter` (alertas push en segundo plano y vinculación con backend)
- **Deep Linking**: `app_links` (navegación directa a eventos desde notificaciones o enlaces externos)
- **Manejo de Multimedia**: `image_picker` + `crypto` (captura de fotos y cálculo de hash SHA-256 para almacenamiento direccionado por contenido en AWS S3)

---

## Funcionalidades Principales

- **Autenticación Robusta**: Login por código de técnico, validación de contraseñas temporales con cambio obligatorio en primer acceso y autenticación biométrica de un toque.
- **Reporte de Cortes en Campo**: Registro ágil con captura de coordenadas por GPS o selección manual en Google Maps, asociando centrales de origen y destino.
- **Evidencia Fotográfica Segura**: Deduplicación local mediante hash SHA-256 y carga directa a AWS S3 a través de URLs prefirmadas (*Presigned URLs*), evitando el trasiego innecesario de archivos por la API.
- **Directorio de Centrales**: Visualización de centrales de red en listado y mapa satelital/normal con navegación a detalle.
- **Comentarios y Seguimiento**: Hilo de comentarios por evento con visualización de foto de perfil del técnico autor.
- **Operación Offline**: Cola de almacenamiento local para registrar eventos y fotos sin cobertura celular, con sincronización automática en segundo plano al recuperar señal.
- **Notificaciones Push e In-App**: Historial de alertas con conteo de no leídas y redirección inmediata al evento reportado.
- **Modo Oscuro / Claro**: Soporte completo de temas personalizables (`ThemeProvider`).

---

## Setup y Desarrollo Local

### 1. Clonar el repositorio e instalar dependencias

```bash
git clone <url-del-repo>
cd Sistema_cortes_fibra
flutter pub get
```

### 2. Configurar variables de entorno

Copia el archivo de ejemplo para entorno local:

```bash
cp env/local.example.json env/local.json
```

Edita `env/local.json` con los valores de tu entorno:

```json
{
  "API_BASE_URL": "http://localhost:8000",
  "ONESIGNAL_APP_ID": "tu_onesignal_app_id"
}
```

### 3. Google Maps API Key

Para desarrollo en Android, agrega tu clave en `android/local.properties`:

```properties
MAPS_API_KEY=tu_google_maps_api_key
```

### 4. Ejecutar la aplicación

```bash
# Usando el archivo de variables:
flutter run --dart-define-from-file=env/local.json

# O pasando las variables directamente:
flutter run --dart-define=API_BASE_URL=http://localhost:8000 --dart-define=ONESIGNAL_APP_ID=tu_app_id
```

---

## Pruebas y Análisis de Código

El proyecto utiliza análisis estático estricto para asegurar la calidad y consistencia del código:

```bash
# Análisis estático de código (linter)
flutter analyze --no-fatal-infos

# Ejecución de pruebas unitarias
flutter test
```

---

## Compilación y CI/CD (Despliegue a Google Play)

El proyecto cuenta con un flujo de integración y despliegue continuo automatizado en GitHub Actions ([`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)), el cual se ejecuta ante cada `push` a la rama `master`.

### Pasos del Pipeline

1. **Checkout & Setup**: Prepara el entorno con Flutter stable.
2. **Dependencias y Análisis**: Ejecuta `flutter pub get` y `flutter analyze --no-fatal-infos`.
3. **Firma de Release**:
   - Decodifica el keystore `release-key.jks` en `android/app/`.
   - Genera dinámicamente el archivo `android/key.properties`.
4. **Inyección de Configuración**: Crea `env/production.json` y configura `MAPS_API_KEY` en `android/local.properties`.
5. **Compilación del App Bundle**: Genera el archivo inmutable `app-release.aab` con:
   ```bash
   flutter build appbundle --release --dart-define-from-file=env/production.json
   ```
6. **Publicación en Google Play**: Sube automáticamente el bundle al canal de pruebas cerradas (*Closed Testing - Alpha*) de Google Play Console mediante `r0adkll/upload-google-play`.
7. **Limpieza de Seguridad**: Elimina llaves y archivos sensibles del runner de CI.

### Secretos requeridos en GitHub Actions

Configurados en `Settings -> Secrets and variables -> Actions`:

| Secreto | Descripción |
|---|---|
| `KEYSTORE_BASE64` | Archivo de llave de firma (`.jks`) codificado en Base64 |
| `KEYSTORE_PASSWORD` | Contraseña del almacén de claves (keystore) |
| `KEY_PASSWORD` | Contraseña de la clave privada |
| `KEY_ALIAS` | Alias de la clave de firma |
| `API_BASE_URL` | URL pública de la API de producción (`https://scf-api.shop`) |
| `ONESIGNAL_APP_ID` | App ID de OneSignal para producción |
| `GOOGLE_MAPS_API_KEY` | Clave de API de Google Maps con Maps SDK habilitado |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Credencial JSON de la cuenta de servicio de Google Cloud vinculada a Google Play Console |

---

## Convenciones de Contribución

Consulta [docs/development.md](docs/development.md) para conocer las políticas de ramas (`feature/`, `fix/`, `chore/`), formato de commits (Conventional Commits) y revisión de Pull Requests.
 