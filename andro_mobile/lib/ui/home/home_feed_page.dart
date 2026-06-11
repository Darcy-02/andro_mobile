import 'package:flutter/material.dart';
import '../theme_colors.dart';
import '../models/andro_models.dart';
import 'event_detail_page.dart';
import 'opportunity_detail_page.dart';

class HomeFeedPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final Map<String, String> currentUser;
  final VoidCallback onNotificationsTap;

  const HomeFeedPage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.currentUser,
    required this.onNotificationsTap,
  });

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;

  final List<String> _filters = ['All', 'Events', 'Opportunities', 'Clubs'];
  String _selectedFilter = 'All';

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  List<AndroEvent> get _filteredEvents {
    if (_selectedFilter == 'All' || _selectedFilter == 'Events') {
      return upcomingEvents;
    }
    return [];
  }

  List<AndroOpportunity> get _filteredOpportunities {
    if (_selectedFilter == 'All' || _selectedFilter == 'Opportunities') {
      return latestOpportunities;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final bg     = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final amber  = _isDark ? AndroColors.darkAmber       : AndroColors.lightAmber;
    final text   = _isDark ? AndroColors.darkText        : AndroColors.lightText;
    final sub    = _isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;
    final accent = _isDark ? AndroColors.darkAccent      : AndroColors.lightAccent;
    final name   = widget.currentUser['name'] ?? 'Explorer';
    final firstName = name.split(' ').first;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Top bar ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ANDRO',
                      style: TextStyle(
                        color: text,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onNotificationsTap,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _isDark
                                  ? AndroColors.darkSurface
                                  : AndroColors.lightSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: sub,
                              size: 22,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Greeting ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: text,
                        ),
                        children: [
                          TextSpan(text: '$_greeting '),
                          TextSpan(
                            text: firstName,
                            style: TextStyle(color: amber),
                          ),
                          const TextSpan(text: ''),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ALU Kigali · Trimester 3',
                      style: TextStyle(
                        color: sub,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Featured card ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _FeaturedCard(
                  event: featuredEvent,
                  amber: amber,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(
                        event: featuredEvent,
                        themeMode: widget.themeMode,
                        onToggleTheme: widget.onToggleTheme,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter chips ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final f = _filters[i];
                      final selected = f == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? accent
                                : (_isDark
                                    ? AndroColors.darkSurface
                                    : AndroColors.lightSurface),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: selected
                                  ? accent
                                  : sub.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              color: selected ? Colors.white : sub,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Latest Opportunities ─────────────────────────────────────
            if (_filteredOpportunities.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest Opportunities',
                        style: TextStyle(
                          color: text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          color: accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: _filteredOpportunities.length > 4
                        ? 4
                        : _filteredOpportunities.length,
                    itemBuilder: (context, i) {
                      return _OpportunityCard(
                        opp: _filteredOpportunities[i],
                        isDark: _isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OpportunityDetailPage(
                              opp: _filteredOpportunities[i],
                              themeMode: widget.themeMode,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],

            // ── Upcoming Events ──────────────────────────────────────────
            if (_filteredEvents.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          color: text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          color: accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _EventCard(
                          event: _filteredEvents[i],
                          isDark: _isDark,
                          accent: accent,
                          sub: sub,
                          text: text,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailPage(
                                event: _filteredEvents[i],
                                themeMode: widget.themeMode,
                                onToggleTheme: widget.onToggleTheme,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _filteredEvents.length,
                  ),
                ),
              ),
            ],

            if (_filteredEvents.isEmpty && _filteredOpportunities.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded,
                          color: sub, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Nothing here yet',
                        style: TextStyle(color: sub, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Featured Card
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final AndroEvent event;
  final Color amber;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.event,
    required this.amber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [event.gradientStart, event.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: event.gradientEnd.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FEATURED badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: amber.withOpacity(0.5), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: amber, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'FEATURED',
                          style: TextStyle(
                            color: amber,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Subtitle
                  Text(
                    'Pitches · Panels · Networking · ${event.location}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  // Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: Colors.white.withOpacity(0.7), size: 12),
                          const SizedBox(width: 5),
                          Text(
                            event.date,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'RSVP →',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Opportunity Card (2-column grid)
// ─────────────────────────────────────────────────────────────────────────────

class _OpportunityCard extends StatelessWidget {
  final AndroOpportunity opp;
  final bool isDark;
  final VoidCallback onTap;

  const _OpportunityCard({
    required this.opp,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
    final text    = isDark ? AndroColors.darkText    : AndroColors.lightText;
    final sub     = isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: opp.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(opp.icon, color: opp.iconColor, size: 18),
            ),
            const SizedBox(height: 10),
            // Type label
            Text(
              opp.type,
              style: TextStyle(
                color: sub,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Title
            Text(
              opp.title,
              style: TextStyle(
                color: text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Deadline
            Text(
              opp.deadline,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Event Card (full width with gradient header)
// ─────────────────────────────────────────────────────────────────────────────

class _EventCard extends StatefulWidget {
  final AndroEvent event;
  final bool isDark;
  final Color accent;
  final Color sub;
  final Color text;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.isDark,
    required this.accent,
    required this.sub,
    required this.text,
    required this.onTap,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _saved = false;

  Color get _categoryColor {
    switch (widget.event.category) {
      case 'Hackathon':
        return const Color(0xFF3B82F6);
      case 'Workshop':
        return const Color(0xFF22C55E);
      case 'Conference':
        return const Color(0xFF4A7CF7);
      case 'Talk':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = widget.isDark
        ? AndroColors.darkSurface
        : AndroColors.lightSurface;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDark ? 0.25 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gradient header ─────────────────────────────────────────
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.event.gradientStart,
                    widget.event.gradientEnd
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(14),
              child: Stack(
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _categoryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.event.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Icon top-right
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.event.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info section ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: TextStyle(
                      color: widget.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: widget.sub, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        widget.event.date,
                        style: TextStyle(
                            color: widget.sub, fontSize: 11),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on_rounded,
                          color: widget.sub, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        widget.event.location,
                        style: TextStyle(
                            color: widget.sub, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${widget.event.going} Going',
                        style: TextStyle(
                            color: widget.sub, fontSize: 11),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.event.interested} Interested',
                        style: TextStyle(
                            color: widget.sub, fontSize: 11),
                      ),
                      const Spacer(),
                      // Save
                      GestureDetector(
                        onTap: () => setState(() => _saved = !_saved),
                        child: Row(
                          children: [
                            Icon(
                              _saved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _saved
                                  ? const Color(0xFFEF4444)
                                  : widget.sub,
                              size: 16,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Save',
                              style: TextStyle(
                                  color: widget.sub, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // RSVP button
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: widget.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'RSVP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
