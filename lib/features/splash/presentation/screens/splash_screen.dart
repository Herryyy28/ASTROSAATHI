import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/routing/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 1800));
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated Logo Container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldSubtleGradient,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldGlow,
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          '✦',
                          style: TextStyle(
                            fontSize: 64,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
                  .animate()
                  .scale(
                    duration: 1000.ms,
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1.0, 1.0),
                  )
                  .fadeIn(duration: 800.ms)
                  .then()
                  .shimmer(
                    duration: 1400.ms,
                    color: AppColors.primaryLight.withOpacity(0.4),
                  ),

              const SizedBox(height: 32),

              // App Name
              Text(
                'AstroSaathi',
                style: GoogleFonts.outfit(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark,
                  letterSpacing: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

              const SizedBox(height: 10),

              // Slogan
              Text(
                'Your Personal Cosmic Companion',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondaryDark,
                  letterSpacing: 0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const Spacer(flex: 2),

              // Loading Spinner & Version
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 16),

              Text(
                'AUTHENTIC VEDIC ASTROLOGY',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiaryDark,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(delay: 1000.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
