import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../models/andro_models.dart';
import '../models/profile_models.dart';
import '../theme_colors.dart';
import 'edit_profile_screen.dart';
import 'connections_screen.dart';
import '../rsvps/my_rsvps_screen.dart';
import '../settings/settings_screen.dart';
import '../startups/startup_showcase_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _amber => _isDark ? AndroColors.darkAmber : AndroColors.lightAmber;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;
  Color get _success => _isDark ? AndroColors.darkGreen : AndroColors.lightGreen;
  Color get _accentMuted =>
      _isDark ? const Color(0xFF1A2A4A) : const Color(0xFFEAF0FE);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isOwn = widget.userId == appState.currentUser.id;
    final user = isOwn
        ? appState.currentUser
        : _findUser(widget.userId, appState.currentUser);

    return Scaffold(
      backgroundColor: _bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(isOwn, innerBoxIsScrolled),
          SliverToBoxAdapter(child: _buildHeader(user, appState, isOwn)),
          SliverToBoxAdapter(child: _buildStats(user, appState)),
          SliverToBoxAdapter(child: _buildInterestTags(user)),
          SliverToBoxAdapter(child: _buildBio(user)),
          SliverToBoxAdapter(child: _buildActionRow(isOwn, user, appState)),
          SliverToBoxAdapter(child: _buildQuickLinks(isOwn)),
          SliverPersistentHeader(
            delegate: _StickyTabBar(
              tabBar: TabBar(
                controller: _tabController,
                labelColor: _accent,
                unselectedLabelColor: _secondary,
                indicatorColor: _accent,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'My Posts'),
                  Tab(text: 'Saved'),
                ],
              ),
              bg: _surface,
              divider: _divider,
            ),
            pinned: true,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _MyPostsTab(bg: _bg, surface: _surface, secondary: _secondary, text: _text),
            _SavedTab(
              savedIds: appState.savedEventIds,
              bg: _bg,
              surface: _surface,
              accent: _accent,
              text: _text,
              secondary: _secondary,
              amber: _amber,
            ),
          ],
        ),
      ),
    );
  }

  UserProfile _findUser(String userId, UserProfile fallback) {
    final mock = mockUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => MockUser(id: userId, name: 'Unknown', programme: ''),
    );
    return UserProfile(
      id: mock.id,
      name: mock.name,
      preferredName: mock.name.split(' ').first,
      email: '',
      bio: 'ALU student passionate about innovation and community.',
      programme: mock.programme,
      graduationYear: 2026,
      interestTags: ['Technology', 'Leadership'],
      eventsAttended: 3,
      communitiesCount: 2,
    );
  }

  SliverAppBar _buildAppBar(bool isOwn, bool innerBoxIsScrolled) {
    return SliverAppBar(
      backgroundColor: _surface,
      foregroundColor: _text,
      elevation: 0,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      title: null,
      actions: isOwn
          ? [
              IconButton(
                icon: Icon(Icons.settings_outlined, color: _secondary),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ]
          : [
              IconButton(
                icon: Icon(Icons.arrow_back, color: _text),
                onPressed: () => Navigator.pop(context),
              ),
            ],
    );
  }

  Widget _buildHeader(UserProfile user, AppState appState, bool isOwn) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Header block
        Container(
          height: 120,
          color: _surface,
          padding: const EdgeInsets.fromLTRB(100, 0, 16, 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  color: _text,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${user.programme} · ${user.graduationYear}',
                style: TextStyle(color: _secondary, fontSize: 13),
              ),
            ],
          ),
        ),
        // Avatar overlapping bottom of header
        Positioned(
          left: 16,
          bottom: -36,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentMuted,
              border: Border.all(color: _bg, width: 3),
            ),
            child: Center(
              child: Text(
                user.initials,
                style: TextStyle(
                  color: _accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(UserProfile user, AppState appState) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
      child: Row(
        children: [
          _StatCard(
            value: '${user.eventsAttended}',
            label: 'Events',
            color: _accent,
            surface: _surface,
            text: _text,
            secondary: _secondary,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: '${user.communitiesCount}',
            label: 'Communities',
            color: _accent,
            surface: _surface,
            text: _text,
            secondary: _secondary,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: '${appState.connectionIds.length}',
            label: 'Connections',
            color: _accent,
            surface: _surface,
            text: _text,
            secondary: _secondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ConnectionsScreen(userId: widget.userId),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTags(UserProfile user) {
    if (user.interestTags.isEmpty) return const SizedBox.shrink();
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interests',
              style: TextStyle(
                  color: _secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: user.interestTags
                  .map((tag) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _accentMuted,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: _accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(UserProfile user) {
    if (user.bio.isEmpty) return const SizedBox.shrink();
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Text(
        user.bio,
        style: TextStyle(color: _secondary, fontSize: 14, height: 1.5),
      ),
    );
  }

  Widget _buildActionRow(bool isOwn, UserProfile user, AppState appState) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: isOwn
          ? SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EditProfileScreen()),
                ).then((_) => setState(() {})),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _text,
                  side: BorderSide(color: _divider),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Edit Profile',
                    style: TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
            )
          : _buildConnectButton(user.id, appState),
    );
  }

  Widget _buildConnectButton(String userId, AppState appState) {
    final isConnected = appState.connectionIds.contains(userId);
    final isPending = appState.pendingConnectionIds.contains(userId);

    if (isConnected) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: Icon(Icons.check, size: 16, color: _success),
          label: Text('Connected',
              style: TextStyle(color: _success, fontWeight: FontWeight.w500)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _success.withValues(alpha: 0.4)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }
    if (isPending) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _divider),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('Pending',
              style: TextStyle(color: _secondary, fontWeight: FontWeight.w500)),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: () {
          appState.sendConnectionRequest(userId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Connection request sent'),
              backgroundColor: _accent,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildQuickLinks(bool isOwn) {
    if (!isOwn) return const SizedBox.shrink();
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          _QuickLink(
            icon: Icons.event_available_rounded,
            label: 'My RSVPs',
            color: _accent,
            surface: _surface,
            text: _text,
            secondary: _secondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyRsvpsScreen()),
            ),
          ),
          const SizedBox(width: 10),
          _QuickLink(
            icon: Icons.rocket_launch_rounded,
            label: 'Startups',
            color: _amber,
            surface: _surface,
            text: _text,
            secondary: _secondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StartupShowcaseScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sticky tab bar delegate ──────────────────────────────────────────────────

class _StickyTabBar extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color bg;
  final Color divider;

  const _StickyTabBar({
    required this.tabBar,
    required this.bg,
    required this.divider,
  });

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bg,
      child: Column(
        children: [
          tabBar,
          Divider(height: 1, thickness: 1, color: divider),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBar old) =>
      old.bg != bg || old.divider != divider;
}

// ── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color surface;
  final Color text;
  final Color secondary;
  final VoidCallback onTap;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.surface,
    required this.text,
    required this.secondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      color: secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick link tile ──────────────────────────────────────────────────────────

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color surface;
  final Color text;
  final Color secondary;
  final VoidCallback onTap;

  const _QuickLink({
    required this.icon,
    required this.label,
    required this.color,
    required this.surface,
    required this.text,
    required this.secondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: secondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── My Posts tab ─────────────────────────────────────────────────────────────

class _MyPostsTab extends StatelessWidget {
  final Color bg;
  final Color surface;
  final Color secondary;
  final Color text;

  const _MyPostsTab({
    required this.bg,
    required this.surface,
    required this.secondary,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, color: secondary, size: 48),
            const SizedBox(height: 12),
            Text('No posts yet',
                style: TextStyle(
                    color: text, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Posts you create will appear here',
                style: TextStyle(color: secondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Saved tab ────────────────────────────────────────────────────────────────

class _SavedTab extends StatelessWidget {
  final List<String> savedIds;
  final Color bg;
  final Color surface;
  final Color accent;
  final Color text;
  final Color secondary;
  final Color amber;

  const _SavedTab({
    required this.savedIds,
    required this.bg,
    required this.surface,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.amber,
  });

  @override
  Widget build(BuildContext context) {
    final all = [featuredEvent, ...upcomingEvents];
    final saved = all.where((e) => savedIds.contains(e.id)).toList();

    if (saved.isEmpty) {
      return Container(
        color: bg,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border_rounded, color: secondary, size: 48),
              const SizedBox(height: 12),
              Text('Nothing saved yet',
                  style: TextStyle(
                      color: text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Save events and opportunities to find them here',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: secondary, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    return Container(
      color: bg,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: saved.length,
        itemBuilder: (context, i) {
          final e = saved[i];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [e.gradientStart, e.gradientEnd],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(e.icon, color: Colors.white70, size: 22),
                const Spacer(),
                Text(e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(e.date,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }
}
