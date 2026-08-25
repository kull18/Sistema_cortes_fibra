import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/get_event_photo_upload_url_usecase.dart';
import '../../domain/usecases/create_event_photo_usecase.dart';
import '../../domain/entities/photo_evidence.dart';

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

  Future<bool> reportEvent({
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
      // 1. Crear el evento
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

      final eventId = int.parse(event.id.split('-').last); // O usar el id numérico si estuviera disponible directamente

      // 2. Subir fotos
      for (var evidence in evidences) {
        if (evidence.localPath == null) continue;
        await _uploadPhoto(eventId, evidence);
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> _uploadPhoto(int eventId, PhotoEvidence evidence) async {
    final file = File(evidence.localPath!);
    final bytes = await file.readAsBytes();
    final contentHash = sha256.convert(bytes).toString();

    // 3a. Pedir URL de subida
    final uploadData = await getEventPhotoUploadUrlUseCase.execute(
      eventId: eventId,
      filename: evidence.fileName,
      contentHash: contentHash,
    );

    final String uploadUrl = uploadData['upload_url'];
    final String objectKey = uploadData['object_key'];
    final bool alreadyExists = uploadData['already_exists'] ?? false;

    // 3b. Subir a S3 si no existe
    if (!alreadyExists) {
      final response = await http.put(
        Uri.parse(uploadUrl),
        body: bytes,
        headers: {
          'Content-Length': bytes.length.toString(),
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Error al subir imagen a S3: ${response.statusCode}');
      }
    }

    // 3c. Registrar en el backend
    await createEventPhotoUseCase.execute(
      eventId: eventId,
      objectKey: objectKey,
      label: evidence.label,
      sizeBytes: bytes.length,
    );
  }
}
