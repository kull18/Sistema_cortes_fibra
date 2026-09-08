import 'package:flutter/material.dart';
import '../../domain/entities/fiber_event.dart';
import '../../domain/entities/technical_comment.dart';
import 'event_detail_main_info.dart';
import 'event_detail_location_map.dart';
import 'event_detail_photos_section.dart';
import 'technical_comments_section.dart';

class EventDetailBody extends StatelessWidget {
  final FiberEvent event;
  final List<Map<String, dynamic>> photos;
  final List<TechnicalComment> comments;

  const EventDetailBody({
    super.key,
    required this.event,
    required this.photos,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventDetailMainInfo(event: event),
          const SizedBox(height: 16),
          EventDetailLocationMap(event: event),
          const SizedBox(height: 16),
          EventDetailPhotosSection(photos: photos),
          const SizedBox(height: 16),
          TechnicalCommentsSection(comments: comments),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
