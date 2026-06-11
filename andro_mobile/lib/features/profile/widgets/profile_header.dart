import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgElevated,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatar(),
          const SizedBox(width: 16),
          Expanded(child: _info()),
        ],
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 36,
      backgroundColor: AppColors.goldMuted,
      backgroundImage:
          user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
      child: user.avatarUrl == null
          ? Text(
              user.fullName[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${user.programme} · ${user.graduationYear}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        _campusBadge(),
      ],
    );
  }

  Widget _campusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.goldMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'ALU ${user.campus}',
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
