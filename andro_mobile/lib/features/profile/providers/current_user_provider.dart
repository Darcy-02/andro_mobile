import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../mock/users.dart';

class CurrentUserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() => mockUsers[0];

  void update(UserModel updated) => state = updated;

  void updateAvatar(String? avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserModel>(
  CurrentUserNotifier.new,
);
