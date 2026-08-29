import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/user_profile_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../features/auth/data/auth_repository.dart';
import '../../../../l10n/app_language.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    // Validate current step
    String? errorMessage;
    if (_currentIndex == 1 && _nameController.text.trim().isEmpty) {
      errorMessage = 'Please enter your name';
    } else if (_currentIndex == 2 && _dobController.text.trim().isEmpty) {
      errorMessage = 'Please enter your date of birth';
    } else if (_currentIndex == 3 && _timeController.text.trim().isEmpty) {
      errorMessage = 'Please enter your time of birth';
    } else if (_currentIndex == 4 && _placeController.text.trim().isEmpty) {
      errorMessage = 'Please enter your place of birth';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _generateChart();
    }
  }

  void _generateChart() async {
    // Validate current step
    String? errorMessage;
    if (_nameController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        _placeController.text.trim().isEmpty) {
      errorMessage = 'Please complete all fields';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _currentIndex = 5;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );

    try {
      // In a full implementation, we'd add slider UI for these, but we'll mock the user input for now
      // as if they selected 80% Career, 20% Love on the UI.
      final focusWeights = {'Career': 1.2, 'Love': 0.8, 'Money': 1.0};

      // Save user profile locally (legacy prefs + geocoding)
      await ref.read(userProfileProvider.notifier).updateProfile(
        name: _nameController.text.trim(),
        dob: _dobController.text.trim(),
        time: _timeController.text.trim(),
        place: _placeController.text.trim(),
      );

      final profile = ref.read(userProfileProvider);

      // Unified profile store — single source of truth for all astrology features
      await ref.read(profilesListProvider.notifier).upsertPrimaryProfile(
        name: profile.name,
        dob: profile.dob,
        birthTime: profile.time,
        birthPlace: profile.place,
        latitude: profile.latitude,
        longitude: profile.longitude,
        timezone: profile.timeZone,
      );

      // Ensure anonymous sign-in happens
      await ref.read(authRepositoryProvider).signInAnonymously();

      // Save profile to backend with real coordinates
      await ref.read(authRepositoryProvider).saveProfileData(
        name: profile.name,
        dob: profile.dob,
        time: profile.time,
        place: profile.place,
        latitude: profile.latitude,
        longitude: profile.longitude,
        timeZone: profile.timeZone,
        focusWeights: focusWeights,
      );
    } catch (e) {
      debugPrint('Failed to sync profile: $e');
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicGradient),
        child: SafeArea(
          child: ResponsiveLayout(
            child: Column(
              children: [
                // ── Custom Progress Indicator ──────────────────────
                if (_currentIndex < 5)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.responsive<double>(mobile: 20, tablet: 32, desktop: 40),
                      24,
                      context.responsive<double>(mobile: 20, tablet: 32, desktop: 40),
                      0,
                    ),
                    child: _buildSegmentedProgress(),
                  ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    children: [
                      _buildWelcomeStep(),
                      _buildNameStep(),
                      _buildDateStep(),
                      _buildTimeStep(),
                      _buildLocationStep(),
                      _buildGeneratingStep(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Segmented Progress Bar ──────────────────────────────────────
  Widget _buildSegmentedProgress() {
    return Row(
      children: List.generate(5, (index) {
        final isActive = index <= _currentIndex;
        final isCurrent = index == _currentIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 4,
            margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isActive
                  ? AppColors.primary
                  : AppColors.surfaceHighlightDark,
              boxShadow: isCurrent
                  ? [BoxShadow(color: AppColors.goldGlow, blurRadius: 8)]
                  : null,
            ),
          ),
        );
      }),
    ).fadeSlideUp();
  }

  // ── Welcome Step ────────────────────────────────────────────────
  Widget _buildWelcomeStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    // Celestial icon
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseController.value * 0.05),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldSubtleGradient,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.goldGlow,
                                blurRadius: 40,
                                spreadRadius: -8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('✦', style: TextStyle(fontSize: 48)),
                          ),
                        ),
                      ).fadeSlideUp(),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Your Personal\nAstrologer, Every Day.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ).fadeSlideUp(delay: 200.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Choose Your Language / भाषा / ભાષા',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondaryDark,
                      ),
                    ).fadeSlideUp(delay: 350.ms),
                    const SizedBox(height: 16),

                    // Language Cards
                    Consumer(
                      builder: (context, ref, _) {
                        final currentLang = ref.watch(localeProvider);
                        final languages = [
                          AppLanguage.english,
                          AppLanguage.hindi,
                          AppLanguage.gujarati,
                        ];

                        return Column(
                          children: languages.map((lang) {
                            final isSelected = currentLang == lang;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(localeProvider.notifier).setLanguage(lang);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.18)
                                        : AppColors.surfaceDark.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.glassBorder,
                                      width: isSelected ? 1.5 : 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(lang.flagEmoji, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${lang.nativeName} (${lang.englishName})',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (isSelected)
                                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                                      else
                                        Icon(Icons.circle_outlined, color: AppColors.textTertiaryDark, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ).fadeSlideUp(delay: 400.ms),

                    const Spacer(),
                    GradientButton(
                      text: 'Begin Your Journey',
                      icon: Icons.auto_awesome,
                      onPressed: _nextPage,
                    ).fadeSlideUp(delay: 500.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Name Step ───────────────────────────────────────────────────
  Widget _buildNameStep() {
    return _buildInputStep(
      icon: '👤',
      title: 'What should we\ncall you?',
      subtitle: 'Your name helps us personalize your daily guidance.',
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'Enter your name',
              prefixIcon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 32),
          GradientButton(text: 'Continue', onPressed: _nextPage),
        ],
      ),
    );
  }

  // ── Date Step ───────────────────────────────────────────────────
  Widget _buildDateStep() {
    return _buildInputStep(
      icon: '📅',
      title: 'When were\nyou born?',
      subtitle: 'This is essential for your birth chart.',
      child: Column(
        children: [
          TextField(
            controller: _dobController,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'DD / MM / YYYY',
              prefixIcon: Icons.calendar_today_rounded,
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 32),
          GradientButton(text: 'Continue', onPressed: _nextPage),
        ],
      ),
    );
  }

  // ── Time Step ───────────────────────────────────────────────────
  Widget _buildTimeStep() {
    return _buildInputStep(
      icon: '🕐',
      title: 'What time were\nyou born?',
      subtitle: 'Exact time ensures accurate planetary positions.',
      child: Column(
        children: [
          TextField(
            controller: _timeController,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'HH : MM AM/PM',
              prefixIcon: Icons.access_time_rounded,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _nextPage,
            child: Text(
              'I don\'t know my exact birth time',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.textTertiaryDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(text: 'Continue', onPressed: _nextPage),
        ],
      ),
    );
  }

  // ── Location Step ───────────────────────────────────────────────
  Widget _buildLocationStep() {
    return _buildInputStep(
      icon: '📍',
      title: 'Where were\nyou born?',
      subtitle: 'Required for natal chart generation.',
      child: Column(
        children: [
          TextField(
            controller: _placeController,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'City, Country',
              prefixIcon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Generate Chart',
            icon: Icons.auto_awesome,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // ── Generating Step ─────────────────────────────────────────────
  Widget _buildGeneratingStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Animated celestial sphere
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: false))
                    .rotate(duration: 8000.ms, curve: Curves.linear),
                // Inner dashed ring
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .rotate(
                      duration: 2000.ms,
                      curve: Curves.linear,
                      begin: 1,
                      end: 0,
                    ),
                // Center icon
                const Text(
                  '✦',
                  style: TextStyle(fontSize: 24, color: AppColors.primary),
                ),
              ],
            ).fadeSlideUp(),

            const SizedBox(height: 40),

            Text(
                  'Reading your stars...',
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(
                  duration: 1500.ms,
                  color: AppColors.primaryLight.withOpacity(0.5),
                )
                .fade(duration: 800.ms),

            const SizedBox(height: 32),

            // Animated checklist items
            _buildCheckItem('Birth details processed', 0),
            _buildCheckItem('Planetary positions calculated', 1),
            _buildCheckItem('Today\'s energy mapped', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, int index) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success.withOpacity(0.5)),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryDark,
                  height: 1.5,
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 500 + (index * 600)))
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideX(begin: 0.1, duration: 400.ms);
  }

  // ── Shared Input Step Layout ────────────────────────────────────
  Widget _buildInputStep({
    required String icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 40)).fadeSlideUp(),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ).fadeSlideUp(delay: 100.ms),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textSecondaryDark,
                        height: 1.5,
                      ),
                    ).fadeSlideUp(delay: 200.ms),
                    const Spacer(),
                    child.fadeSlideUp(delay: 300.ms),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
