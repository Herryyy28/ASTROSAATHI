import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/language_selection_modal.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';
import '../widgets/add_family_member_modal.dart';
import 'settings/notifications_screen.dart';
import 'settings/saved_insights_screen.dart';
import 'settings/data_privacy_screen.dart';
import 'settings/about_screen.dart';
import '../widgets/profile_switcher_modal.dart';
import '../../../reminders/presentation/screens/astro_reminders_screen.dart';

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

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
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
                          _buildPrimaryKundliCard(context, primary.first, l10n, activeProfile, ref)
                              .animate().fadeIn(delay: 100.ms),
                          const SizedBox(height: 24),
                        ],

                        // ── Family Kundlis ────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle(l10n.familyKundlis),
                            if (family.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  if (ref.read(canAddMoreProfilesProvider)) {
                                    AddFamilyMemberModal.show(context);
                                  } else {
                                    PremiumUpgradeModal.show(context);
                                  }
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (family.isEmpty)
                          _buildEmptyFamilyCard(l10n, context, ref)
                              .animate().fadeIn(delay: 200.ms)
                        else
                          ...family.asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildFamilyMemberCard(context, entry.value, activeProfile, ref)
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
                          context,
                          icon: Icons.language_rounded,
                          iconColor: AppColors.tertiary,
                          title: l10n.languageSetting,
                          subtitle: lang.nativeName,
                          onTap: () => LanguageSelectionModal.show(context),
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 8),

                        // Notifications
                        // Appearance / Theme
                        Consumer(
                          builder: (context, ref, _) {
                            final currentThemeMode = ref.watch(themeModeProvider);
                            return _buildSettingsTile(
                              context,
                              icon: currentThemeMode.icon,
                              iconColor: AppColors.primary,
                              title: 'Appearance',
                              subtitle: currentThemeMode.label,
                              onTap: () => _showThemeSelectionModal(context, ref),
                            );
                          },
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 8),

                        _buildSettingsTile(
                          context,
                          icon: Icons.notifications_rounded,
                          iconColor: AppColors.warning,
                          title: l10n.notifications,
                          subtitle: 'Smart Astro Reminders & Event Alerts',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AstroRemindersScreen()),
                          ),
                        ).animate().fadeIn(delay: 360.ms),
                        const SizedBox(height: 8),

                        // Saved Insights
                        _buildSettingsTile(
                          context,
                          icon: Icons.bookmark_rounded,
                          iconColor: AppColors.secondary,
                          title: l10n.savedInsights,
                          subtitle: 'Your saved AI recommendations',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SavedInsightsScreen()),
                          ),
                        ).animate().fadeIn(delay: 420.ms),
                        const SizedBox(height: 8),

                        // Data Privacy
                        _buildSettingsTile(
                          context,
                          icon: Icons.shield_rounded,
                          iconColor: AppColors.success,
                          title: l10n.dataPrivacy,
                          subtitle: 'End-to-end encrypted',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DataPrivacyScreen()),
                          ),
                        ).animate().fadeIn(delay: 480.ms),
                        const SizedBox(height: 8),

                        // About
                        _buildSettingsTile(
                          context,
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.getTextSecondary(context),
                          title: l10n.about,
                          subtitle: 'AstroSaathi v2.0',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AboutScreen()),
                          ),
                        ).animate().fadeIn(delay: 540.ms),

                        // VIP Account Deletion & Reset (Shows when VIP is enabled)
                        if (subState.isPremium) ...[
                          const SizedBox(height: 8),
                          _buildSettingsTile(
                            context,
                            icon: Icons.delete_forever_rounded,
                            iconColor: AppColors.error,
                            title: l10n.deleteAccount,
                            subtitle: 'Erase all profile details & return to entry onboarding',
                            onTap: () => _showDeleteAccountDialog(context, ref),
                          ).animate().fadeIn(delay: 600.ms),
                        ],

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
                        color: AppColors.getTextPrimary(context),
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
                    color: AppColors.getTextSecondary(context),
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

  Widget _buildPrimaryKundliCard(BuildContext context, BirthProfileData profile, AppLocalizations l10n, BirthProfileData activeProfile, WidgetRef ref) {
    final zodiac = profile.name.isNotEmpty
        ? ZodiacSignUtils.getZodiacFromName(profile.name)
        : null;
    final isActive = activeProfile.id == profile.id;

    return GlassCard(
      borderRadius: 20,
      glowColor: isActive ? AppColors.goldGlow : null,
      borderColor: isActive ? AppColors.primary : AppColors.getGlassBorder(context),
      padding: const EdgeInsets.all(20),
      onTap: () {
        final profiles = ref.read(profilesListProvider);
        ref.read(activeProfileIndexProvider.notifier).state = profiles.indexOf(profile);
      },
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
                          color: AppColors.getTextPrimary(context),
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
                    if (isActive) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.success.withOpacity(0.2),
                          border: Border.all(color: AppColors.success.withOpacity(0.4)),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.dob} • ${profile.birthTime}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
                if (profile.birthPlace.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '📍 ${profile.birthPlace}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.getTextMuted(context),
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

  Widget _buildFamilyMemberCard(BuildContext context, BirthProfileData profile, BirthProfileData activeProfile, WidgetRef ref) {
    final zodiac = profile.name.isNotEmpty
        ? ZodiacSignUtils.getZodiacFromName(profile.name)
        : null;
    final isActive = activeProfile.id == profile.id;

    return GlassCard(
      borderRadius: 16,
      borderColor: isActive ? AppColors.primary : AppColors.getGlassBorder(context),
      glowColor: isActive ? AppColors.goldGlow : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () {
        final profiles = ref.read(profilesListProvider);
        ref.read(activeProfileIndexProvider.notifier).state =
            profiles.indexOf(profile);
      },
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getSurfaceSecondary(context),
              border: Border.all(
                color: AppColors.getGlassBorder(context),
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
                  color: AppColors.getTextPrimary(context),
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
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
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
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.success.withOpacity(0.2),
                border: Border.all(color: AppColors.success.withOpacity(0.4)),
              ),
              child: Text(
                'Active',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.getTextMuted(context),
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyFamilyCard(AppLocalizations l10n, BuildContext context, WidgetRef ref) {
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(20),
      onTap: () {
        if (ref.read(canAddMoreProfilesProvider)) {
          AddFamilyMemberModal.show(context);
        } else {
          PremiumUpgradeModal.show(context);
        }
      },
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
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  'Store birth details for instant Kundli',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
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

  Widget _buildSettingsTile(
    BuildContext context, {
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
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.getTextMuted(context),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      borderColor: AppColors.primary.withOpacity(0.5),
      glowColor: AppColors.goldGlow,
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
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Unlimited AI chats, family Kundlis & more',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getDynamicTextSecondary(context),
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
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Delete Account & Reset Data',
                style: GoogleFonts.outfit(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently erase your VIP subscription, saved Kundlis, family profiles, and settings?\n\nYou will be returned to the entry level onboarding screen to fill all your birth details from scratch.',
          style: GoogleFonts.inter(
            color: AppColors.getTextSecondary(context),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.getTextSecondary(context)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);

              // 1. Wipe all profile data
              await ref.read(profilesListProvider.notifier).clearAllProfiles();

              // 2. Cancel VIP Subscription
              await ref.read(subscriptionProvider.notifier).cancelSubscription();

              // 3. Clear SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Account deleted & data cleared. Returning to onboarding...',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
                // 4. Redirect to entry level Onboarding
                context.go('/onboarding');
              }
            },
            child: const Text(
              'Delete & Reset',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeSelectionModal(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.read(themeModeProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : AppColors.surfaceDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: isLight ? Colors.black.withOpacity(0.08) : AppColors.glassBorder,
                width: 0.8,
              ),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isLight ? Colors.black26 : AppColors.textTertiaryDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Appearance Preference',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getDynamicTextPrimary(context),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how AstroSaathi looks on your device',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.getDynamicTextSecondary(context),
                ),
              ),
              const SizedBox(height: 20),
              ...AppThemeMode.values.map((mode) {
                final isSelected = currentThemeMode == mode;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : (isLight
                            ? const Color(0xFFF1F5F9)
                            : AppColors.surfaceHighlightDark.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isLight ? Colors.black.withOpacity(0.08) : AppColors.glassBorder),
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      mode.icon,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.getDynamicTextSecondary(context),
                    ),
                    title: Text(
                      mode.label,
                      style: GoogleFonts.outfit(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: AppColors.getDynamicTextPrimary(context),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  },
    );
  }
}
