import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/providers/auth_provider.dart';

// Dev-only — remove when Darcy's router is ready
class DevMenu extends ConsumerWidget {
  const DevMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(Icons.developer_mode, color: AppColors.accent, size: 18),
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
          _section('Auth'),
          _tile(context, 'Login', Icons.login_outlined,
              () => context.push('/login')),
          _tile(context, 'Onboarding', Icons.waving_hand_outlined,
              () => context.push('/onboarding')),
          _tile(context, 'Enter App (skip auth)', Icons.skip_next_outlined, () {
            ref.read(authProvider.notifier).completeOnboarding();
          }),
          const SizedBox(height: 8),
          _section('Main Screens'),
          _tile(context, 'Feed', Icons.home_outlined,
              () => context.push('/feed')),
          _tile(context, 'Explore', Icons.explore_outlined,
              () => context.push('/explore')),
          _tile(context, 'Chats', Icons.chat_bubble_outline,
              () => context.push('/chats')),
          _tile(context, 'Notifications', Icons.notifications_outlined,
              () => context.push('/notifications')),
          const SizedBox(height: 8),
          _section('Profile & Identity'),
          _tile(context, 'Profile (own)', Icons.person_outline,
              () => context.push('/profile/u1')),
          _tile(context, 'Profile (other user)', Icons.person_outline,
              () => context.push('/profile/u3')),
          _tile(context, 'Edit Profile', Icons.edit_outlined,
              () => context.push('/profile/edit')),
          _tile(context, 'Connections', Icons.people_outline,
              () => context.push('/profile/u1/connections')),
          _tile(context, 'Settings', Icons.settings_outlined,
              () => context.push('/settings')),
          const SizedBox(height: 8),
          _section('Events & RSVPs'),
          _tile(context, 'Event Detail (Innovation Week)', Icons.event_outlined,
              () => context.push('/event/e1')),
          _tile(context, 'My RSVPs', Icons.event_available_outlined,
              () => context.push('/rsvps')),
          _tile(context, 'Attendance View (organiser)', Icons.bar_chart_outlined,
              // e2 is owned by u1
              () => context.push('/event/e2/attendance')),
          const SizedBox(height: 8),
          _section('Communities'),
          _tile(context, 'Communities', Icons.groups_outlined,
              () => context.push('/communities')),
          _tile(context, 'Community Detail (Tech Hub)', Icons.info_outline,
              () => context.push('/community/c2')),
          const SizedBox(height: 8),
          _section('Startups'),
          _tile(context, 'Startup Showcase', Icons.rocket_launch_outlined,
              () => context.push('/startups')),
          _tile(context, 'Startup Detail (AgriConnect)', Icons.info_outline,
              () => context.push('/startups/s1')),
          _tile(context, 'Submit Startup', Icons.add_business_outlined,
              () => context.push('/startups/submit')),
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
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent, size: 20),
        title: Text(
          label,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: AppColors.textSecondary, size: 14),
        onTap: onTap,
      ),
    );
  }
}
