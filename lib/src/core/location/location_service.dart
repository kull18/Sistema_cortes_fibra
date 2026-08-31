import 'package:geolocator/geolocator.dart';

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);
  @override
  String toString() => message;
}

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verificar si el servicio está activo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException('El servicio de ubicación está desactivado en el dispositivo.');
    }

    // 2. Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException('Permiso de ubicación denegado.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Los permisos de ubicación están denegados permanentemente. Por favor, actívalos en los ajustes del dispositivo.'
      );
    }

    // 3. Obtener posición
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
