import 'dart:math';
import 'package:flutter/material.dart';
import 'shell/main_shell.dart';
import 'login_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _twinkleController;

  @override
  void initState() {
    super.initState();
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    super.dispose();
  }

  void _enterApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _twinkleController,
            builder: (context, _) => CustomPaint(
              painter: _ConstellationPainter(_twinkleController.value),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'ANDRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your universe of possibilities.',
                            style: TextStyle(
                              color: Color(0xFF8B9CB0),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Explore. Connect. Grow. All in one place.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 15,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _enterApp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A1A1A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(20, 20),
                            painter: _GoogleGPainter(),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Color(0xFF6B788D), fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          ' Sign In',
                          style: TextStyle(
                            color: Color(0xFFE5A020),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Star constellation painter ───────────────────────────────────────────────

class _ConstellationPainter extends CustomPainter {
  final double t;
  _ConstellationPainter(this.t);

  static final List<Offset> _stars = _buildStars();
  static final List<(int, int)> _edges = _buildEdges();

  static List<Offset> _buildStars() {
    final rng = Random(17);
    return List.generate(90, (_) => Offset(rng.nextDouble(), rng.nextDouble()));
  }

  static List<(int, int)> _buildEdges() {
    final stars = _buildStars();
    final edges = <(int, int)>[];
    for (int i = 0; i < stars.length; i++) {
      for (int j = i + 1; j < stars.length; j++) {
        if ((stars[i] - stars[j]).distance < 0.11 && edges.length < 35) {
          edges.add((i, j));
        }
      }
    }
    return edges;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (final (a, b) in _edges) {
      final p1 = Offset(_stars[a].dx * size.width, _stars[a].dy * size.height);
      final p2 = Offset(_stars[b].dx * size.width, _stars[b].dy * size.height);
      linePaint.color = Colors.white.withValues(alpha: 0.07 + 0.05 * t);
      canvas.drawLine(p1, p2, linePaint);
    }

    for (int i = 0; i < _stars.length; i++) {
      final phase = sin(t * pi * 2 + i * 1.3);
      final opacity = 0.35 + 0.45 * ((phase + 1) / 2);
      final r = 0.7 + 0.9 * ((phase + 1) / 2);
      dotPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(_stars[i].dx * size.width, _stars[i].dy * size.height),
        r,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter old) => old.t != t;
}

// ── Google G logo painter ────────────────────────────────────────────────────

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = w / 2;
    final cy = w / 2;
    final outerR = w / 2;
    final innerR = w * 0.30;
    final ringW = outerR - innerR;
    final arcR = (outerR + innerR) / 2;

    final arcRect = Rect.fromCircle(center: Offset(cx, cy), radius: arcR);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringW
      ..strokeCap = StrokeCap.butt;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(arcRect, -pi / 2, pi / 2, false, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(arcRect, 0, pi / 2, false, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(arcRect, pi / 2, pi / 2, false, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(arcRect, pi, pi / 2, false, paint);

    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - ringW / 2, outerR, ringW),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
