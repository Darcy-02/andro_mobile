import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    // Mocked sign-in: no backend, any tap logs in as the default mock user.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    ref.read(authProvider.notifier).login();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            // Full-screen star field — covers the entire screen
            Positioned.fill(
              child: CustomPaint(painter: const _StarfieldPainter()),
            ),

            // Subtle radial accent-glow from top
            Positioned(
              top: -size.height * 0.1,
              left: 0,
              right: 0,
              height: size.height * 0.65,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 0.85,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                // ── Hero area ──────────────────────────────────────
                Expanded(
                  flex: 55,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Gradient fade-to-panel at the bottom of the hero
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 160,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.bgPrimary.withValues(alpha: 0.95),
                                AppColors.bgPrimary,
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Wordmark + logo centered
                      SafeArea(
                        bottom: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Orbit ring logo
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.25,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent.withValues(
                                      alpha: 0.12,
                                    ),
                                    border: Border.all(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.45,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'ANDRO',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'YOUR CAMPUS, CONNECTED',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bottom panel ───────────────────────────────────
                Expanded(
                  flex: 45,
                  child: Container(
                    width: double.infinity,
                    color: AppColors.bgPrimary,
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to ALU Kigali',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Discover events, join communities,\nand connect with your campus.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),

                          _SignInButton(
                            loading: _loading,
                            onTap: _loading ? null : _signInWithGoogle,
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '@alustudent.com accounts only',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Star field ────────────────────────────────────────────────────────────────

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  // Named constellation star positions (normalized 0–1)
  static const _named = [
    // Top band
    Offset(0.10, 0.06),
    Offset(0.28, 0.10),
    Offset(0.50, 0.05),
    Offset(0.72, 0.09),
    Offset(0.88, 0.06),
    Offset(0.95, 0.16),
    // Upper-mid band
    Offset(0.05, 0.22),
    Offset(0.20, 0.28),
    Offset(0.38, 0.24),
    Offset(0.57, 0.20),
    Offset(0.74, 0.26),
    Offset(0.88, 0.22),
    // Mid band
    Offset(0.12, 0.40),
    Offset(0.30, 0.45),
    Offset(0.48, 0.38),
    Offset(0.65, 0.43),
    Offset(0.82, 0.40),
    Offset(0.94, 0.48),
    // Lower-mid band
    Offset(0.08, 0.58),
    Offset(0.25, 0.63),
    Offset(0.44, 0.58),
    Offset(0.62, 0.65),
    Offset(0.80, 0.60),
    // Lower band
    Offset(0.16, 0.78),
    Offset(0.38, 0.74),
    Offset(0.56, 0.80),
    Offset(0.74, 0.76),
    Offset(0.91, 0.82),
  ];

  static const _lines = [
    // Top band chain
    [0, 1], [1, 2], [2, 3], [3, 4], [4, 5],
    // Top → upper-mid verticals
    [0, 6], [1, 7], [2, 8], [3, 9], [4, 10], [5, 11],
    // Upper-mid chain
    [6, 7], [7, 8], [8, 9], [9, 10], [10, 11],
    // Upper-mid → mid verticals
    [7, 12], [8, 13], [9, 14], [10, 15], [11, 16],
    // Mid chain
    [12, 13], [13, 14], [14, 15], [15, 16], [16, 17],
    // Mid → lower-mid verticals
    [12, 18], [13, 19], [14, 20], [15, 21], [16, 22],
    // Lower-mid chain
    [18, 19], [19, 20], [20, 21], [21, 22],
    // Lower-mid → lower verticals
    [19, 23], [20, 24], [21, 25], [22, 26],
    // Lower chain
    [23, 24], [24, 25], [25, 26], [26, 27],
    // Diagonal cross-connects for realism
    [1, 8], [3, 10], [8, 15], [14, 21], [20, 25],
  ];

  // Stars that get a 4-point sparkle cross
  static const _sparkleIdx = {2, 9, 14, 20, 25};

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);

    // Layer 1: tiny background stars
    for (int i = 0; i < 210; i++) {
      final p = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      final r = rng.nextDouble() * 0.9 + 0.2;
      final a = rng.nextDouble() * 0.42 + 0.08;
      canvas.drawCircle(
        p,
        r,
        Paint()..color = Colors.white.withValues(alpha: a),
      );
    }

    // Layer 2: medium stars
    for (int i = 0; i < 60; i++) {
      final p = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      final r = rng.nextDouble() * 1.1 + 0.9;
      final a = rng.nextDouble() * 0.38 + 0.22;
      canvas.drawCircle(
        p,
        r,
        Paint()..color = Colors.white.withValues(alpha: a),
      );
    }

    // Constellation lines
    final lp = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..strokeWidth = 0.55
      ..style = PaintingStyle.stroke;

    for (final ln in _lines) {
      if (ln[0] < _named.length && ln[1] < _named.length) {
        canvas.drawLine(
          Offset(_named[ln[0]].dx * size.width, _named[ln[0]].dy * size.height),
          Offset(_named[ln[1]].dx * size.width, _named[ln[1]].dy * size.height),
          lp,
        );
      }
    }

    // Named constellation star nodes with glow
    for (int i = 0; i < _named.length; i++) {
      final p = Offset(_named[i].dx * size.width, _named[i].dy * size.height);

      // Outer glow halo
      canvas.drawCircle(
        p,
        6.0,
        Paint()..color = Colors.white.withValues(alpha: 0.04),
      );
      canvas.drawCircle(
        p,
        3.5,
        Paint()..color = Colors.white.withValues(alpha: 0.12),
      );
      // Bright core
      canvas.drawCircle(
        p,
        1.6,
        Paint()..color = Colors.white.withValues(alpha: 0.88),
      );

      if (_sparkleIdx.contains(i)) {
        _drawSparkle(canvas, p);
      }
    }
  }

  void _drawSparkle(Canvas canvas, Offset c) {
    final p = Paint()
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    // Long arms (horizontal + vertical)
    p.color = Colors.white.withValues(alpha: 0.50);
    canvas.drawLine(Offset(c.dx - 10, c.dy), Offset(c.dx + 10, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - 10), Offset(c.dx, c.dy + 10), p);

    // Short diagonal arms
    p.color = Colors.white.withValues(alpha: 0.28);
    const d = 6.0;
    canvas.drawLine(Offset(c.dx - d, c.dy - d), Offset(c.dx + d, c.dy + d), p);
    canvas.drawLine(Offset(c.dx + d, c.dy - d), Offset(c.dx - d, c.dy + d), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Sign-in button ────────────────────────────────────────────────────────────

class _SignInButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;

  const _SignInButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 54,
        decoration: BoxDecoration(
          color: loading ? AppColors.bgElevated : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: loading
                ? AppColors.border
                : AppColors.accent.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: loading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _GoogleLogo(),
                    SizedBox(width: 12),
                    Text(
                      'Continue with ALU Gmail',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Google logo ───────────────────────────────────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.05,
      1.75,
      false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      0.7,
      0.95,
      false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.65,
      0.95,
      false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.6,
      0.7,
      false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - size.height * 0.09, r * 0.95, size.height * 0.18),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
