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

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  // Step 0 fields
  final _nameCtrl = TextEditingController(text: 'Ayomide Adeleye');
  final _preferredCtrl = TextEditingController(text: 'Ayo');
  String _programme = 'BSc Software Engineering';
  int _gradYear = 2026;

  // Step 2 fields
  final _selectedTags = <String>{};

  // Step 3 fields
  UserRole _role = UserRole.student;

  static const _programmes = [
    'BSc Software Engineering',
    'BSc Entrepreneurship',
    'BSc International Business',
    'BA Leadership and Entrepreneurship',
    'BSc Data Science',
  ];

  static const _years = [2024, 2025, 2026, 2027, 2028];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _preferredCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary, size: 18),
                onPressed: () => setState(() => _step--),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / 4,
            backgroundColor: AppColors.bgElevated,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.gold),
            minHeight: 3,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Step ${_step + 1} of 4',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              Expanded(child: _body()),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canProceed ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    disabledBackgroundColor:
                        AppColors.gold.withValues(alpha: 0.4),
                    foregroundColor: AppColors.bgPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_step == 3 ? 'Get Started' : 'Continue',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canProceed {
    if (_step == 0) return _nameCtrl.text.trim().isNotEmpty;
    if (_step == 2) return _selectedTags.isNotEmpty;
    return true;
  }

  Widget _body() {
    switch (_step) {
      case 0:
        return _step0();
      case 1:
        return _step1();
      case 2:
        return _step2();
      default:
        return _step3();
    }
  }

  Widget _step0() {
    return ListView(
      children: [
        const Text('Tell us about yourself',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        _label('Full name'),
        const SizedBox(height: 6),
        _textField(_nameCtrl, 'e.g. Ayomide Adeleye'),
        const SizedBox(height: 16),
        _label('Preferred name'),
        const SizedBox(height: 6),
        _textField(_preferredCtrl, 'What should we call you?'),
        const SizedBox(height: 16),
        _label('Programme'),
        const SizedBox(height: 6),
        _dropdown(
          value: _programme,
          items: _programmes,
          onChanged: (v) => setState(() => _programme = v!),
        ),
        const SizedBox(height: 16),
        _label('Graduation year'),
        const SizedBox(height: 6),
        _dropdown(
          value: _gradYear,
          items: _years,
          onChanged: (v) => setState(() => _gradYear = v!),
        ),
      ],
    );
  }

  Widget _step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your campus',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('ANDRO is for ALU Kigali students only.',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldMuted,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('YOUR CAMPUS',
                    style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8)),
              ),
              const SizedBox(height: 12),
              const Text('ALU Kigali',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('Kigali, Rwanda',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your interests',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('Pick at least one. We use this to personalise your feed.',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 24),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interestTagOptions.map((tag) {
              final selected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedTags.remove(tag)
                      : _selectedTags.add(tag);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.goldMuted : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.border,
                    ),
                  ),
                  child: Text(tag,
                      style: TextStyle(
                          color: selected
                              ? AppColors.gold
                              : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w500
                              : FontWeight.w400)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _step3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your role',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('This shapes what you can post and organise.',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14)),
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
          'All of the above, plus manage your club and post events',
          Icons.groups_outlined,
        ),
        const SizedBox(height: 10),
        _roleCard(
          UserRole.organiser,
          'Organiser',
          'Create and manage campus-wide events and opportunities',
          Icons.event_outlined,
        ),
      ],
    );
  }

  Widget _roleCard(UserRole role, String title, String subtitle, IconData icon) {
    final selected = _role == role;
    return GestureDetector(
      onTap: () => setState(() => _role = role),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.goldMuted : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppColors.gold : AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: selected ? AppColors.bgPrimary : AppColors.textSecondary,
                  size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: selected
                              ? AppColors.gold
                              : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.gold, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500));

  Widget _textField(TextEditingController ctrl, String hint) => TextField(
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
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            borderSide: const BorderSide(color: AppColors.gold),
          ),
        ),
      );

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      dropdownColor: AppColors.bgElevated,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString(),
                  style: const TextStyle(color: AppColors.textPrimary))))
          .toList(),
    );
  }
}
