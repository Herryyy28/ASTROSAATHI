import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

/// Local-first trust, privacy, and support information for the demo build.
class TrustCenterScreen extends ConsumerStatefulWidget {
  const TrustCenterScreen({super.key});

  @override
  ConsumerState<TrustCenterScreen> createState() => _TrustCenterScreenState();
}

class _TrustCenterScreenState extends ConsumerState<TrustCenterScreen> {
  static const _tabs = <_TrustTabData>[
    _TrustTabData('How It Works', Icons.auto_awesome_outlined),
    _TrustTabData('Privacy & Safety', Icons.shield_outlined),
    _TrustTabData('Account Deletion', Icons.delete_outline_rounded),
    _TrustTabData('Help & Support', Icons.help_outline_rounded),
  ];

  static const _reportCategories = <_IssueCategory>[
    _IssueCategory('Rashi Calculation', Icons.brightness_5_outlined),
    _IssueCategory('Kundli', Icons.grid_view_rounded),
    _IssueCategory('Calendar', Icons.calendar_month_outlined),
    _IssueCategory('Numerology', Icons.pin_outlined),
    _IssueCategory('Synastry', Icons.favorite_border_rounded),
    _IssueCategory('Horoscope', Icons.auto_awesome_outlined),
    _IssueCategory('Profile', Icons.person_outline_rounded),
    _IssueCategory('UI / App Bug', Icons.bug_report_outlined),
    _IssueCategory('Other', Icons.more_horiz_rounded),
  ];

  static const _faqs = <_FaqData>[
    _FaqData(
      'How does AstroSaathi personalize my experience?',
      'The demo uses the profile, birth details, selected focus areas, and local app state saved on this device to shape the screens and guidance you see.',
    ),
    _FaqData(
      'Is my birth information stored online?',
      'No. This frontend-only build keeps profile information in local app preferences on this device. It does not sync your birth details to an AstroSaathi server.',
    ),
    _FaqData(
      'Can I change my birth details?',
      'Yes. Open Profile, then Birth Details. The dedicated editor updates the locally saved profile without reopening onboarding.',
    ),
    _FaqData(
      'Why does birth time matter?',
      'Birth time influences time-sensitive astrology concepts such as the Ascendant and house placements. If the time is uncertain, treat precision-sensitive details as approximate.',
    ),
    _FaqData(
      'How are daily insights generated?',
      'Daily insights in this demo come from the app’s deterministic local demo engine and your saved profile context. They are not fetched from a live astrologer or remote AI service.',
    ),
    _FaqData(
      'Can I use AstroSaathi without internet?',
      'The core demo experience is designed to work locally. System actions outside the app, such as sharing a prepared report, depend on apps available on your device.',
    ),
    _FaqData(
      'How do I reset my local data?',
      'Open the Account Deletion tab and choose Clear Local App Data. Review the confirmation carefully because the local reset cannot be undone.',
    ),
    _FaqData(
      'Why are some astronomy details unavailable?',
      'Some exact angles, event timings, and ephemeris-level values require astronomy data that is not included in this frontend-only demo. AstroSaathi shows an unavailable state rather than inventing a value.',
    ),
  ];

  final _reportController = TextEditingController();
  final _emailController = TextEditingController();
  int _selectedTab = 0;
  int? _expandedFaqIndex;
  String? _selectedReportCategory;

  @override
  void dispose() {
    _reportController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryNavigation(),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 210),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, .015),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_selectedTab),
                  child: switch (_selectedTab) {
                    0 => _buildHowItWorksTab(),
                    1 => _buildPrivacyTab(),
                    2 => _buildDeletionTab(),
                    _ => _buildHelpTab(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.softLavender,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primaryLightMode,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trust & Help Center',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimaryLight,
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Safety, privacy & support',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryLight,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: -.04, end: 0);
  }

  Widget _buildCategoryNavigation() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final selected = _selectedTab == index;
          return Semantics(
            button: true,
            selected: selected,
            label: '${tab.label} tab',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedTab = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryLightMode
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryLightMode
                          : AppColors.softLavender,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryLightMode.withValues(
                                alpha: .12,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 17,
                        color: selected
                            ? AppColors.surfaceLight
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        tab.label,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          color: selected
                              ? AppColors.surfaceLight
                              : AppColors.textSecondaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabList(List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: children,
    );
  }

  Widget _buildHowItWorksTab() {
    return _tabList([
      _TrustHero(
        title: 'Trusted Astrology Foundation',
        subtitle:
            'Local deterministic astrology calculations shaped for a transparent frontend-only demo.',
        icon: Icons.auto_awesome_outlined,
        badges: const ['Verified logic', 'Offline-first', 'Demo mode'],
      ),
      const SizedBox(height: 28),
      const _SectionHeading(
        eyebrow: 'TRANSPARENT BY DESIGN',
        title: 'How AstroSaathi works',
        subtitle: 'Clear explanations without hidden server claims.',
      ),
      const SizedBox(height: 14),
      const TrustInfoCard(
        icon: Icons.calculate_outlined,
        title: 'How your chart is calculated',
        description:
            'The current demo uses its bundled local calculation and presentation logic. Precision-only fields stay unavailable when canonical astronomy data is not present.',
        badge: 'Local logic',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.badge_outlined,
        title: 'Your birth details',
        description:
            'Your name, date, time, and birthplace provide the local profile context used across astrology screens.',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.schedule_outlined,
        title: 'Why birth time matters',
        description:
            'Time-sensitive concepts such as Lagna and houses can change throughout the day. Unknown or approximate times may reduce precision.',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.tune_rounded,
        title: 'How personalization works',
        description:
            'The app combines your locally saved profile and focus areas with deterministic demo content to organize relevant guidance.',
      ),
    ]);
  }

  Widget _buildPrivacyTab() {
    return _tabList([
      const _TrustHero(
        title: 'Your data stays close',
        subtitle:
            'This frontend-only build keeps profile data in local app preferences and does not sync it to an AstroSaathi server.',
        icon: Icons.lock_outline_rounded,
        badges: ['Local profile data', 'No server sync', 'No live payment'],
      ),
      const SizedBox(height: 28),
      const _SectionHeading(
        eyebrow: 'PRIVACY & SAFETY',
        title: 'Clear local-data controls',
        subtitle: 'Know what is stored, why it is used, and how to remove it.',
      ),
      const SizedBox(height: 14),
      const TrustInfoCard(
        icon: Icons.person_outline_rounded,
        title: 'Your profile data',
        description:
            'Profile names, relationships, birth details, and focus areas are stored in local app preferences on this device.',
        badge: 'On device',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.cake_outlined,
        title: 'Birth details',
        description:
            'Birth information is used to personalize the local astrology experience. This demo does not upload it to a remote AstroSaathi account.',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.phonelink_lock_outlined,
        title: 'Permissions',
        description:
            'The Android demo does not declare runtime location, camera, microphone, contacts, or notification permissions.',
        badge: 'Minimal access',
      ),
      const SizedBox(height: 12),
      const TrustInfoCard(
        icon: Icons.safety_check_outlined,
        title: 'Safety',
        description:
            'Astrology guidance is presented for reflection and personal exploration. It is not medical, legal, or financial advice.',
      ),
      const SizedBox(height: 12),
      TrustInfoCard(
        icon: Icons.delete_sweep_outlined,
        title: 'Delete local data',
        description:
            'Use the Account Deletion tab to clear local profiles, onboarding state, preferences, and demo state from this installation.',
        trailing: const Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.primaryLightMode,
        ),
        onTap: () => setState(() => _selectedTab = 2),
      ),
    ]);
  }

  Widget _buildDeletionTab() {
    return _tabList([
      const _TrustHero(
        title: 'Clear local app data',
        subtitle:
            'This action resets this installation. There is no server account to delete in the frontend-only demo.',
        icon: Icons.delete_outline_rounded,
        badges: ['Device only', 'Immediate reset'],
        warning: true,
      ),
      const SizedBox(height: 28),
      const _SectionHeading(
        eyebrow: 'BEFORE YOU CONTINUE',
        title: 'What will be removed',
        subtitle: 'The reset cannot be undone from inside the app.',
      ),
      const SizedBox(height: 14),
      const _RemovalList(),
      const SizedBox(height: 20),
      FilledButton.icon(
        key: const ValueKey('clear-local-data-button'),
        onPressed: _handleAccountDeletion,
        icon: const Icon(Icons.delete_forever_outlined),
        label: const Text('Clear Local App Data'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: AppColors.primaryLightMode,
          foregroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(height: 10),
      TextButton(
        onPressed: () => setState(() => _selectedTab = 0),
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          foregroundColor: AppColors.textSecondaryLight,
        ),
        child: const Text('Cancel'),
      ),
    ]);
  }

  Widget _buildHelpTab() {
    return _tabList([
      const _SectionHeading(
        eyebrow: 'HELP & SUPPORT',
        title: 'Answers when you need them',
        subtitle: 'Browse local-demo guidance or prepare a report to share.',
      ),
      const SizedBox(height: 18),
      Text(
        'Frequently Asked Questions',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimaryLight,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 12),
      ...List.generate(_faqs.length, (index) {
        final faq = _faqs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: HelpFaqTile(
            question: faq.question,
            answer: faq.answer,
            expanded: _expandedFaqIndex == index,
            onTap: () => setState(() {
              _expandedFaqIndex = _expandedFaqIndex == index ? null : index;
            }),
          ),
        );
      }),
      const SizedBox(height: 22),
      Text(
        'Report an Issue',
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimaryLight,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Found an incorrect placement, calculation, or interface issue? Choose a category and tell us what happened.',
        style: GoogleFonts.inter(
          color: AppColors.textSecondaryLight,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        runSpacing: 10,
        children: _reportCategories.map((category) {
          final selected = _selectedReportCategory == category.label;
          return IssueCategoryChip(
            label: category.label,
            icon: category.icon,
            selected: selected,
            onSelected: () => setState(() {
              _selectedReportCategory = category.label;
            }),
          );
        }).toList(),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: _selectedReportCategory == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 18),
                child: _buildReportForm(),
              ),
      ),
      const SizedBox(height: 26),
      const _SectionHeading(
        eyebrow: 'APP INFORMATION',
        title: 'Frontend-only demo',
        subtitle:
            'No fake live chat, server ticket, account sync, or payment processing is represented here.',
      ),
      const SizedBox(height: 14),
      const TrustInfoCard(
        icon: Icons.info_outline_rounded,
        title: 'About AstroSaathi',
        description:
            'A locally presented astrology demo focused on clear, thoughtful, and transparent product experiences.',
        badge: 'Demo build',
      ),
    ]);
  }

  Widget _buildReportForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.softLavender),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue category',
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedReportCategory!,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimaryLight,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('issue-description-field'),
            controller: _reportController,
            minLines: 4,
            maxLines: 7,
            textInputAction: TextInputAction.newline,
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryLight,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              label: 'Description',
              hint: 'Describe what you expected and what happened.',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryLight,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              label: 'Contact email (optional)',
              hint: 'name@example.com',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.image_outlined,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'If useful, attach a screenshot after sharing the prepared report through an app on your device.',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const ValueKey('prepare-support-report-button'),
            onPressed: _prepareSupportReport,
            icon: const Icon(Icons.content_copy_rounded, size: 18),
            label: const Text('Prepare Support Report'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.primaryLightMode,
              foregroundColor: AppColors.surfaceLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Support reporting is available in this demo as a local clipboard draft. Nothing is submitted to a server.',
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      fillColor: AppColors.backgroundLight,
      labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
      hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.softLavender),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primaryLightMode,
          width: 1.4,
        ),
      ),
    );
  }

  Future<void> _prepareSupportReport() async {
    final description = _reportController.text.trim();
    if (description.isEmpty) {
      CosmicNotification.show(
        context,
        message: 'Please describe the issue before preparing the report.',
        icon: Icons.info_outline_rounded,
      );
      return;
    }

    final email = _emailController.text.trim();
    final report = StringBuffer()
      ..writeln('AstroSaathi Demo Support Report')
      ..writeln('Category: $_selectedReportCategory')
      ..writeln('Description: $description');
    if (email.isNotEmpty) report.writeln('Contact: $email');
    report.writeln('Build: Frontend-only demo');

    await Clipboard.setData(ClipboardData(text: report.toString()));
    if (!mounted) return;
    CosmicNotification.show(
      context,
      message: 'Local support report copied to clipboard.',
      icon: Icons.content_copy_rounded,
    );
  }

  Future<void> _handleAccountDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.highlightSurface),
        ),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primaryLightMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Clear local app data?',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'This removes local profiles, onboarding state, focus areas, preferences, demo subscription state, and saved demo sessions from this installation. This cannot be undone.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondaryLight,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryLightMode,
              foregroundColor: AppColors.surfaceLight,
            ),
            child: const Text('Clear Local Data'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await ref.read(profilesListProvider.notifier).clearAllProfiles();
    await ref.read(subscriptionProvider.notifier).cancelSubscription();
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (!mounted) return;
    CosmicNotification.show(
      context,
      message: 'Local AstroSaathi data has been cleared.',
      icon: Icons.check_circle_outline_rounded,
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (_) => false,
    );
  }
}

class TrustInfoCard extends StatelessWidget {
  const TrustInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? badge;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.softLavender),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLightMode.withValues(alpha: .05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primaryLightMode, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimaryLight,
                              fontSize: 16,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing!,
                        ],
                      ],
                    ),
                    if (badge != null) ...[
                      const SizedBox(height: 7),
                      TrustBadge(label: badge!),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondaryLight,
                        fontSize: 14,
                        height: 1.45,
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

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: AppColors.primaryLightMode,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class HelpFaqTile extends StatelessWidget {
  const HelpFaqTile({
    super.key,
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      expanded: expanded,
      label: question,
      child: Material(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 210),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: expanded
                    ? AppColors.highlightSurface
                    : AppColors.softLavender,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryLight,
                          fontSize: 15.5,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 210),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            answer,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondaryLight,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IssueCategoryChip extends StatelessWidget {
  const IssueCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label issue category',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 46),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryLightMode
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? AppColors.primaryLightMode
                    : AppColors.highlightSurface,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected
                      ? AppColors.surfaceLight
                      : AppColors.primaryLightMode,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: selected
                        ? AppColors.surfaceLight
                        : AppColors.textPrimaryLight,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustHero extends StatelessWidget {
  const _TrustHero({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badges,
    this.warning = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> badges;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryBackground,
            AppColors.softLavender,
            AppColors.highlightSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: ExcludeSemantics(
              child: CustomPaint(painter: _TrustSkyPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: warning
                        ? AppColors.actionPurple
                        : AppColors.primaryLightMode,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryLightMode,
                    fontSize: 22,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryLight,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: badges
                      .map((label) => TrustBadge(label: label))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: .03, end: 0);
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: GoogleFonts.inter(
            color: AppColors.secondary,
            fontSize: 10.5,
            letterSpacing: 1.25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimaryLight,
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: AppColors.textSecondaryLight,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _RemovalList extends StatelessWidget {
  const _RemovalList();

  static const items = [
    'Local profiles and birth details',
    'Onboarding state and focus areas',
    'Language and local preferences',
    'Demo subscription state',
    'Saved demo sessions and local history',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.highlightSurface),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    color: AppColors.primaryLightMode,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    items[index],
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimaryLight,
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (index != items.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _TrustSkyPainter extends CustomPainter {
  const _TrustSkyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final orbit = Paint()
      ..color = AppColors.primaryLightMode.withValues(alpha: .06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final stars = Paint()
      ..color = AppColors.secondary.withValues(alpha: .07)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .88, size.height * .2),
        width: size.width * .55,
        height: size.width * .55,
      ),
      orbit,
    );
    canvas.drawCircle(Offset(size.width * .78, 32), 2.2, stars);
    canvas.drawCircle(Offset(size.width * .9, size.height * .56), 2.8, stars);
    canvas.drawCircle(Offset(size.width * .66, size.height * .78), 1.8, stars);
    final constellation = Path()
      ..moveTo(size.width * .68, size.height * .3)
      ..lineTo(size.width * .8, size.height * .4)
      ..lineTo(size.width * .72, size.height * .55)
      ..lineTo(size.width * .88, size.height * .66);
    canvas.drawPath(constellation, orbit);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrustTabData {
  const _TrustTabData(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _IssueCategory {
  const _IssueCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _FaqData {
  const _FaqData(this.question, this.answer);
  final String question;
  final String answer;
}
