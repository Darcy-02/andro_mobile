import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/notification_model.dart';
import '../../../mock/notifications.dart';

class NotificationNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => List.from(mockNotifications);

  int get unreadCount => state.where((n) => !n.isRead).length;

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, List<AppNotification>>(NotificationNotifier.new);

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((n) => !n.isRead).length;
});
