enum EventType { workshop, hackathon, social, competition, seminar, other }
enum EventStatus { upcoming, ongoing, past, cancelled }

class EventModel {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String? room;
  final String? coverImageUrl;
  final String organiserId;
  final String organiserName;
  final List<String> tags;
  final int capacity;
  final List<String> goingIds;
  final List<String> interestedIds;
  final EventStatus status;
  final String? communityId;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.room,
    this.coverImageUrl,
    required this.organiserId,
    required this.organiserName,
    required this.tags,
    required this.capacity,
    required this.goingIds,
    required this.interestedIds,
    required this.status,
    this.communityId,
  });

  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isPast => endTime.isBefore(DateTime.now());
  int get totalInterest => goingIds.length + interestedIds.length;
}
