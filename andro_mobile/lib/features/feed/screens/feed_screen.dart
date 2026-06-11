import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../mock/events.dart';
import '../../../mock/opportunities.dart';
import '../../notifications/providers/notification_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/opportunity_card.dart';

enum _FeedFilter { all, events, opportunities, clubs, academics }

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  _FeedFilter _filter = _FeedFilter.all;

  // Top 3 upcoming events shown in featured strip — excluded from main list
  static final _featuredIds = mockEvents
      .where((e) => e.status == EventStatus.upcoming)
      .take(3)
      .map((e) => e.id)
      .toSet();

  @override
  Widget build(BuildContext context) {
    final unread = ref.watch(unreadCountProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(unread, now)),
            SliverToBoxAdapter(child: _filterRow()),
            if (_filter == _FeedFilter.all || _filter == _FeedFilter.events)
              SliverToBoxAdapter(child: _featuredSection()),
            if (_filter == _FeedFilter.all ||
                _filter == _FeedFilter.opportunities)
              SliverToBoxAdapter(child: _opportunitiesSection()),
            if (_sectionTitle().isNotEmpty)
              SliverToBoxAdapter(child: _sectionHeader(_sectionTitle())),
            ..._feedItems(),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _header(int unread, DateTime now) {
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Ayo 👋',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                DateFormat('EEEE, d MMMM').format(now),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push('/notifications'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary, size: 20),
                ),
                if (unread > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                          color: AppColors.danger, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        children: _FeedFilter.values.map((f) {
          final active = _filter == f;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? AppColors.accent : AppColors.border),
              ),
              child: Text(
                _filterLabel(f),
                style: TextStyle(
                  color: active ? AppColors.bgPrimary : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _featuredSection() {
    final featured = mockEvents
        .where((e) => e.status == EventStatus.upcoming)
        .take(3)
        .toList();

    if (featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('FEATURED'),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 4),
            itemCount: featured.length,
            itemBuilder: (_, i) => SizedBox(
              width: 270,
              child: EventCard(
                event: featured[i],
                compact: true,
                onTap: () => context.push('/event/${featured[i].id}'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _opportunitiesSection() {
    final ops = mockOpportunities.where((o) => !o.isExpired).take(3).toList();

    if (ops.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('OPPORTUNITIES'),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 4),
            itemCount: ops.length,
            itemBuilder: (_, i) => SizedBox(
              width: 260,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: OpportunityCard(
                  opportunity: ops[i],
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _feedItems() {
    switch (_filter) {
      case _FeedFilter.events:
      case _FeedFilter.all:
        // Exclude events already shown in featured strip
        final events = mockEvents
            .where((e) =>
                e.status == EventStatus.upcoming &&
                !_featuredIds.contains(e.id))
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        if (events.isEmpty) return [];

        return events
            .map<Widget>((e) => SliverToBoxAdapter(
                  child: EventCard(
                    event: e,
                    onTap: () => context.push('/event/${e.id}'),
                  ),
                ))
            .toList();

      case _FeedFilter.opportunities:
        return mockOpportunities
            .map<Widget>((o) => SliverToBoxAdapter(
                  child: OpportunityCard(opportunity: o, onTap: () {}),
                ))
            .toList();

      case _FeedFilter.clubs:
        return [
          SliverToBoxAdapter(
            child: _emptyState(
              Icons.groups_outlined,
              'Club feed coming soon',
              'Join communities to see their posts here',
              action: ('Browse communities', () => context.push('/communities')),
            ),
          ),
        ];

      case _FeedFilter.academics:
        return [
          SliverToBoxAdapter(
            child: _emptyState(
              Icons.school_outlined,
              'Academic posts coming soon',
              'Course updates and academic announcements will appear here',
            ),
          ),
        ];
    }
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      );

  Widget _emptyState(
    IconData icon,
    String title,
    String subtitle, {
    (String label, VoidCallback onTap)? action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
          if (action != null) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: action.$2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accentMuted,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                ),
                child: Text(action.$1,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _filterLabel(_FeedFilter f) {
    switch (f) {
      case _FeedFilter.all: return 'All';
      case _FeedFilter.events: return 'Events';
      case _FeedFilter.opportunities: return 'Opportunities';
      case _FeedFilter.clubs: return 'Clubs';
      case _FeedFilter.academics: return 'Academics';
    }
  }

  String _sectionTitle() {
    switch (_filter) {
      case _FeedFilter.all:
      case _FeedFilter.events:
        // Only show header if there are events not in featured
        final remaining = mockEvents
            .where((e) =>
                e.status == EventStatus.upcoming &&
                !_featuredIds.contains(e.id))
            .length;
        return remaining > 0 ? 'MORE EVENTS' : '';
      case _FeedFilter.opportunities:
        return 'ALL OPPORTUNITIES';
      default:
        return '';
    }
  }
}
