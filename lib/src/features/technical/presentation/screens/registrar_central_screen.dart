import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../providers/central_office_provider.dart';
import '../../domain/entities/central_office_entity.dart';

class RegistrarCentralScreen extends StatefulWidget {
  const RegistrarCentralScreen({super.key});

  @override
  State<RegistrarCentralScreen> createState() => _RegistrarCentralScreenState();
}

class _RegistrarCentralScreenState extends State<RegistrarCentralScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prefijoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _direccionController = TextEditingController();
  final _observacionesController = TextEditingController();

  double _latitude = 16.7528;
  double _longitude = -93.1165;

  CentralOfficeEntity? _editingOffice;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is CentralOfficeEntity) {
        _editingOffice = args;
        _prefijoController.text = args.prefix;
        _nombreController.text = args.name;
        _ciudadController.text = args.city;
        _latitude = args.latitude;
        _longitude = args.longitude;
      }
      _isInitialized = true;
    }
  }

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CentralOfficeProvider>();
    bool success;

    if (_editingOffice != null) {
      success = await provider.updateOffice(
        officeId: _editingOffice!.id,
        prefix: _prefijoController.text,
        name: _nombreController.text,
        city: _ciudadController.text,
        latitude: _latitude,
        longitude: _longitude,
      );
    } else {
      success = await provider.createOffice(
        prefix: _prefijoController.text,
        name: _nombreController.text,
        city: _ciudadController.text,
        latitude: _latitude,
        longitude: _longitude,
      );
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingOffice != null ? 'Central actualizada' : 'Central registrada')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Error al guardar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<CentralOfficeProvider>().isLoading;
    final isEdit = _editingOffice != null;

    return AppScaffold(
      currentTab: AppTab.centrales,
      onTabSelected: _onTabSelected,
      showDivider: true,
      padding: EdgeInsets.zero,
      isScrollable: false,
      appBar: DetailTopBar(
        title: isEdit ? 'Editar Central' : 'Registrar Nueva Central',
        subtitle: 'Alta de Nodo en Red FiberTech',
        notificationCount: 0,
        onNotificationTap: () {},
        onAvatarTap: () {},
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          children: [
            // Hero Image restaurada
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
                child: Text(
                  isEdit ? 'Actualizar Información' : 'Registrar Nueva Central',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildTextField(
              label: 'Prefijo del Nodo (Máx 4 Letras) *',
              hint: 'Ej. TGZ',
              controller: _prefijoController,
              onChanged: (val) => setState(() {}),
              extraInfo: 'Ej. TGZ, SCH',
              validator: (val) {
                if (val == null || val.isEmpty) return 'El prefijo es requerido';
                if (val.length > 4) return 'Máximo 4 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Nombre Oficial de la Central *',
              hint: 'Ej. Central Tuxtla Gutiérrez',
              controller: _nombreController,
              onChanged: (val) => setState(() {}),
              icon: Icons.business_outlined,
              validator: (val) => (val == null || val.isEmpty) ? 'El nombre es requerido' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Ciudad / Municipio *',
              hint: 'Ej. Tuxtla Gutiérrez, Chiapas',
              controller: _ciudadController,
              onChanged: (val) => setState(() {}),
              icon: Icons.location_on_outlined,
              validator: (val) => (val == null || val.isEmpty) ? 'La ciudad es requerida' : null,
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
                  onPressed: () {
                    setState(() {
                      _latitude = 16.7528;
                      _longitude = -93.1165;
                    });
                  },
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
              child: Text(
                '${_latitude.toStringAsFixed(4)}° N, ${_longitude.toStringAsFixed(4)}° W',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            ElevatedButton(
              onPressed: isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_save.svg',
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Guardar Cambios' : 'Guardar y Dar de Alta Central',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
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
                  'Cancelar',
                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
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
    String? Function(String?)? validator,
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
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
