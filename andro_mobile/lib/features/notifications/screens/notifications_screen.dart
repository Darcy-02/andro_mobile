import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final hasUnread = notifications.any((n) => !n.isRead);

    final grouped = _group(notifications);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: notifier.markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(
                      color: AppColors.gold, fontSize: 13)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _empty()
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: grouped.entries.expand((entry) {
                return [
                  _dateHeader(entry.key),
                  ...entry.value.map((n) => _NotifRow(
                        notification: n,
                        onTap: () {
                          notifier.markRead(n.id);
                          context.push(n.targetRoute);
                        },
                      )),
                ];
              }).toList(),
            ),
    );
  }

  Map<String, List<AppNotification>> _group(List<AppNotification> items) {
    final map = <String, List<AppNotification>>{};
    for (final n in items) {
      final key = _dateKey(n.createdAt);
      map.putIfAbsent(key, () => []).add(n);
    }
    return map;
  }

  String _dateKey(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.day == yesterday.day &&
        dt.month == yesterday.month &&
        dt.year == yesterday.year) {
      return 'Yesterday';
    }
    return DateFormat('EEEE, d MMMM').format(dt);
  }

  Widget _dateHeader(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8)),
      );

  Widget _empty() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none,
                color: AppColors.textSecondary, size: 48),
            SizedBox(height: 12),
            Text('No notifications yet',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 6),
            Text('We will let you know when something happens',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      );
}

class _NotifRow extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotifRow({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : AppColors.goldMuted.withValues(alpha: 0.3),
          border: const Border(
              bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 6),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: AppColors.gold, shape: BoxShape.circle),
                ),
              )
            else
              const SizedBox(width: 14),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon(), color: AppColors.gold, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: notification.isRead
                              ? FontWeight.w400
                              : FontWeight.w500)),
                  const SizedBox(height: 3),
                  Text(notification.body,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon() {
    switch (notification.type) {
      case NotificationType.eventReminder:
        return Icons.event_outlined;
      case NotificationType.connectionRequest:
        return Icons.person_add_outlined;
      case NotificationType.rsvpConfirmed:
        return Icons.check_circle_outline;
      case NotificationType.communityInvite:
        return Icons.groups_outlined;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
