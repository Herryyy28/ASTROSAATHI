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
        const SnackBar(
          content: Text('Maximum limit of 5 family profiles reached.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
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
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Add Birth Profile (Up to 5)',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Name Field with Auto-Capitalization
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(color: AppColors.textPrimaryDark),
                        onChanged: (val) {
                          setModalState(() {
                            _modalZodiac = ZodiacSignUtils.getZodiacFromName(val);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                          filled: true,
                          fillColor: AppColors.surfaceHighlightDark,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      if (_modalZodiac != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Text(_modalZodiac!.symbol, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Auto Nam Rashi: ${_modalZodiac!.englishName} (${_modalZodiac!.hindiName})',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Relationship Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedRelationship,
                        dropdownColor: AppColors.surfaceDark,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, height: 1.2),
                        decoration: InputDecoration(
                          labelText: 'Relationship',
                          labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                          filled: true,
                          fillColor: AppColors.surfaceHighlightDark,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        items: _relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => _selectedRelationship = val);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Date of Birth
                      TextField(
                        controller: _dobController,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setModalState(() {
                              _dobController.text =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        style: const TextStyle(color: AppColors.textPrimaryDark),
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (YYYY-MM-DD)',
                          labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                          filled: true,
                          fillColor: AppColors.surfaceHighlightDark,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Time of Birth with AM/PM
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
                                  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
                                  final minute = time.minute.toString().padLeft(2, '0');
                                  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                                  setModalState(() {
                                    _timeController.text = '${hour.toString().padLeft(2, '0')}:$minute';
                                    _selectedAmPm = period;
                                  });
                                }
                              },
                              style: const TextStyle(color: AppColors.textPrimaryDark),
                              decoration: InputDecoration(
                                labelText: 'Birth Time (HH:MM)',
                                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                                filled: true,
                                fillColor: AppColors.surfaceHighlightDark,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 54,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHighlightDark,
                                borderRadius: BorderRadius.circular(16),
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
                                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => _selectedAmPm = val);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // City Dropdown
                      Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHighlightDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _popularCities.contains(_selectedCity) ? _selectedCity : 'Custom Location',
                            isExpanded: true,
                            dropdownColor: AppColors.surfaceDark,
                            alignment: Alignment.centerLeft,
                            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, height: 1.2),
                            items: _popularCities
                                .map((city) => DropdownMenuItem(
                                      value: city,
                                      child: Text(
                                        city,
                                        style: TextStyle(
                                          color: city == 'Custom Location' ? AppColors.primary : AppColors.textPrimaryDark,
                                          fontWeight: city == 'Custom Location' ? FontWeight.bold : FontWeight.normal,
                                          height: 1.2,
                                        ),
                                      ),
                                    ))
                                .toList(),
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
                          style: const TextStyle(color: AppColors.textPrimaryDark),
                          decoration: InputDecoration(
                            labelText: 'Birth Location',
                            labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                            filled: true,
                            fillColor: AppColors.surfaceHighlightDark,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () async {
                            final name = ZodiacSignUtils.capitalizeName(_nameController.text.trim());
                            if (name.isNotEmpty &&
                                _dobController.text.isNotEmpty &&
                                _timeController.text.isNotEmpty) {
                              final place = _placeController.text.trim();
                              double lat = 28.6139;
                              double lon = 77.2090;
                              try {
                                final locations = await locationFromAddress(place);
                                if (locations.isNotEmpty) {
                                  lat = locations.first.latitude;
                                  lon = locations.first.longitude;
                                }
                              } catch (e) {
                                debugPrint('Geocoding failed for $place: $e');
                              }

                              final success = await ref.read(profilesListProvider.notifier).addProfile(
                                    BirthProfileData(
                                      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
                                      name: name,
                                      relationship: _selectedRelationship,
                                      dob: _dobController.text,
                                      birthTime: '${_timeController.text} $_selectedAmPm',
                                      birthPlace: place,
                                      latitude: lat,
                                      longitude: lon,
                                      timezone: '5.5',
                                    ),
                                  );

                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cannot add more than 5 family member profiles.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }

                              _nameController.clear();
                              _dobController.clear();
                              _timeController.clear();
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          child: const Text('Save Birth Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
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
    final profiles = ref.watch(profilesListProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final canAdd = ref.watch(canAddMoreProfilesProvider);
    final capacityText = ref.watch(profileCapacityTextProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
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
                            child: const Icon(Icons.contacts_rounded, color: Colors.black, size: 20),
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
                                    color: AppColors.textPrimaryDark,
                                    height: 1.35,
                                  ),
                                ),
                                Text(
                                  'Up to 5 Family & Partner Kundlis ($capacityText)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryDark,
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
                      onPressed: canAdd ? () => _showAddProfileModal(context) : null,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: canAdd
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.surfaceHighlightDark,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: canAdd ? AppColors.primary : AppColors.glassBorder,
                          ),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: canAdd ? AppColors.primary : AppColors.textTertiaryDark,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Capacity Bar Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.family_restroom_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Family Slots Usage',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimaryDark,
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
                                value: profiles.length / ProfilesNotifier.maxProfiles,
                                backgroundColor: AppColors.surfaceHighlightDark,
                                color: profiles.length >= ProfilesNotifier.maxProfiles
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
                        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
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
                                child: const Center(child: Text('✦', style: TextStyle(fontSize: 24, color: Colors.black))),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Active Kundli Profile',
                                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondaryDark, height: 1.35),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      activeProfile.name,
                                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.35),
                                    ),
                                    Text(
                                      '${activeProfile.birthPlace} • ${activeProfile.dob} (${activeProfile.birthTime})',
                                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark, height: 1.35),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Consumer(
                                  builder: (context, ref, _) => Text(
                                    AppLocalizations.of(context, ref).active,
                                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
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
                                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                onPressed: _isGeneratingPdf ? null : () => _handlePdfExport(activeProfile),
                                icon: _isGeneratingPdf
                                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                                    : const Icon(Icons.picture_as_pdf_rounded, size: 16),
                                label: Consumer(
                                  builder: (context, ref, _) => Text(
                                    AppLocalizations.of(context, ref).generatePdfReport,
                                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, height: 1.2),
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
                      color: AppColors.textPrimaryDark,
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
                      color: isCurrent ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceHighlightDark.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCurrent ? AppColors.primary.withOpacity(0.5) : AppColors.glassBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCurrent ? Icons.check_circle_rounded : Icons.account_circle_outlined,
                          color: isCurrent ? AppColors.primary : AppColors.textTertiaryDark,
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
                                  color: isCurrent ? AppColors.primary : AppColors.textPrimaryDark,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.relationship} • ${p.birthPlace}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _handlePdfExport(p),
                              icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary, size: 20),
                              tooltip: 'Download PDF',
                            ),
                            if (!isCurrent) ...[
                              TextButton(
                                onPressed: () async {
                                  await ref.read(profilesListProvider.notifier).setPrimary(p.id);
                                  ref.invalidate(dailyGamePlanProvider);
                                  ref.invalidate(birthChartProvider);
                                },
                                child: const Text('Switch', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  ref.read(profilesListProvider.notifier).deleteProfile(p.id);
                                },
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
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

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 16),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileSettings,
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary, height: 1.35),
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => LanguageSelectionModal.show(context),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHighlightDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.glassBorder),
                              ),
                              child: Row(
                                children: [
                                  Text(currentLang.flagEmoji, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.languageSetting,
                                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark, height: 1.35),
                                        ),
                                        Text(
                                          '${currentLang.nativeName} (${currentLang.englishName})',
                                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, height: 1.35),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
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



