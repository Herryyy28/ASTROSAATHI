import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class SkyNowEphemerisScreen extends StatefulWidget {
  const SkyNowEphemerisScreen({super.key});

  @override
  State<SkyNowEphemerisScreen> createState() => _SkyNowEphemerisScreenState();
}

class _SkyNowEphemerisScreenState extends State<SkyNowEphemerisScreen> {
  int _selectedView = 0; // 0: Sky Now Live, 1: Planetary Ephemeris Table

  final List<Map<String, String>> _liveSkyData = [
    {'planet': 'Sun ☀️', 'position': 'Virgo 14° 22\'', 'house': '10th House', 'state': 'Direct'},
    {'planet': 'Moon 🌙', 'position': 'Aquarius 08° 45\'', 'house': '5th House', 'state': 'Direct'},
    {'planet': 'Mercury ☿', 'position': 'Virgo 02° 18\'', 'house': '10th House', 'state': 'Exalted'},
    {'planet': 'Venus ♀', 'position': 'Leo 21° 50\'', 'house': '9th House', 'state': 'Direct'},
    {'planet': 'Mars ♂', 'position': 'Gemini 18° 10\'', 'house': '7th House', 'state': 'Direct'},
    {'planet': 'Jupiter ♃', 'position': 'Cancer 11° 30\'', 'house': '8th House', 'state': 'Exalted'},
    {'planet': 'Saturn ♄', 'position': 'Aquarius 29° 12\'', 'house': '5th House', 'state': 'Own Sign'},
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
                                  'Sky Now & Ephemeris',
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
                                  'LIVE CLOCK',
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
                            'Live planetary coordinates & tables',
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

              // View Selector Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        showCheckmark: false,
                        selected: _selectedView == 0,
                        onSelected: (_) => setState(() => _selectedView = 0),
                        avatar: const Icon(Icons.access_time_filled_rounded, size: 16, color: AppColors.primary),
                        label: Text('Sky Now (Live Clock)', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        showCheckmark: false,
                        selected: _selectedView == 1,
                        onSelected: (_) => setState(() => _selectedView = 1),
                        avatar: const Icon(Icons.table_chart_rounded, size: 16, color: Colors.cyanAccent),
                        label: Text('Ephemeris Table', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _liveSkyData.length,
                  itemBuilder: (context, index) {
                    final item = _liveSkyData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(item['planet']!, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(item['position']!, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  Text('${item['house']} • ${item['state']}', style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.getTextSecondary(context))),
                                ],
                              ),
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
