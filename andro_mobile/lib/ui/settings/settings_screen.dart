import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../theme_colors.dart';
import '../profile/edit_profile_screen.dart';
import '../launch_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg       = isDark ? AndroColors.darkBackground  : AndroColors.lightBackground;
    final surface  = isDark ? AndroColors.darkSurface      : AndroColors.lightSurface;
    final accent   = isDark ? AndroColors.darkAccent       : AndroColors.lightAccent;
    final text     = isDark ? AndroColors.darkText         : AndroColors.lightText;
    final secondary= isDark ? AndroColors.darkSecondary    : AndroColors.lightSecondary;
    final divider  = isDark ? AndroColors.darkDivider      : AndroColors.lightDivider;
    final danger   = isDark ? AndroColors.darkRed          : AndroColors.lightRed;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: text, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // ── Account ──────────────────────────────────────────────────────
          _SectionHeader(label: 'Account', color: secondary),
          _SettingGroup(surface: surface, divider: divider, children: [
            _ArrowRow(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              accent: accent,
              text: text,
              secondary: secondary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            _Divider(color: divider),
            _ArrowRow(
              icon: Icons.lock_outline_rounded,
              label: 'Change Password',
              accent: accent,
              text: text,
              secondary: secondary,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Password update coming soon'),
                  backgroundColor: accent,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
            _Divider(color: divider),
            _StaticRow(
              icon: Icons.link_rounded,
              label: 'Linked Accounts',
              accent: accent,
              text: text,
              secondary: secondary,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Google', style: TextStyle(color: secondary, fontSize: 13)),
                  const SizedBox(width: 6),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4285F4),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('G',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ]),

          // ── Notifications ─────────────────────────────────────────────────
          _SectionHeader(label: 'Notifications', color: secondary),
          _SettingGroup(surface: surface, divider: divider, children: [
            for (final entry in [
              ('notif_events', Icons.event_rounded, 'Events'),
              ('notif_opportunities', Icons.work_outline_rounded, 'Opportunities'),
              ('notif_communities', Icons.group_outlined, 'Communities'),
              ('notif_dms', Icons.chat_bubble_outline_rounded, 'Direct Messages'),
              ('notif_mentions', Icons.alternate_email_rounded, 'Mentions'),
            ]) ...[
              _SwitchRow(
                icon: entry.$2,
                label: entry.$3,
                value: appState.getPref(entry.$1),
                accent: accent,
                text: text,
                secondary: secondary,
                onChanged: (v) => appState.setPref(entry.$1, v),
              ),
              if (entry.$1 != 'notif_mentions') _Divider(color: divider),
            ],
          ]),

          // ── Appearance ───────────────────────────────────────────────────
          _SectionHeader(label: 'Appearance', color: secondary),
          _SettingGroup(surface: surface, divider: divider, children: [
            _SwitchRow(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              value: isDark,
              accent: accent,
              text: text,
              secondary: secondary,
              onChanged: (_) => appState.toggleTheme(),
            ),
          ]),

          // ── Privacy ──────────────────────────────────────────────────────
          _SectionHeader(label: 'Privacy', color: secondary),
          _SettingGroup(surface: surface, divider: divider, children: [
            _SwitchRow(
              icon: Icons.visibility_outlined,
              label: 'Show my RSVPs to others',
              value: appState.getPref('privacy_show_rsvps'),
              accent: accent,
              text: text,
              secondary: secondary,
              onChanged: (v) => appState.setPref('privacy_show_rsvps', v),
            ),
            _Divider(color: divider),
            _SwitchRow(
              icon: Icons.search_rounded,
              label: 'Appear in search results',
              value: appState.getPref('privacy_appear_search'),
              accent: accent,
              text: text,
              secondary: secondary,
              onChanged: (v) => appState.setPref('privacy_appear_search', v),
            ),
          ]),

          // ── Danger zone ──────────────────────────────────────────────────
          _SectionHeader(label: 'Danger Zone', color: danger),
          _SettingGroup(surface: surface, divider: divider, children: [
            _ArrowRow(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              accent: danger,
              text: danger,
              secondary: secondary,
              onTap: () => _confirmLogout(context, appState, surface, text, secondary, danger),
            ),
            _Divider(color: divider),
            _ArrowRow(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Account',
              accent: danger,
              text: danger,
              secondary: secondary,
              onTap: () => _confirmDelete(context, appState, surface, text, secondary, accent, danger),
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _confirmLogout(
    BuildContext context,
    AppState appState,
    Color surface,
    Color text,
    Color secondary,
    Color danger,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text('Log out?',
            style: TextStyle(color: text, fontWeight: FontWeight.w700)),
        content: Text('You will be returned to the sign-in screen.',
            style: TextStyle(color: secondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LaunchScreen()),
                (_) => false,
              );
            },
            child: Text('Log Out',
                style: TextStyle(color: danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AppState appState,
    Color surface,
    Color text,
    Color secondary,
    Color accent,
    Color danger,
  ) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: surface,
          title: Text('Delete Account',
              style: TextStyle(color: danger, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This is permanent and cannot be undone. Type DELETE to confirm.',
                style: TextStyle(color: secondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                onChanged: (_) => setDlgState(() {}),
                style: TextStyle(color: text),
                decoration: InputDecoration(
                  hintText: 'DELETE',
                  hintStyle: TextStyle(color: secondary),
                  filled: true,
                  fillColor: danger.withValues(alpha: 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: danger.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: danger.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: danger),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: secondary)),
            ),
            TextButton(
              onPressed: ctrl.text == 'DELETE'
                  ? () {
                      Navigator.pop(ctx);
                      appState.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LaunchScreen()),
                        (_) => false,
                      );
                    }
                  : null,
              child: Text('Delete Account',
                  style: TextStyle(
                      color: ctrl.text == 'DELETE' ? danger : secondary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Setting group (card wrapper) ─────────────────────────────────────────────

class _SettingGroup extends StatelessWidget {
  final Color surface;
  final Color divider;
  final List<Widget> children;
  const _SettingGroup({
    required this.surface,
    required this.divider,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: color, indent: 52);
}

// ── Row variants ─────────────────────────────────────────────────────────────

class _ArrowRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent, text, secondary;
  final VoidCallback onTap;

  const _ArrowRow({
    required this.icon,
    required this.label,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: text,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              Icon(Icons.chevron_right_rounded, color: secondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent, text, secondary;
  final Widget trailing;

  const _StaticRow({
    required this.icon,
    required this.label,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: text,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final Color accent, text, secondary;
  final void Function(bool) onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: text,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: accent,
            ),
          ],
        ),
      ),
    );
  }
}
