import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../data/auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showToast(String msg, {bool isError = true}) {
    CosmicNotification.show(
      context,
      message: msg,
      icon: isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    setState(() => _isLoading = true);

    try {
      bool success = false;
      if (_isSignUp) {
        success = await ref.read(userSessionProvider.notifier).register(name, email, password);
        if (success) {
          _showToast('Account created successfully! Welcome, $name', isError: false);
          if (mounted && context.canPop()) {
            context.pop();
          } else if (mounted) {
            context.go('/');
          }
        } else {
          _showToast('Registration failed. Please check credentials or try logging in.');
        }
      } else {
        success = await ref.read(userSessionProvider.notifier).login(email, password);
        if (success) {
          _showToast('Signed in successfully! Welcome back', isError: false);
          if (mounted && context.canPop()) {
            context.pop();
          } else if (mounted) {
            context.go('/');
          }
        } else {
          _showToast('Invalid email or password. Please verify and retry.');
        }
      }
    } catch (e) {
      _showToast('Authentication error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                // Top Navigation Bar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.getTextPrimary(context)),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
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

                const SizedBox(height: 16),

                // Celestial Emblem
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.stars_rounded, size: 44, color: AppColors.primary),
                ).fadeSlideUp(),

                const SizedBox(height: 12),

                Text(
                  _isSignUp
                      ? 'Join AstroSaathi for Personalized Vedic Guidance'
                      : 'Sign in to access your Kundli & Consultations',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: context.fontSM,
                    color: AppColors.getTextSecondary(context),
                  ),
                ).fadeSlideUp(delay: 100.ms),

                const SizedBox(height: 20),

                // If already logged in, show current session banner
                if (session.isAuthenticated) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Logged In',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${session.name ?? "User"} (${session.email ?? "No Email"})',
                                style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref.read(userSessionProvider.notifier).logout();
                            _showToast('Signed out', isError: false);
                          },
                          child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ).fadeSlideUp(delay: 150.ms),
                  const SizedBox(height: 20),
                ],

                // Main Auth Form Glass Card
                GlassCard(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tab switcher: Sign In vs Sign Up
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.getSurfaceSecondary(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isSignUp = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !_isSignUp ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        color: !_isSignUp ? Colors.white : AppColors.getTextSecondary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isSignUp = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _isSignUp ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Create Account',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        color: _isSignUp ? Colors.white : AppColors.getTextSecondary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Name field (Sign Up only)
                        if (_isSignUp) ...[
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: AppColors.getTextPrimary(context)),
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                              filled: true,
                              fillColor: AppColors.getSurfaceSecondary(context),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Please enter your name';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: AppColors.getTextPrimary(context)),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.getSurfaceSecondary(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter your email';
                            if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email';
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: AppColors.getTextPrimary(context)),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: AppColors.getSurfaceSecondary(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Please enter password';
                            if (val.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Primary Submit Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(
                                  _isSignUp ? 'Create AstroSaathi Account' : 'Sign In',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 18),

                        // Divider with OR
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.getGlassBorder(context))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.getTextSecondary(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.getGlassBorder(context))),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Google Sign-In Secondary Button
                        OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  final success = await ref
                                      .read(userSessionProvider.notifier)
                                      .loginWithGoogle();
                                  if (!mounted) return;
                                  setState(() => _isLoading = false);

                                  if (success) {
                                    _showToast('Signed in with Google successfully!', isError: false);
                                    if (mounted && context.canPop()) {
                                      context.pop();
                                    } else if (mounted) {
                                      context.go('/');
                                    }
                                  } else {
                                    _showToast('Google Sign-In failed or cancelled.');
                                  }
                                },
                          icon: const Icon(Icons.g_mobiledata_rounded, color: AppColors.primary, size: 28),
                          label: Text(
                            'Continue with Google',
                            style: GoogleFonts.outfit(
                              color: AppColors.getTextPrimary(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: BorderSide(color: AppColors.getGlassBorder(context)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Continue as Guest Option
                        TextButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/');
                            }
                          },
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
                  ),
                ).fadeSlideUp(delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
