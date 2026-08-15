import 'package:flutter/material.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../models/location_mode.dart';
import '../../models/photo_evidence.dart';
import '../widgets/reportar_hero_banner.dart';
import '../widgets/network_segment_section.dart';
import '../widgets/location_section.dart';
import '../widgets/diagnosis_section.dart';
import '../widgets/photo_evidence_section.dart';
import '../widgets/submit_actions.dart';

class ReportarEventoScreen extends StatefulWidget {
  const ReportarEventoScreen({super.key});

  @override
  State<ReportarEventoScreen> createState() => _ReportarEventoScreenState();
}

class _ReportarEventoScreenState extends State<ReportarEventoScreen> {
  // TODO: reemplazar por datos reales desde el backend (GET /centrales)
  final List<Central> _centrales = const [
    Central(id: '1', prefix: 'TGZ', cityLabel: 'Tuxtla', latitude: 16.7528, longitude: -93.1165),
    Central(id: '2', prefix: 'SCH', cityLabel: 'San', latitude: 16.7370, longitude: -92.6376),
    Central(id: '3', prefix: 'SCL', cityLabel: 'Socoltenango', latitude: 16.2411, longitude: -92.3512),
  ];

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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _origin = _centrales[0]; // TGZ
    _destination = _centrales[1]; // SCH
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

  void _handleAttachPhoto() {
    setState(() {
      _evidences.add(
        PhotoEvidence(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fileName: 'evidencia_${_evidences.length + 1}.jpg',
          label: 'Evidencia fotográfica',
          timeLabel: TimeOfDay.now().format(context),
          sizeLabel: '1.8 MB',
        ),
      );
    });
  }

  void _handleDeletePhoto(PhotoEvidence evidence) {
    setState(() => _evidences.removeWhere((e) => e.id == evidence.id));
  }

  Future<void> _handleSubmit() async {
    if (_origin == null || _destination == null) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.reportar,
      onTabSelected: (tab) {
        if (tab == AppTab.inicio) {
          Navigator.of(context).pushReplacementNamed('/home');
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
          NetworkSegmentSection(
            centrales: _centrales,
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
            isSubmitting: _isSubmitting,
            onSubmit: _handleSubmit,
            onCancel: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
