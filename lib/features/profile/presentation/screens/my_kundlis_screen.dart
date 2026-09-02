import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/widgets/language_selection_modal.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../features/astrology/services/pdf_report_generator.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/providers/subscription_provider.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';

class MyKundlisScreen extends ConsumerStatefulWidget {
  const MyKundlisScreen({super.key});

  @override
  ConsumerState<MyKundlisScreen> createState() => _MyKundlisScreenState();
}

class _MyKundlisScreenState extends ConsumerState<MyKundlisScreen> {
  final _nameController = TextEditingController();
  final _placeController = TextEditingController(text: 'New Delhi, India');
  final _dobController = TextEditingController();
  final _timeController = TextEditingController(text: '07:30');

  String _selectedAmPm = 'AM';
  String _selectedRelationship = 'Partner';
  String _selectedCity = 'New Delhi, India';
  ZodiacInfo? _modalZodiac;
  bool _isGeneratingPdf = false;

  final List<String> _relationships = [
    'Self',
    'Partner',
    'Spouse',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Child',
    'Friend',
  ];

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

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onModalNameChanged);
  }

  void _onModalNameChanged() {
    final text = _nameController.text;
    if (text.isNotEmpty) {
      final zodiac = ZodiacSignUtils.getZodiacFromName(text);
      if (zodiac != _modalZodiac) {
        setState(() => _modalZodiac = zodiac);
      }
    } else {
      if (_modalZodiac != null) {
        setState(() => _modalZodiac = null);
      }
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onModalNameChanged);
    _nameController.dispose();
    _placeController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showAddProfileModal(BuildContext context) {
    final canAdd = ref.read(canAddMoreProfilesProvider);
    if (!canAdd) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Maximum limit of 5 family profiles reached.',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      return;
    }

    _modalZodiac = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.borderLight
                        : AppColors.primary.withOpacity(0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldGlow.withOpacity(0.2),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Drag Indicator
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 42,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: AppColors.glassBorder,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Header Title Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_add_alt_1_rounded,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add Birth Profile',
                                  style: GoogleFonts.outfit(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimaryDark,
                                  ),
                                ),
                                Text(
                                  'Store family & friends birth details for instant Kundli',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHighlightDark,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 24),

                    // Scrollable Form Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Section 1: Relationship Selector Chips ────
                            Text(
                              'RELATIONSHIP',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _relationships.map((rel) {
                                final isSelected = _selectedRelationship == rel;
                                return ChoiceChip(
                                  selected: isSelected,
                                  showCheckmark: false,
                                  label: Text(rel),
                                  labelStyle: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.black
                                        : AppColors.getTextPrimary(context),
                                  ),
                                  selectedColor: AppColors.getPrimary(context),
                                  backgroundColor: AppColors.getSurfaceSecondary(context),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.getPrimary(context)
                                          : AppColors.getGlassBorder(context),
                                    ),
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setModalState(
                                        () => _selectedRelationship = rel,
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // ── Section 2: Full Name Input ─────────────
                            Text(
                              'FULL NAME',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getPrimary(context),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              style: GoogleFonts.outfit(
                                color: AppColors.getTextPrimary(context),
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (val) {
                                setModalState(() {
                                  _modalZodiac =
                                      ZodiacSignUtils.getZodiacFromName(val);
                                });
                              },
                              decoration: InputDecoration(
                                hintText:
                                    'Enter full name (e.g., Rajesh Sharma)',
                                hintStyle: GoogleFonts.inter(
                                  color: AppColors.getTextMuted(context),
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.person_rounded,
                                  color: AppColors.getPrimary(context),
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: AppColors.getSurfaceSecondary(context),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            // Auto-detected Nam Rashi Card
                            if (_modalZodiac != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.18),
                                      AppColors.surfaceHighlightDark,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.4),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        _modalZodiac!.symbol,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Auto Nam Rashi (Based on Name)',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                          ),
                                          Text(
                                            '${_modalZodiac!.englishName} • ${_modalZodiac!.hindiName}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),

                            // ── Section 3: Date & Time of Birth ──────────
                            Text(
                              'DATE & TIME OF BIRTH',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // Date Picker Field
                                Expanded(
                                  flex: 5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.dark(
                                                    primary: AppColors.primary,
                                                    onPrimary: Colors.black,
                                                    surface:
                                                        AppColors.surfaceDark,
                                                    onSurface: AppColors
                                                        .textPrimaryDark,
                                                  ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (date != null) {
                                        setModalState(() {
                                          _dobController.text =
                                              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceHighlightDark,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_rounded,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _dobController.text.isEmpty
                                                  ? 'Select Date'
                                                  : _dobController.text,
                                              style: GoogleFonts.outfit(
                                                color:
                                                    _dobController.text.isEmpty
                                                    ? AppColors.textTertiaryDark
                                                    : AppColors.textPrimaryDark,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Time Picker Field
                                Expanded(
                                  flex: 4,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: const TimeOfDay(
                                          hour: 7,
                                          minute: 30,
                                        ),
                                      );
                                      if (time != null) {
                                        final hour = time.hourOfPeriod == 0
                                            ? 12
                                            : time.hourOfPeriod;
                                        final minute = time.minute
                                            .toString()
                                            .padLeft(2, '0');
                                        final period =
                                            time.period == DayPeriod.am
                                            ? 'AM'
                                            : 'PM';
                                        setModalState(() {
                                          _timeController.text =
                                              '${hour.toString().padLeft(2, '0')}:$minute';
                                          _selectedAmPm = period;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceHighlightDark,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _timeController.text,
                                              style: GoogleFonts.outfit(
                                                color:
                                                    AppColors.textPrimaryDark,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // AM/PM Segmented Toggle
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceHighlightDark,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.glassBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: ['AM', 'PM'].map((period) {
                                      final isSelected =
                                          _selectedAmPm == period;
                                      return GestureDetector(
                                        onTap: () => setModalState(
                                          () => _selectedAmPm = period,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Text(
                                            period,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.black
                                                  : AppColors.textSecondaryDark,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ── Section 4: Birth Location ───────────────
                            Text(
                              'BIRTH LOCATION',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHighlightDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _popularCities.contains(_selectedCity)
                                      ? _selectedCity
                                      : 'Custom Location',
                                  isExpanded: true,
                                  dropdownColor: AppColors.surfaceDark,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: AppColors.primary,
                                  ),
                                  style: GoogleFonts.outfit(
                                    color: AppColors.textPrimaryDark,
                                    fontSize: 14,
                                  ),
                                  items: _popularCities.map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_city_rounded,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            city,
                                            style: GoogleFonts.outfit(
                                              color: city == 'Custom Location'
                                                  ? AppColors.primary
                                                  : AppColors.textPrimaryDark,
                                              fontWeight:
                                                  city == 'Custom Location'
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setModalState(() {
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
                                style: GoogleFonts.outfit(
                                  color: AppColors.textPrimaryDark,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter City, Country (e.g., Jaipur, India)',
                                  hintStyle: GoogleFonts.inter(
                                    color: AppColors.textTertiaryDark,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.pin_drop_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceHighlightDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppColors.glassBorder,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 28),

                            // ── Save CTA Button ─────────────────────────
                            Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppColors.goldGlowShadow,
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  final name = ZodiacSignUtils.capitalizeName(
                                    _nameController.text.trim(),
                                  );
                                  if (name.isNotEmpty &&
                                      _dobController.text.isNotEmpty &&
                                      _timeController.text.isNotEmpty) {
                                    final place = _placeController.text.trim();
                                    double lat = 28.6139;
                                    double lon = 77.2090;
                                    try {
                                      if (place.isNotEmpty && (Platform.isAndroid || Platform.isIOS)) {
                                        final locations =
                                            await locationFromAddress(place).timeout(const Duration(seconds: 2));
                                        if (locations.isNotEmpty) {
                                          lat = locations.first.latitude;
                                          lon = locations.first.longitude;
                                        }
                                      }
                                    } catch (e) {
                                      debugPrint(
                                        'Geocoding failed for $place: $e',
                                      );
                                    }

                                    final isPrem = ref.read(isPremiumProvider);
                                    final success = await ref
                                        .read(profilesListProvider.notifier)
                                        .addProfile(
                                          BirthProfileData(
                                            id: 'p-${DateTime.now().millisecondsSinceEpoch}',
                                            name: name,
                                            relationship: _selectedRelationship,
                                            dob: _dobController.text,
                                            birthTime:
                                                '${_timeController.text} $_selectedAmPm',
                                            birthPlace: place,
                                            latitude: lat,
                                            longitude: lon,
                                            timezone: '5.5',
                                          ),
                                          isPremium: isPrem,
                                        );

                                    if (!success && context.mounted) {
                                      Navigator.pop(context);
                                      PremiumUpgradeModal.show(context);
                                    } else {
                                      _nameController.clear();
                                      _dobController.clear();
                                      _timeController.clear();
                                      if (context.mounted)
                                        Navigator.pop(context);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please fill all required birth details.',
                                          style: GoogleFonts.outfit(),
                                        ),
                                        backgroundColor: AppColors.warning,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 20,
                                ),
                                label: Text(
                                  'Save Birth Profile',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handlePdfExport(BirthProfileData profile) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final currentLang = ref.read(localeProvider);
      await PdfReportGenerator.downloadAndPrintPdf(
        userName: profile.name,
        dob: profile.dob,
        birthTime: profile.birthTime,
        birthPlace: profile.birthPlace,
        language: currentLang,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kundli PDF generated for ${profile.name}'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final profiles = ref.watch(profilesListProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final canAdd = ref.watch(canAddMoreProfilesProvider);
    final capacityText = ref.watch(profileCapacityTextProvider);

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: ResponsiveLayout(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header & Capacity Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.goldGradient,
                              ),
                              child: const Icon(
                                Icons.contacts_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Kundli Profiles',
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(context),
                                      height: 1.35,
                                    ),
                                  ),
                                  Text(
                                    'Up to 5 Family & Partner Kundlis ($capacityText)',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.getTextSecondary(context),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: canAdd
                            ? () => _showAddProfileModal(context)
                            : null,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: canAdd
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.surfaceHighlightDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: canAdd
                                  ? AppColors.primary
                                  : AppColors.glassBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: canAdd
                                ? AppColors.primary
                                : AppColors.textTertiaryDark,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Capacity Bar Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isLight
                          ? AppColors.surfaceLight
                          : AppColors.surfaceDark.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.getGlassBorder(context)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.family_restroom_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Family Slots Usage',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                  Text(
                                    capacityText,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value:
                                      profiles.length /
                                      ProfilesNotifier.maxProfiles,
                                  backgroundColor: isLight
                                      ? AppColors.surfaceSecondaryLight
                                      : AppColors.surfaceHighlightDark,
                                  color:
                                      profiles.length >=
                                          ProfilesNotifier.maxProfiles
                                      ? AppColors.warning
                                      : AppColors.primary,
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Active Profile Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldSubtleGradient,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.goldGradient,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '✦',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Active Kundli Profile',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors.getTextSecondary(context),
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        activeProfile.name,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          height: 1.35,
                                        ),
                                      ),
                                      Text(
                                        '${activeProfile.birthPlace} • ${activeProfile.dob} (${activeProfile.birthTime})',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.getTextSecondary(context),
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Consumer(
                                    builder: (context, ref, _) => Text(
                                      AppLocalizations.of(context, ref).active,
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: _isGeneratingPdf
                                      ? null
                                      : () => _handlePdfExport(activeProfile),
                                  icon: _isGeneratingPdf
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.picture_as_pdf_rounded,
                                          size: 16,
                                        ),
                                  label: Consumer(
                                    builder: (context, ref, _) => Text(
                                      AppLocalizations.of(
                                        context,
                                        ref,
                                      ).generatePdfReport,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fade().slideY(begin: 0.1),
                  const SizedBox(height: 24),

                  // Saved Profiles List
                  Consumer(
                    builder: (context, ref, _) => Text(
                      AppLocalizations.of(context, ref).myFamily,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...profiles.map((p) {
                    final isCurrent = p.id == activeProfile.id;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primary.withOpacity(0.12)
                            : (isLight
                                ? AppColors.surfaceLight
                                : AppColors.surfaceHighlightDark.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.getGlassBorder(context),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.check_circle_rounded
                                : Icons.account_circle_outlined,
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.getTextMuted(context),
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? AppColors.primary
                                        : AppColors.getTextPrimary(context),
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${p.relationship} • ${p.birthPlace}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.getTextSecondary(context),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _handlePdfExport(p),
                                icon: const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                tooltip: 'Download PDF',
                              ),
                              if (!isCurrent) ...[
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(profilesListProvider.notifier)
                                        .setPrimary(p.id);
                                    ref.invalidate(dailyGamePlanProvider);
                                    ref.invalidate(birthChartProvider);
                                  },
                                  child: const Text(
                                    'Switch',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    ref
                                        .read(profilesListProvider.notifier)
                                        .deleteProfile(p.id);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Settings & Language Selector
                  Consumer(
                    builder: (context, ref, _) {
                      final currentLang = ref.watch(localeProvider);
                      final l10n = AppLocalizations.of(context, ref);
                      final subState = ref.watch(subscriptionProvider);
                      final isPremium = subState.isPremium;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isLight
                              ? AppColors.surfaceLight
                              : AppColors.surfaceDark.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.getGlassBorder(context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.08),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.profileSettings,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // VIP membership card
                            GestureDetector(
                              onTap: () => PremiumUpgradeModal.show(context),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: isPremium
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF2C220E),
                                            Color(0xFF1F1706),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            Color(0xFF15181F),
                                            Color(0xFF0F1116),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isPremium
                                        ? const Color(0xFFFFD700)
                                        : AppColors.glassBorder,
                                    width: isPremium ? 1.5 : 1.0,
                                  ),
                                  boxShadow: isPremium
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFFD700,
                                            ).withOpacity(0.12),
                                            blurRadius: 12,
                                            spreadRadius: -2,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(
                                          0xFFFFD700,
                                        ).withOpacity(0.12),
                                      ),
                                      child: const Text(
                                        '👑',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isPremium
                                                ? 'VIP Active - ${subState.tier.displayName}'
                                                : 'AstroSaathi VIP / Pro',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isPremium
                                                  ? const Color(0xFFFFD700)
                                                  : Colors.white,
                                              height: 1.35,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Builder(
                                            builder: (context) {
                                              if (isPremium) {
                                                final daysLeft = ref
                                                    .watch(
                                                      subscriptionProvider
                                                          .notifier,
                                                    )
                                                    .remainingDaysOfSubscription;
                                                final daysText = daysLeft == 0
                                                    ? 'Expires today!'
                                                    : '$daysLeft days left';
                                                return Text(
                                                  'Premium active • $daysText',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color: const Color(
                                                      0xFFFFD700,
                                                    ).withOpacity(0.9),
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.35,
                                                  ),
                                                );
                                              }
                                              return Text(
                                                'Ad-Free • Unlimited AI Chat • 25+ Page PDF',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: Colors.white70,
                                                  height: 1.35,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: isPremium
                                          ? const Color(0xFFFFD700)
                                          : AppColors.textSecondaryDark,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () => LanguageSelectionModal.show(context),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceHighlightDark,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      currentLang.flagEmoji,
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.languageSetting,
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimaryDark,
                                              height: 1.35,
                                            ),
                                          ),
                                          Text(
                                            '${currentLang.nativeName} (${currentLang.englishName})',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
