import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/startup_provider.dart';
import '../../profile/providers/current_user_provider.dart';

class SubmitStartupScreen extends ConsumerStatefulWidget {
  final StartupModel? existing;

  const SubmitStartupScreen({super.key, this.existing});

  @override
  ConsumerState<SubmitStartupScreen> createState() =>
      _SubmitStartupScreenState();
}

class _SubmitStartupScreenState extends ConsumerState<SubmitStartupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _pitchCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _deckCtrl;
  late StartupStage _stage;
  late int _teamSize;
  late Set<String> _lookingFor;

  final _roles = ['Designer', 'Engineer', 'Marketer', 'Operations', 'Other'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _pitchCtrl = TextEditingController(text: e?.pitch ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _deckCtrl = TextEditingController(text: e?.pitchDeckUrl ?? '');
    _stage = e?.stage ?? StartupStage.idea;
    _teamSize = e?.teamMemberIds.length ?? 1;
    _lookingFor = Set.from(e?.openRoles ?? <String>[]);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pitchCtrl.dispose();
    _descCtrl.dispose();
    _deckCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final currentUser = ref.read(currentUserProvider);
    final isEdit = widget.existing != null;

    final startup = StartupModel(
      id: isEdit ? widget.existing!.id : 's${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      pitch: _pitchCtrl.text.trim(),
      stage: _stage,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      pitchDeckUrl: _deckCtrl.text.trim().isEmpty ? null : _deckCtrl.text.trim(),
      organiserId: currentUser.id,
      teamMemberIds: isEdit ? widget.existing!.teamMemberIds : [currentUser.id],
      openRoles: _lookingFor.toList(),
      interestCount: widget.existing?.interestCount ?? 0,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    if (isEdit) {
      ref.read(startupProvider.notifier).updateStartup(startup);
    } else {
      ref.read(startupProvider.notifier).submitStartup(startup);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
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
        title: Text(isEdit ? 'Edit Startup' : 'Submit Startup',
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.gold, fontWeight: FontWeight.w600)),
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
              _label('Startup Name'),
              _textField(
                controller: _nameCtrl,
                hint: 'e.g. AgriConnect',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _label('One-line Pitch'),
              _charField(
                controller: _pitchCtrl,
                hint: 'What does it do in one sentence?',
                maxLength: 120,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _label('Stage'),
              const SizedBox(height: 8),
              _stageSelector(),
              const SizedBox(height: 16),
              _label('Description'),
              _charField(
                controller: _descCtrl,
                hint: 'Tell the community more about your startup…',
                maxLength: 280,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _label('Pitch Deck Link (optional)'),
              _textField(
                controller: _deckCtrl,
                hint: 'https://…',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _label('Team Size'),
              const SizedBox(height: 8),
              _teamSizePicker(),
              const SizedBox(height: 16),
              _label('Looking For'),
              const SizedBox(height: 8),
              _lookingForChips(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8)),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDec(hint),
    );
  }

  Widget _charField({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: _inputDec(hint).copyWith(counterText: ''),
          onChanged: (_) => setState(() {}),
        ),
        Text('${controller.text.length}/$maxLength',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _stageSelector() {
    final stages = [
      (StartupStage.idea, 'Idea'),
      (StartupStage.prototype, 'Prototype'),
      (StartupStage.earlyRevenue, 'Early Revenue'),
    ];
    return Row(
      children: stages.map((s) {
        final selected = _stage == s.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _stage = s.$1),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: selected ? AppColors.gold : AppColors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                s.$2,
                style: TextStyle(
                  color: selected
                      ? AppColors.bgPrimary
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _teamSizePicker() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (_teamSize > 1) setState(() => _teamSize--);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.remove,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$_teamSize',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => setState(() => _teamSize++),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.add,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _lookingForChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _roles.map((role) {
        final selected = _lookingFor.contains(role);
        return GestureDetector(
          onTap: () => setState(() {
            selected ? _lookingFor.remove(role) : _lookingFor.add(role);
          }),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.goldMuted : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: selected ? AppColors.gold : AppColors.border),
            ),
            child: Text(role,
                style: TextStyle(
                  color: selected
                      ? AppColors.gold
                      : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                )),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.bgSurface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.gold)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.danger)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.danger)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
}
