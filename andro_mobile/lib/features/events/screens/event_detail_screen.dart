import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../models/rsvp_entry.dart';
import '../../../mock/events.dart';
import '../../rsvp/providers/rsvp_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = mockEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => mockEvents.first,
    );

    final rsvpAsync = ref.watch(rsvpProvider);
    final myStatus = rsvpAsync.whenData((entries) {
      try {
        return entries.firstWhere((e) => e.eventId == eventId).status;
      } catch (_) {
        return null;
      }
    }).value;

    final isOrganiser = event.organiserId == 'u1';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (isOrganiser)
                TextButton(
                  onPressed: () =>
                      context.push('/event/$eventId/attendance'),
                  child: const Text('Manage',
                      style: TextStyle(
                          color: AppColors.gold, fontWeight: FontWeight.w600)),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: _typeColor(event.type).withValues(alpha: 0.15),
                    child: Center(
                      child: Icon(_typeIcon(event.type),
                          color: _typeColor(event.type), size: 64),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.bgPrimary],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _chip(_typeLabel(event.type), AppColors.gold,
                        AppColors.goldMuted),
                    if (event.status == EventStatus.past) ...[
                      const SizedBox(width: 6),
                      _chip('Past', AppColors.textSecondary,
                          AppColors.bgElevated),
                    ],
                  ]),
                  const SizedBox(height: 10),
                  Text(event.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _infoRow(Icons.person_outline, event.organiserName),
                  const SizedBox(height: 20),
                  _statsRow(event),
                  const Divider(color: AppColors.border, height: 32),
                  _infoRow(Icons.access_time_outlined,
                      DateFormat('EEEE, d MMMM yyyy · HH:mm').format(event.startTime)),
                  const SizedBox(height: 8),
                  _infoRow(Icons.place_outlined, event.location),
                  if (event.room != null) ...[
                    const SizedBox(height: 8),
                    _infoRow(Icons.door_back_door_outlined, event.room!),
                  ],
                  if (event.capacity > 0) ...[
                    const SizedBox(height: 8),
                    _infoRow(Icons.people_outline,
                        '${event.capacity} capacity'),
                  ],
                  if (event.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: event.tags
                          .map((t) => _chip(
                              t, AppColors.textSecondary, AppColors.bgElevated))
                          .toList(),
                    ),
                  ],
                  const Divider(color: AppColors.border, height: 32),
                  const Text('About this event',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(event.description,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.6)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: event.status != EventStatus.past
          ? _RsvpFooter(event: event, currentStatus: myStatus)
          : null,
    );
  }

  Widget _statsRow(EventModel event) => Row(
        children: [
          _stat('${event.goingIds.length}', 'Going', AppColors.success),
          const SizedBox(width: 24),
          _stat('${event.interestedIds.length}', 'Interested', AppColors.gold),
          if (event.totalInterest > 0) ...[
            const SizedBox(width: 24),
            _stat('${event.totalInterest}', 'Total', AppColors.textSecondary),
          ],
        ],
      );

  Widget _stat(String value, String label, Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      );

  Widget _infoRow(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14)),
          ),
        ],
      );

  Widget _chip(String label, Color fg, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
      );

  String _typeLabel(EventType t) {
    switch (t) {
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

  IconData _typeIcon(EventType t) {
    switch (t) {
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

  Color _typeColor(EventType t) {
    switch (t) {
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

class _RsvpFooter extends ConsumerWidget {
  final EventModel event;
  final RsvpStatus? currentStatus;

  const _RsvpFooter({required this.event, required this.currentStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rsvpProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: currentStatus == RsvpStatus.interested
                  ? () => notifier.cancelRsvp(event.id)
                  : () => notifier.rsvpEvent(event.id, RsvpStatus.interested),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: currentStatus == RsvpStatus.interested
                        ? AppColors.gold
                        : AppColors.border),
                backgroundColor: currentStatus == RsvpStatus.interested
                    ? AppColors.goldMuted
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                currentStatus == RsvpStatus.interested
                    ? '★ Interested'
                    : '☆ Interested',
                style: TextStyle(
                    color: currentStatus == RsvpStatus.interested
                        ? AppColors.gold
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: currentStatus == RsvpStatus.going
                  ? () => notifier.cancelRsvp(event.id)
                  : () => notifier.rsvpEvent(event.id, RsvpStatus.going),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentStatus == RsvpStatus.going
                    ? AppColors.success
                    : AppColors.gold,
                foregroundColor: AppColors.bgPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                currentStatus == RsvpStatus.going ? '✓ Going' : 'RSVP Going',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
