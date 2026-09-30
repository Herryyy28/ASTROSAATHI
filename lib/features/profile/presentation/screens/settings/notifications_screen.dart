import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../reminders/providers/reminder_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final reminderState = ref.watch(reminderStateProvider);
    final notifier = ref.read(reminderStateProvider.notifier);

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications & Alerts',
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
            Text(
              'Customize your cosmic alerts & habit engine',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.getTextSecondary(context),
              ),
            ),
            const SizedBox(height: 20),
            GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildToggle(
                    'Morning Score & Horoscope',
                    'Get your morning cosmic energy score at 7:00 AM',
                    reminderState.morningScoreNotification,
                    (val) => notifier.updateSettings(morningScore: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    'Rahu Kaal Pre-Warning',
                    '20-minute lead alert to avoid signing contracts',
                    reminderState.rahuKaalNotification,
                    (val) => notifier.updateSettings(rahuKaal: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    'Shubh Muhurat Golden Window',
                    'Alert when your peak auspicious window opens',
                    reminderState.shubhMuhuratNotification,
                    (val) => notifier.updateSettings(shubhMuhurat: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    'Daily Mood & Cosmic Check-In',
                    'Evening reflection prompt for +5 Karma XP',
                    reminderState.dailyCheckInNotification,
                    (val) => notifier.updateSettings(dailyCheckIn: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    'Spiritual Routine (Surya / Gayatri)',
                    'Dawn alerts for daily Surya Arghya and mantras',
                    reminderState.dailyRoutineNotification,
                    (val) => notifier.updateSettings(dailyRoutine: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    '108 Mala Bead Japa',
                    'Reminders to complete daily chanting milestone',
                    reminderState.japaReminderNotification,
                    (val) => notifier.updateSettings(japa: val),
                    context,
                  ),
                  Divider(color: AppColors.getGlassBorder(context)),
                  _buildToggle(
                    'Cosmic Streak Protector',
                    'Alert before midnight so you never break your streak',
                    reminderState.streakProtectorNotification,
                    (val) => notifier.updateSettings(streakProtector: val),
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged, BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.getTextPrimary(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          color: AppColors.getTextSecondary(context),
        ),
      ),
      activeColor: AppColors.primary,
    );
  }
}
