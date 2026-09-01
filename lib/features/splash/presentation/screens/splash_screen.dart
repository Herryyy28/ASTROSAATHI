import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/routing/app_router.dart';

/// Elite Production Splash Screen for AstroSaathi
/// Features layered radial aura, rotating sacred zodiac ring, gold shader title,
/// dynamic ephemeris status indicator, and luxury branding details.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  int _statusIndex = 0;
  Timer? _statusTimer;

  final List<String> _loadingStatuses = [
    'Aligning Ephemeris Data...',
    'Calculating Nakshatras & Cusps...',
    'Preparing Today\'s Cosmic Energy...',
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _statusTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _statusIndex = (_statusIndex + 1) % _loadingStatuses.length;
        });
      }
    });

    _navigateToNext();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2200));
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CosmicParticleBackground(
        child: ResponsiveLayout(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // ── Central Glowing Sacred Geometry & Emblem ─────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Deep Ambient Radial Glow
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 70,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: const Color(0xFF7B2CBF).withOpacity(0.2),
                            blurRadius: 90,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    // Outer Rotating Zodiac Ring (Hardware Layer Isolated)
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationController.value * 2 * math.pi,
                            child: CustomPaint(
                              size: const Size(180, 180),
                              painter: _SacredZodiacRingPainter(),
                            ),
                          );
                        },
                      ),
                    ),

                    // Inner Frosted Gold Core Emblem
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceDark,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldGlow,
                            blurRadius: 32,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldSubtleGradient,
                            border: Border.all(
                              color: AppColors.primaryLight.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFFF2B2), Color(0xFFD4AF37)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds),
                              child: const Text(
                                '✦',
                                style: TextStyle(
                                  fontSize: 54,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .scale(
                          duration: 1100.ms,
                          curve: Curves.easeOutBack,
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                        )
                        .fadeIn(duration: 800.ms)
                        .then()
                        .shimmer(
                          duration: 1600.ms,
                          color: AppColors.primaryLight.withOpacity(0.5),
                        ),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Luxury Brand Title with Gold Shader Gradient ─────────
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFE899),
                      Color(0xFFD4AF37),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    'AstroSaathi',
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 700.ms)
                    .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 12),

                // ── Slogan Glass Pill Badge ──────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'YOUR PERSONAL COSMIC COMPANION',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryDark,
                      letterSpacing: 1.8,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 450.ms, duration: 700.ms)
                    .slideY(begin: 0.2, end: 0),

                const Spacer(flex: 3),

                // ── Dynamic Ephemeris Status & Progress Bar ─────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _loadingStatuses[_statusIndex],
                    key: ValueKey<int>(_statusIndex),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                      letterSpacing: 0.4,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 12),

                // Custom Sleek Gold Progress Bar (Isolated Layer)
                RepaintBoundary(
                  child: Container(
                    width: 140,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlightDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 140,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ).animate(onPlay: (controller) => controller.repeat()).slideX(
                            duration: 1500.ms,
                            begin: -1.0,
                            end: 1.0,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ),
                ).animate().fadeIn(delay: 850.ms),

                const SizedBox(height: 24),

                // ── Footer Edition Badge ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AUTHENTIC VEDIC ASTROLOGY',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiaryDark,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('✦', style: TextStyle(fontSize: 8, color: AppColors.primary)),
                    ),
                    Text(
                      'LAHIRI AYANAMSA',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiaryDark,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1000.ms),

                const SizedBox(height: 32),
              ],
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
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final innerRingPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final tickPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, outerRingPaint);
    canvas.drawCircle(center, radius - 12, innerRingPaint);

    // Draw 12 Zodiac Constellation Tick Marks & Accent Dots
    const int count = 12;
    for (int i = 0; i < count; i++) {
      final angle = (i * 30) * math.pi / 180;
      final start = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);

      // Accent dots on major cardinal points (0°, 90°, 180°, 270°)
      if (i % 3 == 0) {
        final dotPos = Offset(
          center.dx + (radius + 6) * math.cos(angle),
          center.dy + (radius + 6) * math.sin(angle),
        );
        canvas.drawCircle(dotPos, 2.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
