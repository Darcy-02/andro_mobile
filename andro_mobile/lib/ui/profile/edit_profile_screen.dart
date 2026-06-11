import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../theme_colors.dart';

const _programmes = [
  'BSc Computer Science',
  'BSc Software Engineering',
  'BSc Data Science',
  'BSc Business Management',
  'BSc Entrepreneurship',
  'BSc Global Challenges',
  'BSc Electrical Engineering',
  'BSc Mechatronics',
];

const _allInterests = [
  'Technology',
  'Entrepreneurship',
  'Arts & Culture',
  'Leadership',
  'Sports',
  'Community Service',
  'Academic Research',
  'Career & Internships',
];

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _preferredCtrl;
  late TextEditingController _bioCtrl;
  late String _programme;
  late int _gradYear;
  late List<String> _selectedInterests;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;
  Color get _accentMuted =>
      _isDark ? const Color(0xFF1A2A4A) : const Color(0xFFEAF0FE);

  @override
  void initState() {
    super.initState();
    final u = context.read<AppState>().currentUser;
    _nameCtrl = TextEditingController(text: u.name);
    _preferredCtrl = TextEditingController(text: u.preferredName);
    _bioCtrl = TextEditingController(text: u.bio);
    _programme = _programmes.contains(u.programme) ? u.programme : _programmes.first;
    _gradYear = u.graduationYear;
    _selectedInterests = List.from(u.interestTags);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _preferredCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final appState = context.read<AppState>();
    appState.updateCurrentUser(
      appState.currentUser.copyWith(
        name: _nameCtrl.text.trim(),
        preferredName: _preferredCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        programme: _programme,
        graduationYear: _gradYear,
        interestTags: _selectedInterests,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated'),
        backgroundColor: _accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _text,
        elevation: 0,
        title: Text('Edit Profile',
            style: TextStyle(color: _text, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Photo update coming soon'),
                        backgroundColor: _accent,
                        duration: const Duration(seconds: 2),
                      ),
                    ),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentMuted,
                        border: Border.all(color: _accent, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          context.watch<AppState>().currentUser.initials,
                          style: TextStyle(
                            color: _accent,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: _bg, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _label('Full Name'),
            const SizedBox(height: 6),
            _field(
              controller: _nameCtrl,
              hint: 'Your full name',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 18),
            _label('Preferred Name'),
            const SizedBox(height: 6),
            _field(controller: _preferredCtrl, hint: 'Nickname (optional)'),
            const SizedBox(height: 18),
            _label('Bio'),
            const SizedBox(height: 6),
            _field(
              controller: _bioCtrl,
              hint: 'Tell the community about yourself...',
              maxLines: 4,
              maxLength: 160,
            ),
            const SizedBox(height: 18),
            _label('Programme'),
            const SizedBox(height: 6),
            _dropdownField<String>(
              value: _programme,
              items: _programmes,
              display: (v) => v,
              onChanged: (v) => setState(() => _programme = v!),
            ),
            const SizedBox(height: 18),
            _label('Graduation Year'),
            const SizedBox(height: 6),
            _dropdownField<int>(
              value: _gradYear,
              items: [2024, 2025, 2026, 2027, 2028],
              display: (v) => v.toString(),
              onChanged: (v) => setState(() => _gradYear = v!),
            ),
            const SizedBox(height: 28),
            Text('Interests',
                style: TextStyle(
                    color: _text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Select what you are into',
                style: TextStyle(color: _secondary, fontSize: 13)),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
              children: _allInterests.map((tag) {
                final selected = _selectedInterests.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    selected
                        ? _selectedInterests.remove(tag)
                        : _selectedInterests.add(tag);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: selected ? _accentMuted : _surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? _accent : _divider,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: selected ? _accent : _secondary,
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(
          color: _secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4));

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      style: TextStyle(color: _text, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _secondary),
        filled: true,
        fillColor: _surface,
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

  Widget _dropdownField<T>({
    required T value,
    required List<T> items,
    required String Function(T) display,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      dropdownColor: _surface,
      style: TextStyle(color: _text, fontSize: 14),
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: _secondary),
      decoration: InputDecoration(
        filled: true,
        fillColor: _surface,
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
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(display(item)),
              ))
          .toList(),
    );
  }
}
