import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../models/andro_models.dart';
import '../models/profile_models.dart';
import '../theme_colors.dart';

// Fixed mock start dates relative to now so tabs are populated correctly
DateTime get _now => DateTime.now();

final _eventDates = <String, DateTime>{
  'f1': _now.add(const Duration(hours: 6)),
  'e1': _now.add(const Duration(days: 3)),
  'e2': _now.subtract(const Duration(days: 5)),
  'e3': _now.add(const Duration(hours: 30)),
};

final _allEvents = [featuredEvent, ...upcomingEvents];

AndroEvent? _findEvent(String id) {
  try {
    return _allEvents.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
}

class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
  Color get _surface => _isDark ? AndroColors.darkSurface : AndroColors.lightSurface;
  Color get _accent => _isDark ? AndroColors.darkAccent : AndroColors.lightAccent;
  Color get _amber => _isDark ? AndroColors.darkAmber : AndroColors.lightAmber;
  Color get _text => _isDark ? AndroColors.darkText : AndroColors.lightText;
  Color get _secondary => _isDark ? AndroColors.darkSecondary : AndroColors.lightSecondary;
  Color get _divider => _isDark ? AndroColors.darkDivider : AndroColors.lightDivider;
  Color get _danger => _isDark ? AndroColors.darkRed : AndroColors.lightRed;
  Color get _success => _isDark ? AndroColors.darkGreen : AndroColors.lightGreen;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final rsvps = appState.rsvps;

    final going = rsvps
        .where((r) => r.status == RsvpStatus.going)
        .toList()
      ..sort((a, b) {
        final da = _eventDates[a.eventId] ?? DateTime(9999);
        final db = _eventDates[b.eventId] ?? DateTime(9999);
        return da.compareTo(db);
      });

    final interested =
        rsvps.where((r) => r.status == RsvpStatus.interested).toList();

    final past = rsvps
        .where((r) {
          final d = _eventDates[r.eventId];
          return d != null && d.isBefore(_now);
        })
        .toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _text,
        elevation: 0,
        title: Text('My RSVPs',
            style: TextStyle(color: _text, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _accent,
          unselectedLabelColor: _secondary,
          indicatorColor: _accent,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Going (${going.length})'),
            Tab(text: 'Interested (${interested.length})'),
            const Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RsvpList(
            entries: going,
            tab: _RsvpTab.going,
            appState: appState,
            isDark: _isDark,
            bg: _bg,
            surface: _surface,
            accent: _accent,
            amber: _amber,
            text: _text,
            secondary: _secondary,
            divider: _divider,
            danger: _danger,
            success: _success,
          ),
          _RsvpList(
            entries: interested,
            tab: _RsvpTab.interested,
            appState: appState,
            isDark: _isDark,
            bg: _bg,
            surface: _surface,
            accent: _accent,
            amber: _amber,
            text: _text,
            secondary: _secondary,
            divider: _divider,
            danger: _danger,
            success: _success,
          ),
          _RsvpList(
            entries: past,
            tab: _RsvpTab.past,
            appState: appState,
            isDark: _isDark,
            bg: _bg,
            surface: _surface,
            accent: _accent,
            amber: _amber,
            text: _text,
            secondary: _secondary,
            divider: _divider,
            danger: _danger,
            success: _success,
          ),
        ],
      ),
    );
  }
}

enum _RsvpTab { going, interested, past }

class _RsvpList extends StatelessWidget {
  final List<RsvpEntry> entries;
  final _RsvpTab tab;
  final AppState appState;
  final bool isDark;
  final Color bg, surface, accent, amber, text, secondary, divider, danger, success;

  const _RsvpList({
    required this.entries,
    required this.tab,
    required this.appState,
    required this.isDark,
    required this.bg,
    required this.surface,
    required this.accent,
    required this.amber,
    required this.text,
    required this.secondary,
    required this.divider,
    required this.danger,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _EmptyState(tab: tab, bg: bg, text: text, secondary: secondary, accent: accent);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final entry = entries[i];
        final event = _findEvent(entry.eventId);
        if (event == null) return const SizedBox.shrink();

        final card = _RsvpCard(
          entry: entry,
          event: event,
          tab: tab,
          appState: appState,
          surface: surface,
          accent: accent,
          amber: amber,
          text: text,
          secondary: secondary,
          danger: danger,
          success: success,
        );

        if (tab == _RsvpTab.past) {
          return Opacity(opacity: 0.6, child: card);
        }
        if (tab == _RsvpTab.going) {
          return Dismissible(
            key: Key(entry.eventId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: danger,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.event_busy_rounded,
                  color: Colors.white, size: 24),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: surface,
                  title: Text('Cancel RSVP',
                      style: TextStyle(
                          color: text, fontWeight: FontWeight.w700)),
                  content: Text(
                    'Remove your RSVP for "${event.title}"?',
                    style: TextStyle(color: secondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('Keep it',
                          style: TextStyle(color: secondary)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('Cancel RSVP',
                          style: TextStyle(color: danger)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) {
              appState.cancelRsvp(entry.eventId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('RSVP cancelled for ${event.title}'),
                  backgroundColor: danger,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: card,
          );
        }
        return card;
      },
    );
  }
}

class _RsvpCard extends StatelessWidget {
  final RsvpEntry entry;
  final AndroEvent event;
  final _RsvpTab tab;
  final AppState appState;
  final Color surface, accent, amber, text, secondary, danger, success;

  const _RsvpCard({
    required this.entry,
    required this.event,
    required this.tab,
    required this.appState,
    required this.surface,
    required this.accent,
    required this.amber,
    required this.text,
    required this.secondary,
    required this.danger,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = _eventDates[event.id];
    final hoursUntil =
        startDate != null ? startDate.difference(_now).inHours : -1;
    final accentMuted = accent.withValues(alpha: 0.12);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              // Colour thumbnail
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [event.gradientStart, event.gradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(event.icon, color: Colors.white70, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.date}  ·  ${event.location}',
                      style: TextStyle(color: secondary, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    // Status badge row
                    Row(
                      children: [
                        if (tab == _RsvpTab.going && hoursUntil > 0 && hoursUntil < 48)
                          _Pill(
                            label: hoursUntil < 1
                                ? 'Starting soon'
                                : 'Starts in ${hoursUntil}h',
                            bg: accentMuted,
                            fg: accent,
                          ),
                        if (tab == _RsvpTab.past)
                          _Pill(
                            label: entry.checkedIn ? 'Attended' : 'Missed',
                            bg: entry.checkedIn
                                ? success.withValues(alpha: 0.15)
                                : danger.withValues(alpha: 0.15),
                            fg: entry.checkedIn ? success : danger,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Interested nudge banner
          if (tab == _RsvpTab.interested &&
              startDate != null &&
              startDate.difference(_now).inDays < 3 &&
              startDate.isAfter(_now))
            _NudgeBanner(
              event: event,
              appState: appState,
              accent: accent,
              accentMuted: accentMuted,
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Pill({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _NudgeBanner extends StatelessWidget {
  final AndroEvent event;
  final AppState appState;
  final Color accent;
  final Color accentMuted;

  const _NudgeBanner({
    required this.event,
    required this.appState,
    required this.accent,
    required this.accentMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accentMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: accent, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Event is coming up soon — confirm you\'re going',
                style: TextStyle(color: accent, fontSize: 12)),
          ),
          GestureDetector(
            onTap: () {
              appState.rsvpEvent(event.id, RsvpStatus.going);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('RSVP confirmed for ${event.title}'),
                  backgroundColor: accent,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Icon(Icons.arrow_forward_rounded, color: accent, size: 18),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final _RsvpTab tab;
  final Color bg, text, secondary, accent;
  const _EmptyState(
      {required this.tab,
      required this.bg,
      required this.text,
      required this.secondary,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (tab) {
      _RsvpTab.going => (
          Icons.event_available_rounded,
          'No upcoming RSVPs',
          'Events you RSVP to will show here',
        ),
      _RsvpTab.interested => (
          Icons.star_border_rounded,
          'Nothing marked as interested',
          'Mark events as interested to track them',
        ),
      _RsvpTab.past => (
          Icons.history_rounded,
          'No past events yet',
          'Events you attended will appear here',
        ),
    };

    return Container(
      color: bg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: secondary, size: 52),
            const SizedBox(height: 14),
            Text(title,
                style: TextStyle(
                    color: text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: secondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
