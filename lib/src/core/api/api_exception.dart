/// Excepcion generica para cualquier error de la API (4xx, 5xx).
/// El backend siempre responde errores con la forma {"detail": "..."}.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isRateLimited => statusCode == 429;
  bool get isServerError => statusCode >= 500;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Se lanza cuando no hay conexion o la request no llega al servidor
/// (timeout, sin internet, host inalcanzable). Distinto de ApiException,
/// que implica que el servidor SI respondio, con un error.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No se pudo conectar al servidor']);

  @override
  String toString() => 'NetworkException: $message';
}