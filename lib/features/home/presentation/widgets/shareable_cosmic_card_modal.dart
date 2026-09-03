import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/engine/models/game_plan_data.dart';

class ShareableCosmicCardModal extends ConsumerWidget {
  final GamePlanData gamePlan;

  const ShareableCosmicCardModal({super.key, required this.gamePlan});

  static Future<void> show(BuildContext context, GamePlanData gamePlan) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => ShareableCosmicCardModal(gamePlan: gamePlan),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeProfileProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xF2090D16),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3), width: 1.0),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.getTextMuted(context),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SHARE YOUR COSMIC VIBE',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.getPrimary(context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 9:16 Story Card Container (Export Target)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40E0A13A),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // App Branding
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.goldGradient,
                              ),
                              child: const Center(
                                child: Text('✦', style: TextStyle(fontSize: 11, color: Colors.black)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AstroSaathi Daily Cosmic Plan',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: const Color(0xFFFFD700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User Name & Signs
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          activeProfile.name.isNotEmpty ? activeProfile.name : 'Cosmic Traveler',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vedic Birth Chart Alignment ✦',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFAAB3C2),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Score Dial
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF111827),
                          border: Border.all(color: const Color(0xFFFFD700), width: 4),
                          boxShadow: const [
                            BoxShadow(color: Color(0x60FFD700), blurRadius: 20),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              gamePlan.dayScore.toStringAsFixed(1),
                              style: GoogleFonts.outfit(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFD700),
                                height: 1,
                              ),
                            ),
                            Text(
                              'out of 10',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Quote
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '“${gamePlan.transitFactor ?? "Gajakesari Yoga active • High financial & strategic clarity today."}”',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Best Window Footer Strip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '✦ Golden Window ',
                                style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFFD700)),
                              ),
                              Text(
                                '${gamePlan.bestWindow.start} – ${gamePlan.bestWindow.end}',
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24), // Action Buttons (100% Responsive, Zero Edge Clipping)
                // Action Buttons Row 1: Instagram & WhatsApp
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final shareText = '✦ AstroSaathi Daily Cosmic Plan ✦\n'
                              'Profile: ${activeProfile.name}\n'
                              'Cosmic Alignment Score: ${gamePlan.dayScore.toStringAsFixed(1)}/10\n'
                              'Golden Window: ${gamePlan.bestWindow.start} – ${gamePlan.bestWindow.end}\n'
                              'Check your Vedic birth chart alignment on AstroSaathi!';
                          await Clipboard.setData(ClipboardData(text: shareText));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✦ Cosmic Card copied to clipboard! Open Instagram to paste in Story.')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1306C),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE1306C).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Instagram Story',
                                  style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final shareText = '✦ AstroSaathi Daily Cosmic Plan ✦\n'
                              'Profile: ${activeProfile.name}\n'
                              'Score: ${gamePlan.dayScore.toStringAsFixed(1)}/10\n'
                              'Golden Window: ${gamePlan.bestWindow.start} – ${gamePlan.bestWindow.end}';
                          final waUrl = Uri.parse('https://api.whatsapp.com/send?text=${Uri.encodeComponent(shareText)}');
                          try {
                            if (await canLaunchUrl(waUrl)) {
                              await launchUrl(waUrl, mode: LaunchMode.externalApplication);
                            } else {
                              await Clipboard.setData(ClipboardData(text: shareText));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('✦ Cosmic Card copied to clipboard for WhatsApp!')),
                                );
                              }
                            }
                          } catch (_) {
                            await Clipboard.setData(ClipboardData(text: shareText));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF25D366).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'WhatsApp Status',
                                  style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Action Buttons Row 2: Copy Details & More Apps
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final fullText = '✦ AstroSaathi Daily Cosmic Reading ✦\n'
                              'Name: ${activeProfile.name}\n'
                              'Cosmic Alignment: ${gamePlan.dayScore.toStringAsFixed(1)}/10\n'
                              'Transit Focus: ${gamePlan.transitFactor ?? "Gajakesari Yoga active"}\n'
                              'Golden Window: ${gamePlan.bestWindow.start} – ${gamePlan.bestWindow.end}\n'
                              'Do: ${gamePlan.doList.take(2).join(", ")}\n'
                              'Avoid: ${gamePlan.avoidList.take(2).join(", ")}\n\n'
                              'Get your daily personalized Vedic astrology alignment at AstroSaathi!';
                          await Clipboard.setData(ClipboardData(text: fullText));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('📋 Full Cosmic Reading details copied to clipboard!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.getSurfaceElevated(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copy_rounded, color: AppColors.getTextPrimary(context), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Copy Text',
                                  style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final shareText = '✦ AstroSaathi Daily Cosmic Plan ✦\n'
                              'Profile: ${activeProfile.name}\n'
                              'Cosmic Score: ${gamePlan.dayScore.toStringAsFixed(1)}/10\n'
                              'Golden Window: ${gamePlan.bestWindow.start} – ${gamePlan.bestWindow.end}\n'
                              'Check your Vedic alignment on AstroSaathi!';
                          await Clipboard.setData(ClipboardData(text: shareText));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✦ Cosmic Card copied! Paste into Telegram, Twitter, or Messages.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share_rounded, color: AppColors.primary, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'More Apps',
                                  style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
