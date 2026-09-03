import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../home/presentation/widgets/add_event_modal.dart';

class FutureEventRadarScreen extends StatefulWidget {
  const FutureEventRadarScreen({super.key});

  @override
  State<FutureEventRadarScreen> createState() => _FutureEventRadarScreenState();
}

class _FutureEventRadarScreenState extends State<FutureEventRadarScreen> {
  int _selectedFilterDays = 90; // 30, 60, 90 days

  final List<Map<String, dynamic>> _allRadarEvents = [
    {
      'date': '12 Sep 2026',
      'daysAway': 9,
      'title': 'Jupiter Transit into 11th House of Gains',
      'category': 'Major Transit',
      'icon': Icons.stars_rounded,
      'color': Colors.amberAccent,
      'description': 'Jupiter moves into your 11th House, opening a 6-month window of heightened financial opportunities, network expansion, and business growth.',
    },
    {
      'date': '21 Sep 2026',
      'daysAway': 18,
      'title': 'Vimshottari Dasha Synergy Shift',
      'category': 'Dasha Transition',
      'icon': Icons.timeline_rounded,
      'color': Colors.cyanAccent,
      'description': 'Transition into Mercury Antardasha under Jupiter Mahadasha. Favorable for contract negotiations, strategic planning, and intellectual achievements.',
    },
    {
      'date': '05 Oct 2026',
      'daysAway': 32,
      'title': 'Mercury Direct in 10th House',
      'category': 'Planetary Direct',
      'icon': Icons.rotate_right_rounded,
      'color': Colors.greenAccent,
      'description': 'Mercury goes direct in your House of Career, clearing past communication delays and favoring public presentations or product launches.',
    },
    {
      'date': '18 Oct 2026',
      'daysAway': 45,
      'title': 'Venus Trine Natal Moon',
      'category': 'Benefic Aspect',
      'icon': Icons.favorite_rounded,
      'color': Colors.pinkAccent,
      'description': 'Venus forms a 120-degree trine with your natal Moon, enhancing personal charm, emotional harmony, and relationship milestones.',
    },
    {
      'date': '10 Nov 2026',
      'daysAway': 68,
      'title': 'Sun Enters Scorpio (Scorpio Ingress)',
      'category': 'Solar Ingress',
      'icon': Icons.wb_sunny_rounded,
      'color': Colors.orangeAccent,
      'description': 'Sun enters your 8th House of transformation and research. Excellent period for introspection, deep financial auditing, and spiritual practice.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final filteredEvents = _allRadarEvents.where((e) => (e['daysAway'] as int) <= _selectedFilterDays).toList();

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
                                  'Future Event Radar',
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
                                  '90 DAYS',
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
                            'Upcoming cosmic milestones & major transits',
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

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [30, 60, 90].map((days) {
                    final isSelected = _selectedFilterDays == days;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        showCheckmark: false,
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedFilterDays = days),
                        label: Text(
                          'Next $days Days',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                        side: BorderSide(color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.12)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Timeline List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final item = filteredEvents[index];
                    final color = item['color'] as Color;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        borderColor: color.withOpacity(0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.18),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(item['icon'] as IconData, size: 16, color: color),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['date'] as String,
                                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: color),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'In ${item['daysAway']} Days',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Text(
                              item['title'] as String,
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['description'] as String,
                              style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.getTextSecondary(context), height: 1.35),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      side: BorderSide(color: color.withOpacity(0.5)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: Icon(Icons.event_note_rounded, size: 14, color: color),
                                    label: Text('Schedule Event', style: GoogleFonts.outfit(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
                                    onPressed: () => AddEventModal.show(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: color.withOpacity(0.2),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color)),
                                    ),
                                    icon: const Icon(Icons.smart_toy_rounded, size: 14),
                                    label: Text('Ask AI', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AstroBabaScreen(
                                            initialMessage: 'Explain how ${item['title']} on ${item['date']} will impact my natal chart.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
