import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/engine/models/astrology_validation.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../demo/demo_locations.dart';
import '../../../auth/data/auth_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController(
    text: 'Ahmedabad, Gujarat, India',
  );
  int _step = 0;
  DateTime _dob = DateTime(1998, 3, 18);
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 42);
  bool _unknownTime = false;
  String _gender = 'Male';
  String _city = 'Ahmedabad, Gujarat, India';
  final Set<String> _focus = {
    'Love & Relationships',
    'Career',
    'Spiritual Growth',
  };
  String _system = 'Both';
  AppLanguage _language = AppLanguage.english;
  bool _saving = false;

  static const _cities = [
    'Ahmedabad, Gujarat, India',
    'New Delhi, Delhi, India',
    'Mumbai, Maharashtra, India',
    'Bengaluru, Karnataka, India',
    'Kolkata, West Bengal, India',
    'Chennai, Tamil Nadu, India',
    'Hyderabad, Telangana, India',
    'Pune, Maharashtra, India',
  ];
  static const _areas = [
    'Love & Relationships',
    'Marriage',
    'Career',
    'Money & Wealth',
    'Health & Wellness',
    'Family',
    'Education',
    'Business',
    'Spiritual Growth',
    'Life Purpose',
    'Personal Growth',
    'Timing & Decisions',
  ];

  @override
  void initState() {
    super.initState();
    final existing = ref.read(profilesListProvider);
    if (existing.isNotEmpty) {
      final p = ref.read(activeProfileProvider);
      _nameController.text = p.name;
      _placeController.text = p.birthPlace;
      _city = _cities.contains(p.birthPlace) ? p.birthPlace : _cities.first;
      final parsed = DateTime.tryParse(p.dob);
      if (parsed != null) _dob = parsed;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.backgroundLight,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 18, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _step == 0
                      ? () => context.canPop() ? context.pop() : null
                      : _back,
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.primaryLightMode,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceLight,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / 9,
                      minHeight: 5,
                      color: AppColors.actionPurple,
                      backgroundColor: AppColors.softLavender,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Step ${_step + 1} of 9',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) => setState(() => _step = value),
              children: [
                _name(),
                _genderStep(),
                _date(),
                _timeStep(),
                _place(),
                _focusStep(),
                _systemStep(),
                _languageStep(),
                _reviewStep(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: AstroPrimaryButton(
              label: _step == 8 ? 'Create my profile' : 'Continue',
              loading: _saving,
              onPressed: _next,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _layout(String title, {String? subtitle, required Widget child}) =>
      LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLightMode,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                child,
              ],
            ),
          ),
        ),
      );

  Widget _name() => _layout(
    'What should we call you?',
    subtitle: "We'll use this to personalize your readings.",
    child: AstroInput(controller: _nameController, hintText: 'Your name'),
  );
  Widget _genderStep() => _layout(
    'What is your gender?',
    child: Column(
      children: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
          .map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AstroSelectCard(
                title: g,
                selected: _gender == g,
                onTap: () => setState(() => _gender = g),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _date() {
    final zodiac = _zodiacForDate(_dob);
    return _layout(
      'What is your date of birth?',
      subtitle:
          'Your birth date helps AstroSaathi calculate your zodiac placements and personalize your insights.',
      child: Column(
        children: [
          AstroCard(
            onTap: _pickDate,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: _dateColumn('DAY', '${_dob.day}'.padLeft(2, '0')),
                ),
                _separator(),
                Expanded(child: _dateColumn('MONTH', _month(_dob.month))),
                _separator(),
                Expanded(child: _dateColumn('YEAR', '${_dob.year}')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.highlightSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_dob.day} ${DateTime(0, _dob.month).month == _dob.month ? _monthLong(_dob.month) : ''} ${_dob.year}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    '${zodiac.$1} ${zodiac.$2}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 15,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 6),
              Text(
                'We use this only to personalize your astrology profile.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateColumn(String label, String value) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          color: AppColors.textSecondaryLight,
        ),
      ),
      const SizedBox(height: 18),
      Text(
        value,
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryLightMode,
        ),
      ),
      const SizedBox(height: 8),
      const Icon(
        Icons.unfold_more_rounded,
        size: 18,
        color: AppColors.textSecondaryLight,
      ),
    ],
  );
  Widget _separator() =>
      Container(width: 1, height: 88, color: AppColors.softLavender);

  Widget _timeStep() {
    final local = _unknownTime ? const TimeOfDay(hour: 12, minute: 0) : _time;
    return _layout(
      'What time were you born?',
      subtitle:
          'Your birth time helps us calculate your rising sign, houses and more precise planetary positions.',
      child: Column(
        children: [
          Text(
            local.format(context),
            style: GoogleFonts.playfairDisplay(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLightMode,
            ),
          ),
          const SizedBox(height: 18),
          AstroCard(
            onTap: _unknownTime ? null : _pickTime,
            child: Row(
              children: [
                Expanded(
                  child: _dateColumn(
                    'HOUR',
                    '${local.hourOfPeriod == 0 ? 12 : local.hourOfPeriod}'
                        .padLeft(2, '0'),
                  ),
                ),
                _separator(),
                Expanded(
                  child: _dateColumn(
                    'MINUTE',
                    '${local.minute}'.padLeft(2, '0'),
                  ),
                ),
                _separator(),
                Expanded(
                  child: _dateColumn(
                    'AM / PM',
                    local.period == DayPeriod.am ? 'AM' : 'PM',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AstroSelectCard(
            title: "I don't know my exact birth time",
            subtitle: _unknownTime
                ? 'A solar chart will be calculated at 12:00 PM.'
                : null,
            selected: _unknownTime,
            onTap: () => setState(() => _unknownTime = !_unknownTime),
          ),
        ],
      ),
    );
  }

  Widget _place() => _layout(
    'Where were you born?',
    child: Column(
      children: [
        _selectField('COUNTRY', 'India', null),
        const SizedBox(height: 12),
        _selectField(
          'STATE / REGION',
          _city.split(',').length > 1 ? _city.split(',')[1].trim() : 'Gujarat',
          null,
        ),
        const SizedBox(height: 12),
        _selectField('CITY', _city.split(',').first, () async {
          final value = await showModalBottomSheet<String>(
            context: context,
            backgroundColor: AppColors.backgroundLight,
            builder: (_) => SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: _cities
                    .map(
                      (c) => ListTile(
                        title: Text(c),
                        onTap: () => Navigator.pop(context, c),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
          if (value != null) {
            setState(() {
              _city = value;
              _placeController.text = value;
            });
          }
        }),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.highlightSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _placeController.text,
                  style: const TextStyle(
                    color: AppColors.primaryLightMode,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _selectField(String label, String value, VoidCallback? onTap) =>
      AstroCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: .5,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.secondary,
              ),
          ],
        ),
      );

  Widget _focusStep() => _layout(
    'What would you like AstroSaathi to help you with?',
    subtitle: 'Choose what matters most to you right now.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_focus.length}/3 selected · Choose up to 3',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.primaryLightMode,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _areas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.72,
          ),
          itemBuilder: (_, i) {
            final area = _areas[i];
            final selected = _focus.contains(area);
            return AstroSelectCard(
              title: area,
              icon: _areaIcon(area),
              selected: selected,
              onTap: () {
                setState(() {
                  if (selected) {
                    _focus.remove(area);
                  } else if (_focus.length < 3) {
                    _focus.add(area);
                  }
                });
              },
            );
          },
        ),
      ],
    ),
  );
  Widget _systemStep() => _layout(
    'What would you like to explore?',
    child: Column(
      children:
          [
                (
                  'Vedic Astrology',
                  'Kundli, Nakshatra, Dasha and planetary timing',
                ),
                (
                  'Western Astrology',
                  'Natal wheel, houses, aspects and transits',
                ),
                ('Both', 'Get a combined personalized experience'),
              ]
              .map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AstroSelectCard(
                    title: s.$1 == 'Both' ? 'Both   RECOMMENDED' : s.$1,
                    subtitle: s.$2,
                    icon: s.$1 == 'Vedic Astrology'
                        ? Icons.temple_hindu_outlined
                        : s.$1 == 'Western Astrology'
                        ? Icons.public_rounded
                        : Icons.auto_awesome_outlined,
                    selected: _system == s.$1,
                    onTap: () => setState(() => _system = s.$1),
                  ),
                ),
              )
              .toList(),
    ),
  );
  Widget _languageStep() => _layout(
    'Which language do you prefer?',
    subtitle: 'You can change this later in your profile.',
    child: Column(
      children: [
        const AstroInput(
          hintText: 'Search language',
          prefixIcon: Icons.search_rounded,
        ),
        const SizedBox(height: 12),
        ...AppLanguage.values.map(
          (lang) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AstroSelectCard(
              title: lang.nativeName,
              titleStyle: _languageStyle(lang),
              selected: _language == lang,
              onTap: () => setState(() => _language = lang),
            ),
          ),
        ),
      ],
    ),
  );

  TextStyle _languageStyle(AppLanguage language) {
    const base = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    );
    return switch (language) {
      AppLanguage.hindi ||
      AppLanguage.marathi => GoogleFonts.notoSansDevanagari(textStyle: base),
      AppLanguage.tamil => GoogleFonts.notoSansTamil(textStyle: base),
      AppLanguage.kannada => GoogleFonts.notoSansKannada(textStyle: base),
      AppLanguage.malayalam => GoogleFonts.notoSansMalayalam(textStyle: base),
      AppLanguage.gujarati => GoogleFonts.notoSansGujarati(textStyle: base),
      AppLanguage.bengali => GoogleFonts.notoSansBengali(textStyle: base),
      AppLanguage.telugu => GoogleFonts.notoSansTelugu(textStyle: base),
      AppLanguage.english => GoogleFonts.inter(textStyle: base),
    };
  }

  Widget _reviewStep() => _layout(
    'Review your profile',
    subtitle:
        'Confirm these details before AstroSaathi prepares your personalized experience.',
    child: Column(
      children: [
        AstroInsightCard(
          child: Column(
            children: [
              _reviewRow(
                Icons.person_outline_rounded,
                'Name',
                _nameController.text.trim(),
              ),
              _reviewRow(
                Icons.cake_outlined,
                'Birth date',
                '${_dob.day} ${_monthLong(_dob.month)} ${_dob.year}',
              ),
              _reviewRow(
                Icons.schedule_outlined,
                'Birth time',
                _unknownTime ? 'Estimated · 12:00 PM' : _time.format(context),
              ),
              _reviewRow(Icons.location_on_outlined, 'Birth place', _city),
              _reviewRow(Icons.explore_outlined, 'Astrology', _system),
              _reviewRow(
                Icons.language_rounded,
                'Language',
                _language.nativeName,
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AstroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FOCUS AREAS',
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: .8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _focus
                    .map(
                      (area) => Chip(
                        avatar: Icon(_areaIcon(area), size: 15),
                        label: Text(area),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _reviewRow(
    IconData icon,
    String label,
    String value, {
    bool last = false,
  }) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryLightMode),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.textSecondaryLight),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
      if (!last) const Divider(),
    ],
  );

  IconData _areaIcon(String area) => switch (area) {
    'Love & Relationships' => Icons.favorite_outline_rounded,
    'Marriage' => Icons.volunteer_activism_outlined,
    'Career' => Icons.work_outline_rounded,
    'Money & Wealth' => Icons.savings_outlined,
    'Health & Wellness' => Icons.spa_outlined,
    'Family' => Icons.family_restroom_outlined,
    'Education' => Icons.school_outlined,
    'Business' => Icons.business_center_outlined,
    'Spiritual Growth' => Icons.self_improvement_rounded,
    'Life Purpose' => Icons.explore_outlined,
    'Personal Growth' => Icons.trending_up_rounded,
    _ => Icons.schedule_outlined,
  };

  void _back() => _pageController.previousPage(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );
  Future<void> _next() async {
    if (_step == 0 && _nameController.text.trim().length < 2) {
      _snack('Please enter your name');
      return;
    }
    if (_step == 5 && _focus.isEmpty) {
      _snack('Choose at least one focus area');
      return;
    }
    if (_step < 8) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      await _save();
    }
  }

  void _snack(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.secondary,
            surface: AppColors.surfaceLight,
          ),
        ),
        child: child!,
      ),
    );
    if (value != null) setState(() => _dob = value);
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.secondary,
            surface: AppColors.surfaceLight,
          ),
        ),
        child: child!,
      ),
    );
    if (value != null) setState(() => _time = value);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final name = ZodiacSignUtils.capitalizeName(_nameController.text.trim());
    final dob =
        '${_dob.year}-${_dob.month.toString().padLeft(2, '0')}-${_dob.day.toString().padLeft(2, '0')}';
    final t = _unknownTime ? const TimeOfDay(hour: 12, minute: 0) : _time;
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final time =
        '${hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
    try {
      AstrologyValidator.validateDate(dob);
      AstrologyValidator.validateTime(time);
    } on AstrologyValidationException catch (e) {
      _snack(e.message);
      setState(() => _saving = false);
      return;
    }
    final demoLocation =
        demoBirthLocations[_placeController.text.trim()] ??
        demoBirthLocations[_city] ??
        demoBirthLocations.values.first;
    final lat = demoLocation.latitude;
    final lon = demoLocation.longitude;
    final weights = <String, double>{for (final area in _focus) area: 1.0};
    await ref
        .read(profilesListProvider.notifier)
        .upsertPrimaryProfile(
          name: name,
          dob: dob,
          birthTime: time,
          birthPlace: _placeController.text,
          latitude: lat,
          longitude: lon,
          timezone: '5.5',
          focusAreas: _focus.toList(),
          gender: _gender,
          birthTimeUnknown: _unknownTime,
        );
    await ref.read(localeProvider.notifier).setLanguage(_language);
    try {
      await ref
          .read(authRepositoryProvider)
          .signInAnonymously()
          .timeout(const Duration(milliseconds: 600));
      await ref
          .read(authRepositoryProvider)
          .saveProfileData(
            name: name,
            dob: dob,
            time: time,
            place: _placeController.text,
            latitude: lat,
            longitude: lon,
            timeZone: '5.5',
            focusWeights: weights,
            gender: _gender,
            astrologyPreference: _system,
          )
          .timeout(const Duration(seconds: 2));
    } catch (_) {}
    ref.invalidate(onboardingCompleteProvider);
    ref.invalidate(profilesListProvider);
    if (mounted) context.go('/');
  }

  String _month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
  String _monthLong(int m) => const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][m - 1];
  (String, String) _zodiacForDate(DateTime d) {
    final md = d.month * 100 + d.day;
    if (md >= 321 && md <= 419) return ('Aries', '♈');
    if (md <= 219 || md >= 1222) return ('Capricorn', '♑');
    if (md <= 320) return ('Pisces', '♓');
    if (md <= 520) return ('Taurus', '♉');
    if (md <= 620) return ('Gemini', '♊');
    if (md <= 722) return ('Cancer', '♋');
    if (md <= 822) return ('Leo', '♌');
    if (md <= 922) return ('Virgo', '♍');
    if (md <= 1022) return ('Libra', '♎');
    if (md <= 1121) return ('Scorpio', '♏');
    return ('Sagittarius', '♐');
  }
}
