import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../mock/users.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/current_user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameCtrl;
  late TextEditingController _preferredNameCtrl;
  late TextEditingController _bioCtrl;
  late String _programme;
  late int _gradYear;
  late Set<String> _selectedTags;
  String? _localAvatarPath;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _fullNameCtrl = TextEditingController(text: user.fullName);
    _preferredNameCtrl = TextEditingController(text: user.preferredName);
    _bioCtrl = TextEditingController(text: user.bio ?? '');
    _programme = user.programme;
    _gradYear = user.graduationYear;
    _selectedTags = Set.from(user.interestTags);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _preferredNameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _localAvatarPath = picked.path);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(currentUserProvider.notifier).update(
          ref.read(currentUserProvider).copyWith(
                fullName: _fullNameCtrl.text.trim(),
                preferredName: _preferredNameCtrl.text.trim(),
                bio: _bioCtrl.text.trim(),
                programme: _programme,
                graduationYear: _gradYear,
                interestTags: _selectedTags.toList(),
                avatarUrl: _localAvatarPath ??
                    ref.read(currentUserProvider).avatarUrl,
              ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        leadingWidth: 80,
        title: const Text('Edit Profile',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _avatarPicker(),
              const SizedBox(height: 28),
              _label('Full Name'),
              _textField(
                controller: _fullNameCtrl,
                hint: 'Your full name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _label('Preferred Name'),
              _textField(
                controller: _preferredNameCtrl,
                hint: 'What do friends call you? (optional)',
              ),
              const SizedBox(height: 16),
              _label('Bio'),
              _bioField(),
              const SizedBox(height: 16),
              _label('Programme'),
              _programmeDropdown(),
              const SizedBox(height: 16),
              _label('Graduation Year'),
              _gradYearDropdown(),
              const SizedBox(height: 20),
              _label('Interest Tags'),
              const SizedBox(height: 8),
              _interestTagGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarPicker() {
    final user = ref.watch(currentUserProvider);
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.accentMuted,
              backgroundImage: _localAvatarPath != null
                  ? FileImage(File(_localAvatarPath!))
                  : null,
              child: _localAvatarPath == null
                  ? Text(
                      user.fullName[0].toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt,
                    color: AppColors.bgPrimary, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8),
        ),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration(hint),
    );
  }

  Widget _bioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: _bioCtrl,
          maxLength: 160,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: _inputDecoration('Tell people about yourself…')
              .copyWith(counterText: ''),
          onChanged: (_) => setState(() {}),
        ),
        Text(
          '${_bioCtrl.text.length}/160',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _programmeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _programme,
      dropdownColor: AppColors.bgElevated,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration('Select programme'),
      items: aluProgrammes
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
      onChanged: (v) => setState(() => _programme = v!),
    );
  }

  Widget _gradYearDropdown() {
    return DropdownButtonFormField<int>(
      initialValue: _gradYear,
      dropdownColor: AppColors.bgElevated,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration('Select year'),
      items: [2026, 2027, 2028, 2029, 2030]
          .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
          .toList(),
      onChanged: (v) => setState(() => _gradYear = v!),
    );
  }

  Widget _interestTagGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interestTagOptions.map((tag) {
        final selected = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => setState(() {
            if (selected) {
              _selectedTags.remove(tag);
            } else {
              _selectedTags.add(tag);
            }
          }),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.accentMuted : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.accent : AppColors.border,
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: selected
                    ? AppColors.accent
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.bgSurface,
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
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
}
