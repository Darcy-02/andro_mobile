import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../mock/users.dart';
import '../providers/auth_provider.dart';
import '../../profile/providers/current_user_provider.dart';
import '../../../models/user_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  bool _forward = true;

  // Step 0 fields
  final _nameCtrl = TextEditingController(text: 'Ayomide Adeleye');
  final _preferredCtrl = TextEditingController(text: 'Ayo');
  String _programme = 'BSc Software Engineering';
  int _gradYear = 2026;

  // Step 2 fields
  final _selectedTags = <String>{};

  // Step 3 fields
  UserRole _role = UserRole.student;

  static const _years = [2026, 2027, 2028, 2029, 2030];

  static const _tagIcons = <String, IconData>{
    'Entrepreneurship': Icons.rocket_launch_outlined,
    'Technology': Icons.computer_outlined,
    'Leadership': Icons.stars_outlined,
    'Arts & Culture': Icons.palette_outlined,
    'Sports': Icons.sports_soccer_outlined,
    'Community Service': Icons.volunteer_activism_outlined,
    'Academic Research': Icons.science_outlined,
    'Career & Internships': Icons.work_outline,
  };

  static const _stepMeta = [
    (icon: Icons.person_outline, label: 'Profile'),
    (icon: Icons.interests_outlined, label: 'Interests'),
    (icon: Icons.badge_outlined, label: 'Role'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _preferredCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      setState(() {
        _forward = true;
        _step++;
      });
    } else {
      ref.read(currentUserProvider.notifier).update(
            ref.read(currentUserProvider).copyWith(
                  fullName: _nameCtrl.text.trim(),
                  preferredName: _preferredCtrl.text.trim(),
                  programme: _programme,
                  graduationYear: _gradYear,
                  interestTags: _selectedTags.toList(),
                  role: _role,
                ),
          );
      ref.read(authProvider.notifier).completeOnboarding();
    }
  }

  void _back() => setState(() {
        _forward = false;
        _step--;
      });

  bool get _canProceed {
    if (_step == 0) return _nameCtrl.text.trim().isNotEmpty;
    if (_step == 1) return _selectedTags.isNotEmpty;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) {
                  final offset = _forward
                      ? Tween(begin: const Offset(0.12, 0), end: Offset.zero)
                      : Tween(begin: const Offset(-0.12, 0), end: Offset.zero);
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: offset.animate(anim),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _stepBody(),
                ),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Back or placeholder
          SizedBox(
            width: 36,
            height: 36,
            child: _step > 0
                ? GestureDetector(
                    onTap: _back,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary,
                        size: 14,
                      ),
                    ),
                  )
                : null,
          ),
          const Spacer(),
          // Dot step indicators
          Row(
            children: List.generate(3, (i) {
              final active = i == _step;
              final done = i < _step;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(left: 6),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.accent.withValues(alpha: 0.5)
                      : active
                          ? AppColors.accent
                          : AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          // Step count label (mirrors back button width)
          SizedBox(
            width: 36,
            child: Text(
              '${_step + 1}/3',
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: GestureDetector(
              onTap: _canProceed ? _next : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _canProceed ? AppColors.accent : AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _canProceed
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _step == 2 ? 'Get Started →' : 'Continue →',
                    style: TextStyle(
                      color: _canProceed
                          ? AppColors.bgPrimary
                          : AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBody() {
    switch (_step) {
      case 0:
        return _step0();
      case 1:
        return _step1();
      default:
        return _step2();
    }
  }

  // ── Step 0: Profile ──────────────────────────────────────────────

  Widget _step0() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      children: [
        _stepIconHeader(_stepMeta[0].icon),
        const SizedBox(height: 20),
        const Text(
          'Tell us about\nyourself',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'This shows up on your campus profile.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 28),
        _fieldLabel('Full name'),
        _textField(_nameCtrl, 'Your full name'),
        const SizedBox(height: 16),
        _fieldLabel('Preferred name'),
        _textField(_preferredCtrl, 'What should we call you?'),
        const SizedBox(height: 16),
        _fieldLabel('Programme'),
        _dropdown(
          value: _programme,
          items: aluProgrammes,
          onChanged: (v) => setState(() => _programme = v!),
        ),
        const SizedBox(height: 16),
        _fieldLabel('Graduation year'),
        _dropdown(
          value: _gradYear,
          items: _years,
          onChanged: (v) => setState(() => _gradYear = v!),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 1: Interests ────────────────────────────────────────────

  Widget _step1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepIconHeader(_stepMeta[1].icon),
          const SizedBox(height: 20),
          const Text(
            'Your interests',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _selectedTags.isEmpty
                ? 'Pick at least one to personalise your feed.'
                : '${_selectedTags.length} selected',
            style: TextStyle(
              color: _selectedTags.isEmpty
                  ? AppColors.textSecondary
                  : AppColors.accent,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interestTagOptions.map((tag) {
                  final selected = _selectedTags.contains(tag);
                  final icon = _tagIcons[tag] ?? Icons.tag;
                  return GestureDetector(
                    onTap: () => setState(() {
                      selected
                          ? _selectedTags.remove(tag)
                          : _selectedTags.add(tag);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accentMuted
                            : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: selected ? AppColors.accent : AppColors.border,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 15,
                            color: selected
                                ? AppColors.accent
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tag,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Role ─────────────────────────────────────────────────

  Widget _step2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepIconHeader(_stepMeta[2].icon),
          const SizedBox(height: 20),
          const Text(
            'Your role',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This shapes what you can post and organise.\nYou can change it later.',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          _roleCard(
            UserRole.student,
            'Student',
            'Attend events, join communities, connect with peers',
            Icons.school_outlined,
          ),
          const SizedBox(height: 10),
          _roleCard(
            UserRole.clubLeader,
            'Club Leader',
            'Manage your club and post events for members',
            Icons.groups_outlined,
          ),
          const SizedBox(height: 10),
          _roleCard(
            UserRole.organiser,
            'Organiser',
            'Create campus-wide events and post opportunities',
            Icons.event_note_outlined,
          ),
        ],
      ),
    );
  }

  // ── Shared components ────────────────────────────────────────────

  Widget _stepIconHeader(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, color: AppColors.accent, size: 22),
    );
  }

  Widget _roleCard(UserRole role, String title, String subtitle, IconData icon) {
    final selected = _role == role;
    return GestureDetector(
      onTap: () => setState(() => _role = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentMuted : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.bgPrimary : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? AppColors.accent : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.accent,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      );

  Widget _textField(TextEditingController ctrl, String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: TextField(
          controller: ctrl,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            filled: true,
            fillColor: AppColors.bgSurface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
        ),
      );

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) =>
      DropdownButtonFormField<T>(
        initialValue: value,
        onChanged: onChanged,
        dropdownColor: AppColors.bgElevated,
        icon: const Icon(Icons.keyboard_arrow_down,
            color: AppColors.textSecondary),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.bgSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.accent, width: 1.5),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString(),
                      style:
                          const TextStyle(color: AppColors.textPrimary)),
                ))
            .toList(),
      );
}
