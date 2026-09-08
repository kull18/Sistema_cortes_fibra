import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/preferences/user_preferences.dart';
import '../../../../core/location/location_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../../../technical/domain/entities/location_mode.dart';
import '../../../technical/domain/entities/photo_evidence.dart';
import '../widgets/reportar_hero_banner.dart';
import '../widgets/network_segment_section.dart';
import '../widgets/location_section.dart';
import '../widgets/diagnosis_section.dart';
import '../widgets/photo_evidence_section.dart';
import '../widgets/submit_actions.dart';
import '../providers/central_office_provider.dart';
import '../providers/report_event_provider.dart';

class ReportarEventoScreen extends StatefulWidget {
  const ReportarEventoScreen({super.key});

  @override
  State<ReportarEventoScreen> createState() => _ReportarEventoScreenState();
}

class _ReportarEventoScreenState extends State<ReportarEventoScreen> {
  Central? _origin;
  Central? _destination;

  LocationMode _locationMode = LocationMode.gps;
  double? _latitude;
  double? _longitude;
  double? _accuracy;

  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<PhotoEvidence> _evidences = [];
  final ImagePicker _picker = ImagePicker();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CentralOfficeProvider>().loadOffices();
      _useCurrentLocation(); // Intentar obtener ubicación al iniciar
    });
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _accuracy = position.accuracy;
        _locationMode = LocationMode.gps;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _handleManualLocationChange(LatLng position) {
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _accuracy = null; // Regla: MAP no lleva accuracy
      _locationMode = LocationMode.manual;
    });
  }

  double get _totalDistanceKm {
    if (_origin == null || _destination == null) return 0;
    return 35.8; // Valor simulado o calculado entre centrales
  }

  void _handleSwap() {
    setState(() {
      final temp = _origin;
      _origin = _destination;
      _destination = temp;
    });
  }

  Future<void> _handleAttachPhoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agregar Evidencia Fotográfica',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Seleccione la fuente para adjuntar imágenes:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryBlue),
                  ),
                  title: const Text(
                    'Tomar foto con Cámara',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Capturar evidencia fotográfica directamente',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _pickFromCamera();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.primaryBlue),
                  ),
                  title: const Text(
                    'Seleccionar de Galería',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Elegir una o varias fotos del almacenamiento',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _addPhotoEvidence(image);
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    for (final image in images) {
      await _addPhotoEvidence(image);
    }
  }

  Future<void> _addPhotoEvidence(XFile image) async {
    final file = File(image.path);
    final size = await file.length();
    
    if (mounted) {
      setState(() {
        _evidences.add(
          PhotoEvidence(
            id: '${DateTime.now().millisecondsSinceEpoch}_${image.name}',
            fileName: image.name,
            label: 'Evidencia fotográfica',
            timeLabel: TimeOfDay.now().format(context),
            sizeLabel: '${(size / (1024 * 1024)).toStringAsFixed(1)} MB',
            localPath: image.path,
          ),
        );
      });
    }
  }

  void _handleDeletePhoto(PhotoEvidence evidence) {
    setState(() => _evidences.removeWhere((e) => e.id == evidence.id));
  }

  Future<void> _handleSubmit() async {
    if (_origin == null || _destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione origen y destino')),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor establezca la ubicación del incidente')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una descripción')),
      );
      return;
    }

    final event = await context.read<ReportEventProvider>().reportEvent(
      originOfficeId: int.parse(_origin!.id),
      destinationOfficeId: int.parse(_destination!.id),
      latitude: _latitude!,
      longitude: _longitude!,
      locationMethod: _locationMode == LocationMode.gps ? 'GPS' : 'MAP',
      accuracy: _accuracy,
      fieldReference: _referenceController.text,
      description: _descriptionController.text,
      evidences: _evidences,
    );

    if (mounted) {
      if (event != null) {
        final currentUser = await UserPreferences.getUser();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.confirmacionRegistro,
            arguments: {
              'event': event,
              'reportedByName': event.reportedBy?.displayName ?? currentUser?.fullName ?? currentUser?.technicianCode ?? 'Técnico',
            },
          );
        }
      } else {
        final error = context.read<ReportEventProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Error al enviar reporte')),
        );
      }
    }
  }

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.reportar) return;

    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case AppTab.centrales:
        Navigator.of(context).pushReplacementNamed(AppRoutes.centrales);
        break;
      case AppTab.reportar:
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed(AppRoutes.eventos);
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final officeProvider = context.watch<CentralOfficeProvider>();
    final reportProvider = context.watch<ReportEventProvider>();
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;

    final centrales = officeProvider.offices.map((e) => Central.fromEntity(e)).toList();

    if (_origin == null && centrales.isNotEmpty) {
      _origin = centrales[0];
    }
    if (_destination == null && centrales.length > 1) {
      _destination = centrales[1];
    }

    return AppScaffold(
      currentTab: AppTab.reportar,
      onTabSelected: _onTabSelected,
      appBar: DetailTopBar(
        title: 'Reporte de Evento',
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ReportarHeroBanner(),
            const SizedBox(height: 20),
            if (officeProvider.isLoading && centrales.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else
              NetworkSegmentSection(
                centrales: centrales,
                origin: _origin,
                destination: _destination,
                estimatedDistanceKm: _totalDistanceKm,
                onOriginSelected: (c) => setState(() => _origin = c),
                onDestinationSelected: (c) => setState(() => _destination = c),
                onSwap: _handleSwap,
              ),
            const SizedBox(height: 16),
            LocationSection(
              mode: _locationMode,
              onModeChanged: (m) => setState(() => _locationMode = m),
              latitude: _latitude,
              longitude: _longitude,
              gpsAccuracy: _accuracy,
              referenceController: _referenceController,
              onLocationChanged: _handleManualLocationChange,
              onUseGps: _useCurrentLocation,
            ),
            const SizedBox(height: 16),
            DiagnosisSection(descriptionController: _descriptionController),
            const SizedBox(height: 16),
            PhotoEvidenceSection(
              evidences: _evidences,
              onAttach: _handleAttachPhoto,
              onDelete: _handleDeletePhoto,
            ),
            const SizedBox(height: 24),
            SubmitActions(
              isSubmitting: reportProvider.isSubmitting,
              onSubmit: _handleSubmit,
              onCancel: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
