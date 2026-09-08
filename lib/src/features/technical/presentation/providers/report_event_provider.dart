import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/get_event_photo_upload_url_usecase.dart';
import '../../domain/usecases/create_event_photo_usecase.dart';
import '../../domain/entities/photo_evidence.dart';
import '../../domain/entities/fiber_event.dart';

class ReportEventProvider extends ChangeNotifier {
  final CreateEventUseCase createEventUseCase;
  final GetEventPhotoUploadUrlUseCase getEventPhotoUploadUrlUseCase;
  final CreateEventPhotoUseCase createEventPhotoUseCase;

  ReportEventProvider({
    required this.createEventUseCase,
    required this.getEventPhotoUploadUrlUseCase,
    required this.createEventPhotoUseCase,
  });

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _error;
  String? get error => _error;

  Future<FiberEvent?> reportEvent({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
    required List<PhotoEvidence> evidences,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Crear el evento en el backend
      final event = await createEventUseCase.execute(
        originOfficeId: originOfficeId,
        destinationOfficeId: destinationOfficeId,
        latitude: latitude,
        longitude: longitude,
        locationMethod: locationMethod,
        accuracy: accuracy,
        fieldReference: fieldReference,
        description: description,
      );

      // Obtener el ID numérico real del servidor
      final int? realEventId = event.rawId ?? int.tryParse(event.id.split('-').last);
      print('DEBUG realEventId para subida de fotos: $realEventId (folio: ${event.id})');

      // 2. Subir fotos en secuencia si se obtuvo el ID real del evento
      if (realEventId != null) {
        for (var evidence in evidences) {
          if (evidence.localPath == null) continue;
          await _uploadPhoto(realEventId, evidence);
        }
      } else {
        print('DEBUG Advertencia: No se pudo obtener realEventId numérico. Se omite subida de fotos online.');
      }

      return event;
    } catch (e, stackTrace) {
      print('DEBUG Error en reportEvent: $e\n$stackTrace');
      _error = e.toString();
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> _uploadPhoto(int eventId, PhotoEvidence evidence) async {
    try {
      final file = File(evidence.localPath!);
      final bytes = await file.readAsBytes();
      final contentHash = sha256.convert(bytes).toString();

      // Paso 1: Pedir URL pre-firmada de subida (GET /event-photos/upload-url)
      print('DEBUG [Paso 1/3] Solicitando URL de subida para eventId=$eventId, file=${evidence.fileName}');
      final uploadData = await getEventPhotoUploadUrlUseCase.execute(
        eventId: eventId,
        filename: evidence.fileName,
        contentHash: contentHash,
      );

      final String uploadUrl = uploadData['upload_url'];
      final String objectKey = uploadData['object_key'];
      final bool alreadyExists = uploadData['already_exists'] ?? false;
      print('DEBUG [Paso 1/3] OK: objectKey=$objectKey, alreadyExists=$alreadyExists');

      // Paso 2: Subir archivo a S3 vía PUT directo
      if (!alreadyExists) {
        print('DEBUG [Paso 2/3] Subiendo bytes a S3 (PUT a upload_url)...');
        final response = await http.put(
          Uri.parse(uploadUrl),
          body: bytes,
          headers: {
            'Content-Length': bytes.length.toString(),
          },
        );

        print('DEBUG [Paso 2/3] S3 status code: ${response.statusCode}');
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('Error al subir imagen a S3 (HTTP ${response.statusCode}): ${response.body}');
        }
      } else {
        print('DEBUG [Paso 2/3] Omitido porque el archivo ya existe en S3');
      }

      // Paso 3: Registrar la foto en la base de datos (POST /event-photos)
      print('DEBUG [Paso 3/3] Registrando foto en el backend (POST /event-photos)...');
      await createEventPhotoUseCase.execute(
        eventId: eventId,
        objectKey: objectKey,
        label: evidence.label,
        sizeBytes: bytes.length,
      );
      print('DEBUG [Paso 3/3] OK: Foto registrada exitosamente en el backend para eventId=$eventId');
    } catch (e, stackTrace) {
      print('DEBUG Error en _uploadPhoto: $e\n$stackTrace');
      rethrow;
    }
  }
}
