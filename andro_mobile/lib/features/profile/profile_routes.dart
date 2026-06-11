import 'package:go_router/go_router.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/connections_screen.dart';
import 'screens/settings_screen.dart';
import '../rsvp/screens/my_rsvps_screen.dart';
import '../rsvp/screens/attendance_view_screen.dart';
import '../startups/screens/startup_showcase_screen.dart';
import '../startups/screens/startup_detail_screen.dart';
import '../startups/screens/submit_startup_screen.dart';

// Give to Darcy to merge into the root router.
// /profile/edit must come before /profile/:userId or "edit" matches as a userId.
final profileRoutes = <GoRoute>[
  GoRoute(
    path: '/profile/edit',
    builder: (_, _) => const EditProfileScreen(),
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
  GoRoute(
    path: '/rsvps',
    builder: (_, _) => const MyRsvpsScreen(),
  ),
  GoRoute(
    path: '/event/:id/attendance',
    builder: (_, state) =>
        AttendanceViewScreen(eventId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/startups',
    builder: (_, _) => const StartupShowcaseScreen(),
  ),
  GoRoute(
    path: '/startups/submit',
    builder: (_, _) => const SubmitStartupScreen(),
  ),
  GoRoute(
    path: '/startups/:id',
    builder: (_, state) =>
        StartupDetailScreen(startupId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/settings',
    builder: (_, _) => const SettingsScreen(),
  ),
];
