import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final bool compact;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cover(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _typeChip(),
                      if (event.status == EventStatus.past) ...[
                        const SizedBox(width: 6),
                        _statusChip('Past', AppColors.textSecondary),
                      ] else if (event.status == EventStatus.ongoing) ...[
                        const SizedBox(width: 6),
                        _statusChip('Live', AppColors.success),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _row(Icons.person_outline, event.organiserName),
                  const SizedBox(height: 4),
                  _row(Icons.access_time_outlined,
                      DateFormat('EEE d MMM · HH:mm').format(event.startTime)),
                  const SizedBox(height: 4),
                  _row(Icons.place_outlined, event.location,
                      maxLines: 1),
                  if (!compact) ...[
                    const SizedBox(height: 10),
                    _footer(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: _typeColor().withValues(alpha: 0.15),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Center(
        child: Icon(_typeIcon(), color: _typeColor(), size: 36),
      ),
    );
  }

  Widget _typeChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.goldMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _typeLabel(),
          style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w500),
        ),
      );

  Widget _statusChip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w500)),
      );

  Widget _row(IconData icon, String text, {int maxLines = 2}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );

  Widget _footer() => Row(
        children: [
          _countPill(Icons.check_circle_outline, '${event.goingIds.length} Going',
              AppColors.success),
          const SizedBox(width: 8),
          _countPill(Icons.star_outline, '${event.interestedIds.length} Interested',
              AppColors.gold),
          const Spacer(),
          if (event.capacity > 0)
            Text(
              '${event.capacity} capacity',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
            ),
        ],
      );

  Widget _countPill(IconData icon, String label, Color color) => Row(
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      );

  String _typeLabel() {
    switch (event.type) {
      case EventType.workshop:
        return 'Workshop';
      case EventType.hackathon:
        return 'Hackathon';
      case EventType.social:
        return 'Social';
      case EventType.competition:
        return 'Competition';
      case EventType.seminar:
        return 'Seminar';
      case EventType.other:
        return 'Event';
    }
  }

  IconData _typeIcon() {
    switch (event.type) {
      case EventType.workshop:
        return Icons.build_outlined;
      case EventType.hackathon:
        return Icons.code_outlined;
      case EventType.social:
        return Icons.people_outline;
      case EventType.competition:
        return Icons.emoji_events_outlined;
      case EventType.seminar:
        return Icons.mic_outlined;
      case EventType.other:
        return Icons.event_outlined;
    }
  }

  Color _typeColor() {
    switch (event.type) {
      case EventType.hackathon:
        return AppColors.success;
      case EventType.competition:
        return AppColors.danger;
      case EventType.social:
        return const Color(0xFF7B68EE);
      default:
        return AppColors.gold;
    }
  }
}
