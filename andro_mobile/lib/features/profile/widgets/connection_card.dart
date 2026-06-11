import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/connections_provider.dart';

class ConnectionCard extends StatelessWidget {
  final UserModel user;
  final ConnectionStatus status;
  final VoidCallback? onConnect;
  final VoidCallback? onTap;

  const ConnectionCard({
    super.key,
    required this.user,
    required this.status,
    this.onConnect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _avatar(),
            const SizedBox(width: 12),
            Expanded(child: _info()),
            _connectButton(),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.goldMuted,
      child: Text(
        user.fullName[0].toUpperCase(),
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.fullName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          user.programme,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.goldMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ALU ${user.campus}',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _connectButton() {
    switch (status) {
      case ConnectionStatus.connected:
        return _pill('Connected', AppColors.bgElevated, AppColors.textSecondary);
      case ConnectionStatus.pending:
        return _pill('Pending', AppColors.goldMuted, AppColors.gold);
      case ConnectionStatus.none:
        return GestureDetector(
          onTap: onConnect,
          child: _pill('Connect', AppColors.gold, AppColors.bgPrimary),
        );
    }
  }

  Widget _pill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
