import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/community_model.dart';
import '../providers/community_provider.dart';

class CommunitiesScreen extends ConsumerStatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  ConsumerState<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends ConsumerState<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _searchCtrl = TextEditingController();
  String _query = '';
  CommunityCategory? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Communities',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: AppColors.border,
          tabs: const [Tab(text: 'All Clubs'), Tab(text: 'My Clubs')],
        ),
      ),
      body: Column(
        children: [
          _searchBar(),
          _categoryChips(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _AllClubs(query: _query, category: _categoryFilter),
                _MyClubs(query: _query),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search communities…',
            hintStyle:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.textSecondary, size: 20),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () => _searchCtrl.clear(),
                  )
                : null,
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
                borderSide: const BorderSide(color: AppColors.accent)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );

  Widget _categoryChips() {
    final cats = [null, ...CommunityCategory.values];
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        children: cats.map((cat) {
          final active = _categoryFilter == cat;
          return GestureDetector(
            onTap: () => setState(() => _categoryFilter = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.accentMuted : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? AppColors.accent : AppColors.border),
              ),
              child: Text(
                cat == null ? 'All' : _catLabel(cat),
                style: TextStyle(
                    color: active
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _catLabel(CommunityCategory c) {
    switch (c) {
      case CommunityCategory.academic:
        return 'Academic';
      case CommunityCategory.social:
        return 'Social';
      case CommunityCategory.professional:
        return 'Professional';
      case CommunityCategory.sports:
        return 'Sports';
      case CommunityCategory.arts:
        return 'Arts';
      case CommunityCategory.service:
        return 'Service';
    }
  }
}

class _AllClubs extends ConsumerWidget {
  final String query;
  final CommunityCategory? category;

  const _AllClubs({required this.query, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = ref.watch(communityProvider);
    final notifier = ref.read(communityProvider.notifier);
    final filtered = communities
        .where((c) => !c.isPrivate)
        .where((c) => category == null || c.category == category)
        .where((c) => query.isEmpty ||
            c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filtered.isEmpty) {
      return _empty('No communities found.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _CommunityCard(
        community: filtered[i],
        isMember: notifier.isMember(filtered[i].id),
        onTap: () => context.push('/community/${filtered[i].id}'),
        onJoin: () => notifier.join(filtered[i].id),
        onLeave: () => notifier.leave(filtered[i].id),
      ),
    );
  }
}

class _MyClubs extends ConsumerWidget {
  final String query;

  const _MyClubs({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(communityProvider.notifier);
    final joined = notifier
        .joined()
        .where((c) => query.isEmpty ||
            c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (joined.isEmpty) {
      return _empty('You have not joined any communities yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: joined.length,
      itemBuilder: (_, i) => _CommunityCard(
        community: joined[i],
        isMember: true,
        onTap: () => context.push('/community/${joined[i].id}'),
        onLeave: () => notifier.leave(joined[i].id),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final CommunityModel community;
  final bool isMember;
  final VoidCallback onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const _CommunityCard({
    required this.community,
    required this.isMember,
    required this.onTap,
    this.onJoin,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _avatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(community.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _catChip(),
                      const SizedBox(width: 8),
                      Text(
                        '${community.memberCount} members',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _actionButton(),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          community.name[0],
          style: const TextStyle(
              color: AppColors.accent,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _catChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          community.category.name,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      );

  Widget _actionButton() {
    if (isMember) {
      return GestureDetector(
        onTap: onLeave,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: AppColors.accent, size: 12),
              SizedBox(width: 4),
              Text('Joined',
                  style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onJoin,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent),
        ),
        child: const Text('Join',
            style: TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

Widget _empty(String msg) => Center(
      child: Text(msg,
          style: const TextStyle(color: AppColors.textSecondary)),
    );
