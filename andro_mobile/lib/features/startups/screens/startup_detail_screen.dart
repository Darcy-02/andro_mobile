import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../../../mock/users.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/startup_provider.dart';
import '../../profile/providers/current_user_provider.dart';
import '../../profile/screens/profile_screen.dart';
import 'submit_startup_screen.dart';

class StartupDetailScreen extends ConsumerWidget {
  final String startupId;

  const StartupDetailScreen({super.key, required this.startupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startups = ref.watch(startupProvider);
    final startup = startups.firstWhere(
      (s) => s.id == startupId,
      orElse: () => startups.first,
    );
    final currentUser = ref.watch(currentUserProvider);
    final isOrganiser = startup.organiserId == currentUser.id;
    final userRoles = currentUser.interestTags;
    final canJoin = startup.openRoles
        .any((r) => userRoles.any((t) => t.toLowerCase().contains(r.toLowerCase())));
    final alreadyOnTeam = startup.teamMemberIds.contains(currentUser.id);

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
        title: Text(startup.name,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: isOrganiser
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.textPrimary),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            SubmitStartupScreen(existing: startup)),
                  ),
                ),
              ]
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _logoHeader(startup),
          const SizedBox(height: 20),
          _stageBadge(startup.stage),
          const SizedBox(height: 12),
          Text(startup.pitch,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4)),
          if (startup.description != null) ...[
            const SizedBox(height: 16),
            Text(startup.description!,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6)),
          ],
          const SizedBox(height: 24),
          _statRow(
              Icons.favorite_border, '${startup.interestCount} interested'),
          _statRow(
              Icons.group_outlined, '${startup.teamMemberIds.length} on team'),
          if (startup.openRoles.isNotEmpty)
            _statRow(Icons.work_outline,
                'Looking for: ${startup.openRoles.join(', ')}'),
          const SizedBox(height: 24),
          if (!isOrganiser) ...[
            _primaryButton(
              label: 'Express Interest',
              enabled: true,
              onTap: () =>
                  ref.read(startupProvider.notifier).expressInterest(startupId),
            ),
            const SizedBox(height: 10),
            if (canJoin && !alreadyOnTeam)
              _outlineButton(
                label: 'Join Team',
                onTap: () => ref
                    .read(startupProvider.notifier)
                    .joinTeam(startupId, currentUser.id),
              ),
          ],
          const SizedBox(height: 28),
          const Text('TEAM',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          ...startup.teamMemberIds.map((uid) {
            final user = mockUsers.firstWhere(
              (u) => u.id == uid,
              orElse: () => mockUsers[0],
            );
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(userId: uid)),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.goldMuted,
                      child: Text(user.fullName[0],
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.fullName,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          Text(user.programme,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (uid == startup.organiserId)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldMuted,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Founder',
                            style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                      ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary, size: 16),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _logoHeader(StartupModel startup) {
    final colors = [
      const Color(0xFF1A3A5C),
      const Color(0xFF2D1B4E),
      const Color(0xFF1A3D2B),
      const Color(0xFF3D1A1A),
      const Color(0xFF1A3040),
    ];
    final bg = colors[startup.id.hashCode % colors.length];
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(startup.name[0].toUpperCase(),
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 44,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _stageBadge(StartupStage stage) {
    final (label, bg, fg) = switch (stage) {
      StartupStage.idea => ('Idea', AppColors.bgElevated, AppColors.textSecondary),
      StartupStage.prototype => ('Prototype', AppColors.goldMuted, AppColors.gold),
      StartupStage.earlyRevenue => ('Early Revenue', const Color(0x1A3FB950), AppColors.success),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _statRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(text,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      );

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) =>
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.bgPrimary,
            disabledBackgroundColor: AppColors.bgElevated,
            disabledForegroundColor: AppColors.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      );

  Widget _outlineButton(
          {required String label, required VoidCallback onTap}) =>
      SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      );
}
