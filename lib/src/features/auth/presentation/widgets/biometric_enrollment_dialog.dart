import 'package:flutter/material.dart';

class BiometricEnrollmentDialog extends StatelessWidget {
  const BiometricEnrollmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Acceso rápido'),
      content: const Text(
        '¿Quieres usar tu huella o rostro para entrar más rápido la próxima vez?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Activar'),
        ),
      ],
    );
  }
}