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
      child: compact ? _compactCard() : _fullCard(),
    );
  }

  // Featured horizontal-scroll card — cover with overlay title
  Widget _compactCard() {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Cover
          Container(
            height: double.infinity,
            width: double.infinity,
            color: _typeColor().withValues(alpha: 0.18),
            child: Center(
              child: Icon(_typeIcon(), color: _typeColor(), size: 52),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.bgSurface.withValues(alpha: 0.6),
                    AppColors.bgSurface,
                  ],
                  stops: const [0.35, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Content overlaid at bottom
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _typeChip(),
                const SizedBox(height: 6),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined,
                        color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('d MMM · HH:mm').format(event.startTime),
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.people_outline,
                        color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${event.goingIds.length} going',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge top-right
          if (event.status == EventStatus.ongoing)
            Positioned(
              top: 10,
              right: 10,
              child: _statusChip('● LIVE', AppColors.success),
            ),
        ],
      ),
    );
  }

  // Full vertical-feed card
  Widget _fullCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fullCover(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                      _statusChip('● Live', AppColors.success),
                    ],
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _infoRow(Icons.person_outline, event.organiserName),
                const SizedBox(height: 5),
                _infoRow(Icons.access_time_outlined,
                    DateFormat('EEE, d MMM · HH:mm').format(event.startTime)),
                const SizedBox(height: 5),
                _infoRow(Icons.place_outlined, event.location),
                const SizedBox(height: 12),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 10),
                _footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fullCover() {
    return Stack(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          color: _typeColor().withValues(alpha: 0.14),
          child: Center(
            child: Icon(_typeIcon(), color: _typeColor(), size: 40),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.bgSurface.withValues(alpha: 0.6)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _typeChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: _typeColor().withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _typeLabel(),
          style: TextStyle(
              color: _typeColor(),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2),
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
                color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _infoRow(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );

  Widget _footer() => Row(
        children: [
          _pill(Icons.check_circle_outline,
              '${event.goingIds.length} Going', AppColors.success),
          const SizedBox(width: 10),
          _pill(Icons.star_border_rounded,
              '${event.interestedIds.length} Interested', AppColors.accent),
          const Spacer(),
          if (event.capacity > 0)
            Text(
              '${event.capacity} spots',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
            ),
        ],
      );

  Widget _pill(IconData icon, String label, Color color) => Row(
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
      case EventType.workshop: return 'Workshop';
      case EventType.hackathon: return 'Hackathon';
      case EventType.social: return 'Social';
      case EventType.competition: return 'Competition';
      case EventType.seminar: return 'Seminar';
      case EventType.other: return 'Event';
    }
  }

  IconData _typeIcon() {
    switch (event.type) {
      case EventType.workshop: return Icons.build_outlined;
      case EventType.hackathon: return Icons.code_outlined;
      case EventType.social: return Icons.people_outline;
      case EventType.competition: return Icons.emoji_events_outlined;
      case EventType.seminar: return Icons.mic_outlined;
      case EventType.other: return Icons.event_outlined;
    }
  }

  Color _typeColor() {
    switch (event.type) {
      case EventType.hackathon: return AppColors.success;
      case EventType.competition: return AppColors.danger;
      case EventType.social: return const Color(0xFF9B8FE8);
      case EventType.workshop: return const Color(0xFF4CA9D8);
      default: return AppColors.accent;
    }
  }
}
