import 'package:flutter/material.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/numbered_section_card.dart';
import '../../models/location_mode.dart';
import 'location_mode_toggle.dart';
import 'map_preview_card.dart';
import 'distance_slider_card.dart';

class LocationSection extends StatelessWidget {
  final LocationMode mode;
  final ValueChanged<LocationMode> onModeChanged;
  final double? latitude;
  final double? longitude;
  final double gpsPrecisionMeters;
  final double kmOnSegment;
  final Central? origin;
  final Central? destination;
  final double totalDistanceKm;
  final ValueChanged<double> onKmChanged;
  final TextEditingController referenceController;

  const LocationSection({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.latitude,
    required this.longitude,
    required this.gpsPrecisionMeters,
    required this.kmOnSegment,
    required this.origin,
    required this.destination,
    required this.totalDistanceKm,
    required this.onKmChanged,
    required this.referenceController,
  });

  @override
  Widget build(BuildContext context) {
    return NumberedSectionCard(
      stepNumber: 2,
      title: 'Ubicación Exacta del Corte',
      subtitle: 'Coordenadas GPS y distancia a centrales',
      iconAssetPath: 'assets/icons/brujula.svg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationModeToggle(selected: mode, onChanged: onModeChanged),
          const SizedBox(height: 16),
          MapPreviewCard(
            latitude: latitude,
            longitude: longitude,
            gpsPrecisionMeters: gpsPrecisionMeters,
            kmOnSegment: kmOnSegment,
            origin: origin,
            destination: destination,
            distanceToOriginKm: kmOnSegment,
            distanceToDestinationKm: totalDistanceKm - kmOnSegment,
          ),
          const SizedBox(height: 16),
          DistanceSliderCard(
            value: kmOnSegment,
            min: 0,
            max: totalDistanceKm > 0 ? totalDistanceKm : 1,
            origin: origin,
            destination: destination,
            onChanged: onKmChanged,
          ),
          const SizedBox(height: 16),
          const Text(
            'Descripción / Referencia de Terreno',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderSubtle),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: referenceController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
                hintText:
                'Ej. Km 18.5 Carretera Tuxtla - San Cristóbal (Paraje El Calvario)',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
