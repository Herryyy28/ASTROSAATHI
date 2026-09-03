import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/providers/profile_provider.dart';
import '../../../../../core/providers/subscription_provider.dart';
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
          'Data Privacy',
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
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(
              Icons.shield_rounded,
              size: 72,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Data is Secure',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We use end-to-end encryption for all your birth details and cosmic logs.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyPoint(
                    context,
                    Icons.lock_rounded,
                    'End-to-End Encryption',
                    'Your birth data and AI chats are encrypted before leaving your device.',
                  ),
                  const SizedBox(height: 20),
                  _buildPrivacyPoint(
                    context,
                    Icons.visibility_off_rounded,
                    'No Third-Party Sharing',
                    'We never sell your data to advertisers or third parties.',
                  ),
                  const SizedBox(height: 20),
                  _buildPrivacyPoint(
                    context,
                    Icons.cloud_off_rounded,
                    'Local Storage First',
                    'Your Kundlis are stored locally on your device for maximum privacy.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            TextButton.icon(
              onPressed: () => _showDeleteDialog(context, ref),
              icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              label: Text(
                'Delete All My Data & Account',
                style: GoogleFonts.outfit(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Delete All Data & Account?',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        content: Text(
          'This will permanently erase all your birth profiles, VIP subscription, settings, and saved insights.\n\nYou will be returned to the entry level onboarding screen to fill all your details from scratch.',
          style: GoogleFonts.inter(
            color: AppColors.getTextSecondary(context),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: AppColors.getTextSecondary(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                CosmicNotification.show(
                  context,
                  message: 'Account erased. Returning to entry onboarding...',
                  icon: Icons.delete_outline_rounded,
                );
                // 4. Redirect to entry level Onboarding
                context.go('/onboarding');
              }
            },
            child: const Text('Permanently Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
