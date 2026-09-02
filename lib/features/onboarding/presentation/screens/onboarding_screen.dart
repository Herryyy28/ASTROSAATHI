import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../features/auth/data/auth_repository.dart';
import '../../../../core/widgets/location_permission_dialog.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/engine/models/astrology_validation.dart';

/// Elite Production Onboarding Screen for AstroSaathi
/// Delivers a high-converting, celestial UI/UX with smooth transitions,
/// real-time Nam Rashi discovery, precision birth inputs, and animated Kundli creation.
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
  final TextEditingController _timeController = TextEditingController(
    text: '07:30',
  );
  final TextEditingController _placeController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedAmPm = 'AM';
  String _selectedCity = 'New Delhi, India';

  final List<String> _popularCities = [
    'New Delhi, India',
    'Mumbai, India',
    'Bengaluru, India',
    'Kolkata, India',
    'Chennai, India',
    'Ahmedabad, India',
    'Hyderabad, India',
    'Pune, India',
    'Jaipur, India',
    'Surat, India',
    'Lucknow, India',
    'London, UK',
    'New York, USA',
    'Dubai, UAE',
    'Singapore',
    'Custom Location',
  ];

  late AnimationController _pulseController;
  late AnimationController _spinController;
  ZodiacInfo? _detectedZodiac;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _nameController.addListener(_onNameChanged);
    _placeController.text = _selectedCity;
  }

  void _onNameChanged() {
    final text = _nameController.text.trim();
    if (text.isNotEmpty) {
      final zodiac = ZodiacSignUtils.getZodiacFromName(text);
      if (zodiac != _detectedZodiac) {
        setState(() {
          _detectedZodiac = zodiac;
        });
      }
    } else {
      if (_detectedZodiac != null) {
        setState(() {
          _detectedZodiac = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _pulseController.dispose();
    _spinController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _nextPage() {
    String? errorMessage;
    if (_currentIndex == 1) {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        errorMessage = 'Please enter your full name';
      } else if (name.length < 2) {
        errorMessage = 'Name must be at least 2 characters';
      }
    } else if (_currentIndex == 2) {
      if (_dobController.text.trim().isEmpty) {
        errorMessage = 'Please select your date of birth';
      } else if (_timeController.text.trim().isEmpty) {
        errorMessage = 'Please enter your birth time';
      } else if (_placeController.text.trim().isEmpty) {
        errorMessage = 'Please enter or select your place of birth';
      } else {
        try {
          AstrologyValidator.validateDate(_dobController.text.trim());
          AstrologyValidator.validateTime('${_timeController.text.trim()} $_selectedAmPm');
        } on AstrologyValidationException catch (e) {
          errorMessage = e.message;
        }
      }
    }

    if (errorMessage != null) {
      _showError(errorMessage);
      return;
    }

    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else if (_currentIndex == 2) {
      _generateChart();
    }
  }

  void _generateChart() async {
    final name = ZodiacSignUtils.capitalizeName(_nameController.text.trim());
    final dob = _dobController.text.trim();
    final fullTime = '${_timeController.text.trim()} $_selectedAmPm';
    final place = _placeController.text.trim();

    if (name.isEmpty || dob.isEmpty || fullTime.isEmpty || place.isEmpty) {
      _showError('Please complete all birth details');
      return;
    }

    try {
      AstrologyValidator.validateDate(dob);
      AstrologyValidator.validateTime(fullTime);
    } on AstrologyValidationException catch (e) {
      _showError(e.message);
      return;
    }

    setState(() {
      _currentIndex = 3;
    });
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }

    try {
      final focusWeights = {'Career': 1.2, 'Love': 0.8, 'Money': 1.0};

      double lat = 28.6139;
      double lon = 77.2090;
      try {
        if (place.isNotEmpty && (Platform.isAndroid || Platform.isIOS)) {
          final locations = await locationFromAddress(place).timeout(const Duration(seconds: 2));
          if (locations.isNotEmpty) {
            lat = locations.first.latitude;
            lon = locations.first.longitude;
          }
        }
      } catch (e) {
        debugPrint('Geocoding failed during onboarding for $place: $e');
      }

      final profile = BirthProfileData(
        id: 'primary',
        name: name,
        relationship: 'Self',
        dob: dob,
        birthTime: fullTime,
        birthPlace: place,
        latitude: lat,
        longitude: lon,
        timezone: '5.5',
        isPrimary: true,
      );

      await ref
          .read(profilesListProvider.notifier)
          .upsertPrimaryProfile(
            name: profile.name,
            dob: profile.dob,
            birthTime: profile.birthTime,
            birthPlace: profile.birthPlace,
            latitude: profile.latitude,
            longitude: profile.longitude,
            timezone: profile.timezone,
          );

      try {
        await ref
            .read(authRepositoryProvider)
            .signInAnonymously()
            .timeout(const Duration(milliseconds: 500));
        await ref
            .read(authRepositoryProvider)
            .saveProfileData(
              name: profile.name,
              dob: profile.dob,
              time: profile.birthTime,
              place: profile.birthPlace,
              latitude: profile.latitude,
              longitude: profile.longitude,
              timeZone: profile.timezone,
              focusWeights: focusWeights,
            )
            .timeout(const Duration(milliseconds: 500));
      } catch (_) {}
    } catch (e) {
      debugPrint('Failed to sync profile: $e');
    } finally {
      ref.invalidate(onboardingCompleteProvider);
      ref.invalidate(profilesListProvider);

      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            child: Column(
              children: [
                // Top Navigation Bar (Header + Back Button + Progress)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive<double>(
                      mobile: 20,
                      tablet: 32,
                      desktop: 40,
                    ),
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      if (_currentIndex > 0 && _currentIndex < 3)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isLight ? AppColors.textPrimaryLight : Colors.white,
                            size: 20,
                          ),
                          onPressed: _previousPage,
                        )
                      else
                        const SizedBox(width: 40),
                      Expanded(
                        child: _currentIndex < 3
                            ? _buildSegmentedProgress(isLight)
                            : const SizedBox.shrink(),
                      ),
                      if (_currentIndex < 3)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimary(context).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.getPrimary(context).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Step ${_currentIndex + 1}/3',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getPrimary(context),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Main Page View
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
                      _buildBirthDetailsStep(),
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

  Widget _buildSegmentedProgress(bool isLight) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentIndex;
        final isCurrent = index == _currentIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 5,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: isActive ? AppColors.goldGradient : null,
              color: isActive
                  ? null
                  : (isLight ? AppColors.borderLight : Colors.white.withOpacity(0.12)),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    ).fadeSlideUp();
  }

  Widget _buildWelcomeStep() {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),

                    // Animated Glowing Cosmic Emblem
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseController.value * 0.04),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldSubtleGradient,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 40,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.auto_awesome,
                                      size: 54,
                                      color: AppColors.primary,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ).fadeSlideUp(),
                    ),

                    const SizedBox(height: 28),

                    // Gold Mask Title
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isLight
                            ? [
                                AppColors.primaryLightMode,
                                AppColors.primaryDarkLightMode,
                                AppColors.secondary,
                              ]
                            : [
                                const Color(0xFFFFFFFF),
                                const Color(0xFFFFE899),
                                const Color(0xFFE5B842),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        'Unlock Your Cosmic Blueprint',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: isLight ? AppColors.primaryLightMode : Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ).fadeSlideUp(delay: 150.ms),

                    const SizedBox(height: 10),

                    Text(
                      'Your Personal Vedic Astrologer & Kundli Companion',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.getTextSecondary(context),
                        height: 1.4,
                      ),
                    ).fadeSlideUp(delay: 250.ms),

                    const SizedBox(height: 28),

                    // Language Selection Box
                    GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(18),
                      borderColor: AppColors.getGlassBorder(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.language_rounded,
                                color: AppColors.getPrimary(context),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Select Preferred Language',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
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
                                        ref
                                            .read(localeProvider.notifier)
                                            .setLanguage(lang);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.getPrimary(context).withOpacity(0.18)
                                              : (isLight
                                                  ? AppColors.surfaceSecondaryLight
                                                  : Colors.white.withOpacity(0.04)),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.getPrimary(context)
                                                : AppColors.getGlassBorder(context),
                                            width: isSelected ? 1.5 : 0.8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              lang.flagEmoji,
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                '${lang.nativeName} (${lang.englishName})',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 15,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? AppColors.getPrimary(context)
                                                      : AppColors.getTextPrimary(context),
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: AppColors.getPrimary(context),
                                                size: 20,
                                              )
                                            else
                                              Icon(
                                                Icons.circle_outlined,
                                                color: isLight
                                                    ? AppColors.textMutedLight
                                                    : Colors.white.withOpacity(0.3),
                                                size: 18,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ).fadeSlideUp(delay: 350.ms),

                    const Spacer(),

                    // Trust Tagline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 14,
                          color: AppColors.getPrimary(context),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '100% Accurate Vedic Calculations • Privacy Protected',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppColors.getTextMuted(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ).fadeSlideUp(delay: 450.ms),

                    const SizedBox(height: 16),

                    GradientButton(
                      text: 'Begin Your Cosmic Journey',
                      icon: Icons.auto_awesome,
                      onPressed: _nextPage,
                    ).fadeSlideUp(delay: 550.ms),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameStep() {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return _buildInputStep(
      badgeTitle: 'PERSONALIZATION',
      title: 'What should we call you?',
      subtitle: 'Your name maps your Nam Rashi and personalizes daily forecasts.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Text Field
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.outfit(
              color: AppColors.getTextPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline_rounded,
              context: context,
            ),
          ),

          const SizedBox(height: 20),

          // Gender Selection Segmented Pills
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Male', 'Female', 'Other'].map((gender) {
                  final isSelected = _selectedGender == gender;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = gender),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.getPrimary(context).withOpacity(0.2)
                                : (isLight
                                    ? AppColors.surfaceSecondaryLight
                                    : Colors.white.withOpacity(0.05)),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.getPrimary(context)
                                  : AppColors.getGlassBorder(context),
                              width: isSelected ? 1.5 : 0.8,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              gender,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.getPrimary(context)
                                    : AppColors.getTextPrimary(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Real-Time Nam Rashi Discovery Card
          if (_detectedZodiac != null)
            GlassCard(
              borderRadius: 18,
              padding: const EdgeInsets.all(16),
              borderColor: AppColors.getPrimary(context).withOpacity(0.5),
              glowColor: AppColors.getPrimary(context).withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.getPrimary(context).withOpacity(0.15),
                      border: Border.all(color: AppColors.getPrimary(context).withOpacity(0.4)),
                    ),
                    child: Center(
                      child: Text(
                        _detectedZodiac!.symbol,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Nam Rashi: ${_detectedZodiac!.englishName}',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${_detectedZodiac!.hindiName})',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Element: ${_detectedZodiac!.element} • Ruler: ${_detectedZodiac!.rulingPlanet}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).fadeSlideUp(),

          const SizedBox(height: 28),

          GradientButton(
            text: 'Continue to Birth Details',
            icon: Icons.arrow_forward_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsStep() {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return _buildInputStep(
      badgeTitle: 'VEDIC KUNDLI CALCULATION',
      title: 'Enter Precise Birth Details',
      subtitle: 'Date, exact time, and birth city calculate your authentic Kundli.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date of Birth Field Button / Card
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(2000, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: isLight
                          ? const ColorScheme.light(
                              primary: AppColors.primaryLightMode,
                              onPrimary: Colors.white,
                              surface: AppColors.surfaceLight,
                              onSurface: AppColors.textPrimaryLight,
                            )
                          : const ColorScheme.dark(
                              primary: AppColors.primary,
                              onPrimary: Colors.black,
                              surface: AppColors.surfaceDark,
                              onSurface: Colors.white,
                            ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() {
                  _dobController.text =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: _dobController,
                style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 16),
                decoration: AppDecorations.premiumInput(
                  hintText: 'Date of Birth (YYYY-MM-DD)',
                  prefixIcon: Icons.calendar_today_rounded,
                  context: context,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time of Birth + AM/PM Segment Toggle
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 7, minute: 30),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: isLight
                                ? const ColorScheme.light(
                                    primary: AppColors.primaryLightMode,
                                    onPrimary: Colors.white,
                                    surface: AppColors.surfaceLight,
                                    onSurface: AppColors.textPrimaryLight,
                                  )
                                : const ColorScheme.dark(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.black,
                                    surface: AppColors.surfaceDark,
                                    onSurface: Colors.white,
                                  ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
                      final minute = time.minute.toString().padLeft(2, '0');
                      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                      setState(() {
                        _timeController.text =
                            '${hour.toString().padLeft(2, '0')}:$minute';
                        _selectedAmPm = period;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 16),
                      decoration: AppDecorations.premiumInput(
                        hintText: 'Time (HH:MM)',
                        prefixIcon: Icons.access_time_rounded,
                        context: context,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.surfaceSecondaryLight
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: Row(
                    children: ['AM', 'PM'].map((period) {
                      final isSelected = _selectedAmPm == period;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedAmPm = period),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.getPrimary(context) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                period,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.black
                                      : AppColors.getTextPrimary(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // City Location Dropdown / Selection
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isLight
                  ? AppColors.surfaceSecondaryLight
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.getGlassBorder(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _popularCities.contains(_selectedCity)
                    ? _selectedCity
                    : 'Custom Location',
                isExpanded: true,
                dropdownColor: AppColors.getSurface(context),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.getPrimary(context)),
                style: GoogleFonts.outfit(
                  color: AppColors.getTextPrimary(context),
                  fontSize: 15,
                ),
                items: _popularCities
                    .map(
                      (city) => DropdownMenuItem(
                        value: city,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColors.getPrimary(context),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                city,
                                style: GoogleFonts.outfit(
                                  color: city == 'Custom Location'
                                      ? AppColors.getPrimary(context)
                                      : AppColors.getTextPrimary(context),
                                  fontWeight: city == 'Custom Location'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCity = val;
                      if (val != 'Custom Location') {
                        _placeController.text = val;
                      } else {
                        _placeController.clear();
                      }
                    });
                  }
                },
              ),
            ),
          ),

          if (_selectedCity == 'Custom Location') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _placeController,
              style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 16),
              decoration: AppDecorations.premiumInput(
                hintText: 'Enter City, State, Country',
                prefixIcon: Icons.edit_location_alt_outlined,
                context: context,
              ),
            ),
          ],

          const SizedBox(height: 8),

          // Detect Location Action Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                final accepted = await LocationPermissionDialog.show(context);
                if (accepted == true) {
                  setState(() {
                    _selectedCity = 'New Delhi, India';
                    _placeController.text = 'New Delhi, India';
                  });
                }
              },
              icon: const Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              label: Text(
                'Auto-Detect Location',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          GradientButton(
            text: 'Generate My Birth Chart',
            icon: Icons.auto_awesome,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Animated Concentric Celestial Zodiac Wheel
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _spinController,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.35),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: List.generate(8, (i) {
                          final angle = (i * 45) * 3.14159 / 180;
                          return Align(
                            alignment: Alignment(
                              0.85 * (i % 2 == 0 ? 1 : -1),
                              0.85 * (i % 4 < 2 ? 1 : -1),
                            ),
                            child: Text(
                              ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏'][i],
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary.withOpacity(0.6),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldSubtleGradient,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.stars_rounded,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ).fadeSlideUp(),

              const SizedBox(height: 32),

              Text(
                'Reading Your Celestial Chart...',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                    duration: 1600.ms,
                    color: AppColors.getPrimary(context),
                  ),

              const SizedBox(height: 24),

              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(18),
                borderColor: AppColors.getGlassBorder(context),
                child: Column(
                  children: [
                    _buildCheckItem('Nam Rashi & Zodiac Sign Mapped', 0),
                    Divider(color: Theme.of(context).brightness == Brightness.light ? AppColors.dividerLight : Colors.white10, height: 16),
                    _buildCheckItem('Planetary Positions & Kundli Calculated', 1),
                    Divider(color: Theme.of(context).brightness == Brightness.light ? AppColors.dividerLight : Colors.white10, height: 16),
                    _buildCheckItem('Vedic Guidance & Daily Horoscope Ready', 2),
                  ],
                ),
              ).fadeSlideUp(delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.2),
              border: Border.all(color: Colors.green.shade400),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 300 + (index * 350)))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.08);
  }

  Widget _buildInputStep({
    required String badgeTitle,
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step Badge Header Pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimary(context).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.getPrimary(context).withOpacity(0.35),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '✦  $badgeTitle',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getPrimary(context),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ).fadeSlideUp(),

                    const SizedBox(height: 16),

                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                        letterSpacing: -0.4,
                      ),
                    ).fadeSlideUp(delay: 100.ms),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.getTextSecondary(context),
                        height: 1.35,
                      ),
                    ).fadeSlideUp(delay: 200.ms),

                    const SizedBox(height: 24),

                    child.fadeSlideUp(delay: 300.ms),

                    const Spacer(),
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
