import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class YearAheadScreen extends StatefulWidget {
  const YearAheadScreen({super.key});

  @override
  State<YearAheadScreen> createState() => _YearAheadScreenState();
}

class _YearAheadScreenState extends State<YearAheadScreen> {
  int _selectedMonthIndex = 0;
  String _selectedTab = 'Overview';

  final List<Map<String, dynamic>> _months = [
    {
      'month': 'JAN 2026',
      'focus': 'Career Expansion & Leadership',
      'score': 92,
      'career': 'Promising developments with Saturn in favorable alignment. Ideal time to present new proposals around Jan 15th.',
      'relationship': 'Harmonic communication cycles. Best period for meaningful conversations: Jan 18th.',
      'finance': 'Positive liquidity flow. Favorable investment window: Jan 10th - Jan 22nd.',
      'health': 'High vitality. Maintain consistent routine during full moon phases.',
      'dates': ['Jan 05: Sun Conjunction', 'Jan 18: Venus Transit', 'Jan 27: Mercury Direct'],
    },
    {
      'month': 'FEB 2026',
      'focus': 'Relationships & Emotional Harmony',
      'score': 88,
      'career': 'Collaborative projects succeed. Networking opens doors around Feb 12th.',
      'relationship': 'Peak emotional alignment. Deep soulmate connections highlighted.',
      'finance': 'Steady growth; balance impulse spending around Feb 20th.',
      'health': 'Calm mental focus; ideal for meditation and yoga.',
      'dates': ['Feb 08: Moon Trine Venus', 'Feb 14: Jupiter Aspect', 'Feb 24: Full Moon'],
    },
    {
      'month': 'MAR 2026',
      'focus': 'Financial Growth & Investments',
      'score': 95,
      'career': 'High recognition from leadership. Executive authority expanded.',
      'relationship': 'Family gatherings & social celebrations bring joy.',
      'finance': 'Major financial gain opportunity through property or assets.',
      'health': 'Strong physical immunity.',
      'dates': ['Mar 03: Mercury Direct', 'Mar 15: Sun 10th House', 'Mar 28: New Moon'],
    },
    {
      'month': 'APR 2026',
      'focus': 'Creative Endeavors & Education',
      'score': 84,
      'career': 'Skill acquisition and strategic learning lead to breakthroughs.',
      'relationship': 'Honest dialogues build long-term trust.',
      'finance': 'Re-evaluate budgets and long-term savings goals.',
      'health': 'Hydration and active morning walks recommended.',
      'dates': ['Apr 06: Jupiter Direct', 'Apr 19: Mars Trine Sun', 'Apr 29: Venus Shift'],
    },
    {
      'month': 'MAY 2026',
      'focus': 'Partnerships & Public Standing',
      'score': 90,
      'career': 'New contract signings and joint ventures flourish.',
      'relationship': 'Commitment milestones and engagement opportunities.',
      'finance': 'Secondary income stream gains momentum.',
      'health': 'Restorative sleep routines recommended.',
      'dates': ['May 10: Full Moon in Scorpio', 'May 22: Sun Sextile Saturn'],
    },
    {
      'month': 'JUN 2026',
      'focus': 'Travel & Global Opportunities',
      'score': 86,
      'career': 'International connections or remote projects active.',
      'relationship': 'Travel with partner creates lasting memories.',
      'finance': 'Favorable currency or foreign trade returns.',
      'health': 'High energy; stay mindful during outdoor activities.',
      'dates': ['Jun 04: Mercury 9th House', 'Jun 21: Solstice Alignment'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final activeMonth = _months[_selectedMonthIndex];
    final accentGold = isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          'Personal Year Ahead Roadmap (2026)',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Year Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLight
                      ? [const Color(0xFFFFF7E6), const Color(0xFFFEEDC9)]
                      : [const Color(0xFF2B220B), const Color(0xFF161205)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentGold.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: accentGold.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '90%',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: accentGold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2026 Cosmic Energy: High Momentum',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: accentGold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Primary Dasha: Jupiter-Mercury • Peak Months: March & October',
                          style: GoogleFonts.outfit(
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
            const SizedBox(height: 20),

            // Horizontal Month Selector Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_months.length, (idx) {
                  final m = _months[idx];
                  final isSelected = _selectedMonthIndex == idx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMonthIndex = idx),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentGold
                            : AppColors.getSurfaceElevated(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? accentGold : AppColors.getBorder(context),
                        ),
                      ),
                      child: Text(
                        m['month'],
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Active Month Detail Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.getBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activeMonth['month'],
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Score: ${activeMonth['score']}/100',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Focus: ${activeMonth['focus']}',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF),
                    ),
                  ),
                  Divider(color: AppColors.getDivider(context), height: 24),

                  // Category Breakdown
                  _buildSectionTile('💼 Career & Authority', activeMonth['career'], context),
                  const SizedBox(height: 12),
                  _buildSectionTile('💞 Relationships & Love', activeMonth['relationship'], context),
                  const SizedBox(height: 12),
                  _buildSectionTile('💰 Finance & Liquidity', activeMonth['finance'], context),
                  const SizedBox(height: 12),
                  _buildSectionTile('🌿 Health & Vitality', activeMonth['health'], context),
                  Divider(color: AppColors.getDivider(context), height: 24),

                  // Key Dates Badges
                  Text(
                    'Key Dates & Transits:',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (activeMonth['dates'] as List<String>).map((d) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.getBorder(context)),
                        ),
                        child: Text(
                          d,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.getTextSecondary(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTile(String title, String desc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          desc,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppColors.getTextSecondary(context),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
