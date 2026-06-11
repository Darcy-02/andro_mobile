enum NotificationType {
  eventReminder,
  connectionRequest,
  rsvpConfirmed,
  communityInvite,
  mention,
  announcement,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String targetRoute;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.targetRoute,
    required this.isRead,
    required this.createdAt,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        targetRoute: targetRoute,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}
