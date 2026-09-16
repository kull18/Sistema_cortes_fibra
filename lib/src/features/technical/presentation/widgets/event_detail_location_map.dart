import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/dark_map_style.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/fiber_event.dart';

class EventDetailLocationMap extends StatefulWidget {
  final FiberEvent event;

  const EventDetailLocationMap({super.key, required this.event});

  @override
  State<EventDetailLocationMap> createState() => _EventDetailLocationMapState();
}

class _EventDetailLocationMapState extends State<EventDetailLocationMap> {
  LatLng get _eventPosition {
    final lat = widget.event.latitude ?? 16.7528;
    final lng = widget.event.longitude ?? -93.1152;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pos = _eventPosition;
    final latFormatted = pos.latitude.toStringAsFixed(4);
    final lngFormatted = pos.longitude.toStringAsFixed(4);
    final mapHeight = context.responsiveValue<double>(
      small: 180.0,
      medium: 220.0,
      large: 260.0,
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: colors.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Ubicación Exacta\nde Incidencia',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.surfaceMuted,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.event.kmReference} · ${widget.event.location}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: mapHeight,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              style: isDark ? darkMapStyle : null,
              initialCameraPosition: CameraPosition(
                target: pos,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('event_location'),
                  position: pos,
                  infoWindow: InfoWindow(
                    title: widget.event.kmReference,
                    snippet: widget.event.location,
                  ),
                ),
              },
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.my_location, size: 14, color: colors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Lat: $latFormatted, Lng: $lngFormatted',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryBlueSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GPS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
