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
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../features/auth/data/auth_repository.dart';
import '../../../../core/widgets/location_permission_dialog.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/routing/app_router.dart';

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
  ZodiacInfo? _detectedZodiac;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _nameController.addListener(_onNameChanged);
    _placeController.text = _selectedCity;
  }

  void _onNameChanged() {
    final text = _nameController.text;
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
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    String? errorMessage;
    if (_currentIndex == 1) {
      if (_nameController.text.trim().isEmpty) {
        errorMessage = 'Please enter your name';
      }
    } else if (_currentIndex == 2) {
      if (_dobController.text.trim().isEmpty) {
        errorMessage = 'Please select your date of birth';
      } else if (_timeController.text.trim().isEmpty) {
        errorMessage = 'Please enter your time of birth';
      } else if (_placeController.text.trim().isEmpty) {
        errorMessage = 'Please select or enter your place of birth';
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all birth details'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
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

      // Direct geocoding with platform guards and timeout
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
      
      // Wait slightly for state to sync and animations to feel right
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        context.go('/');
      }
    }
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
                if (_currentIndex < 3)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.responsive<double>(
                        mobile: 20,
                        tablet: 32,
                        desktop: 40,
                      ),
                      20,
                      context.responsive<double>(
                        mobile: 20,
                        tablet: 32,
                        desktop: 40,
                      ),
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

  Widget _buildSegmentedProgress() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentIndex;
        final isCurrent = index == _currentIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
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

  Widget _buildWelcomeStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
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
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.goldSubtleGradient,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.goldGlow,
                                blurRadius: 36,
                                spreadRadius: -6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      '✦',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ).fadeSlideUp(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your Personal Vedic\nAstrologer, Every Day.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                        height: 1.35,
                        letterSpacing: -0.5,
                      ),
                    ).fadeSlideUp(delay: 200.ms),
                    const SizedBox(height: 10),
                    Text(
                      'Choose Your Preferred Language',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondaryDark,
                        height: 1.35,
                      ),
                    ).fadeSlideUp(delay: 300.ms),
                    const SizedBox(height: 16),
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
                                        ? AppColors.primary.withOpacity(0.18)
                                        : AppColors.surfaceDark.withOpacity(
                                            0.6,
                                          ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.glassBorder,
                                      width: isSelected ? 1.5 : 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        lang.flagEmoji,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '${lang.nativeName} (${lang.englishName})',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textPrimaryDark,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        )
                                      else
                                        Icon(
                                          Icons.circle_outlined,
                                          color: AppColors.textTertiaryDark,
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
                    ).fadeSlideUp(delay: 400.ms),
                    const Spacer(),
                    GradientButton(
                      text: 'Begin Your Cosmic Journey',
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

  Widget _buildNameStep() {
    return _buildInputStep(
      icon: '👤',
      title: 'What should we\ncall you?',
      subtitle: 'Your name personalizes your chart & daily predictions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'Enter full name',
              prefixIcon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),
          if (_detectedZodiac != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Text(
                    _detectedZodiac!.symbol,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nam Rashi: ${_detectedZodiac!.englishName} (${_detectedZodiac!.hindiName})',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Element: ${_detectedZodiac!.element} • Ruler: ${_detectedZodiac!.rulingPlanet}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark,
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
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsStep() {
    return _buildInputStep(
      icon: '✨',
      title: 'Enter Birth Details',
      subtitle:
          'Date, exact time, and location generate your authentic Kundli.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date of Birth Field
          TextField(
            controller: _dobController,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(2000, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _dobController.text =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                });
              }
            },
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
            ),
            decoration: AppDecorations.premiumInput(
              hintText: 'Date of Birth (YYYY-MM-DD)',
              prefixIcon: Icons.calendar_today_rounded,
            ),
          ),
          const SizedBox(height: 14),

          // Time of Birth with AM/PM Dropdown
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 7, minute: 30),
                    );
                    if (time != null) {
                      final hour = time.hourOfPeriod == 0
                          ? 12
                          : time.hourOfPeriod;
                      final minute = time.minute.toString().padLeft(2, '0');
                      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                      setState(() {
                        _timeController.text =
                            '${hour.toString().padLeft(2, '0')}:$minute';
                        _selectedAmPm = period;
                      });
                    }
                  },
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 16,
                  ),
                  decoration: AppDecorations.premiumInput(
                    hintText: 'Time (HH:MM)',
                    prefixIcon: Icons.access_time_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAmPm,
                      dropdownColor: AppColors.surfaceDark,
                      alignment: Alignment.center,
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      items: ['AM', 'PM']
                          .map(
                            (val) =>
                                DropdownMenuItem(value: val, child: Text(val)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedAmPm = val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // City Location Dropdown / Input
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlightDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _popularCities.contains(_selectedCity)
                    ? _selectedCity
                    : 'Custom Location',
                isExpanded: true,
                dropdownColor: AppColors.surfaceDark,
                alignment: Alignment.centerLeft,
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 15,
                  height: 1.2,
                ),
                items: _popularCities
                    .map(
                      (city) => DropdownMenuItem(
                        value: city,
                        child: Text(
                          city,
                          style: TextStyle(
                            color: city == 'Custom Location'
                                ? AppColors.primary
                                : AppColors.textPrimaryDark,
                            fontWeight: city == 'Custom Location'
                                ? FontWeight.bold
                                : FontWeight.normal,
                            height: 1.2,
                          ),
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
            const SizedBox(height: 10),
            TextField(
              controller: _placeController,
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 16,
              ),
              decoration: AppDecorations.premiumInput(
                hintText: 'Enter City, Country',
                prefixIcon: Icons.location_on_outlined,
              ),
            ),
          ],
          const SizedBox(height: 8),
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
                'Detect Location',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            text: 'Generate Birth Chart',
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: false))
                      .rotate(duration: 8000.ms, curve: Curves.linear),
                  Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .rotate(
                        duration: 3000.ms,
                        curve: Curves.linear,
                        begin: 1,
                        end: 0,
                      ),
                  const Text(
                    '✦',
                    style: TextStyle(fontSize: 28, color: AppColors.primary),
                  ),
                ],
              ).fadeSlideUp(),
              const SizedBox(height: 24),
              Text(
                    'Reading your stars...',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark,
                      height: 1.3,
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(
                    duration: 1500.ms,
                    color: AppColors.primaryLight.withOpacity(0.5),
                  ),
              const SizedBox(height: 20),
              _buildCheckItem('Name & Nam Rashi mapped', 0),
              _buildCheckItem(
                'Birth details & planetary positions calculated',
                1,
              ),
              _buildCheckItem('Vedic Kundli & daily guidance ready', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, int index) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryDark,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: 400 + (index * 400)))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1);
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 36),
                    ).fadeSlideUp(),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                    ).fadeSlideUp(delay: 100.ms),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondaryDark,
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
