import 'package:flutter/foundation.dart';

enum RsvpStatus { going, interested, waitlisted, cancelled }

@immutable
class RsvpEntry {
  final String eventId;
  final RsvpStatus status;
  final DateTime createdAt;
  final bool checkedIn;

  const RsvpEntry({
    required this.eventId,
    required this.status,
    required this.createdAt,
    this.checkedIn = false,
  });

  RsvpEntry copyWith({
    String? eventId,
    RsvpStatus? status,
    DateTime? createdAt,
    bool? checkedIn,
  }) {
    return RsvpEntry(
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      checkedIn: checkedIn ?? this.checkedIn,
    );
  }

  Map<String, dynamic> toMap(String userId) => {
        'userId': userId,
        'eventId': eventId,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'checkedIn': checkedIn ? 1 : 0,
      };

  factory RsvpEntry.fromMap(Map<String, dynamic> map) => RsvpEntry(
        eventId: map['eventId'] as String,
        status: RsvpStatus.values.byName(map['status'] as String),
        createdAt: DateTime.parse(map['createdAt'] as String),
        checkedIn: (map['checkedIn'] as int) == 1,
      );
}
