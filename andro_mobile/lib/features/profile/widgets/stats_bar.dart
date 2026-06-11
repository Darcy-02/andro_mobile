import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StatsBar extends StatelessWidget {
  final int eventsCount;
  final int communitiesCount;
  final int connectionsCount;
  final VoidCallback? onEventsTap;
  final VoidCallback? onCommunitiesTap;
  final VoidCallback? onConnectionsTap;

  const StatsBar({
    super.key,
    required this.eventsCount,
    required this.communitiesCount,
    required this.connectionsCount,
    this.onEventsTap,
    this.onCommunitiesTap,
    this.onConnectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              value: eventsCount,
              label: 'Events',
              onTap: onEventsTap,
            ),
          ),
          _divider(),
          Expanded(
            child: _StatColumn(
              value: communitiesCount,
              label: 'Communities',
              onTap: onCommunitiesTap,
            ),
          ),
          _divider(),
          Expanded(
            child: _StatColumn(
              value: connectionsCount,
              label: 'Connections',
              onTap: onConnectionsTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.border,
      );
}

class _StatColumn extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback? onTap;

  const _StatColumn({
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
