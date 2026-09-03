import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../data/auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showToast(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? AppColors.error : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final notifier = ref.read(userSessionProvider.notifier);

    if (_isSignUp) {
      final success = await notifier.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() => _isLoading = false);

      if (success && mounted) {
        _showToast('Account created successfully! Welcome to AstroSaathi.', isError: false);
        context.pop();
      } else if (mounted) {
        _showToast('Registration failed. Please try again.');
      }
    } else {
      final success = await notifier.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() => _isLoading = false);

      if (success && mounted) {
        _showToast('Logged in successfully!', isError: false);
        context.pop();
      } else if (mounted) {
        _showToast('Login failed. Check your email & password.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(userSessionProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Back Button & Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.getTextPrimary(context)),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        _isSignUp ? 'Create Account' : 'Welcome Back',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: context.fontLG,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // Logo Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.15),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.stars_rounded, size: 48, color: AppColors.primary),
                ).fadeSlideUp(),

                const SizedBox(height: 16),

                Text(
                  _isSignUp ? 'Join AstroSaathi for Personalized Vedic Guidance' : 'Sign in to sync your Kundli & Family Profiles',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: context.fontSM,
                    color: AppColors.getTextSecondary(context),
                  ),
                ).fadeSlideUp(delay: 100.ms),

                const SizedBox(height: 30),

                // Glass Card with 1-Tap Sign-In Options
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Google Sign-In Primary Button
                      ElevatedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() => _isLoading = true);
                                final success = await ref
                                    .read(userSessionProvider.notifier)
                                    .loginWithGoogle();
                                setState(() => _isLoading = false);

                                if (success && mounted) {
                                  _showToast('Signed in with Google successfully!', isError: false);
                                  context.pop();
                                } else if (mounted) {
                                  _showToast('Google Sign-In failed or cancelled.');
                                }
                              },
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                          height: 22,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.g_mobiledata_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        label: Text(
                          'Continue with Google',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Continue as Guest Option
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.getGlassBorder(context)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Continue as Guest',
                          style: GoogleFonts.outfit(
                            color: AppColors.getTextSecondary(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).fadeSlideUp(delay: 200.ms),

                const SizedBox(height: 30),

                // Currently Authenticated status if any
                if (session.isAuthenticated) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Signed in as ${session.name} (${session.email})',
                            style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13),
                          ),
                        ),
                        TextButton(
                          onPressed: () => ref.read(userSessionProvider.notifier).logout(),
                          child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
