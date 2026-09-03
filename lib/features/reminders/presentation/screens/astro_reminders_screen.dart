import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/presentation/widgets/add_event_modal.dart';
import '../../providers/reminder_provider.dart';

class AstroRemindersScreen extends ConsumerWidget {
  const AstroRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderStateProvider);
    final notifier = ref.read(reminderStateProvider.notifier);
    final isLight = Theme.of(context).brightness == Brightness.light;

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
                          Text(
                            'Smart Astro Reminders',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Configure habit engine push alerts & event timings',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.black, size: 18),
                      ),
                      onPressed: () => AddEventModal.show(context),
                    ),
                  ],
                ),
              ),

              // Content Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Daily Habit Alerts Settings Card
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'DAILY HABIT ENGINE PUSH ALERTS',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Morning Score Alert
                          _buildSwitchRow(
                            context,
                            title: 'Morning Score Push (07:00 AM)',
                            subtitle: 'Daily 1–10 Energy Score & Gajakesari/Planet transit summary',
                            value: reminderState.morningScoreNotification,
                            onChanged: (val) => notifier.updateSettings(morningScore: val),
                          ),
                          const Divider(height: 24),

                          // Rahu Kaal Warning
                          _buildSwitchRow(
                            context,
                            title: '20-min Rahu Kaal Pre-Warning',
                            subtitle: 'Get notified 20 minutes before Rahu Kaal starts to defer major deals',
                            value: reminderState.rahuKaalNotification,
                            onChanged: (val) => notifier.updateSettings(rahuKaal: val),
                          ),
                          const Divider(height: 24),

                          // Shubh Muhurat Best Window
                          _buildSwitchRow(
                            context,
                            title: 'Golden Window (Shubh Muhurat) Lead Alert',
                            subtitle: 'Receive notification when your peak daily timing window opens',
                            value: reminderState.shubhMuhuratNotification,
                            onChanged: (val) => notifier.updateSettings(shubhMuhurat: val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User Scheduled Events Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'YOUR SCHEDULED EVENTS (${reminderState.reminders.length})',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => AddEventModal.show(context),
                          icon: const Icon(Icons.add_circle_outline_rounded, size: 14, color: AppColors.primary),
                          label: Text(
                            'Add Event',
                            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // List of scheduled events
                    if (reminderState.reminders.isEmpty)
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.event_note_rounded, size: 36, color: AppColors.primary),
                              const SizedBox(height: 8),
                              Text(
                                'No Personal Events Scheduled Yet',
                                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Schedule meetings, travels or property deals to receive astrological timing scores & reminders.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context)),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...reminderState.reminders.map((reminder) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: reminder.category.color.withOpacity(0.18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(reminder.category.icon, size: 18, color: reminder.category.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reminder.title,
                                              style: GoogleFonts.outfit(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.getTextPrimary(context),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.getPrimary(context).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '★ ${reminder.astroScore}/10',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.getPrimary(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        reminder.astroRecommendation,
                                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                                  onPressed: () {
                                    notifier.deleteReminder(reminder.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

final reminderStateProvider = reminderProvider;
