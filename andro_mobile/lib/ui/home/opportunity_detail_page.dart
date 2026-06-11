import 'package:flutter/material.dart';
import '../theme_colors.dart';
import '../models/andro_models.dart';

class OpportunityDetailPage extends StatefulWidget {
  final AndroOpportunity opp;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const OpportunityDetailPage({
    super.key,
    required this.opp,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<OpportunityDetailPage> createState() => _OpportunityDetailPageState();
}

class _OpportunityDetailPageState extends State<OpportunityDetailPage> {
  bool get _isDark => widget.themeMode == ThemeMode.dark;
  bool _saved = false;
  bool _applied = false;

  @override
  Widget build(BuildContext context) {
    final bg      = _isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final surface = _isDark ? AndroColors.darkSurface     : AndroColors.lightSurface;
    final accent  = _isDark ? AndroColors.darkAccent      : AndroColors.lightAccent;
    final text    = _isDark ? AndroColors.darkText        : AndroColors.lightText;
    final sub     = _isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;
    final opp     = widget.opp;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
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
                    color: opp.iconColor.withOpacity(0.3),
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
                      color: opp.iconColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: Colors.white,
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
                    colors: [
                      opp.iconColor.withOpacity(0.3),
                      opp.iconColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: opp.iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: opp.iconColor.withOpacity(0.4), width: 1.5),
                      ),
                      child: Icon(opp.icon, color: opp.iconColor, size: 38),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: opp.iconColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: opp.iconColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        opp.type,
                        style: TextStyle(
                          color: opp.iconColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
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
                  Text(
                    opp.title,
                    style: TextStyle(
                      color: text,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    opp.organization,
                    style: TextStyle(
                      color: opp.iconColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Deadline warning
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          opp.deadline,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Apply soon!',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About
                  Text(
                    'About this Opportunity',
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
                      opp.description,
                      style: TextStyle(
                        color: sub,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Benefits
                  Text(
                    'Benefits',
                    style: TextStyle(
                      color: text,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BenefitRow(
                    icon: Icons.card_giftcard_rounded,
                    label: 'Certificate of completion',
                    color: accent,
                    surface: surface,
                    text: text,
                  ),
                  const SizedBox(height: 8),
                  _BenefitRow(
                    icon: Icons.handshake_rounded,
                    label: 'Mentorship & networking',
                    color: opp.iconColor,
                    surface: surface,
                    text: text,
                  ),
                  const SizedBox(height: 8),
                  _BenefitRow(
                    icon: Icons.star_rounded,
                    label: 'Portfolio & career boost',
                    color: const Color(0xFFF5A524),
                    surface: surface,
                    text: text,
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
          border: Border(top: BorderSide(color: sub.withOpacity(0.1))),
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
                    setState(() => _applied = !_applied);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _applied
                              ? 'Application submitted!'
                              : 'Application withdrawn.',
                        ),
                        backgroundColor: accent,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _applied ? surface : accent,
                    foregroundColor: _applied ? accent : Colors.white,
                    elevation: 0,
                    side: _applied
                        ? BorderSide(color: accent, width: 1.5)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _applied ? '✓ Applied' : 'Apply Now',
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

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color surface;
  final Color text;

  const _BenefitRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.surface,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Icon(Icons.check_circle_rounded, color: color, size: 16),
        ],
      ),
    );
  }
}
