import 'package:flutter/material.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/build_info_row.dart';

class BuildInfoCard extends StatelessWidget {
  final String role;
  final String phone;
  final String email;

  const BuildInfoCard({
    super.key,
    required this.role,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          BuildInfoRow(icon: 'ic_hard_hat.svg', label: 'Puesto Operativo:', value: role),
          BuildInfoRow(icon: 'ic_phone.svg', label: 'Teléfono:', value: phone),
          BuildInfoRow(icon: 'ic_mail.svg', label: 'Correo Corporativo:', value: email),
        ],
      ),
    );
  }
}
