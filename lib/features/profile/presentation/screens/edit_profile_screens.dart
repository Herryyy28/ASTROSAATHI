import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../demo/demo_locations.dart';

class EditPersonalInfoScreen extends ConsumerStatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  ConsumerState<EditPersonalInfoScreen> createState() =>
      _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState
    extends ConsumerState<EditPersonalInfoScreen> {
  late final TextEditingController _nameController;
  late String _gender;
  late String _relationship;
  late AppLanguage _language;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(activeProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _gender = profile.gender;
    _relationship = profile.relationship;
    _language = ref.read(localeProvider);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = ZodiacSignUtils.capitalizeName(_nameController.text.trim());
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your full name to continue.')),
      );
      return;
    }
    setState(() => _saving = true);
    final profile = ref.read(activeProfileProvider);
    await ref
        .read(profilesListProvider.notifier)
        .updateProfile(
          profile.copyWith(
            name: name,
            gender: _gender,
            relationship: _relationship,
          ),
        );
    await ref.read(localeProvider.notifier).setLanguage(_language);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => _ProfileEditScaffold(
    title: 'Personal Information',
    subtitle: 'Keep your identity and language preferences up to date.',
    saving: _saving,
    onSave: _save,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AstroInput(
          controller: _nameController,
          label: 'Full Name',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 22),
        const _FieldLabel('Gender'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Female', 'Male', 'Non-binary', 'Prefer not to say']
              .map(
                (gender) => AstroChip(
                  label: gender,
                  selected: _gender == gender,
                  onTap: () => setState(() => _gender = gender),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        const _FieldLabel('Profile type'),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _relationship,
          decoration: _decoration(Icons.people_outline_rounded),
          items:
              const ['Self', 'Partner', 'Child', 'Parent', 'Family', 'Friend']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
          onChanged: (value) => setState(() => _relationship = value!),
        ),
        const SizedBox(height: 22),
        const _FieldLabel('Preferred language'),
        DropdownButtonFormField<AppLanguage>(
          isExpanded: true,
          initialValue: _language,
          decoration: _decoration(Icons.language_rounded),
          items: AppLanguage.values
              .map(
                (language) => DropdownMenuItem(
                  value: language,
                  child: Text(language.displayLabel),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _language = value!),
        ),
      ],
    ),
  );
}

class EditBirthDetailsScreen extends ConsumerStatefulWidget {
  const EditBirthDetailsScreen({super.key});

  @override
  ConsumerState<EditBirthDetailsScreen> createState() =>
      _EditBirthDetailsScreenState();
}

class _EditBirthDetailsScreenState
    extends ConsumerState<EditBirthDetailsScreen> {
  late DateTime _dob;
  late TimeOfDay _time;
  late bool _unknownTime;
  late String _country;
  late String _stateName;
  late String _city;
  bool _saving = false;

  static final _locations = demoBirthLocations.keys
      .map(_LocationParts.parse)
      .toList();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(activeProfileProvider);
    _dob = DateTime.tryParse(profile.dob) ?? DateTime(1998, 3, 18);
    _time = _parseTime(profile.birthTime);
    _unknownTime = profile.birthTimeUnknown;
    final initial = _locations.firstWhere(
      (item) => item.fullName == profile.birthPlace,
      orElse: () => _locations.first,
    );
    _country = initial.country;
    _stateName = initial.state;
    _city = initial.city;
  }

  Iterable<_LocationParts> get _countryLocations =>
      _locations.where((item) => item.country == _country);

  List<String> get _states =>
      _countryLocations.map((item) => item.state).toSet().toList()..sort();

  List<String> get _cities =>
      _countryLocations
          .where((item) => item.state == _stateName)
          .map((item) => item.city)
          .toSet()
          .toList()
        ..sort();

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (value != null) setState(() => _dob = value);
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(context: context, initialTime: _time);
    if (value != null) setState(() => _time = value);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = ref.read(activeProfileProvider);
    final location = '$_city, $_stateName, $_country';
    final coordinates = demoBirthLocations[location]!;
    final date = DateFormat('yyyy-MM-dd').format(_dob);
    final time = _unknownTime ? '12:00 PM' : _formatTime(_time);
    await ref
        .read(profilesListProvider.notifier)
        .updateProfile(
          profile.copyWith(
            dob: date,
            birthTime: time,
            birthTimeUnknown: _unknownTime,
            birthPlace: location,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: '5.5',
          ),
        );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => _ProfileEditScaffold(
    title: 'Birth Details',
    subtitle:
        'These details refresh your local chart and personalized insights.',
    saving: _saving,
    onSave: _save,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PickerCard(
          label: 'Date of birth',
          value: DateFormat('d MMMM yyyy').format(_dob),
          icon: Icons.cake_outlined,
          onTap: _pickDate,
        ),
        const SizedBox(height: 12),
        _PickerCard(
          label: 'Birth time',
          value: _unknownTime ? 'Exact time unknown' : _formatTime(_time),
          icon: Icons.schedule_rounded,
          onTap: _unknownTime ? null : _pickTime,
        ),
        SwitchListTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: const Text('I don’t know my exact birth time'),
          subtitle: const Text(
            'A neutral noon time will be used for the offline demo.',
          ),
          value: _unknownTime,
          activeTrackColor: AppColors.secondary,
          onChanged: (value) => setState(() => _unknownTime = value),
        ),
        const SizedBox(height: 14),
        const _FieldLabel('Country'),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _country,
          decoration: _decoration(Icons.public_rounded),
          items: _locations
              .map((item) => item.country)
              .toSet()
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _country = value!;
              _stateName = _states.first;
              _city = _cities.first;
            });
          },
        ),
        const SizedBox(height: 14),
        const _FieldLabel('State'),
        DropdownButtonFormField<String>(
          isExpanded: true,
          key: ValueKey('state-$_country-$_stateName'),
          initialValue: _stateName,
          decoration: _decoration(Icons.map_outlined),
          items: _states
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _stateName = value!;
              _city = _cities.first;
            });
          },
        ),
        const SizedBox(height: 14),
        const _FieldLabel('City'),
        DropdownButtonFormField<String>(
          isExpanded: true,
          key: ValueKey('city-$_stateName-$_city'),
          initialValue: _city,
          decoration: _decoration(Icons.location_on_outlined),
          items: _cities
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) => setState(() => _city = value!),
        ),
      ],
    ),
  );
}

class EditFocusAreasScreen extends ConsumerStatefulWidget {
  const EditFocusAreasScreen({super.key});

  @override
  ConsumerState<EditFocusAreasScreen> createState() =>
      _EditFocusAreasScreenState();
}

class _EditFocusAreasScreenState extends ConsumerState<EditFocusAreasScreen> {
  static const areas = <String>[
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

  late final Set<String> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(activeProfileProvider).focusAreas.toSet();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final profile = ref.read(activeProfileProvider);
    await ref
        .read(profilesListProvider.notifier)
        .updateProfile(profile.copyWith(focusAreas: _selected.toList()));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => _ProfileEditScaffold(
    title: 'Focus Areas',
    subtitle: 'Choose the themes that should shape Home, Ask and Calendar.',
    saving: _saving,
    onSave: _save,
    child: Wrap(
      spacing: 10,
      runSpacing: 10,
      children: areas
          .map(
            (area) => AstroChip(
              label: area,
              selected: _selected.contains(area),
              onTap: () => setState(() {
                if (!_selected.add(area)) _selected.remove(area);
              }),
            ),
          )
          .toList(),
    ),
  );
}

class _ProfileEditScaffold extends StatelessWidget {
  const _ProfileEditScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onSave,
    required this.saving,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onSave;
  final bool saving;

  @override
  Widget build(BuildContext context) => AstroScaffold(
    appBar: AstroAppBar(
      title: title,
      onBack: () => Navigator.maybePop(context),
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: AstroPrimaryButton(
        label: 'Save Changes',
        icon: Icons.check_rounded,
        loading: saving,
        onPressed: onSave,
      ),
    ),
    child: ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        AstroPageIntro(
          tag: 'PROFILE SETTINGS',
          title: title,
          subtitle: subtitle,
          icon: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: 22),
        child,
      ],
    ),
  );
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => AstroCard(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondaryLight,
          ),
      ],
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10.5,
        letterSpacing: .8,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary,
      ),
    ),
  );
}

class _LocationParts {
  const _LocationParts(this.city, this.state, this.country);
  final String city;
  final String state;
  final String country;

  String get fullName => '$city, $state, $country';

  factory _LocationParts.parse(String value) {
    final parts = value.split(',').map((part) => part.trim()).toList();
    return _LocationParts(parts[0], parts[1], parts[2]);
  }
}

InputDecoration _decoration(IconData icon) => InputDecoration(
  prefixIcon: Icon(icon, color: AppColors.textSecondaryLight),
  filled: true,
  fillColor: AppColors.surfaceLight,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: AppColors.borderLight),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: AppColors.borderLight),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
  ),
);

TimeOfDay _parseTime(String raw) {
  final normalized = raw.trim().toUpperCase();
  final match = RegExp(
    r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$',
  ).firstMatch(normalized);
  if (match == null) return const TimeOfDay(hour: 12, minute: 0);
  var hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  final period = match.group(3);
  if (period == 'PM' && hour < 12) hour += 12;
  if (period == 'AM' && hour == 12) hour = 0;
  return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
}

String _formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  return '${hour.toString().padLeft(2, '0')}:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
}
