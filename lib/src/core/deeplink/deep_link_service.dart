import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks({
    required ValueChanged<int> onEventLinkTapped,
  }) async {
    // 1. Escuchar links con la app ya en ejecución o en segundo plano
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, onEventLinkTapped);
    }, onError: (err) {
      debugPrint('Error en uriLinkStream: $err');
    });

    // 2. Escuchar link cuando la app es abierta estando cerrada (Cold Start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri, onEventLinkTapped);
      }
    } catch (e) {
      debugPrint('Error obteniendo initialUri: $e');
    }
  }

  void _handleUri(Uri uri, ValueChanged<int> onEventLinkTapped) {
    // Aceptamos el esquema "fibertechops" con host "event"
    // Ejemplo: fibertechops://event/42 -> scheme: fibertechops, host: event, pathSegments: ['42']
    if (uri.scheme == 'fibertechops' && uri.host == 'event') {
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final eventId = int.tryParse(pathSegments.first);
        if (eventId != null) {
          onEventLinkTapped(eventId);
        }
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
