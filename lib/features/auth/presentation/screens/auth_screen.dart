import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../core/config/app_config.dart';
import '../../data/auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;

  void _finish() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Future<void> _google() async {
    setState(() => _loading = true);
    final ok = await ref.read(userSessionProvider.notifier).loginWithGoogle();
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      _finish();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In was cancelled or unavailable.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.backgroundLight,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ASTROSAATHI',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLightMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 72),
                  Container(
                    width: 112,
                    height: 112,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white,
                          AppColors.highlightSurface,
                          Color(0xFFF7EAF8),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 42,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Your stars.\nYour journey.\nYour AstroSaathi.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 37,
                      height: 1.17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      AppConfig.experienceLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Personalized astrology, daily guidance and cosmic insights created around you.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const Spacer(),
                  AstroSecondaryButton(
                    label: _loading ? 'Signing in…' : 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: _loading ? null : _google,
                  ),
                  const SizedBox(height: 12),
                  AstroSecondaryButton(
                    label: 'Continue with Email',
                    icon: Icons.mail_outline_rounded,
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            final ok = await ref
                                .read(userSessionProvider.notifier)
                                .login('demo@astrosaathi.local', 'demo');
                            if (!context.mounted) return;
                            setState(() => _loading = false);
                            if (ok) _finish();
                          },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: _finish,
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'By continuing you agree to our Terms & Privacy Policy.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
