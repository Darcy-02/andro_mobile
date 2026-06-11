import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../../../mock/startups.dart';

class StartupNotifier extends Notifier<List<StartupModel>> {
  @override
  List<StartupModel> build() => List.from(mockStartups);

  void submitStartup(StartupModel startup) {
    state = [...state, startup];
  }

  void expressInterest(String startupId) {
    state = [
      for (final s in state)
        if (s.id == startupId)
          s.copyWith(interestCount: s.interestCount + 1)
        else
          s,
    ];
  }

  void joinTeam(String startupId, String userId) {
    state = [
      for (final s in state)
        if (s.id == startupId && !s.teamMemberIds.contains(userId))
          s.copyWith(teamMemberIds: [...s.teamMemberIds, userId])
        else
          s,
    ];
  }

  void updateStartup(StartupModel updated) {
    state = [
      for (final s in state) if (s.id == updated.id) updated else s,
    ];
  }
}

final startupProvider =
    NotifierProvider<StartupNotifier, List<StartupModel>>(StartupNotifier.new);
