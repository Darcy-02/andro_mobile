import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/user_model.dart';
import '../../../mock/stub_event.dart';
import '../../../mock/users.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/providers/current_user_provider.dart';

class AttendanceViewScreen extends ConsumerWidget {
  final String eventId;

  const AttendanceViewScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final event = _findEvent(eventId);

    if (event == null) {
      return _errorScaffold(context, 'Event not found.');
    }

    if (event.organiserId != currentUser.id) {
      return _errorScaffold(context, 'You are not the organiser of this event.');
    }

    final attendees = mockUsers
        .where((u) => event.goingIds.contains(u.id))
        .toList();
    final goingCount = event.goingIds.length;
    final capacity = event.capacity;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Event',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _eventTitle(event),
          const SizedBox(height: 24),
          _statRow('Going', goingCount, capacity, AppColors.gold),
          const SizedBox(height: 12),
          _statRow('Interested', (goingCount * 0.4).round(), capacity,
              AppColors.textSecondary),
          const SizedBox(height: 28),
          const Text(
            'ATTENDEES',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          if (attendees.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('No attendees yet.',
                  style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            ...attendees.map((u) => _attendeeRow(u)),
          const SizedBox(height: 28),
          _actionButton(
            icon: Icons.qr_code,
            label: 'Generate QR Code',
            onTap: () => _showQrPlaceholder(context),
          ),
          const SizedBox(height: 12),
          _actionButton(
            icon: Icons.download_outlined,
            label: 'Export CSV',
            onTap: () => _exportCsv(context, event, attendees),
            outlined: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _eventTitle(EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(event.location,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _statRow(String label, int count, int total, Color barColor) {
    final fraction = total == 0 ? 0.0 : (count / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            Text(
              '$count / $total',
              style: TextStyle(
                  color: barColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: AppColors.bgElevated,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }

  Widget _attendeeRow(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.goldMuted,
            child: Text(user.fullName[0],
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(user.programme,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          _checkinBadge(user.eventsAttended > 0),
        ],
      ),
    );
  }

  Widget _checkinBadge(bool attended) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: attended
            ? const Color(0x1A3FB950)
            : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        attended ? 'Attended ✓' : 'Not yet',
        style: TextStyle(
          color: attended ? AppColors.success : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: AppColors.bgPrimary),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.bgPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
    );
  }

  void _showQrPlaceholder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.qr_code,
                  color: AppColors.textSecondary, size: 80),
            ),
            const SizedBox(height: 16),
            const Text('QR Check-in Code',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Attendees scan this to check in.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCsv(
      BuildContext context, EventModel event, List attendees) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          '${event.title.replaceAll(' ', '_')}_attendees.csv';
      final file = File('${dir.path}/$fileName');
      final buffer = StringBuffer()
        ..writeln('Name,Programme,Attended')
        ..writeAll(
          attendees.map(
              (u) => '${u.fullName},${u.programme},${u.eventsAttended > 0}'),
          '\n',
        );
      await file.writeAsString(buffer.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to $fileName'),
            backgroundColor: AppColors.bgElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  EventModel? _findEvent(String id) {
    try {
      return mockEvents.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Scaffold _errorScaffold(BuildContext context, String message) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.bgPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      );
}
