import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';

/// Elite Pure Animation Splash Screen for AstroSaathi
/// Directly displays full-screen cosmic particle background & rotating sacred geometry emblem
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _navigateToNext();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    bool isDone = false;
    try {
      isDone = ref.read(onboardingCompleteProvider);
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
    }

    if (!mounted) return;
    if (isDone) {
      context.go('/');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: CosmicParticleBackground(
          child: ResponsiveLayout(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Deep Ambient Radial Glow
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.30),
                          blurRadius: 80,
                          spreadRadius: 24,
                        ),
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.20),
                          blurRadius: 100,
                          spreadRadius: 12,
                        ),
                      ],
                    ),
                  ),

                  // Outer Rotating Sacred Zodiac Ring
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(200, 200),
                            painter: _SacredZodiacRingPainter(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Inner Frosted Gold Core Emblem with App Icon
                  Container(
                    width: 124,
                    height: 124,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: isLight ? Colors.white : AppColors.surfaceDark,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.85),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldGlow,
                          blurRadius: 36,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 124,
                        height: 124,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1.0, 1.0),
                      )
                      .fadeIn(duration: 600.ms)
                      .then()
                      .shimmer(
                        duration: 1200.ms,
                        color: AppColors.primaryLight.withOpacity(0.6),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter drawing a 12-section sacred zodiac ring around the splash emblem
class _SacredZodiacRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerRingPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final innerRingPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final tickPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, outerRingPaint);
    canvas.drawCircle(center, radius - 14, innerRingPaint);

    // Draw 12 Zodiac Constellation Tick Marks & Accent Dots
    const int count = 12;
    for (int i = 0; i < count; i++) {
      final angle = (i * 30) * math.pi / 180;
      final start = Offset(
        center.dx + (radius - 14) * math.cos(angle),
        center.dy + (radius - 14) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);

      // Accent dots on major cardinal points (0°, 90°, 180°, 270°)
      if (i % 3 == 0) {
        final dotPos = Offset(
          center.dx + (radius + 7) * math.cos(angle),
          center.dy + (radius + 7) * math.sin(angle),
        );
        canvas.drawCircle(dotPos, 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
