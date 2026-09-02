import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/providers/profile_provider.dart';

class NumerologyScreen extends ConsumerStatefulWidget {
  const NumerologyScreen({super.key});

  @override
  ConsumerState<NumerologyScreen> createState() => _NumerologyScreenState();
}

class _NumerologyScreenState extends ConsumerState<NumerologyScreen> {
  int _calculateLifePath(String dob) {
    if (dob.isEmpty) return 1;
    // dob is assumed to be YYYY-MM-DD
    final digits = dob.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 1;

    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      sum += int.parse(digits[i]);
    }

    // Reduce to single digit, excluding master numbers 11, 22, 33
    while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
      int temp = 0;
      String sumStr = sum.toString();
      for (int i = 0; i < sumStr.length; i++) {
        temp += int.parse(sumStr[i]);
      }
      sum = temp;
    }
    return sum;
  }

  int _calculateDestiny(String name) {
    if (name.isEmpty) return 1;
    
    // Chaldean numerology map
    final Map<String, int> values = {
      'a': 1, 'i': 1, 'j': 1, 'q': 1, 'y': 1,
      'b': 2, 'k': 2, 'r': 2,
      'c': 3, 'g': 3, 'l': 3, 's': 3,
      'd': 4, 'm': 4, 't': 4,
      'e': 5, 'h': 5, 'n': 5, 'x': 5,
      'u': 6, 'v': 6, 'w': 6,
      'o': 7, 'z': 7,
      'f': 8, 'p': 8,
    };

    int sum = 0;
    final cleanName = name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    for (int i = 0; i < cleanName.length; i++) {
      sum += values[cleanName[i]] ?? 0;
    }

    while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
      int temp = 0;
      String sumStr = sum.toString();
      for (int i = 0; i < sumStr.length; i++) {
        temp += int.parse(sumStr[i]);
      }
      sum = temp;
    }
    return sum == 0 ? 1 : sum;
  }

  String _getInterpretation(int number) {
    switch (number) {
      case 1: return "The Leader: Independent, original, and driven by achievement.";
      case 2: return "The Peacemaker: Diplomatic, sensitive, and thrives in partnerships.";
      case 3: return "The Communicator: Creative, social, and expresses ideas effectively.";
      case 4: return "The Builder: Practical, disciplined, and focused on stability.";
      case 5: return "The Adventurer: Versatile, freedom-loving, and adaptable to change.";
      case 6: return "The Nurturer: Responsible, loving, and focused on family and harmony.";
      case 7: return "The Seeker: Analytical, spiritual, and driven by the search for truth.";
      case 8: return "The Powerhouse: Ambitious, goal-oriented, and focused on material success.";
      case 9: return "The Humanitarian: Compassionate, idealistic, and driven to help others.";
      case 11: return "The Illuminator: Highly intuitive, inspiring, and possesses spiritual insight.";
      case 22: return "The Master Builder: Visionary, practical, and capable of large-scale achievements.";
      case 33: return "The Master Teacher: Compassionate, healing, and focused on uplifting humanity.";
      default: return "A unique path filled with mystery and potential.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
    final lifePath = _calculateLifePath(activeProfile.dob);
    final destiny = _calculateDestiny(activeProfile.name);

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
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
                _buildHeader(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileInfo(context, activeProfile).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 24),
                        Text(
                          'YOUR CORE NUMBERS',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.getPrimary(context),
                            letterSpacing: 1.2,
                          ),
                        ).animate().fadeIn(delay: 150.ms),
                        const SizedBox(height: 12),
                        _buildNumberCard(
                          context: context,
                          title: 'Life Path Number',
                          number: lifePath,
                          subtitle: 'Derived from your Date of Birth',
                          interpretation: _getInterpretation(lifePath),
                          delay: 200,
                        ),
                        const SizedBox(height: 16),
                        _buildNumberCard(
                          context: context,
                          title: 'Destiny Number',
                          number: destiny,
                          subtitle: 'Derived from your Name',
                          interpretation: _getInterpretation(destiny),
                          delay: 300,
                        ),
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

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.getTextPrimary(context), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A3A), Color(0xFF4A90E2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🔢', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Numerology',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    'Vedic & Chaldean Insights',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
    );
  }

  Widget _buildProfileInfo(BuildContext context, BirthProfileData profile) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.getPrimary(context).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: AppColors.getPrimary(context), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name.isNotEmpty ? profile.name : 'Your Profile',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                Text(
                  profile.dob.isNotEmpty ? profile.dob : 'Date of Birth not set',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCard({
    required BuildContext context,
    required String title,
    required int number,
    required String subtitle,
    required String interpretation,
    required int delay,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      glowColor: AppColors.getPrimary(context).withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldSubtleGradient,
                  border: Border.all(color: AppColors.getPrimary(context).withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getPrimary(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.getTextMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceSecondary(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    interpretation,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.getTextSecondary(context),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}
