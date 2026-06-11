import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../mock/users.dart';
import '../../../mock/stub_event.dart';
import '../widgets/stub_post_card.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/current_user_provider.dart';
import '../providers/connections_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_bar.dart';
import '../widgets/interest_tags_row.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'connections_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwnProfile = widget.userId == currentUser.id;
    final user = isOwnProfile
        ? currentUser
        : mockUsers.firstWhere(
            (u) => u.id == widget.userId,
            orElse: () => currentUser,
          );
    final connStatus = isOwnProfile
        ? ConnectionStatus.none
        : ref.watch(connectionsProvider).statusFor(widget.userId);

    final myPosts =
        mockPosts.where((p) => p.authorId == user.id).toList();
    final savedPosts = mockPosts.where((p) => p.isSaved).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _appBar(context, user, isOwnProfile),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(user: user),
                StatsBar(
                  eventsCount: user.eventsAttended,
                  communitiesCount: user.communityIds.length,
                  connectionsCount: user.connectionIds.length,
                  onEventsTap: () => _showEventsSheet(context, user),
                  onCommunitiesTap: () =>
                      _showCommunitiesSheet(context, user),
                  onConnectionsTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ConnectionsScreen(userId: user.id),
                    ),
                  ),
                ),
                if (user.bio != null && user.bio!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Text(
                      user.bio!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                InterestTagsRow(tags: user.interestTags),
                const SizedBox(height: 16),
                _actionButton(context, isOwnProfile, connStatus, user),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.gold,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.gold,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.border,
                tabs: const [
                  Tab(text: 'My Posts'),
                  Tab(text: 'Saved Items'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _PostGrid(posts: myPosts),
            _PostGrid(posts: savedPosts),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, UserModel user, bool isOwnProfile) {
    return SliverAppBar(
      backgroundColor: AppColors.bgPrimary,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      title: Text(
        user.preferredName,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: isOwnProfile
          ? [
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.textPrimary),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ]
          : null,
    );
  }

  Widget _actionButton(
    BuildContext context,
    bool isOwnProfile,
    ConnectionStatus status,
    UserModel user,
  ) {
    if (isOwnProfile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ),
      );
    }

    final (label, bg, fg) = switch (status) {
      ConnectionStatus.connected => (
          'Connected',
          AppColors.bgElevated,
          AppColors.textSecondary
        ),
      ConnectionStatus.pending => (
          'Pending',
          AppColors.goldMuted,
          AppColors.gold
        ),
      ConnectionStatus.none => (
          'Connect',
          AppColors.gold,
          AppColors.bgPrimary
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: status == ConnectionStatus.none
              ? () => ref
                  .read(connectionsProvider.notifier)
                  .connect(user.id)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            disabledBackgroundColor: bg,
            disabledForegroundColor: fg,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _showEventsSheet(BuildContext context, UserModel user) {
    final attended = mockEvents
        .where((e) => e.attendeeIds.contains(user.id))
        .toList();
    _showListSheet(
      context,
      title: 'Events Attended',
      items: attended.map((e) => e.title).toList(),
      icon: Icons.event_outlined,
    );
  }

  void _showCommunitiesSheet(BuildContext context, UserModel user) {
    _showListSheet(
      context,
      title: 'Communities',
      items: user.communityIds
          .map((id) => _communityName(id))
          .toList(),
      icon: Icons.people_outline,
    );
  }

  String _communityName(String id) {
    const names = {
      'c1': 'ALU Tech Club',
      'c2': 'Entrepreneurship Society',
      'c3': 'Arts & Culture Collective',
      'c4': 'Data Science Circle',
      'c5': 'Community Impact Network',
    };
    return names[id] ?? id;
  }

  void _showListSheet(
    BuildContext context, {
    required String title,
    required List<String> items,
    required IconData icon,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.goldMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                        color: AppColors.gold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Nothing here yet.',
                        style:
                            TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: Icon(icon,
                          color: AppColors.textSecondary, size: 18),
                      title: Text(
                        items[i],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PostGrid extends StatelessWidget {
  final List<StubPost> posts;

  const _PostGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('Nothing here yet.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: posts.length,
      itemBuilder: (_, i) => PostCard(
        postId: posts[i].id,
        authorId: posts[i].authorId,
        content: posts[i].content,
        createdAt: posts[i].createdAt,
        likeCount: posts[i].likeCount,
        commentCount: posts[i].commentCount,
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      ColoredBox(color: AppColors.bgPrimary, child: tabBar);

  @override
  bool shouldRebuild(_TabBarDelegate old) => tabBar != old.tabBar;
}
