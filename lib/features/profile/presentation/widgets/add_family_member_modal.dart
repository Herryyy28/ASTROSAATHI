import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/engine/models/astrology_validation.dart';
import '../../../../core/providers/subscription_provider.dart';

class AddFamilyMemberModal extends ConsumerStatefulWidget {
  const AddFamilyMemberModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFamilyMemberModal(),
    );
  }

  @override
  ConsumerState<AddFamilyMemberModal> createState() => _AddFamilyMemberModalState();
}

class _AddFamilyMemberModalState extends ConsumerState<AddFamilyMemberModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(text: '07:30');
  final TextEditingController _placeController = TextEditingController();

  String _selectedAmPm = 'AM';
  String _selectedCity = 'New Delhi, India';
  String _selectedRelationship = 'Child';

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

  final List<String> _relationships = [
    'Partner',
    'Spouse',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Child',
    'Friend',
    'Other',
  ];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _placeController.text = _selectedCity;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();
    final fullTime = '${_timeController.text.trim()} $_selectedAmPm';
    final place = _placeController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter a name');
      return;
    }
    if (dob.isEmpty) {
      _showError('Please select date of birth');
      return;
    }
    if (_timeController.text.trim().isEmpty) {
      _showError('Please enter time of birth');
      return;
    }
    if (place.isEmpty) {
      _showError('Please enter place of birth');
      return;
    }

    try {
      AstrologyValidator.validateDate(dob);
      AstrologyValidator.validateTime(fullTime);
    } on AstrologyValidationException catch (e) {
      _showError(e.message);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final isPremium = ref.read(subscriptionProvider).isPremium;
      final profile = BirthProfileData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        relationship: _selectedRelationship,
        dob: dob,
        birthTime: fullTime,
        birthPlace: place,
        latitude: 28.6139, // Default fallback
        longitude: 77.2090, // Default fallback
        timezone: '5.5',
        isPrimary: false,
      );

      final success = await ref
          .read(profilesListProvider.notifier)
          .addProfile(profile, isPremium: isPremium);

      if (!success) {
        _showError('Profile limit reached. Please upgrade to VIP.');
      } else {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to save profile. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(top: kToolbarHeight),
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: AppColors.getGlassBorder(context)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceSecondary(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Add Family Member',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add birth details for instant kundlis',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.getTextSecondary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: AppColors.getTextPrimary(context), fontSize: 16),
                  decoration: AppDecorations.premiumInput(
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline_rounded,
                    context: context,
                  ),
                ),
                const SizedBox(height: 14),

                // Relationship
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceSecondary(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRelationship,
                      isExpanded: true,
                      dropdownColor: AppColors.getSurface(context),
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 16,
                      ),
                      items: _relationships.map((rel) {
                        return DropdownMenuItem(value: rel, child: Text(rel));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRelationship = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

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
                  style: TextStyle(
                    color: AppColors.getTextPrimary(context),
                    fontSize: 16,
                  ),
                  decoration: AppDecorations.premiumInput(
                    hintText: 'Date of Birth (YYYY-MM-DD)',
                    prefixIcon: Icons.calendar_today_rounded,
                    context: context,
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
                            final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
                            final minute = time.minute.toString().padLeft(2, '0');
                            final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                            setState(() {
                              _timeController.text = '${hour.toString().padLeft(2, '0')}:$minute';
                              _selectedAmPm = period;
                            });
                          }
                        },
                        style: TextStyle(
                          color: AppColors.getTextPrimary(context),
                          fontSize: 16,
                        ),
                        decoration: AppDecorations.premiumInput(
                          hintText: 'Time (HH:MM)',
                          prefixIcon: Icons.access_time_rounded,
                          context: context,
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
                          color: AppColors.getSurfaceSecondary(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.getGlassBorder(context)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedAmPm,
                            dropdownColor: AppColors.getSurface(context),
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
                    color: AppColors.getSurfaceSecondary(context),
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
                      alignment: Alignment.centerLeft,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                        fontSize: 15,
                        height: 1.2,
                      ),
                      items: _popularCities
                          .map((city) => DropdownMenuItem(
                                value: city,
                                child: Text(
                                  city,
                                  style: TextStyle(
                                    color: city == 'Custom Location'
                                        ? AppColors.primary
                                        : AppColors.getTextPrimary(context),
                                    fontWeight: city == 'Custom Location'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    height: 1.2,
                                  ),
                                ),
                              ))
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
                    style: TextStyle(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 16,
                    ),
                    decoration: AppDecorations.premiumInput(
                      hintText: 'Enter City, Country',
                      prefixIcon: Icons.location_on_outlined,
                      context: context,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                GradientButton(
                  text: 'Save Family Member',
                  icon: Icons.save_rounded,
                  isLoading: _isSaving,
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
