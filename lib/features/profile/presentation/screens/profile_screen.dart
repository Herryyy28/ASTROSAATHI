import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../core/widgets/language_selection_modal.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../reminders/presentation/screens/astro_reminders_screen.dart';
import '../../../reports/presentation/screens/predictions_reports_screen.dart';
import '../../../security/presentation/screens/privacy_dashboard_screen.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';
import '../../../support/presentation/screens/trust_center_screen.dart';
import '../widgets/add_family_member_modal.dart';
import '../widgets/profile_switcher_modal.dart';
import 'edit_profile_screens.dart';
import 'settings/about_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final profiles = ref.watch(profilesListProvider);
    final subscription = ref.watch(subscriptionProvider);
    final language = ref.watch(localeProvider);
    final zodiac = ZodiacSignUtils.getZodiacFromName(profile.name);
    return Material(
      color: AppColors.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            const AstroPrimaryHeader(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 12),
              eyebrow: 'Your cosmic identity',
              title: 'Profile',
              subtitle: 'Birth details, preferences and membership',
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.surfaceLight,
                    child: Text(
                      profile.name.isEmpty
                          ? 'A'
                          : profile.name[0].toUpperCase(),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.name.isEmpty ? 'AstroSaathi' : profile.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${zodiac?.symbol ?? '✦'} ${zodiac?.englishName ?? 'Cosmic'} Sun',
                    style: const TextStyle(color: AppColors.textSecondaryLight),
                  ),
                  if (profile.dob.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${profile.dob} · ${profile.birthTimeUnknown ? 'Time unknown' : profile.birthTime} · ${profile.birthPlace}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            _section('ACCOUNT'),
            AstroCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _row(
                    context,
                    Icons.person_outline_rounded,
                    'Personal Information',
                    '${profile.name} · ${profile.gender} · ${profile.relationship}',
                    () => _openEditor(
                      context,
                      const EditPersonalInfoScreen(),
                      'Personal information updated',
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.cake_outlined,
                    'Birth Details',
                    '${profile.dob} · ${profile.birthTimeUnknown ? 'Time unknown' : profile.birthTime} · ${profile.birthPlace}',
                    () => _openEditor(
                      context,
                      const EditBirthDetailsScreen(),
                      'Birth details updated',
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.people_outline_rounded,
                    'My Profiles',
                    '${profiles.length} profiles',
                    () => ProfileSwitcherModal.show(context),
                    trailingAction: () {
                      if (ref.read(canAddMoreProfilesProvider)) {
                        AddFamilyMemberModal.show(context);
                      } else {
                        PremiumUpgradeModal.show(context);
                      }
                    },
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.auto_awesome_outlined,
                    'Focus Areas',
                    profile.focusAreas.isEmpty
                        ? 'Choose your focus areas'
                        : profile.focusAreas.join(' · '),
                    () => _openEditor(
                      context,
                      const EditFocusAreasScreen(),
                      'Focus areas updated',
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.language_rounded,
                    'Language',
                    language.nativeName,
                    () => LanguageSelectionModal.show(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _section('PLAN'),
            AstroCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _row(
                    context,
                    Icons.workspace_premium_outlined,
                    'Subscription',
                    subscription.tier.displayName,
                    () => PremiumUpgradeModal.show(context),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.chat_bubble_outline_rounded,
                    'Question Credits',
                    subscription.isPremium
                        ? 'Unlimited'
                        : '${(3 - subscription.aiQueriesToday).clamp(0, 3)} remaining',
                    () => PremiumUpgradeModal.show(context),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.description_outlined,
                    'Saved Reports',
                    'Your personal reports',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PredictionsReportsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _section('APP'),
            AstroCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _row(
                    context,
                    Icons.notifications_none_rounded,
                    'Notifications',
                    'Astro reminders & event alerts',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AstroRemindersScreen(),
                      ),
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.shield_outlined,
                    'Privacy',
                    'Data and privacy controls',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyDashboardScreen(),
                      ),
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.help_outline_rounded,
                    'Help',
                    'Trust, support and guidance',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TrustCenterScreen(),
                      ),
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.gavel_outlined,
                    'Terms',
                    'Terms of use and policies',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TrustCenterScreen(),
                      ),
                    ),
                  ),
                  _divider(),
                  _row(
                    context,
                    Icons.info_outline_rounded,
                    'About',
                    'Version 2.0',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    ),
                  ),
                ],
              ),
            ),
            if (subscription.isPremium) ...[
              const SizedBox(height: 14),
              AstroSecondaryButton(
                label: 'Delete account data',
                icon: Icons.delete_outline_rounded,
                onPressed: () => _deleteDialog(context, ref),
              ),
            ],
            const SizedBox(height: 18),
            AstroSecondaryButton(
              label: 'Logout',
              icon: Icons.logout_rounded,
              onPressed: () => _logoutDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: .8,
        color: AppColors.textSecondaryLight,
      ),
    ),
  );

  Future<void> _openEditor(
    BuildContext context,
    Widget screen,
    String successMessage,
  ) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _divider() => const Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
    color: AppColors.softLavender,
  );
  Widget _row(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    VoidCallback? trailingAction,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: trailingAction ?? onTap,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              trailingAction == null
                  ? Icons.chevron_right_rounded
                  : Icons.add_circle_outline_rounded,
              color: AppColors.textSecondaryLight,
              size: 20,
            ),
          ),
        ],
      ),
    ),
  );

  void _logoutDialog(BuildContext context, WidgetRef ref) => showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await ref.read(userSessionProvider.notifier).logout();
            if (context.mounted) context.go('/onboarding');
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
  void _deleteDialog(BuildContext context, WidgetRef ref) => showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete account data?'),
      content: const Text(
        'This removes profiles, preferences and the local subscription state from this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await ref.read(profilesListProvider.notifier).clearAllProfiles();
            await ref.read(subscriptionProvider.notifier).cancelSubscription();
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            if (context.mounted) context.go('/onboarding');
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.errorLight),
          ),
        ),
      ],
    ),
  );
}
