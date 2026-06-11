import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/shell/main_shell.dart';
import 'features/feed/screens/feed_screen.dart';
import 'features/explore/screens/explore_screen.dart';
import 'features/chat/screens/chat_list_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/connections_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/events/screens/event_detail_screen.dart';
import 'features/rsvp/screens/my_rsvps_screen.dart';
import 'features/rsvp/screens/attendance_view_screen.dart';
import 'features/communities/screens/communities_screen.dart';
import 'features/communities/screens/community_detail_screen.dart';
import 'features/startups/screens/startup_showcase_screen.dart';
import 'features/startups/screens/startup_detail_screen.dart';
import 'features/startups/screens/submit_startup_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      if (!auth.isLoggedIn) {
        return loc == '/login' ? null : '/login';
      }
      if (!auth.hasCompletedOnboarding) {
        return loc == '/onboarding' ? null : '/onboarding';
      }
      if (loc == '/login' || loc == '/onboarding') return '/feed';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/feed',
              builder: (_, __) => const FeedScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/explore',
              builder: (_, __) => const ExploreScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/create', builder: (_, __) => const FeedScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/chats',
              builder: (_, __) => const ChatListScreen(),
              routes: [
                GoRoute(
                  path: ':chatId',
                  builder: (_, state) =>
                      ChatScreen(chatId: state.pathParameters['chatId']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(userId: 'u1'),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/event/:id',
        builder: (_, state) =>
            EventDetailScreen(eventId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'attendance',
            builder: (_, state) =>
                AttendanceViewScreen(eventId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/community/:id',
        builder: (_, state) =>
            CommunityDetailScreen(communityId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        builder: (_, state) =>
            ProfileScreen(userId: state.pathParameters['userId']!),
        routes: [
          GoRoute(
            path: 'connections',
            builder: (_, state) =>
                ConnectionsScreen(userId: state.pathParameters['userId']!),
          ),
        ],
      ),
      GoRoute(path: '/rsvps', builder: (_, __) => const MyRsvpsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
          path: '/communities', builder: (_, __) => const CommunitiesScreen()),
      GoRoute(
          path: '/startups', builder: (_, __) => const StartupShowcaseScreen()),
      GoRoute(
        path: '/startups/:id',
        builder: (_, state) =>
            StartupDetailScreen(startupId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/startups/submit',
          builder: (_, __) => const SubmitStartupScreen()),
      GoRoute(
          path: '/notifications',
          builder: (_, __) => const NotificationsScreen()),
    ],
  );
});
