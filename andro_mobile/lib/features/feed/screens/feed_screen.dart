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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  _sectionTitle(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            ..._feedItems(),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _header(int unread, DateTime now) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good day, Ayo 👋',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary, size: 20),
                ),
                if (unread > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.danger, shape: BoxShape.circle),
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
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        children: _FeedFilter.values.map((f) {
          final active = _filter == f;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.goldMuted : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? AppColors.gold : AppColors.border),
              ),
              child: Text(
                _filterLabel(f),
                style: TextStyle(
                  color: active ? AppColors.gold : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight:
                      active ? FontWeight.w500 : FontWeight.w400,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text('FEATURED',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8)),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: featured.length,
            itemBuilder: (_, i) => SizedBox(
              width: 280,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: EventCard(
                  event: featured[i],
                  compact: true,
                  onTap: () => context.push('/event/${featured[i].id}'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _opportunitiesSection() {
    final ops = mockOpportunities.where((o) => !o.isExpired).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text('LATEST OPPORTUNITIES',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8)),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
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
        final events = mockEvents
            .where((e) => e.status == EventStatus.upcoming)
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
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

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 48),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  String _filterLabel(_FeedFilter f) {
    switch (f) {
      case _FeedFilter.all:
        return 'All';
      case _FeedFilter.events:
        return 'Events';
      case _FeedFilter.opportunities:
        return 'Opportunities';
      case _FeedFilter.clubs:
        return 'Clubs';
      case _FeedFilter.academics:
        return 'Academics';
    }
  }

  String _sectionTitle() {
    switch (_filter) {
      case _FeedFilter.all:
      case _FeedFilter.events:
        return 'UPCOMING EVENTS';
      case _FeedFilter.opportunities:
        return 'ALL OPPORTUNITIES';
      default:
        return '';
    }
  }
}
