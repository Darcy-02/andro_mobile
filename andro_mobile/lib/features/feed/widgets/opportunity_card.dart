import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/opportunity_model.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft =
        opportunity.deadline.difference(DateTime.now()).inDays;
    final urgent = daysLeft <= 7 && !opportunity.isExpired;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: urgent ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _typeChip(),
                if (urgent && !opportunity.isExpired) ...[
                  const SizedBox(width: 6),
                  _urgentChip(daysLeft),
                ],
                if (opportunity.isExpired) ...[
                  const SizedBox(width: 6),
                  _expiredChip(),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(opportunity.title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            _row(Icons.business_outlined, opportunity.provider),
            const SizedBox(height: 4),
            _row(
              Icons.schedule_outlined,
              opportunity.isExpired
                  ? 'Closed ${DateFormat('d MMM').format(opportunity.deadline)}'
                  : 'Deadline: ${DateFormat('d MMM yyyy').format(opportunity.deadline)}',
              color: urgent ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(opportunity.eligibility,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _typeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(_typeLabel(),
          style: const TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget _urgentChip(int days) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('$days days left',
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      );

  Widget _expiredChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('Closed',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      );

  Widget _row(IconData icon, String text, {Color color = AppColors.textSecondary}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: TextStyle(color: color, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );

  String _typeLabel() {
    switch (opportunity.type) {
      case OpportunityType.internship:
        return 'Internship';
      case OpportunityType.fellowship:
        return 'Fellowship';
      case OpportunityType.competition:
        return 'Competition';
      case OpportunityType.grant:
        return 'Grant';
      case OpportunityType.leadership:
        return 'Leadership';
      case OpportunityType.research:
        return 'Research';
    }
  }
}
