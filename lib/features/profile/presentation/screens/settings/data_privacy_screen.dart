import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/providers/profile_provider.dart';
import '../../../../../core/providers/subscription_provider.dart';
import '../../../../../core/providers/gamification_provider.dart';
import '../../../../../core/widgets/cosmic_notification.dart';

class DataPrivacyScreen extends ConsumerWidget {
  const DataPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          'Data Privacy & Sovereignty',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Icon(
              Icons.shield_rounded,
              size: 72,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Data is Secure & Private',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We use local device persistence and end-to-end security for all your personal birth details, astrological calculations, and spiritual habit logs.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.getTextSecondary(context),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyPoint(
                    context,
                    Icons.lock_rounded,
                    'End-to-End Privacy',
                    'Your birth coordinates, planetary calculations, and AI queries are isolated to your device session.',
                  ),
                  const SizedBox(height: 20),
                  _buildPrivacyPoint(
                    context,
                    Icons.visibility_off_rounded,
                    'Zero Data Monetization',
                    'AstroSaathi never sells, rents, or shares your personal astrology data with advertisers or data brokers.',
                  ),
                  const SizedBox(height: 20),
                  _buildPrivacyPoint(
                    context,
                    Icons.cloud_off_rounded,
                    'Local Storage First',
                    'Your Kundlis, habit streaks, Karma XP, and reminder settings remain securely stored on your device.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Export Data Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _showExportDialog(context, ref),
              icon: const Icon(Icons.download_rounded),
              label: Text(
                'Export My Astrological Data (JSON)',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Delete Account & Data Button
            TextButton.icon(
              onPressed: () => _showDeleteDialog(context, ref),
              icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              label: Text(
                'Delete All My Data & Account',
                style: GoogleFonts.outfit(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPoint(BuildContext context, IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: AppColors.getTextSecondary(context),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(activeProfileProvider);
    final gamification = ref.read(gamificationProvider);

    final exportData = {
      'app': 'AstroSaathi',
      'version': '2.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'profile': {
        'name': profile.name,
        'dateOfBirth': profile.dob,
        'timeOfBirth': profile.birthTime,
        'placeOfBirth': profile.birthPlace,
        'relationship': profile.relationship,
        'latitude': profile.latitude,
        'longitude': profile.longitude,
        'timezone': profile.timezone,
      },
      'habitsAndGamification': {
        'currentStreakDays': gamification.streakDays,
        'karmaXp': gamification.karmaXp,
        'todayMood': gamification.todayMood,
        'unlockedBadges': gamification.badges.where((b) => b.isUnlocked).map((b) => b.title).toList(),
      },
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Your Astrological Data Export',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete on-device profile, coordinates, and habit records formatted in JSON:',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context)),
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceSecondary(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorder(context)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    jsonString,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Close', style: TextStyle(color: AppColors.getTextMuted(context))),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: jsonString));
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (context.mounted) {
                CosmicNotification.showSuccess(
                  context,
                  title: 'Data Copied! 📋',
                  message: 'Your personal astrological profile JSON has been copied to your clipboard.',
                );
              }
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy JSON'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account & Data?',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        content: Text(
          'This action is irreversible. All your stored profiles, family Kundlis, AI chat histories, and preferences will be permanently wiped from this device.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.getTextSecondary(context),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);

              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              ref.read(profilesListProvider.notifier).clearAllProfiles();
              ref.read(subscriptionProvider.notifier).cancelSubscription();

              if (context.mounted) {
                CosmicNotification.showSuccess(
                  context,
                  title: 'Data Erased',
                  message: 'All your local device data has been completely wiped.',
                );
                context.go('/onboarding');
              }
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }
}
