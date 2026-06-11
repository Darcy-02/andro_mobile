import 'package:flutter/material.dart';
import '../theme_colors.dart';
import '../models/andro_models.dart';

class EventDetailPage extends StatefulWidget {
  final AndroEvent event;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const EventDetailPage({
    super.key,
    required this.event,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;
  bool _saved = false;
  bool _rsvped = false;

  @override
  Widget build(BuildContext context) {
    final bg      = _isDark ? AndroColors.darkBackground  : AndroColors.lightBackground;
    final surface = _isDark ? AndroColors.darkSurface      : AndroColors.lightSurface;
    final accent  = _isDark ? AndroColors.darkAccent       : AndroColors.lightAccent;
    final amber   = _isDark ? AndroColors.darkAmber        : AndroColors.lightAmber;
    final text    = _isDark ? AndroColors.darkText         : AndroColors.lightText;
    final sub     = _isDark ? AndroColors.darkSecondary    : AndroColors.lightSecondary;
    final event   = widget.event;

    Color categoryColor;
    switch (event.category) {
      case 'Hackathon':
        categoryColor = const Color(0xFF3B82F6);
        break;
      case 'Workshop':
        categoryColor = const Color(0xFF22C55E);
        break;
      case 'Conference':
        categoryColor = amber;
        break;
      case 'Talk':
        categoryColor = const Color(0xFF7C3AED);
        break;
      default:
        categoryColor = accent;
    }

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: bg,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => setState(() => _saved = !_saved),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: _saved ? amber : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [event.gradientStart, event.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),
                    ),
                    // Center content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(event.icon,
                                color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 14),
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Going/Interested counts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${event.going} Going',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                '${event.interested} Interested',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
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
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      color: text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Organized by ${event.organizer}',
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: event.date,
                        color: accent,
                        surface: surface,
                      ),
                      _InfoChip(
                        icon: Icons.location_on_rounded,
                        label: event.location,
                        color: accent,
                        surface: surface,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // About
                  Text(
                    'About',
                    style: TextStyle(
                      color: text,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      event.description,
                      style: TextStyle(
                        color: sub,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Highlights
                  Text(
                    'Event Highlights',
                    style: TextStyle(
                      color: text,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HighlightRow(
                    icon: Icons.groups_rounded,
                    title: 'Community',
                    desc: 'Connect with fellow students & industry leaders.',
                    color: accent,
                    surface: surface,
                    text: text,
                    sub: sub,
                  ),
                  const SizedBox(height: 10),
                  _HighlightRow(
                    icon: Icons.emoji_events_rounded,
                    title: 'Prizes',
                    desc: 'Win recognition and exciting prizes.',
                    color: amber,
                    surface: surface,
                    text: text,
                    sub: sub,
                  ),
                  const SizedBox(height: 10),
                  _HighlightRow(
                    icon: Icons.lightbulb_rounded,
                    title: 'Learning',
                    desc: 'Gain practical skills and new perspectives.',
                    color: const Color(0xFF22C55E),
                    surface: surface,
                    text: text,
                    sub: sub,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom CTA ────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: bg,
          border: Border(
              top: BorderSide(color: sub.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sub.withOpacity(0.2)),
              ),
              child: IconButton(
                icon: Icon(Icons.share_rounded, color: sub, size: 20),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _rsvped = !_rsvped);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _rsvped
                              ? 'RSVP confirmed! See you there.'
                              : 'RSVP cancelled.',
                        ),
                        backgroundColor: accent,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rsvped ? surface : accent,
                    foregroundColor: _rsvped ? accent : Colors.white,
                    elevation: 0,
                    side: _rsvped
                        ? BorderSide(color: accent, width: 1.5)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _rsvped ? '✓ RSVP\'d' : 'RSVP Now',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color surface;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final Color surface;
  final Color text;
  final Color sub;

  const _HighlightRow({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    required this.surface,
    required this.text,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(color: sub, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
