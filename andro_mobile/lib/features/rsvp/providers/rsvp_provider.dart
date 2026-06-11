import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/rsvp_entry.dart';
import '../../../mock/stub_event.dart';
import 'rsvp_database.dart';

class RsvpNotifier extends AsyncNotifier<List<RsvpEntry>> {
  static const _userId = 'u1';

  @override
  Future<List<RsvpEntry>> build() async {
    final count = await RsvpDatabase.instance.countForUser(_userId);
    if (count == 0) await _seedMockRsvps();
    return RsvpDatabase.instance.getRsvpsForUser(_userId);
  }

  Future<void> rsvpEvent(String eventId, RsvpStatus status) async {
    final entry = RsvpEntry(
      eventId: eventId,
      status: status,
      createdAt: DateTime.now(),
    );
    await RsvpDatabase.instance.upsertRsvp(_userId, entry);
    _reload();
  }

  Future<void> cancelRsvp(String eventId) async {
    await RsvpDatabase.instance.deleteRsvp(_userId, eventId);
    _reload();
  }

  void _reload() {
    ref.invalidateSelf();
  }


  List<RsvpEntry> going(List<RsvpEntry> entries) => entries
      .where((e) => e.status == RsvpStatus.going)
      .toList()
    ..sort((a, b) => _eventDate(a.eventId).compareTo(_eventDate(b.eventId)));

  List<RsvpEntry> interested(List<RsvpEntry> entries) => entries
      .where((e) => e.status == RsvpStatus.interested)
      .toList()
    ..sort((a, b) => _eventDate(a.eventId).compareTo(_eventDate(b.eventId)));

  List<RsvpEntry> past(List<RsvpEntry> entries) {
    final now = DateTime.now();
    return entries
        .where((e) {
          final event = _eventById(e.eventId);
          return event != null && event.endTime.isBefore(now);
        })
        .toList()
      ..sort((a, b) => _eventDate(b.eventId).compareTo(_eventDate(a.eventId)));
  }

  DateTime _eventDate(String eventId) =>
      _eventById(eventId)?.startTime ?? DateTime(2099);

  EventModel? _eventById(String id) {
    try {
      return mockEvents.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }


  Future<void> _seedMockRsvps() async {
    final seeds = [
      RsvpEntry(eventId: 'e1', status: RsvpStatus.going, createdAt: DateTime.now().subtract(const Duration(days: 2))),
      RsvpEntry(eventId: 'e2', status: RsvpStatus.going, createdAt: DateTime.now().subtract(const Duration(days: 1))),
      RsvpEntry(eventId: 'e3', status: RsvpStatus.interested, createdAt: DateTime.now().subtract(const Duration(hours: 12))),
      RsvpEntry(eventId: 'e4', status: RsvpStatus.going, createdAt: DateTime.now().subtract(const Duration(days: 5)), checkedIn: true),
      RsvpEntry(eventId: 'e5', status: RsvpStatus.going, createdAt: DateTime.now().subtract(const Duration(days: 12)), checkedIn: false),
    ];
    for (final e in seeds) {
      await RsvpDatabase.instance.upsertRsvp(_userId, e);
    }
  }
}

final rsvpProvider =
    AsyncNotifierProvider<RsvpNotifier, List<RsvpEntry>>(RsvpNotifier.new);
