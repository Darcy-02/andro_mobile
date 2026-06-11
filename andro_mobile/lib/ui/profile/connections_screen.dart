import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../models/profile_models.dart';
import '../theme_colors.dart';

class ConnectionsScreen extends StatefulWidget {
  final String userId;
  const ConnectionsScreen({super.key, required this.userId});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  String _query = '';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;
  Color get _accentMuted =>
      _isDark ? const Color(0xFF1A2A4A) : const Color(0xFFEAF0FE);

  bool get _isOwn =>
      widget.userId == context.read<AppState>().currentUser.id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  MockUser? _findUser(String id) {
    try {
      return mockUsers.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!_isOwn) {
      // Flat list for other user's connections
      final friends = appState.connectionIds
          .map(_findUser)
          .whereType<MockUser>()
          .toList();

      return Scaffold(
        backgroundColor: _bg,
        appBar: _appBar('Connections', showBack: true),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _ConnectionCard(
            user: friends[i],
            showChip: true,
            text: _text,
            secondary: _secondary,
            surface: _surface,
            accentMuted: _accentMuted,
            accent: _accent,
          ),
        ),
      );
    }

    final connected = appState.connectionIds
        .map(_findUser)
        .whereType<MockUser>()
        .where((u) =>
            _query.isEmpty ||
            u.name.toLowerCase().contains(_query.toLowerCase()) ||
            u.programme.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    final pending = appState.pendingConnectionIds
        .map(_findUser)
        .whereType<MockUser>()
        .toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: _appBar('Connections', showBack: true, bottom: TabBar(
        controller: _tabController,
        labelColor: _accent,
        unselectedLabelColor: _secondary,
        indicatorColor: _accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: 'My Connections (${appState.connectionIds.length})'),
          Tab(text: 'Pending (${pending.length})'),
        ],
      )),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My connections tab
          Column(
            children: [
              _SearchBar(
                controller: _searchCtrl,
                surface: _surface,
                text: _text,
                secondary: _secondary,
                accent: _accent,
                divider: _divider,
              ),
              Expanded(
                child: connected.isEmpty
                    ? _empty('No connections yet', 'Start connecting with people')
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: connected.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _ConnectionCard(
                          user: connected[i],
                          showChip: true,
                          text: _text,
                          secondary: _secondary,
                          surface: _surface,
                          accentMuted: _accentMuted,
                          accent: _accent,
                        ),
                      ),
              ),
            ],
          ),
          // Pending tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionHeader('Requests sent'),
              if (pending.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('No pending requests',
                      style: TextStyle(color: _secondary, fontSize: 13)),
                )
              else
                ...pending.map((u) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ConnectionCard(
                        user: u,
                        showChip: false,
                        trailingLabel: 'Pending',
                        text: _text,
                        secondary: _secondary,
                        surface: _surface,
                        accentMuted: _accentMuted,
                        accent: _accent,
                      ),
                    )),
              const SizedBox(height: 20),
              _sectionHeader('Requests received'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('No incoming requests',
                    style: TextStyle(color: _secondary, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(String title,
      {required bool showBack, PreferredSizeWidget? bottom}) {
    return AppBar(
      backgroundColor: _surface,
      foregroundColor: _text,
      elevation: 0,
      title:
          Text(title, style: TextStyle(color: _text, fontWeight: FontWeight.w700)),
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: _text),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      bottom: bottom,
    );
  }

  Widget _sectionHeader(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _secondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _empty(String title, String sub) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, color: _secondary, size: 48),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: _secondary, fontSize: 13)),
          ],
        ),
      );
}

// ── Search bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color surface, text, secondary, accent, divider;

  const _SearchBar({
    required this.controller,
    required this.surface,
    required this.text,
    required this.secondary,
    required this.accent,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller,
        style: TextStyle(color: text, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search connections...',
          hintStyle: TextStyle(color: secondary),
          prefixIcon: Icon(Icons.search_rounded, color: secondary, size: 20),
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: accent, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );
  }
}

// ── Connection card ──────────────────────────────────────────────────────────

class _ConnectionCard extends StatelessWidget {
  final MockUser user;
  final bool showChip;
  final String? trailingLabel;
  final Color text, secondary, surface, accentMuted, accent;

  const _ConnectionCard({
    required this.user,
    required this.showChip,
    this.trailingLabel,
    required this.text,
    required this.secondary,
    required this.surface,
    required this.accentMuted,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentMuted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: TextStyle(
                  color: accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: TextStyle(
                        color: text,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(user.programme,
                    style: TextStyle(color: secondary, fontSize: 12)),
              ],
            ),
          ),
          if (showChip)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Connected',
                  style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ),
          if (trailingLabel != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(trailingLabel!,
                  style: TextStyle(
                      color: secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
