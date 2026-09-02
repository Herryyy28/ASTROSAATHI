import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ProfileSwitcherModal extends ConsumerWidget {
  const ProfileSwitcherModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ProfileSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesListProvider);
    final activeProfile = ref.watch(activeProfileProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.getGlassBorder(context), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.getTextMuted(context).withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Switch Active Profile',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Text(
            'Select a profile to update charts, insights & calculations across the app.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 20),

          // Profiles List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: profiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final isActive = activeProfile.id == profile.id;
                final isPrimary = profile.isPrimary;

                return GlassCard(
                  borderRadius: 16,
                  borderColor: isActive ? AppColors.primary : AppColors.getGlassBorder(context),
                  glowColor: isActive ? AppColors.goldGlow : null,
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    ref.read(activeProfileIndexProvider.notifier).state = index;
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isActive ? AppColors.goldGradient : null,
                          color: isActive ? null : AppColors.getSurfaceSecondary(context),
                          border: Border.all(
                            color: isActive ? AppColors.primary : AppColors.getGlassBorder(context),
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '✦',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isActive ? Colors.black : AppColors.getTextPrimary(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    profile.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (isPrimary)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      'Primary',
                                      style: GoogleFonts.outfit(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.relationship} • ${profile.dob}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Active Checkmark or Set Primary Button
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_rounded, size: 14, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                'Active',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_rounded, color: AppColors.getTextMuted(context)),
                          onSelected: (val) {
                            if (val == 'select') {
                              ref.read(activeProfileIndexProvider.notifier).state = index;
                              Navigator.pop(context);
                            } else if (val == 'set_primary') {
                              ref.read(profilesListProvider.notifier).setPrimary(profile.id);
                              ref.read(activeProfileIndexProvider.notifier).state = index;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'select',
                              child: Text('Switch to this Profile'),
                            ),
                            if (!isPrimary)
                              const PopupMenuItem(
                                value: 'set_primary',
                                child: Text('Set as Primary Account'),
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
