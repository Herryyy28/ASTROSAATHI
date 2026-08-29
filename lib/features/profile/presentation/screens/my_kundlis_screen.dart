import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/widgets/language_selection_modal.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_language.dart';
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
  final _timeController = TextEditingController();
  String _selectedRelationship = 'Partner';

  final List<String> _relationships = ['Partner', 'Mother', 'Father', 'Brother', 'Sister', 'Child', 'Friend'];

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showAddProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                      const Text(
                        'Add New Birth Profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textPrimaryDark),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                      filled: true,
                      fillColor: AppColors.surfaceHighlightDark,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedRelationship,
                    dropdownColor: AppColors.surfaceDark,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Relationship',
                      labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                      filled: true,
                      fillColor: AppColors.surfaceHighlightDark,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    items: _relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRelationship = val);
                    },
                  ),
                  const SizedBox(height: 12),
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
                        _dobController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
                  TextField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 12, minute: 0),
                      );
                      if (time != null) {
                        if (!context.mounted) return;
                        _timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    style: const TextStyle(color: AppColors.textPrimaryDark),
                    decoration: InputDecoration(
                      labelText: 'Time of Birth (HH:MM)',
                      labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                      filled: true,
                      fillColor: AppColors.surfaceHighlightDark,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        if (_nameController.text.trim().isNotEmpty && 
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
                          
                          ref.read(profilesListProvider.notifier).addProfile(
                                BirthProfileData(
                                  id: 'p-${DateTime.now().millisecondsSinceEpoch}',
                                  name: _nameController.text.trim(),
                                  relationship: _selectedRelationship,
                                  dob: _dobController.text,
                                  birthTime: _timeController.text,
                                  birthPlace: place,
                                  latitude: lat,
                                  longitude: lon,
                                  timezone: '5.5',
                                ),
                              );
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
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesListProvider);
    final activeProfile = ref.watch(activeProfileProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Kundli Profiles',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                            ),
                            Text(
                              'Manage saved family & partner birth charts',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _showAddProfileModal(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Active Profile Highlight Card
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
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldGradient,
                            ),
                            child: const Center(child: Text('✦', style: TextStyle(fontSize: 24, color: Colors.black))),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Active Kundli Profile', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                                const SizedBox(height: 2),
                                Text(
                                  activeProfile.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                                Text(
                                  '${activeProfile.birthPlace} • ${activeProfile.dob}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
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
                            child: const Text('Active', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Saved Profiles List
                const Text(
                  'Saved Family & Partner Kundlis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
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
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? AppColors.primary : AppColors.textPrimaryDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.relationship} • ${p.birthPlace}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                              ),
                            ],
                          ),
                        ),
                        if (!isCurrent)
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  ref.read(profilesListProvider.notifier).setPrimary(p.id);
                                },
                                child: const Text('Switch', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  ref.read(profilesListProvider.notifier).deleteProfile(p.id);
                                },
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // App Settings & Language Selection
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                                        ),
                                        Text(
                                          '${currentLang.nativeName} (${currentLang.englishName})',
                                          style: const TextStyle(fontSize: 12, color: AppColors.primary),
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
    );
  }
}
