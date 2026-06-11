import 'package:flutter/material.dart';
import '../../../models/startup_model.dart';
import '../../../core/theme/app_colors.dart';

class StartupCard extends StatelessWidget {
  final StartupModel startup;
  final VoidCallback? onTap;

  const StartupCard({super.key, required this.startup, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _logoArea(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: _info(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoArea() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: _logoColor(),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      alignment: Alignment.center,
      child: Text(
        startup.name[0].toUpperCase(),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                startup.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _stageBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          startup.pitch,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.favorite_border, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              '${startup.interestCount}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stageBadge() {
    final (label, bg, fg) = switch (startup.stage) {
      StartupStage.idea => ('Idea', AppColors.bgElevated, AppColors.textSecondary),
      StartupStage.prototype => (
          'Prototype',
          AppColors.accentMuted,
          AppColors.accent,
        ),
      StartupStage.earlyRevenue => (
          'Early Revenue',
          const Color(0x1A3FB950),
          AppColors.success,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _logoColor() {
    final colors = [
      const Color(0xFF1A3A5C),
      const Color(0xFF2D1B4E),
      const Color(0xFF1A3D2B),
      const Color(0xFF3D1A1A),
      const Color(0xFF1A3040),
    ];
    return colors[startup.id.hashCode % colors.length];
  }
}
