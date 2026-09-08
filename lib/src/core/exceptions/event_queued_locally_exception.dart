/// No es un error real -- indica que el evento se guardó localmente
/// con éxito y está esperando sincronizarse. La UI debe capturar esto
/// por separado de un error real, y mostrar un mensaje positivo.
class EventQueuedLocallyException implements Exception {
  final String localId;
  const EventQueuedLocallyException(this.localId);
}
