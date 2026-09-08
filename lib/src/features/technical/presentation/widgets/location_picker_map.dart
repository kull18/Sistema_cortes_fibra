import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/responsive/responsive_extensions.dart';

class LocationPickerMap extends StatefulWidget {
  final LatLng initialPosition;
  final ValueChanged<LatLng> onLocationChanged;

  const LocationPickerMap({
    super.key,
    required this.initialPosition,
    required this.onLocationChanged,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late LatLng _currentPos;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _currentPos = widget.initialPosition;
  }

  @override
  void didUpdateWidget(LocationPickerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPosition != widget.initialPosition) {
      _currentPos = widget.initialPosition;
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(widget.initialPosition),
      );
    }
  }

  void _updatePosition(LatLng position) {
    setState(() {
      _currentPos = position;
    });
    widget.onLocationChanged(position);
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = context.responsiveValue<double>(
      small: 180.0,
      medium: 220.0,
      large: 260.0,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: mapHeight,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: 15,
          ),
          onMapCreated: (controller) => _mapController = controller,
          markers: {
            Marker(
              markerId: const MarkerId('selected_point'),
              position: _currentPos,
              draggable: true,
              onDragEnd: _updatePosition,
            ),
          },
          onTap: _updatePosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}
