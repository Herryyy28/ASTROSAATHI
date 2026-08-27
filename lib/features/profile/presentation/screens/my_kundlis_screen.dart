import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/providers/profile_provider.dart';

class MyKundlisScreen extends ConsumerStatefulWidget {
  const MyKundlisScreen({super.key});

  @override
  ConsumerState<MyKundlisScreen> createState() => _MyKundlisScreenState();
}

class _MyKundlisScreenState extends ConsumerState<MyKundlisScreen> {
  final _nameController = TextEditingController();
  final _placeController = TextEditingController(text: 'New Delhi, India');
  String _selectedRelationship = 'Partner';

  final List<String> _relationships = ['Partner', 'Mother', 'Father', 'Brother', 'Sister', 'Child', 'Friend'];

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
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
                    onPressed: () {
                      if (_nameController.text.trim().isNotEmpty) {
                        ref.read(profilesListProvider.notifier).addProfile(
                              BirthProfileData(
                                id: 'p-${DateTime.now().millisecondsSinceEpoch}',
                                name: _nameController.text.trim(),
                                relationship: _selectedRelationship,
                                dob: '1995-10-10',
                                birthTime: '10:00',
                                birthPlace: _placeController.text.trim(),
                                latitude: 28.6139,
                                longitude: 77.2090,
                                timezone: '5.5',
                              ),
                            );
                        _nameController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Birth Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
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
                Container(
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
                          TextButton(
                            onPressed: () {
                              ref.read(profilesListProvider.notifier).setPrimary(p.id);
                            },
                            child: const Text('Switch', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
