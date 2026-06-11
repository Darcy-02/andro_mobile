import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: settingsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: AppColors.danger))),
        data: (settings) => ListView(
          children: [
            _sectionHeader('Account'),
            _tile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            _tile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => _showToast(context, 'Password updated successfully.'),
            ),
            _tile(
              icon: Icons.link,
              title: 'Linked Accounts',
              subtitle: 'Google · Apple',
              onTap: () {},
            ),
            _sectionHeader('Notifications'),
            _toggle(
              title: 'Events',
              value: settings.eventsNotifications,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setEventsNotifications(v),
            ),
            _toggle(
              title: 'Opportunities',
              value: settings.opportunitiesNotifications,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .setOpportunitiesNotifications(v),
            ),
            _toggle(
              title: 'Communities',
              value: settings.communitiesNotifications,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .setCommunitiesNotifications(v),
            ),
            _toggle(
              title: 'Direct Messages',
              value: settings.dmsNotifications,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setDmsNotifications(v),
            ),
            _toggle(
              title: 'Mentions',
              value: settings.mentionsNotifications,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setMentionsNotifications(v),
            ),
            _sectionHeader('Privacy'),
            _toggle(
              title: 'Show my RSVPs to other students',
              value: settings.showRsvpsPublicly,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setShowRsvpsPublicly(v),
            ),
            _toggle(
              title: 'Appear in search results',
              value: settings.appearInSearch,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setAppearInSearch(v),
            ),
            _sectionHeader('Danger Zone'),
            _dangerTile(
              title: 'Log Out',
              onTap: () => _confirmLogout(context, ref),
            ),
            _dangerTile(
              title: 'Delete Account',
              onTap: () => _confirmDelete(context, ref),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
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

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: AppColors.bgSurface,
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12))
          : null,
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textSecondary, size: 18),
      onTap: onTap,
    );
  }

  Widget _toggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      tileColor: AppColors.bgSurface,
      title: Text(title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      value: value,
      activeThumbColor: AppColors.gold,
      onChanged: onChanged,
    );
  }

  Widget _dangerTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: AppColors.bgSurface,
      title: Text(title,
          style: const TextStyle(color: AppColors.danger, fontSize: 14)),
      onTap: onTap,
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.bgElevated,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Log Out',
        body: "You'll be returned to the login screen.",
        confirmLabel: 'Log Out',
        onConfirm: () async {
          await ref.read(settingsProvider.notifier).clearAll();
          if (context.mounted) {
            Navigator.of(context)
                .popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Delete Account',
        body: 'This will permanently delete your account and all your data. This cannot be undone.',
        confirmLabel: 'Delete',
        destructive: true,
        onConfirm: () async {
          await ref.read(settingsProvider.notifier).clearAll();
          if (context.mounted) {
            Navigator.of(context)
                .popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final bool destructive;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      content: Text(body,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            confirmLabel,
            style: TextStyle(
                color: destructive ? AppColors.danger : AppColors.gold,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
