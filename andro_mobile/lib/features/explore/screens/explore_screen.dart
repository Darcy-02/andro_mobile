import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../models/community_model.dart';
import '../../../mock/events.dart';
import '../../../mock/opportunities.dart';
import '../../../mock/communities.dart';
import '../../../mock/users.dart';
import '../../feed/widgets/event_card.dart';
import '../../feed/widgets/opportunity_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child: _query.trim().isEmpty ? _browse() : _results(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: TextField(
          controller: _searchCtrl,
          autofocus: false,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search events, people, clubs…',
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
                borderSide: const BorderSide(color: AppColors.gold)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );

  Widget _browse() {
    final upcoming = mockEvents
        .where((e) => e.status == EventStatus.upcoming)
        .take(4)
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _sectionHeader('RECOMMENDED FOR YOU'),
        ...upcoming.map((e) => EventCard(
              event: e,
              compact: true,
              onTap: () => context.push('/event/${e.id}'),
            )),
        const SizedBox(height: 8),
        _sectionHeader('BROWSE'),
        _browseShortcut(
          Icons.groups_outlined,
          'Communities',
          '${mockCommunities.where((c) => !c.isPrivate).length} clubs',
          () => context.push('/communities'),
        ),
        _browseShortcut(
          Icons.rocket_launch_outlined,
          'Startups',
          'Student ventures',
          () => context.push('/startups'),
        ),
        _browseShortcut(
          Icons.event_available_outlined,
          'My RSVPs',
          'Your upcoming events',
          () => context.push('/rsvps'),
        ),
      ],
    );
  }

  Widget _results() {
    final q = _query.toLowerCase();

    final events = mockEvents
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();

    final opps = mockOpportunities
        .where((o) =>
            o.title.toLowerCase().contains(q) ||
            o.provider.toLowerCase().contains(q))
        .toList();

    final communities = mockCommunities
        .where((c) =>
            !c.isPrivate && c.name.toLowerCase().contains(q))
        .toList();

    final users = mockUsers
        .where((u) =>
            u.fullName.toLowerCase().contains(q) ||
            u.programme.toLowerCase().contains(q))
        .toList();

    if (events.isEmpty &&
        opps.isEmpty &&
        communities.isEmpty &&
        users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off,
                color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 12),
            Text('No results for "$_query"',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (events.isNotEmpty) ...[
          _sectionHeader('EVENTS'),
          ...events.map((e) => EventCard(
                event: e,
                compact: true,
                onTap: () => context.push('/event/${e.id}'),
              )),
        ],
        if (opps.isNotEmpty) ...[
          _sectionHeader('OPPORTUNITIES'),
          ...opps.map((o) => OpportunityCard(opportunity: o, onTap: () {})),
        ],
        if (communities.isNotEmpty) ...[
          _sectionHeader('COMMUNITIES'),
          ...communities.map((c) => _communityRow(c)),
        ],
        if (users.isNotEmpty) ...[
          _sectionHeader('PEOPLE'),
          ...users.map((u) => ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.goldMuted,
                  child: Text(u.fullName[0],
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600)),
                ),
                title: Text(u.fullName,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14)),
                subtitle: Text(u.programme,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                onTap: () => context.push('/profile/${u.id}'),
              )),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(title,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8)),
      );

  Widget _browseShortcut(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.goldMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _communityRow(CommunityModel c) {
    return GestureDetector(
      onTap: () => context.push('/community/${c.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.goldMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(c.name[0],
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Text('${c.memberCount} members',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textSecondary, size: 14),
          ],
        ),
      ),
    );
  }
}
