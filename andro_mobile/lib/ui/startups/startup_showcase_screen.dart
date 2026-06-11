import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../models/profile_models.dart';
import '../theme_colors.dart';
import 'startup_detail_screen.dart';

class StartupShowcaseScreen extends StatefulWidget {
  const StartupShowcaseScreen({super.key});

  @override
  State<StartupShowcaseScreen> createState() => _StartupShowcaseScreenState();
}

class _StartupShowcaseScreenState extends State<StartupShowcaseScreen> {
  StartupStage? _filter; // null = All

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;
  Color get _success => _isDark ? AndroColors.darkGreen : AndroColors.lightGreen;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filtered = _filter == null
        ? appState.startups
        : appState.startups.where((s) => s.stage == _filter).toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _text,
        elevation: 0,
        title: Text('Startup Showcase',
            style: TextStyle(color: _text, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _showSubmitSheet(context, appState),
            child: Text('Submit',
                style: TextStyle(color: _accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == null,
                  accent: _accent,
                  surface: _surface,
                  text: _text,
                  secondary: _secondary,
                  onTap: () => setState(() => _filter = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Idea',
                  selected: _filter == StartupStage.idea,
                  accent: _accent,
                  surface: _surface,
                  text: _text,
                  secondary: _secondary,
                  onTap: () => setState(
                      () => _filter = _filter == StartupStage.idea ? null : StartupStage.idea),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Prototype',
                  selected: _filter == StartupStage.prototype,
                  accent: _accent,
                  surface: _surface,
                  text: _text,
                  secondary: _secondary,
                  onTap: () => setState(() => _filter =
                      _filter == StartupStage.prototype ? null : StartupStage.prototype),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Early Revenue',
                  selected: _filter == StartupStage.earlyRevenue,
                  accent: _accent,
                  surface: _surface,
                  text: _text,
                  secondary: _secondary,
                  onTap: () => setState(() => _filter =
                      _filter == StartupStage.earlyRevenue ? null : StartupStage.earlyRevenue),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No startups in this stage',
                        style: TextStyle(color: _secondary, fontSize: 14)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => _StartupCard(
                      startup: filtered[i],
                      appState: appState,
                      isDark: _isDark,
                      surface: _surface,
                      text: _text,
                      secondary: _secondary,
                      accent: _accent,
                      success: _success,
                      divider: _divider,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StartupDetailScreen(startupId: filtered[i].id),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showSubmitSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubmitSheet(appState: appState),
    );
  }
}

// ── Filter chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent, surface, text, secondary;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.surface,
    required this.text,
    required this.secondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? accent : surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : secondary,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Startup card ─────────────────────────────────────────────────────────────

class _StartupCard extends StatelessWidget {
  final StartupModel startup;
  final AppState appState;
  final bool isDark;
  final Color surface, text, secondary, accent, success, divider;
  final VoidCallback onTap;

  const _StartupCard({
    required this.startup,
    required this.appState,
    required this.isDark,
    required this.surface,
    required this.text,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.divider,
    required this.onTap,
  });

  (Color, Color) get _stageBadge => switch (startup.stage) {
        StartupStage.idea => (const Color(0xFF1A2A3A), const Color(0xFF5B9BD5)),
        StartupStage.prototype => (
            const Color(0xFF2A2218),
            const Color(0xFFD4A853)
          ),
        StartupStage.earlyRevenue => (
            success.withValues(alpha: 0.15),
            success
          ),
      };

  String get _stageLabel => switch (startup.stage) {
        StartupStage.idea => 'Idea',
        StartupStage.prototype => 'Prototype',
        StartupStage.earlyRevenue => 'Revenue',
      };

  @override
  Widget build(BuildContext context) {
    final (badgeBg, badgeFg) = _stageBadge;
    final alreadyInterested =
        startup.interestedIds.contains(appState.currentUser.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: divider, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    startup.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_stageLabel,
                      style: TextStyle(
                          color: badgeFg,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              startup.pitch,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: secondary, fontSize: 12, height: 1.4),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.favorite_border_rounded,
                    color: secondary, size: 13),
                const SizedBox(width: 4),
                Text('${startup.interestedIds.length}',
                    style: TextStyle(color: secondary, fontSize: 11)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (!alreadyInterested) {
                      appState.expressInterest(startup.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Interested in ${startup.name}'),
                          backgroundColor: accent,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 30,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: alreadyInterested
                            ? success
                            : accent,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      alreadyInterested ? 'Interested' : 'Interest',
                      style: TextStyle(
                        color: alreadyInterested ? success : accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Submit bottom sheet ──────────────────────────────────────────────────────

class _SubmitSheet extends StatefulWidget {
  final AppState appState;
  const _SubmitSheet({required this.appState});

  @override
  State<_SubmitSheet> createState() => _SubmitSheetState();
}

class _SubmitSheetState extends State<_SubmitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _pitchCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  StartupStage _stage = StartupStage.idea;
  int _teamSize = 1;
  final Set<String> _lookingFor = {};

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _elevated => _isDark ? AndroColors.darkSurface2 : AndroColors.lightSurface2;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pitchCtrl.dispose();
    _descCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newStartup = StartupModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      pitch: _pitchCtrl.text.trim(),
      stage: _stage,
      description: _descCtrl.text.trim(),
      pitchDeckUrl: _urlCtrl.text.trim().isEmpty ? null : _urlCtrl.text.trim(),
      organiserId: widget.appState.currentUser.id,
      teamMemberIds: [widget.appState.currentUser.id],
      openRoles: _lookingFor.toList(),
      interestedIds: [],
      createdAt: DateTime.now(),
    );
    widget.appState.addStartup(newStartup);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Startup submitted!'),
        backgroundColor: _accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        maxChildSize: 0.96,
        minChildSize: 0.5,
        builder: (_, scrollCtrl) => Form(
          key: _formKey,
          child: ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Submit Your Startup',
                  style: TextStyle(
                      color: _text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              _label('Startup Name'),
              const SizedBox(height: 6),
              _field(_nameCtrl, 'e.g. AgriLink',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null),
              const SizedBox(height: 16),
              _label('One-line Pitch'),
              const SizedBox(height: 6),
              _field(_pitchCtrl, 'Describe your startup in one sentence',
                  maxLength: 120,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null),
              const SizedBox(height: 16),
              _label('Stage'),
              const SizedBox(height: 8),
              SegmentedButton<StartupStage>(
                segments: const [
                  ButtonSegment(value: StartupStage.idea, label: Text('Idea')),
                  ButtonSegment(
                      value: StartupStage.prototype,
                      label: Text('Prototype')),
                  ButtonSegment(
                      value: StartupStage.earlyRevenue,
                      label: Text('Revenue')),
                ],
                selected: {_stage},
                onSelectionChanged: (s) =>
                    setState(() => _stage = s.first),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white
                        : _secondary,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? _accent
                        : _elevated,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _label('Description'),
              const SizedBox(height: 6),
              _field(_descCtrl, 'Tell people more about your startup...',
                  maxLines: 4, maxLength: 280),
              const SizedBox(height: 16),
              _label('Pitch Deck Link (optional)'),
              const SizedBox(height: 6),
              _field(_urlCtrl, 'https://...',
                  keyboardType: TextInputType.url),
              const SizedBox(height: 16),
              _label('Team Size'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _CounterBtn(
                    icon: Icons.remove_rounded,
                    onTap: _teamSize > 1
                        ? () => setState(() => _teamSize--)
                        : null,
                    surface: _elevated,
                    text: _text,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('$_teamSize',
                        style: TextStyle(
                            color: _text,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  _CounterBtn(
                    icon: Icons.add_rounded,
                    onTap: () => setState(() => _teamSize++),
                    surface: _elevated,
                    text: _text,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _label('Looking For'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final role in [
                    'Designer',
                    'Engineer',
                    'Marketer',
                    'Operations',
                    'Other'
                  ])
                    GestureDetector(
                      onTap: () => setState(() {
                        _lookingFor.contains(role)
                            ? _lookingFor.remove(role)
                            : _lookingFor.add(role);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _lookingFor.contains(role)
                              ? _accent
                              : _elevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _lookingFor.contains(role)
                                ? _accent
                                : _divider,
                          ),
                        ),
                        child: Text(
                          role,
                          style: TextStyle(
                            color: _lookingFor.contains(role)
                                ? Colors.white
                                : _secondary,
                            fontSize: 13,
                            fontWeight: _lookingFor.contains(role)
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Submit Startup',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: TextStyle(
          color: _secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4));

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: _text, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _secondary),
        filled: true,
        fillColor: _elevated,
        counterStyle: TextStyle(color: _secondary, fontSize: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color surface, text;

  const _CounterBtn({
    required this.icon,
    required this.onTap,
    required this.surface,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            color: onTap == null ? text.withValues(alpha: 0.3) : text,
            size: 20),
      ),
    );
  }
}
