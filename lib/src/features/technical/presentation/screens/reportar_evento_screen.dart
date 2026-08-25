import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
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
  double _kmOnSegment = 18.5;
  double? _latitude = 16.7528;
  double? _longitude = -93.1152;
  final double _gpsPrecision = 2.1;

  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<PhotoEvidence> _evidences = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CentralOfficeProvider>().loadOffices();
    });
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double get _totalDistanceKm {
    if (_origin == null || _destination == null) return 0;
    return 35.8;
  }

  void _handleSwap() {
    setState(() {
      final temp = _origin;
      _origin = _destination;
      _destination = temp;
    });
  }

  Future<void> _handleAttachPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      final file = File(image.path);
      final size = await file.length();
      
      setState(() {
        _evidences.add(
          PhotoEvidence(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
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

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una descripción')),
      );
      return;
    }

    final success = await context.read<ReportEventProvider>().reportEvent(
      originOfficeId: int.parse(_origin!.id),
      destinationOfficeId: int.parse(_destination!.id),
      latitude: _latitude ?? 0.0,
      longitude: _longitude ?? 0.0,
      locationMethod: _locationMode == LocationMode.gps ? 'GPS' : 'MAP',
      accuracy: _locationMode == LocationMode.gps ? _gpsPrecision : null,
      fieldReference: _referenceController.text,
      description: _descriptionController.text,
      evidences: _evidences,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.confirmacionRegistro);
      } else {
        final error = context.read<ReportEventProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Error al enviar reporte')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final officeProvider = context.watch<CentralOfficeProvider>();
    final reportProvider = context.watch<ReportEventProvider>();

    final centrales = officeProvider.offices.map((e) => Central.fromEntity(e)).toList();

    // Lógica para selecciones iniciales por defecto cuando se cargan los datos
    if (_origin == null && centrales.isNotEmpty) {
      _origin = centrales[0];
    }
    if (_destination == null && centrales.length > 1) {
      _destination = centrales[1];
    }

    return AppScaffold(
      currentTab: AppTab.reportar,
      onTabSelected: (tab) {
        if (tab == AppTab.inicio) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
      appBar: DetailTopBar(
        title: 'Reporte de Evento',
        notificationCount: 2,
        onNotificationTap: () {},
        onAvatarTap: () {},
      ),
      body: Column(
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
            gpsPrecisionMeters: _gpsPrecision,
            kmOnSegment: _kmOnSegment,
            origin: _origin,
            destination: _destination,
            totalDistanceKm: _totalDistanceKm,
            onKmChanged: (v) => setState(() => _kmOnSegment = v),
            referenceController: _referenceController,
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
        ],
      ),
    );
  }
}
