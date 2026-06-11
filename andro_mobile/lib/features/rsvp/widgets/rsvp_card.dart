import 'package:flutter/material.dart';
import '../../../models/rsvp_entry.dart';
import '../../../mock/stub_event.dart';
import '../../../core/theme/app_colors.dart';
import 'countdown_pill.dart';

class RsvpCard extends StatelessWidget {
  final RsvpEntry entry;
  final EventModel event;
  final bool dimmed;

  const RsvpCard({
    super.key,
    required this.entry,
    required this.event,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = event.endTime.isBefore(now);
    final isToday = !isPast &&
        event.startTime.difference(now).inHours < 24 &&
        event.startTime.isAfter(now);
    final isWithin48h = !isPast &&
        event.startTime.difference(now).inHours <= 48 &&
        event.startTime.isAfter(now);

    return Opacity(
      opacity: dimmed ? 0.55 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _coverThumbnail(),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _details(isPast, isToday, isWithin48h, now),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _coverThumbnail() {
    return Container(
      width: 72,
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
      ),
      child: const Icon(
        Icons.event_outlined,
        color: AppColors.textSecondary,
        size: 28,
      ),
    );
  }

  Widget _details(bool isPast, bool isToday, bool isWithin48h, DateTime now) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _iconRow(Icons.calendar_today_outlined, _formatDate(event.startTime)),
        const SizedBox(height: 2),
        _iconRow(Icons.location_on_outlined, event.location),
        const SizedBox(height: 6),
        Row(
          children: [
            _statusChip(isPast, isToday),
            if (isWithin48h && !isPast) ...[
              const SizedBox(width: 6),
              CountdownPill(eventStart: event.startTime),
            ],
            if (isPast && entry.status == RsvpStatus.going) ...[
              const SizedBox(width: 6),
              _attendedChip(entry.checkedIn),
            ],
          ],
        ),
      ],
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(bool isPast, bool isToday) {
    String label;
    Color bg;
    Color fg;

    if (isPast) {
      label = 'Past';
      bg = AppColors.bgElevated;
      fg = AppColors.textSecondary;
    } else if (isToday) {
      label = 'Today';
      bg = const Color(0x33E5A020);
      fg = AppColors.gold;
    } else {
      label = 'Upcoming';
      bg = const Color(0x1A3FB950);
      fg = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _attendedChip(bool attended) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: attended
            ? const Color(0x1A3FB950)
            : const Color(0x1AF85149),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        attended ? 'Attended ✓' : 'Missed',
        style: TextStyle(
          color: attended ? AppColors.success : AppColors.danger,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${months[dt.month - 1]} ${dt.day} · $h:$m $period';
  }
}
