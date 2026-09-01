import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/language_selection_modal.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context, ref);
    final profiles = ref.watch(profilesListProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final subState = ref.watch(subscriptionProvider);
    final lang = ref.watch(localeProvider);

    final primary = profiles.where((p) => p.isPrimary).toList();
    final family = profiles.where((p) => !p.isPrimary).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Profile Header ────────────────────────
                        _buildProfileHeader(context, activeProfile, subState)
                            .animate().fadeIn(duration: 400.ms),
                        const SizedBox(height: 24),

                        // ── Primary Kundli Card ───────────────────
                        if (primary.isNotEmpty) ...[
                          _buildSectionTitle(l10n.myProfile),
                          const SizedBox(height: 10),
                          _buildPrimaryKundliCard(primary.first, l10n)
                              .animate().fadeIn(delay: 100.ms),
                          const SizedBox(height: 24),
                        ],

                        // ── Family Kundlis ────────────────────────
                        _buildSectionTitle(l10n.familyKundlis),
                        const SizedBox(height: 10),
                        if (family.isEmpty)
                          _buildEmptyFamilyCard(l10n)
                              .animate().fadeIn(delay: 200.ms)
                        else
                          ...family.asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildFamilyMemberCard(entry.value, ref)
                                  .animate()
                                  .fadeIn(delay: Duration(milliseconds: 200 + entry.key * 80)),
                            );
                          }),
                        const SizedBox(height: 24),

                        // ── Settings Section ──────────────────────
                        _buildSectionTitle(l10n.navSettings),
                        const SizedBox(height: 10),

                        // Language
                        _buildSettingsTile(
                          icon: Icons.language_rounded,
                          iconColor: AppColors.tertiary,
                          title: l10n.languageSetting,
                          subtitle: lang.nativeName,
                          onTap: () => LanguageSelectionModal.show(context),
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 8),

                        // Notifications
                        _buildSettingsTile(
                          icon: Icons.notifications_rounded,
                          iconColor: AppColors.warning,
                          title: l10n.notifications,
                          subtitle: 'Daily cosmic plan alerts',
                          onTap: () {},
                        ).animate().fadeIn(delay: 360.ms),
                        const SizedBox(height: 8),

                        // Saved Insights
                        _buildSettingsTile(
                          icon: Icons.bookmark_rounded,
                          iconColor: AppColors.secondary,
                          title: l10n.savedInsights,
                          subtitle: 'Your saved AI recommendations',
                          onTap: () {},
                        ).animate().fadeIn(delay: 420.ms),
                        const SizedBox(height: 8),

                        // Data Privacy
                        _buildSettingsTile(
                          icon: Icons.shield_rounded,
                          iconColor: AppColors.success,
                          title: l10n.dataPrivacy,
                          subtitle: 'End-to-end encrypted',
                          onTap: () {},
                        ).animate().fadeIn(delay: 480.ms),
                        const SizedBox(height: 8),

                        // About
                        _buildSettingsTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.textSecondaryDark,
                          title: l10n.about,
                          subtitle: 'AstroSaathi v2.0',
                          onTap: () {},
                        ).animate().fadeIn(delay: 540.ms),

                        // VIP Upgrade
                        if (!subState.isPremium) ...[
                          const SizedBox(height: 24),
                          _buildUpgradeBanner(context).animate().fadeIn(delay: 600.ms),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    BirthProfileData profile,
    dynamic subState,
  ) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.goldGradient,
            boxShadow: AppColors.goldGlowShadow,
          ),
          child: Center(
            child: Text(
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '✦',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      profile.name.isNotEmpty ? profile.name : 'Your Profile',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (subState.isPremium) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: AppColors.goldGradient,
                      ),
                      child: Text(
                        '👑 VIP',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (profile.dob.isNotEmpty)
                Text(
                  '${profile.birthPlace.isNotEmpty ? profile.birthPlace : ''} • ${profile.dob}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPrimaryKundliCard(BirthProfileData profile, AppLocalizations l10n) {
    final zodiac = profile.name.isNotEmpty
        ? ZodiacSignUtils.getZodiacFromName(profile.name)
        : null;

    return GlassCard(
      borderRadius: 20,
      glowColor: AppColors.goldGlow,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldSubtleGradient,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
            child: Center(
              child: Text(
                zodiac?.symbol ?? '✦',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary.withOpacity(0.15),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        l10n.primaryProfile,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.dob} • ${profile.birthTime}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                if (profile.birthPlace.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '📍 ${profile.birthPlace}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textTertiaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (zodiac != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${zodiac.englishName} • ${zodiac.hindiName}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(BirthProfileData profile, WidgetRef ref) {
    final zodiac = profile.name.isNotEmpty
        ? ZodiacSignUtils.getZodiacFromName(profile.name)
        : null;

    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () {
        ref.read(activeProfileIndexProvider.notifier).state =
            ref.read(profilesListProvider).indexOf(profile);
      },
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHighlightDark,
              border: Border.all(
                color: AppColors.glassBorder,
              ),
            ),
            child: Center(
              child: Text(
                zodiac?.symbol ?? (profile.name.isNotEmpty
                    ? profile.name[0].toUpperCase()
                    : '?'),
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  '${profile.relationship} • ${profile.dob}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiaryDark,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFamilyCard(AppLocalizations l10n) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.12),
            ),
            child: const Icon(
              Icons.group_add_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.addFamilyMember,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'Store birth details for instant Kundli',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiaryDark,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      borderColor: const Color(0xFFFFD700).withOpacity(0.5),
      glowColor: const Color(0xFFFFD700).withOpacity(0.15),
      padding: const EdgeInsets.all(20),
      onTap: () => PremiumUpgradeModal.show(context),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
            ),
            child: const Center(
              child: Text('👑', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to VIP',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Unlimited AI chats, family Kundlis & more',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFFFFD700),
            size: 16,
          ),
        ],
      ),
    );
  }
}
