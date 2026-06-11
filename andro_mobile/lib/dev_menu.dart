import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/connections_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/rsvp/screens/my_rsvps_screen.dart';
import 'features/rsvp/screens/attendance_view_screen.dart';
import 'features/startups/screens/startup_showcase_screen.dart';
import 'features/startups/screens/startup_detail_screen.dart';
import 'features/startups/screens/submit_startup_screen.dart';

// Dev-only — remove when Darcy's router is ready
class DevMenu extends StatelessWidget {
  const DevMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(Icons.developer_mode, color: AppColors.gold, size: 18),
            SizedBox(width: 8),
            Text(
              'ANDRO · Dev Preview',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section('Profile & Identity'),
          _tile(context, 'Profile Screen (own)', Icons.person_outline,
              () => const ProfileScreen(userId: 'u1')),
          _tile(context, 'Profile Screen (other user)', Icons.person_outline,
              () => const ProfileScreen(userId: 'u3')),
          _tile(context, 'Edit Profile', Icons.edit_outlined,
              () => const EditProfileScreen()),
          _tile(context, 'Connections', Icons.people_outline,
              () => const ConnectionsScreen(userId: 'u1')),
          _tile(context, 'Settings', Icons.settings_outlined,
              () => const SettingsScreen()),
          const SizedBox(height: 8),
          _section('RSVPs & Events'),
          _tile(context, 'My RSVPs', Icons.event_available_outlined,
              () => const MyRsvpsScreen()),
          _tile(context, 'Attendance View (organiser)', Icons.bar_chart_outlined,
              // e2 is owned by u1
              () => const AttendanceViewScreen(eventId: 'e2')),
          const SizedBox(height: 8),
          _section('Startups'),
          _tile(context, 'Startup Showcase', Icons.rocket_launch_outlined,
              () => const StartupShowcaseScreen()),
          _tile(context, 'Submit Startup', Icons.add_business_outlined,
              () => const SubmitStartupScreen()),
          _tile(context, 'Startup Detail (AgriConnect)', Icons.info_outline,
              () => const StartupDetailScreen(startupId: 's1')),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Logged in as: Ayomide Adeleye (u1)\n'
              'All data is mocked. RSVPs persist via sqflite.',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _tile(
    BuildContext context,
    String label,
    IconData icon,
    Widget Function() builder,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold, size: 20),
        title: Text(
          label,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: AppColors.textSecondary, size: 14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => builder()),
        ),
      ),
    );
  }
}
