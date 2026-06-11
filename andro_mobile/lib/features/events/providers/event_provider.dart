import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event_model.dart';
import '../../../mock/events.dart';

class EventNotifier extends Notifier<List<EventModel>> {
  @override
  List<EventModel> build() => List.from(mockEvents);

  EventModel? byId(String id) {
    try {
      return state.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<EventModel> upcoming() =>
      state.where((e) => e.status == EventStatus.upcoming).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<EventModel> byType(EventType type) =>
      state.where((e) => e.type == type).toList();
}

final eventProvider =
    NotifierProvider<EventNotifier, List<EventModel>>(EventNotifier.new);
