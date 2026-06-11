// TODO: swap with feed dev's EventModel

class EventModel {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String organiserId;
  final int capacity;
  final List<String> attendeeIds;
  final String? coverImageUrl;

  const EventModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.organiserId,
    required this.capacity,
    required this.attendeeIds,
    this.coverImageUrl,
  });
}

final List<EventModel> mockEvents = [
  EventModel(
    id: 'e1',
    title: 'ALU Innovation Week Kickoff',
    startTime: DateTime.now().add(const Duration(hours: 30)),
    endTime: DateTime.now().add(const Duration(hours: 33)),
    location: 'Main Auditorium, ALU Kigali',
    organiserId: 'u6',
    capacity: 200,
    attendeeIds: ['u1', 'u2', 'u3', 'u5'],
  ),
  EventModel(
    id: 'e2',
    title: 'Startup Pitch Night',
    startTime: DateTime.now().add(const Duration(days: 5)),
    endTime: DateTime.now().add(const Duration(days: 5, hours: 2)),
    location: 'Innovation Hub, ALU Kigali',
    organiserId: 'u1',
    capacity: 80,
    attendeeIds: ['u2', 'u4', 'u7'],
  ),
  EventModel(
    id: 'e3',
    title: 'Women in Tech Panel',
    startTime: DateTime.now().add(const Duration(days: 2)),
    endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
    location: 'Seminar Room B, ALU Kigali',
    organiserId: 'u4',
    capacity: 60,
    attendeeIds: ['u1', 'u5', 'u7', 'u10'],
  ),
  EventModel(
    id: 'e4',
    title: 'Community Football Tournament',
    startTime: DateTime.now().subtract(const Duration(days: 3)),
    endTime: DateTime.now().subtract(const Duration(days: 3)).add(const Duration(hours: 4)),
    location: 'ALU Sports Ground',
    organiserId: 'u9',
    capacity: 100,
    attendeeIds: ['u1', 'u3', 'u6', 'u8', 'u9'],
  ),
  EventModel(
    id: 'e5',
    title: 'Data Science Workshop',
    startTime: DateTime.now().subtract(const Duration(days: 10)),
    endTime: DateTime.now().subtract(const Duration(days: 10)).add(const Duration(hours: 3)),
    location: 'Computer Lab 2, ALU Kigali',
    organiserId: 'u4',
    capacity: 30,
    attendeeIds: ['u1', 'u8', 'u10'],
  ),
];
