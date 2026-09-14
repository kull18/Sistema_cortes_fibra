# Trabajo sin conexión (offline-first)

Los técnicos operan en campo, con acceso a internet intermitente. La app necesita dos capacidades distintas: **ver** datos recientes sin conexión, y **crear** reportes sin conexión (sincronizados después).

## Motor: sqflite

Se evaluaron `sqflite`, `drift` y `Hive`. Se eligió **sqflite** por ser relacional (necesario para relacionar eventos↔centrales↔fotos con queries de filtro/orden) y por ser la opción más estándar/soportada a largo plazo.

## Esquema de base de datos local

### Tablas de caché (solo lectura, se reemplazan completas al sincronizar)

```sql
central_offices (id, prefix, name, city, latitude, longitude, synced_at)
events (id, type, origin_office_id, destination_office_id, latitude, longitude,
        location_method, accuracy, distance_to_origin, distance_to_destination,
        field_reference, description, status, reported_by_id, reported_at, synced_at)
event_photos (id, event_id, label, size_bytes, uploaded_at)
```

**No se cachea el binario ni la URL de las fotos** — las URLs prefirmadas expiran y de todas formas requieren red para mostrarse; solo se cachea la metadata.

### Tablas de cola (escritura pendiente de sincronizar)

```sql
pending_events (local_id [UUID, PK], origin_office_id, destination_office_id,
                 latitude, longitude, location_method, accuracy, field_reference,
                 description, status, created_at, last_attempt_at, attempt_count, last_error)

pending_photos (local_id [UUID, PK], pending_event_local_id, real_event_id,
                local_file_path, content_hash, label, size_bytes, status,
                created_at, last_attempt_at, attempt_count, last_error)
```

`status` en ambas tablas: `PENDING_SYNC`, `SYNCING`, `FAILED`.

`pending_photos` soporta dos escenarios: foto tomada para un evento que **también** está offline (`pending_event_local_id` lleno, `real_event_id` nulo hasta que el evento sincronice), o foto agregada a un evento que **ya existe** en el servidor pero sin señal en ese momento (`real_event_id` lleno directamente).

## Estrategia de lectura: cache-aside

```
try {
  final result = await remoteDataSource.listEvents(status: status);
  await localDao.replaceAll(result['data']); // refresca el cache
  return result;
} on NetworkException {
  return await localDao.getCachedEvents(status: status); // fallback
}
```

La red es siempre la fuente de verdad cuando está disponible; el caché local solo se consulta cuando `NetworkException` se dispara.

## Estrategia de escritura: cola + sincronización automática

```
createEvent() sin conexión
  → NetworkException capturada en el Repository
  → se guarda en pending_events con local_id (UUID) y status PENDING_SYNC
  → se lanza EventQueuedLocallyException (no es un error real)
  → la UI muestra "Guardado, se enviará cuando haya señal"
```

`core/sync/event_sync_service.dart` escucha cambios de conectividad (`connectivity_plus`) y dispara sincronización automática al recuperar señal:

```
Connectivity().onConnectivityChanged.listen((results) {
  if (results.any((r) => r != ConnectivityResult.none)) {
    syncAll();
  }
});
```

### Orden de sincronización (importante)

`syncAll()` sincroniza **eventos primero, fotos después**, en cada ciclo:

```
_syncPendingEvents():
  por cada evento pendiente → POST /events real
    éxito → linkPhotosToRealEvent(local_id, id_real) libera sus fotos
          → se borra de pending_events
    error de validación (409/422) → status = FAILED, no reintenta solo
    error de red → se detiene el batch, el resto sigue pendiente

_syncPendingPhotos():
  solo fotos con real_event_id ya asignado (propio o heredado del paso anterior)
  → mismo flujo de 3 pasos normal (upload-url, PUT a S3, createEventPhoto)
  → al subir con éxito, se borra el archivo local persistido
```

Esto permite que, en la misma pasada de sincronización, un evento recién sincronizado libere inmediatamente sus fotos en cola, sin esperar al siguiente ciclo.

## Persistencia de archivos de fotos pendientes

Las fotos tomadas offline se copian a un directorio propio de la app (no se confía en la ruta original de cámara/galería, que el SO puede limpiar):

```
final appDir = await getApplicationDocumentsDirectory();
final newPath = '${appDir.path}/pending_photos/$contentHash.$extension';
```

## Indicadores en la UI

```
final pendingEvents = await PendingEventDao().countPending();
final pendingPhotos = await PendingPhotoDao().countPending();
// "3 reportes y 5 fotos pendientes de enviar"
```

`EventSyncService.syncStatusStream` expone el progreso en vivo (`SyncStatus.syncing(total, completed)`) para mostrar feedback tipo "Sincronizando 2 de 3...".