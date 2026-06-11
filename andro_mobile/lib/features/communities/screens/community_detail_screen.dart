import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../mock/users.dart';
import '../providers/community_provider.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String communityId;

  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState
    extends ConsumerState<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communities = ref.watch(communityProvider);
    final notifier = ref.read(communityProvider.notifier);
    final community =
        communities.firstWhere((c) => c.id == widget.communityId);
    final isMember = notifier.isMember(widget.communityId);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 18),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.goldMuted,
                child: Center(
                  child: Text(
                    community.name[0],
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 64,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(community.name,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(children: [
                              _chip(community.category.name),
                              const SizedBox(width: 8),
                              Text('${community.memberCount} members',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13)),
                            ]),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: isMember
                            ? () => notifier.leave(widget.communityId)
                            : () => notifier.join(widget.communityId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMember
                                ? AppColors.goldMuted
                                : AppColors.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isMember ? 'Joined ✓' : 'Join',
                            style: TextStyle(
                                color: isMember
                                    ? AppColors.gold
                                    : AppColors.bgPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tab,
                    labelColor: AppColors.gold,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.gold,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: AppColors.border,
                    tabs: const [
                      Tab(text: 'Feed'),
                      Tab(text: 'Members'),
                      Tab(text: 'About'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _FeedTab(communityId: widget.communityId),
            _MembersTab(memberIds: community.memberIds),
            _AboutTab(description: community.description),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
      );
}

class _FeedTab extends StatelessWidget {
  final String communityId;

  const _FeedTab({required this.communityId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.feed_outlined,
              color: AppColors.textSecondary, size: 48),
          SizedBox(height: 12),
          Text('Community feed coming soon',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 6),
          Text('Posts from this community will appear here',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  final List<String> memberIds;

  const _MembersTab({required this.memberIds});

  @override
  Widget build(BuildContext context) {
    final members =
        mockUsers.where((u) => memberIds.contains(u.id)).toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: members.length,
      itemBuilder: (_, i) {
        final u = members[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.goldMuted,
            child: Text(u.fullName[0],
                style: const TextStyle(
                    color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
          title: Text(u.fullName,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14)),
          subtitle: Text(u.programme,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          onTap: () => context.push('/profile/${u.id}'),
        );
      },
    );
  }
}

class _AboutTab extends StatelessWidget {
  final String description;

  const _AboutTab({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(description,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
    );
  }
}
