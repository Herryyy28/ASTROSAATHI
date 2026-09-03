import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../kundli/presentation/widgets/biwheel_chart_painter.dart';

class SynastryCompositeScreen extends StatefulWidget {
  const SynastryCompositeScreen({super.key});

  @override
  State<SynastryCompositeScreen> createState() => _SynastryCompositeScreenState();
}

class _SynastryCompositeScreenState extends State<SynastryCompositeScreen> {
  final List<BiWheelPlanet> _personAPlanets = [
    BiWheelPlanet(name: 'Sun', longitude: 28.5, sign: 'Aries'),
    BiWheelPlanet(name: 'Moon', longitude: 120.2, sign: 'Leo'),
    BiWheelPlanet(name: 'Venus', longitude: 45.0, sign: 'Taurus'),
    BiWheelPlanet(name: 'Mars', longitude: 300.1, sign: 'Aquarius'),
  ];

  final List<BiWheelPlanet> _personBPlanets = [
    BiWheelPlanet(name: 'Sun', longitude: 125.0, sign: 'Leo', isOuter: true),
    BiWheelPlanet(name: 'Moon', longitude: 28.0, sign: 'Aries', isOuter: true),
    BiWheelPlanet(name: 'Venus', longitude: 302.0, sign: 'Aquarius', isOuter: true),
    BiWheelPlanet(name: 'Mars', longitude: 42.0, sign: 'Taurus', isOuter: true),
  ];

  final List<BiWheelAspectLine> _aspects = [
    BiWheelAspectLine(p1Name: 'Sun', p2Name: 'Moon', aspectType: 'Trine', color: const Color(0xFF00E5FF)),
    BiWheelAspectLine(p1Name: 'Venus', p2Name: 'Mars', aspectType: 'Conjunction', color: const Color(0xFFFFD700)),
    BiWheelAspectLine(p1Name: 'Mars', p2Name: 'Venus', aspectType: 'Conjunction', color: const Color(0xFFFFD700)),
  ];

  final List<Map<String, String>> _matrixItems = [
    {
      'pair': 'Person A Sun ↔ Person B Moon',
      'aspect': 'Trine (120°)',
      'score': '95% Soul Harmony',
      'desc': 'Deep emotional nurturing. Person A provides clarity and purpose, Person B provides safety and emotional security.',
    },
    {
      'pair': 'Person A Venus ↔ Person B Mars',
      'aspect': 'Conjunction (0°)',
      'score': '92% Attraction',
      'desc': 'Intense romantic magnetism and mutual passion. High physical alignment and shared artistic preferences.',
    },
    {
      'pair': 'Person A Saturn ↔ Person B Venus',
      'aspect': 'Trine (120°)',
      'score': '88% Commitment',
      'desc': 'Long-term structural stability. High loyalty and mutual financial responsibility over time.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final accentGold = isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          'Synastry & Composite Relationship Chart',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Score Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceElevated(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentGold.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accentGold.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '91%',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
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
                          'Soulmate Connection (High Harmony)',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: accentGold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Person A (Aries Sun) ↔ Person B (Leo Sun)',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
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

            // Synastry Bi-Wheel Chart Radar
            BiWheelChartWidget(
              innerTitle: 'Person A Chart',
              outerTitle: 'Person B Chart',
              innerPlanets: _personAPlanets,
              outerPlanets: _personBPlanets,
              aspectLines: _aspects,
            ),
            const SizedBox(height: 20),

            // Relationship Aspect Matrix Section
            Text(
              '✦ Interactive Relationship Aspect Matrix',
              style: GoogleFonts.outfit(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ..._matrixItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.getBorder(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['pair']!,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['score']!,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: accentGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aspect: ${item['aspect']}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['desc']!,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
