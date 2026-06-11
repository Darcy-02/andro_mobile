import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../models/profile_models.dart';
import '../theme_colors.dart';

class StartupDetailScreen extends StatelessWidget {
  final String startupId;
  const StartupDetailScreen({super.key, required this.startupId});

  MockUser? _findUser(String id) {
    try {
      return mockUsers.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  String _stageLabel(StartupStage s) => switch (s) {
        StartupStage.idea => 'Idea',
        StartupStage.prototype => 'Prototype',
        StartupStage.earlyRevenue => 'Early Revenue',
      };

  (Color, Color) _stageBadge(StartupStage s, Color success) => switch (s) {
        StartupStage.idea => (const Color(0xFF1A2A3A), const Color(0xFF5B9BD5)),
        StartupStage.prototype => (
            const Color(0xFF2A2218),
            const Color(0xFFD4A853)
          ),
        StartupStage.earlyRevenue => (
            success.withValues(alpha: 0.15),
            success
          ),
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg       = isDark ? AndroColors.darkBackground  : AndroColors.lightBackground;
    final surface  = isDark ? AndroColors.darkSurface      : AndroColors.lightSurface;
    final accent   = isDark ? AndroColors.darkAccent       : AndroColors.lightAccent;
    final text     = isDark ? AndroColors.darkText         : AndroColors.lightText;
    final secondary= isDark ? AndroColors.darkSecondary    : AndroColors.lightSecondary;
    final divider  = isDark ? AndroColors.darkDivider      : AndroColors.lightDivider;
    final success  = isDark ? AndroColors.darkGreen        : AndroColors.lightGreen;
    final accentMuted = isDark
        ? const Color(0xFF1A2A4A)
        : const Color(0xFFEAF0FE);

    final appState = context.watch<AppState>();
    final startup = appState.startups.where((s) => s.id == startupId).firstOrNull;

    if (startup == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(backgroundColor: surface, foregroundColor: text),
        body: Center(child: Text('Startup not found', style: TextStyle(color: secondary))),
      );
    }

    final (badgeBg, badgeFg) = _stageBadge(startup.stage, success);
    final teamMembers = startup.teamMemberIds.map(_findUser).whereType<MockUser>().toList();
    final hasOpenRoles = startup.openRoles.isNotEmpty;
    final alreadyInterested = startup.interestedIds.contains(appState.currentUser.id);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        title: Text(startup.name,
            style: TextStyle(color: text, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          // Stage badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_stageLabel(startup.stage),
                    style: TextStyle(
                        color: badgeFg,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Icon(Icons.favorite_border_rounded, color: secondary, size: 14),
                  const SizedBox(width: 4),
                  Text('${startup.interestedIds.length} interested',
                      style: TextStyle(color: secondary, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(startup.name,
              style: TextStyle(
                  color: text, fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          // Pitch
          Text(startup.pitch,
              style: TextStyle(color: secondary, fontSize: 14, height: 1.5)),
          const SizedBox(height: 16),

          // Divider
          Divider(color: divider, height: 1),
          const SizedBox(height: 16),

          // Description
          Text(startup.description,
              style: TextStyle(color: secondary, fontSize: 14, height: 1.6)),
          const SizedBox(height: 28),

          // Team section
          _SectionHeading(label: 'Team', text: text),
          const SizedBox(height: 12),
          if (teamMembers.isEmpty)
            Text('No team members listed',
                style: TextStyle(color: secondary, fontSize: 13))
          else
            Row(
              children: [
                ...teamMembers.take(4).map((u) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: u.name,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: accentMuted,
                            shape: BoxShape.circle,
                            border: Border.all(color: divider),
                          ),
                          child: Center(
                            child: Text(u.initials,
                                style: TextStyle(
                                    color: accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    )),
                if (teamMembers.length > 4)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: divider),
                    ),
                    child: Center(
                      child: Text('+${teamMembers.length - 4}',
                          style: TextStyle(
                              color: secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 28),

          // Open roles section
          _SectionHeading(label: 'Open Roles', text: text),
          const SizedBox(height: 12),
          if (!hasOpenRoles)
            Text('No open roles currently',
                style: TextStyle(color: secondary, fontSize: 13))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: startup.openRoles
                  .map((role) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentMuted,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(role,
                            style: TextStyle(
                                color: accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ))
                  .toList(),
            ),
        ],
      ),
      // Sticky bottom bar
      bottomNavigationBar: Container(
        color: surface,
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: alreadyInterested
                    ? null
                    : () {
                        appState.expressInterest(startup.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Interested in ${startup.name}'),
                            backgroundColor: accent,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(
                      color: alreadyInterested
                          ? divider
                          : accent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(0, 48),
                ),
                child: Text(
                  alreadyInterested ? 'Interested' : 'Express Interest',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: hasOpenRoles
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Join request sent to ${startup.name}'),
                            backgroundColor: accent,
                            duration: const Duration(seconds: 2),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: divider,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Join Team',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String label;
  final Color text;
  const _SectionHeading({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            color: text, fontSize: 16, fontWeight: FontWeight.w600));
  }
}
