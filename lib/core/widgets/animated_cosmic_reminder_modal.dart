import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'cosmic_notification.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Animated Cosmic Real-Time Reminder Alert Modal
/// Pops up dynamically at reminder trigger times with animated celestial UI,
/// astrological muhurat scores, transit recommendations, sound/vibration feedback,
/// and remedial actions.
/// ─────────────────────────────────────────────────────────────────────────────
class AnimatedCosmicReminderModal extends StatelessWidget {
  final String title;
  final String category;
  final double astroScore;
  final String dashaContext;
  final String aiRecommendation;
  final String remediationText;
  final DateTime eventTime;

  const AnimatedCosmicReminderModal({
    super.key,
    required this.title,
    required this.category,
    required this.astroScore,
    required this.dashaContext,
    required this.aiRecommendation,
    required this.remediationText,
    required this.eventTime,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Executive Strategy Session',
    String category = 'Business Muhurat',
    double astroScore = 9.4,
    String dashaContext = 'Jupiter-Mercury • Abhijit Muhurat Active',
    String aiRecommendation =
        'Mercury & Sun alignment in 10th house provides peak mental clarity and negotiating power right now.',
    String remediationText = 'Chant "Om Budhaya Namah" 9x before starting.',
    DateTime? eventTime,
  }) async {
    // 1. Trigger Mobile Haptic Vibration & Audio Sound Feedback
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}

    // 2. Show Mobile Push Notification Panel Banner at top of screen
    CosmicNotification.show(
      context,
      title: '🔔 Reminding: $title',
      message: '★ $astroScore/10 Peak Muhurat • $dashaContext',
      icon: Icons.notifications_active_rounded,
      accentColor: const Color(0xFFFFD700),
      duration: const Duration(seconds: 4),
    );

    // 3. Show Real-time Animated Alert Dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.80),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AnimatedCosmicReminderModal(
          title: title,
          category: category,
          astroScore: astroScore,
          dashaContext: dashaContext,
          aiRecommendation: aiRecommendation,
          remediationText: remediationText,
          eventTime: eventTime ?? DateTime.now(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isHighScore = astroScore >= 8.0;

    final scoreColor = isHighScore
        ? (isLight ? const Color(0xFFD9901A) : const Color(0xFFFFD700))
        : (isLight ? const Color(0xFFC58A1A) : Colors.orangeAccent);

    final primaryTextColor = isLight ? AppColors.textPrimaryLight : Colors.white;
    final secondaryTextColor = isLight ? AppColors.textSecondaryLight : Colors.white.withOpacity(0.90);
    final remedyTextColor = isLight ? AppColors.successLight : const Color(0xFF4ADE80);
    final cardBorderColor = isLight ? scoreColor.withOpacity(0.5) : scoreColor.withOpacity(0.65);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : const Color(0xFF0B0F19),
            gradient: isLight
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF090D16), Color(0xFF141C2E), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: scoreColor.withOpacity(isLight ? 0.18 : 0.35),
                blurRadius: 32,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isLight ? 0.12 : 0.85),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Glowing Bell Animation Header
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Pulse Ring
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scoreColor.withOpacity(isLight ? 0.12 : 0.15),
                      border: Border.all(color: scoreColor.withOpacity(0.5), width: 1.5),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.28, 1.28), duration: 2000.ms, curve: Curves.easeOut)
                      .fadeOut(duration: 2000.ms),

                  // Inner Glowing Emblem
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isLight
                            ? [const Color(0xFFFFF0D3), const Color(0xFFF1F2F4)]
                            : [scoreColor.withOpacity(0.4), const Color(0xFF182132)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withOpacity(isLight ? 0.3 : 0.6),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: scoreColor,
                        size: 30,
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shake(duration: 1500.ms, hz: 3)
                      .scale(begin: const Offset(0.98, 0.98), end: const Offset(1.05, 1.05), duration: 1000.ms),
                ],
              ),
              const SizedBox(height: 14),

              // Live Alert Badge (Responsive FittedBox)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(isLight ? 0.15 : 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scoreColor.withOpacity(0.6), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scoreColor,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 600.ms),
                    const SizedBox(width: 6),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'REAL-TIME COSMIC ALIGNMENT ALERT',
                          style: GoogleFonts.outfit(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: scoreColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Title (High Contrast Light/Dark Adaptive Text)
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  letterSpacing: -0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Category & Score Row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLight ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isLight ? AppColors.borderLight : Colors.white24, width: 0.6),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isLight ? AppColors.textSecondaryLight : const Color(0xFFE4E4E4),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFFFF0D3) : scoreColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: scoreColor.withOpacity(0.6), width: 0.8),
                    ),
                    child: Text(
                      '★ $astroScore / 10 Score',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Planetary & Dasha Context Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFF8F9FA) : Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isLight ? AppColors.borderLight : Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: scoreColor, size: 15),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dashaContext,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      aiRecommendation,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                    if (remediationText.isNotEmpty) ...[
                      Divider(height: 18, color: isLight ? AppColors.dividerLight : Colors.white12),
                      Row(
                        children: [
                          Icon(Icons.spa_rounded, color: remedyTextColor, size: 15),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Remedy: $remediationText',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: remedyTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row (Responsive Light/Dark Adaptive)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isLight ? AppColors.borderLight : Colors.white.withOpacity(0.35)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        try {
                          HapticFeedback.lightImpact();
                        } catch (_) {}
                        Navigator.pop(context);
                        CosmicNotification.show(
                          context,
                          title: 'Snoozed ⏰',
                          message: 'Reminder snoozed for 15 minutes.',
                          icon: Icons.snooze_rounded,
                        );
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Snooze 15m',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLight ? AppColors.textPrimaryLight : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scoreColor,
                        foregroundColor: isLight ? Colors.white : const Color(0xFF161003),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      onPressed: () {
                        try {
                          HapticFeedback.mediumImpact();
                          SystemSound.play(SystemSoundType.click);
                        } catch (_) {}
                        Navigator.pop(context);
                        CosmicNotification.show(
                          context,
                          title: 'Alignment Acknowledged! ✨',
                          message: 'May the planetary energies bring peak success to your event.',
                          icon: Icons.star_rounded,
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Acknowledge & Proceed',
                          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

