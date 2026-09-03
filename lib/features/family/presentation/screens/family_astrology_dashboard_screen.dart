import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../profile/presentation/widgets/add_family_member_modal.dart';
import '../../../matching/presentation/screens/chart_comparison_screen.dart';
import '../../../../core/widgets/cosmic_notification.dart';

class FamilyAstrologyDashboardScreen extends ConsumerWidget {
  const FamilyAstrologyDashboardScreen({super.key});

  String _getZodiacSign(String dobStr) {
    if (dobStr.isEmpty) return 'Taurus ♉';
    try {
      DateTime? dt;
      if (dobStr.contains('-')) {
        final parts = dobStr.split('-');
        if (parts[0].length == 4) {
          dt = DateTime.tryParse(dobStr);
        } else if (parts.length == 3) {
          final day = int.tryParse(parts[0]) ?? 1;
          final month = int.tryParse(parts[1]) ?? 1;
          final year = int.tryParse(parts[2]) ?? 2000;
          dt = DateTime(year, month, day);
        }
      } else if (dobStr.contains('/')) {
        final parts = dobStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]) ?? 1;
          final month = int.tryParse(parts[1]) ?? 1;
          final year = int.tryParse(parts[2]) ?? 2000;
          dt = DateTime(year, month, day);
        }
      }
      if (dt != null) {
        final day = dt.day;
        final month = dt.month;
        if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries ♈';
        if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus ♉';
        if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini ♊';
        if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer ♋';
        if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo ♌';
        if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo ♍';
        if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra ♎';
        if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return 'Scorpio ♏';
        if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return 'Sagittarius ♐';
        if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return 'Capricorn ♑';
        if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return 'Aquarius ♒';
        if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces ♓';
      }
    } catch (_) {}
    return 'Taurus ♉';
  }

  Map<String, dynamic> _getProfileSynergy(BirthProfileData profile) {
    final hash = (profile.id.hashCode + profile.name.hashCode).abs();
    final score = 7.6 + ((hash % 22) / 10.0);

    final statusOptions = [
      {'status': 'High Synergy Window', 'color': Colors.pinkAccent},
      {'status': 'Study & Focus Peak', 'color': Colors.amberAccent},
      {'status': 'Peaceful Transit Window', 'color': Colors.cyanAccent},
      {'status': 'Major Venture Alignment', 'color': Colors.greenAccent},
      {'status': 'Creative Harmony Peak', 'color': Colors.purpleAccent},
      {'status': 'Harmonious Gochar Window', 'color': Colors.orangeAccent},
    ];

    final opt = statusOptions[hash % statusOptions.length];
    return {
      'score': double.parse(score.toStringAsFixed(1)),
      'status': opt['status'] as String,
      'color': opt['color'] as Color,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final profiles = ref.watch(profilesListProvider);

    // Calculate dynamic family overall synergy score
    double avgSynergy = 8.4;
    if (profiles.isNotEmpty) {
      final total = profiles.fold<double>(
        0.0,
        (sum, p) => sum + (_getProfileSynergy(p)['score'] as double),
      );
      avgSynergy = double.parse((total / profiles.length).toStringAsFixed(1));
    }

    final namesSummary = profiles.isEmpty
        ? 'family member'
        : profiles.take(2).map((p) => p.name.split(' ').first).join(' & ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Family Astrology Dashboard',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'FAMILY',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Family transit insights & compatibility',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section 1: Overview Banner
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: AppColors.primary.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'FAMILY SYNERGY TODAY',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'HIGH SYNERGY ($avgSynergy/10)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profiles.isEmpty
                                ? 'Add profiles for your spouse, children & parents to track live planetary transit synergy.'
                                : 'Moon in Shatabhisha Nakshatra aligns favorably with $namesSummary charts today.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.getTextSecondary(context),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Family Profiles Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FAMILY PROFILES (${profiles.length})',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => AddFamilyMemberModal.show(context),
                          icon: const Icon(Icons.person_add_rounded, size: 14, color: AppColors.primary),
                          label: Text(
                            'Add Profile',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Real User Profiles List
                    if (profiles.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          borderColor: AppColors.primary.withOpacity(0.25),
                          child: Column(
                            children: [
                              const Icon(Icons.group_add_rounded, color: AppColors.primary, size: 40),
                              const SizedBox(height: 12),
                              Text(
                                'No Family Profiles Saved Yet',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add birth details for family members to calculate synergy and run chart comparison.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                ),
                                onPressed: () => AddFamilyMemberModal.show(context),
                                icon: const Icon(Icons.add_rounded, color: Colors.black, size: 18),
                                label: Text(
                                  'Add First Member',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...profiles.map((profile) {
                        final synergy = _getProfileSynergy(profile);
                        final color = synergy['color'] as Color;
                        final statusText = synergy['status'] as String;
                        final zodiac = _getZodiacSign(profile.dob);

                        String titleText = profile.name;
                        if (profile.isPrimary) {
                          titleText += ' (Primary Chart)';
                        } else if (profile.relationship.isNotEmpty) {
                          titleText += ' (${profile.relationship})';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            borderColor: color.withOpacity(0.3),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: color.withOpacity(0.18),
                                  child: Icon(
                                    profile.isPrimary ? Icons.star_rounded : Icons.person_rounded,
                                    color: color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              titleText,
                                              style: GoogleFonts.outfit(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.getTextPrimary(context),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            zodiac,
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              color: AppColors.getTextMuted(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        statusText,
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 18),
                                  tooltip: 'Compare Chart',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ChartComparisonScreen()),
                                    );
                                  },
                                ),
                                if (!profile.isPrimary)
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: AppColors.getTextMuted(context),
                                      size: 18,
                                    ),
                                    onSelected: (val) {
                                      if (val == 'delete') {
                                        ref.read(profilesListProvider.notifier).deleteProfile(profile.id);
                                        CosmicNotification.showSuccess(
                                          context,
                                          title: 'Profile Removed',
                                          message: '${profile.name} was removed from family profiles.',
                                          icon: Icons.person_remove_rounded,
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Remove Profile',
                                              style: GoogleFonts.inter(fontSize: 12, color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),

                    // Add profile option at bottom
                    if (profiles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 24),
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => AddFamilyMemberModal.show(context),
                          icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: AppColors.primary),
                          label: Text(
                            'Add Another Family Profile',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
