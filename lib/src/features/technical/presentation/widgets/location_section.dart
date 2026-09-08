import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/numbered_section_card.dart';
import '../../domain/entities/location_mode.dart';
import 'location_mode_toggle.dart';
import 'location_picker_map.dart';

class LocationSection extends StatelessWidget {
  final LocationMode mode;
  final ValueChanged<LocationMode> onModeChanged;
  final double? latitude;
  final double? longitude;
  final double? gpsAccuracy;
  final TextEditingController referenceController;
  final ValueChanged<LatLng> onLocationChanged;
  final VoidCallback onUseGps;

  const LocationSection({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.latitude,
    required this.longitude,
    this.gpsAccuracy,
    required this.referenceController,
    required this.onLocationChanged,
    required this.onUseGps,
  });

  @override
  Widget build(BuildContext context) {
    return NumberedSectionCard(
      stepNumber: 2,
      title: 'Ubicación Exacta del Corte',
      subtitle: 'Coordenadas GPS y distancia a centrales',
      iconAssetPath: 'assets/icons/ic_compass.svg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: LocationModeToggle(selected: mode, onChanged: onModeChanged),
              ),
              const SizedBox(width: 8),
              _buildGpsButton(),
            ],
          ),
          const SizedBox(height: 16),
          if (latitude != null && longitude != null)
            LocationPickerMap(
              initialPosition: LatLng(latitude!, longitude!),
              onLocationChanged: onLocationChanged,
            )
          else
            _buildMapPlaceholder(),
          
          if (gpsAccuracy != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Precisión GPS: ±${gpsAccuracy!.toStringAsFixed(1)}m',
                style: const TextStyle(
                  fontSize: 11, 
                  color: AppColors.primaryBlue, 
                  fontWeight: FontWeight.bold
                ),
              ),
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
                hintText: 'Ej. Km 18.5 Carretera Tuxtla - San Cristóbal (Paraje El Calvario)',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlueSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.my_location, color: AppColors.primaryBlue),
        onPressed: onUseGps,
        tooltip: 'Usar mi ubicación actual',
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'Obteniendo ubicación...',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
