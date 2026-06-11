import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/community_model.dart';
import '../../../mock/communities.dart';

class CommunityNotifier extends Notifier<List<CommunityModel>> {
  static const _userId = 'u1';

  @override
  List<CommunityModel> build() => List.from(mockCommunities);

  List<CommunityModel> joined() =>
      state.where((c) => c.memberIds.contains(_userId)).toList();

  List<CommunityModel> notJoined() =>
      state.where((c) => !c.memberIds.contains(_userId) && !c.isPrivate).toList();

  CommunityModel? byId(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isMember(String communityId) {
    final c = byId(communityId);
    return c?.memberIds.contains(_userId) ?? false;
  }

  void join(String communityId) {
    state = [
      for (final c in state)
        if (c.id == communityId && !c.memberIds.contains(_userId))
          c.copyWith(memberIds: [...c.memberIds, _userId])
        else
          c,
    ];
  }

  void leave(String communityId) {
    state = [
      for (final c in state)
        if (c.id == communityId)
          c.copyWith(memberIds: c.memberIds.where((id) => id != _userId).toList())
        else
          c,
    ];
  }
}

final communityProvider =
    NotifierProvider<CommunityNotifier, List<CommunityModel>>(CommunityNotifier.new);
