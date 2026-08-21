import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/detail_top_bar.dart';

class RegistrarCentralScreen extends StatefulWidget {
  const RegistrarCentralScreen({super.key});

  @override
  State<RegistrarCentralScreen> createState() => _RegistrarCentralScreenState();
}

class _RegistrarCentralScreenState extends State<RegistrarCentralScreen> {
  final _prefijoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _direccionController = TextEditingController();
  final _observacionesController = TextEditingController();

  String get _displayPrefijo => _prefijoController.text.isEmpty ? 'PRE' : _prefijoController.text.toUpperCase();
  String get _displayNombre => _nombreController.text.isEmpty ? 'Nombre de la Central' : _nombreController.text;
  String get _displayCiudad => _ciudadController.text.isEmpty ? 'Ciudad / Municipio' : _ciudadController.text;

  @override
  void dispose() {
    _prefijoController.dispose();
    _nombreController.dispose();
    _ciudadController.dispose();
    _direccionController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _onTabSelected(AppTab tab) {
    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case AppTab.centrales:
        Navigator.of(context).pushReplacementNamed('/centrales');
        break;
      case AppTab.reportar:
        Navigator.of(context).pushReplacementNamed('/reportar-evento');
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed('/eventos');
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.centrales,
      onTabSelected: _onTabSelected,
      showDivider: true,
      padding: EdgeInsets.zero,
      isScrollable: false,
      appBar: DetailTopBar(
        title: 'Registrar Nueva Central',
        subtitle: 'Alta de Nodo en Red FiberTech',
        notificationCount: 2,
        onNotificationTap: () {},
        onAvatarTap: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        children: [
          // Hero Image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFE2E8F0),
              image: const DecorationImage(
                image: AssetImage('assets/images/fondo-central.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Registrar Nueva Central',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Preview Section
          const Text(
            'VISTA PREVIA DE LA FICHA TÉCNICA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildPreviewCard(),
          const SizedBox(height: 32),

          // Form Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_hashtag.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos de Registro de Nodo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Complete los campos requeridos para el catálogo',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form Fields
          _buildTextField(
            label: 'Prefijo del Nodo (3-4 Letras) *',
            hint: 'Ej. VFL',
            controller: _prefijoController,
            onChanged: (val) => setState(() {}),
            extraInfo: 'Ej. TGZ, SCH',
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Nombre Oficial de la Central *',
            hint: 'Ej. Central Villaflores Norte',
            controller: _nombreController,
            onChanged: (val) => setState(() {}),
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Ciudad / Municipio *',
            hint: 'Ej. Villaflores, Chiapas',
            controller: _ciudadController,
            onChanged: (val) => setState(() {}),
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Dirección o Referencia de Carretera',
            hint: 'Ej. Carretera Panamericana Km 32.5, Col. Centro',
            controller: _direccionController,
          ),
          const SizedBox(height: 24),

          // GPS Coords
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Coordenadas GPS de Referencia',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.textPrimary),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.gps_fixed, size: 16),
                label: const Text('Capturar GPS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
            ),
            child: const Text(
              '16.7528° N, -93.1165° W',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 24),

          _buildTextField(
            label: 'Observaciones Técnicas Adicionales (opcional)',
            hint: 'Ingrese detalles sobre acceso a terreno, energía de respaldo o posteía CFE...',
            controller: _observacionesController,
            maxLines: 4,
          ),
          const SizedBox(height: 32),

          // Action Buttons
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_save.svg',
                  width: 20,
                  height: 20,
                  color: AppColors.background,
                ),
                const SizedBox(width: 12),
                const Text('Guardar y Dar de Alta Central', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const Spacer(),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar y Volver al Directorio',
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Bottom section
          _buildExistingCentralsSection(),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '[$_displayPrefijo]',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _displayNombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                _displayCiudad,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    String? extraInfo,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            if (extraInfo != null) ...[
              const Spacer(),
              Text(
                extraInfo,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withOpacity(0.6), fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4), fontSize: 14),
            prefixIcon: icon != null ? Icon(icon, size: 20, color: AppColors.textSecondary.withOpacity(0.7)) : null,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.borderSubtle.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildExistingCentralsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_server_stack.svg',
                    width: 20,
                    height: 20,
                    color: AppColors.primaryBlue
                  ),
                  SizedBox(width: 10),
                  Text(
                    'CENTRALES YA REGISTRADAS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Text('5 Nodos', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExistingItem('TGZ', 'Central Tuxtla Gutiérrez', 'Tuxtla'),
          _buildExistingItem('SCH', 'Central San Cristóbal', 'Sur'),
          _buildExistingItem('SCL', 'Central Socoltenango', 'Socoltenango'),
          _buildExistingItem('TAP', 'Central Tapachula', 'Tapachula'),
          _buildExistingItem('COM', 'Central Comitán', 'Comitán'),
        ],
      ),
    );
  }

  Widget _buildExistingItem(String prefix, String name, String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueSoft,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '[$prefix]', 
              style: const TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.w900, 
                color: AppColors.primaryBlue
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ),
          Text(tag, style: TextStyle(fontSize: 10, color: AppColors.textSecondary.withOpacity(0.6), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
