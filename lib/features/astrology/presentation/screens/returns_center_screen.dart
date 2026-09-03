import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ReturnsCenterScreen extends StatefulWidget {
  const ReturnsCenterScreen({super.key});

  @override
  State<ReturnsCenterScreen> createState() => _ReturnsCenterScreenState();
}

class _ReturnsCenterScreenState extends State<ReturnsCenterScreen> {
  int _selectedTab = 0; // 0: Solar Return, 1: Lunar Return

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
                                  'Solar & Lunar Returns',
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
                                  'ANNUAL & MONTHLY',
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
                            'Exact Sun & Moon return moment forecasts',
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

              // Tab selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        showCheckmark: false,
                        selected: _selectedTab == 0,
                        onSelected: (_) => setState(() => _selectedTab = 0),
                        avatar: const Icon(Icons.wb_sunny_rounded, size: 16, color: Colors.amberAccent),
                        label: Text('Solar Return (Yearly)', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        showCheckmark: false,
                        selected: _selectedTab == 1,
                        onSelected: (_) => setState(() => _selectedTab = 1),
                        avatar: const Icon(Icons.nightlight_round, size: 16, color: Colors.cyanAccent),
                        label: Text('Lunar Return (Monthly)', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (_selectedTab == 0) ...[
                      GlassCard(
                        padding: const EdgeInsets.all(18),
                        borderColor: Colors.amber.withOpacity(0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'SOLAR RETURN 2026 (VARSHAPHAL)',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Oct 14, 2026 • 04:12 PM',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Yearly Theme: Executive Leadership & Financial Expansion', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                            const SizedBox(height: 6),
                            Text('Your 2026 Solar Return Sun lands in the 10th House of Career, conjunct natal Jupiter. Expect high visibility and major professional milestones.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4)),
                          ],
                        ),
                      ),
                    ] else ...[
                      GlassCard(
                        padding: const EdgeInsets.all(18),
                        borderColor: Colors.cyanAccent.withOpacity(0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'LUNAR RETURN SEPTEMBER 2026',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.cyanAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Sep 18, 2026 • 11:45 AM',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Emotional Focus: Strategic Clarity & Intuitive Decisions', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                            const SizedBox(height: 6),
                            Text('Moon returns to Shatabhisha Nakshatra in your 5th House, favoring creative projects, intellectual clarity, and emotional balance.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4)),
                          ],
                        ),
                      ),
                    ],
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
