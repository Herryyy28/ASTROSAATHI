import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../matching/presentation/screens/chart_comparison_screen.dart';

class FamilyAstrologyDashboardScreen extends StatefulWidget {
  const FamilyAstrologyDashboardScreen({super.key});

  @override
  State<FamilyAstrologyDashboardScreen> createState() => _FamilyAstrologyDashboardScreenState();
}

class _FamilyAstrologyDashboardScreenState extends State<FamilyAstrologyDashboardScreen> {
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'name': 'Priya (Spouse)',
      'relation': 'Spouse',
      'zodiac': 'Taurus ♉',
      'score': 8.8,
      'status': 'High Synergy Window',
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Aarav (Child)',
      'relation': 'Son',
      'zodiac': 'Leo ♌',
      'score': 7.6,
      'status': 'Study & Focus Peak',
      'color': Colors.amberAccent,
    },
    {
      'name': 'Sunita (Parent)',
      'relation': 'Mother',
      'zodiac': 'Cancer ♋',
      'score': 8.1,
      'status': 'Peaceful Transit Window',
      'color': Colors.cyanAccent,
    },
    {
      'name': 'Vikram (Partner)',
      'relation': 'Business Partner',
      'zodiac': 'Capricorn ♑',
      'score': 9.2,
      'status': 'Major Venture Alignment',
      'color': Colors.greenAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Family Astrology Dashboard',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'FAMILY',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Shared family transit insights & compatibility radar',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section 1: Overview Banner
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: AppColors.primary.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'FAMILY SYNERGY TODAY',
                                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                                ),
                                child: Text(
                                  'HIGH SYNERGY (8.4/10)',
                                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Moon in Shatabhisha Nakshatra aligns favorably with Spouse & Partner charts today.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Family Members List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FAMILY PROFILES',
                          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.white70),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add family profile modal opened')),
                            );
                          },
                          icon: const Icon(Icons.person_add_rounded, size: 14, color: AppColors.primary),
                          label: Text('Add Profile', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ..._familyMembers.map((member) {
                      final color = member['color'] as Color;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          padding: const EdgeInsets.all(14),
                          borderColor: color.withOpacity(0.3),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: color.withOpacity(0.18),
                                child: Icon(Icons.person_rounded, color: color, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            member['name'] as String,
                                            style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          member['zodiac'] as String,
                                          style: GoogleFonts.inter(fontSize: 10.5, color: Colors.white54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      member['status'] as String,
                                      style: GoogleFonts.inter(fontSize: 10.5, color: color, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 18),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ChartComparisonScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
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
