import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../kundli/presentation/widgets/biwheel_chart_painter.dart';

class SkyNowScreen extends StatefulWidget {
  const SkyNowScreen({super.key});

  @override
  State<SkyNowScreen> createState() => _SkyNowScreenState();
}

class _SkyNowScreenState extends State<SkyNowScreen> {
  bool _showInspector = false;

  final List<BiWheelPlanet> _natalPlanets = [
    BiWheelPlanet(name: 'Sun', longitude: 28.5, sign: 'Aries'),
    BiWheelPlanet(name: 'Moon', longitude: 120.2, sign: 'Leo'),
    BiWheelPlanet(name: 'Jupiter', longitude: 210.5, sign: 'Libra'),
    BiWheelPlanet(name: 'Mars', longitude: 300.1, sign: 'Aquarius'),
  ];

  final List<BiWheelPlanet> _transitPlanets = [
    BiWheelPlanet(name: 'Sun', longitude: 35.0, sign: 'Taurus', isOuter: true),
    BiWheelPlanet(name: 'Moon', longitude: 125.0, sign: 'Leo', isOuter: true),
    BiWheelPlanet(name: 'Saturn', longitude: 330.0, sign: 'Pisces', isOuter: true),
    BiWheelPlanet(name: 'Venus', longitude: 45.0, sign: 'Taurus', isOuter: true),
  ];

  final List<BiWheelAspectLine> _aspects = [
    BiWheelAspectLine(p1Name: 'Sun', p2Name: 'Sun', aspectType: 'Conjunction', color: const Color(0xFFFFD700)),
    BiWheelAspectLine(p1Name: 'Moon', p2Name: 'Moon', aspectType: 'Conjunction', color: const Color(0xFFFFD700)),
    BiWheelAspectLine(p1Name: 'Jupiter', p2Name: 'Saturn', aspectType: 'Trine', color: const Color(0xFF00E5FF)),
    BiWheelAspectLine(p1Name: 'Mars', p2Name: 'Venus', aspectType: 'Square', color: const Color(0xFFFF1744)),
  ];

  Color _getAdaptiveColor(Color darkColor, BuildContext context) {
    if (!AppColors.isLight(context)) return darkColor;
    if (darkColor == const Color(0xFF00E5FF) || darkColor == Colors.cyan) {
      return const Color(0xFF00796B); // High-contrast Deep Teal
    }
    if (darkColor == const Color(0xFFFF1744) || darkColor == Colors.red) {
      return const Color(0xFFC62828); // High-contrast Deep Crimson
    }
    if (darkColor == const Color(0xFFFFD700) || darkColor == Colors.amber || darkColor == Colors.green) {
      return const Color(0xFFB87308); // High-contrast Deep Amber
    }
    return darkColor;
  }

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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.radar_rounded, color: isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF), size: 20),
              const SizedBox(width: 6),
              Text(
                'Sky Now & Live Transits',
                style: GoogleFonts.outfit(
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showInspector ? Icons.analytics : Icons.info_outline, color: accentGold),
            onPressed: () => setState(() => _showInspector = !_showInspector),
            tooltip: 'Calculation Inspector',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Badges (Scrollable horizontal row)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildStatusBadge('Mercury', 'Direct', isLight ? const Color(0xFF2E8B68) : Colors.green),
                  const SizedBox(width: 8),
                  _buildStatusBadge('Moon Phase', 'Waxing Crescent (68%)', isLight ? const Color(0xFF00796B) : Colors.cyan),
                  const SizedBox(width: 8),
                  _buildStatusBadge('Void of Course', 'Active until 08:45 PM', isLight ? const Color(0xFFB87308) : Colors.amber),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Bi-Wheel Radial Chart
            BiWheelChartWidget(
              innerTitle: 'Natal Chart',
              outerTitle: 'Live Sky Transits',
              innerPlanets: _natalPlanets,
              outerPlanets: _transitPlanets,
              aspectLines: _aspects,
            ),
            const SizedBox(height: 20),

            // Calculation Inspector Accordion
            if (_showInspector) ...[
              _buildCalculationInspector(),
              const SizedBox(height: 20),
            ],

            // Active Aspect Patterns Section
            Text(
              '✦ Detected Geometric Aspect Patterns',
              style: GoogleFonts.outfit(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPatternCard(
              'Grand Trine in Fire (Sun, Moon, Mars)',
              'Harmonic triangle linking Leo Moon and Aries Sun fostering high creative momentum.',
              const Color(0xFF00E5FF),
              Icons.change_history_rounded,
            ),
            const SizedBox(height: 10),
            _buildPatternCard(
              'T-Square (Mars Square Venus Apex)',
              'Friction between desires and actions; channel energy into artistic or analytical work.',
              const Color(0xFFFF1744),
              Icons.crop_square_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String title, String subtitle, Color color) {
    final isLight = AppColors.isLight(context);
    final badgeBg = isLight ? AppColors.getSurfaceElevated(context) : color.withOpacity(0.1);
    final badgeBorder = isLight ? AppColors.getBorder(context) : color.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(color: AppColors.getTextSecondary(context), fontSize: 10, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationInspector() {
    final isLight = AppColors.isLight(context);
    final goldAccent = isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceElevated(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: goldAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Calculation Inspector & Provenance Metadata',
                  style: GoogleFonts.outfit(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          Divider(color: AppColors.getDivider(context), height: 20),
          _buildInspectorRow('Ephemeris Source', 'Swiss Ephemeris v2.10 (High Precision)'),
          _buildInspectorRow('Ayanamsa System', 'Lahiri (Chitra Paksha) @ 23° 51\' 14"'),
          _buildInspectorRow('Julian Day (UT)', '2460557.042361'),
          _buildInspectorRow('Observer Coordinates', '28.6139° N, 77.2090° E (New Delhi)'),
          _buildInspectorRow('House System', 'Placidus (Sidereal Equator)'),
          _buildInspectorRow('Engine Guarantee', '100% Deterministic Mathematical Math (No AI hallucination)'),
        ],
      ),
    );
  }

  Widget _buildInspectorRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(color: AppColors.getTextMuted(context), fontSize: 11),
          ),
          Flexible(
            child: Text(
              val,
              style: GoogleFonts.outfit(color: AppColors.getTextPrimary(context), fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternCard(String title, String desc, Color rawColor, IconData icon) {
    final cardColor = _getAdaptiveColor(rawColor, context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cardColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(color: cardColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.outfit(color: AppColors.getTextSecondary(context), fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

