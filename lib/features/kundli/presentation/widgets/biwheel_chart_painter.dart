import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class BiWheelPlanet {
  final String name;
  final double longitude;
  final String sign;
  final bool isOuter;

  BiWheelPlanet({
    required this.name,
    required this.longitude,
    required this.sign,
    this.isOuter = false,
  });
}

class BiWheelAspectLine {
  final String p1Name;
  final String p2Name;
  final String aspectType; // Trine, Square, Opposition, Conjunction
  final Color color;

  BiWheelAspectLine({
    required this.p1Name,
    required this.p2Name,
    required this.aspectType,
    required this.color,
  });
}

class BiWheelChartWidget extends StatelessWidget {
  final String innerTitle;
  final String outerTitle;
  final List<BiWheelPlanet> innerPlanets;
  final List<BiWheelPlanet> outerPlanets;
  final List<BiWheelAspectLine> aspectLines;

  const BiWheelChartWidget({
    super.key,
    required this.innerTitle,
    required this.outerTitle,
    required this.innerPlanets,
    required this.outerPlanets,
    this.aspectLines = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final natalColor = isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700);
    final transitColor = isLight ? const Color(0xFF00897B) : const Color(0xFF00E5FF);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceElevated(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getBorder(context), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLight ? 0.04 : 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTitleBadge(innerTitle, natalColor, context),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isLight ? AppColors.surfaceLight : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorder(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: 14,
                      color: isLight ? const Color(0xFF2E8B68) : const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Calculated Provenance',
                      style: GoogleFonts.outfit(
                        color: AppColors.getTextSecondary(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTitleBadge(outerTitle, transitColor, context),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final chartSize = math.min(constraints.maxWidth, 320.0);
              return SizedBox(
                width: chartSize,
                height: chartSize,
                child: CustomPaint(
                  painter: BiWheelChartPainter(
                    innerPlanets: innerPlanets,
                    outerPlanets: outerPlanets,
                    aspectLines: aspectLines,
                    isLight: isLight,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildTitleBadge(String title, Color color, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.outfit(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    final isLight = AppColors.isLight(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Trine (120°)', isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF), context),
        const SizedBox(width: 12),
        _buildLegendItem('Square (90°)', isLight ? const Color(0xFFC62828) : const Color(0xFFFF1744), context),
        const SizedBox(width: 12),
        _buildLegendItem('Opp (180°)', isLight ? const Color(0xFFB87308) : const Color(0xFFFFC107), context),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: AppColors.getTextMuted(context),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class BiWheelChartPainter extends CustomPainter {
  final List<BiWheelPlanet> innerPlanets;
  final List<BiWheelPlanet> outerPlanets;
  final List<BiWheelAspectLine> aspectLines;
  final bool isLight;

  BiWheelChartPainter({
    required this.innerPlanets,
    required this.outerPlanets,
    required this.aspectLines,
    this.isLight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 10;
    final middleRadius = outerRadius - 32;
    final innerRadius = middleRadius - 32;

    final paintGrid = Paint()
      ..color = isLight ? const Color(0xFFB0BAC5) : const Color(0xFF2A3655)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw Rings
    canvas.drawCircle(center, outerRadius, paintGrid);
    canvas.drawCircle(center, middleRadius, paintGrid);
    canvas.drawCircle(center, innerRadius, paintGrid);

    // Draw 12 Zodiac Sector Spoke Lines
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final pOuter = Offset(center.dx + outerRadius * math.cos(angle), center.dy + outerRadius * math.sin(angle));
      final pInner = Offset(center.dx + innerRadius * math.cos(angle), center.dy + innerRadius * math.sin(angle));
      canvas.drawLine(pInner, pOuter, paintGrid);
    }

    // Map Planet Positions into Offset Coordinates
    final Map<String, Offset> planetPositions = {};

    // Inner Ring Planets (Natal: Gold/Amber)
    final natalColor = isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700);
    final textStyleInner = GoogleFonts.outfit(color: natalColor, fontSize: 10, fontWeight: FontWeight.bold);
    for (var p in innerPlanets) {
      final rad = (p.longitude - 90) * (math.pi / 180);
      final r = (innerRadius + middleRadius) / 2;
      final pos = Offset(center.dx + r * math.cos(rad), center.dy + r * math.sin(rad));
      planetPositions['inner_${p.name}'] = pos;

      canvas.drawCircle(pos, 3, Paint()..color = natalColor);
      _drawText(canvas, p.name.substring(0, math.min(2, p.name.length)), pos.translate(-6, -14), textStyleInner);
    }

    // Outer Ring Planets (Transits: Cyan/Teal)
    final transitColor = isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF);
    final textStyleOuter = GoogleFonts.outfit(color: transitColor, fontSize: 10, fontWeight: FontWeight.bold);
    for (var p in outerPlanets) {
      final rad = (p.longitude - 90) * (math.pi / 180);
      final r = (middleRadius + outerRadius) / 2;
      final pos = Offset(center.dx + r * math.cos(rad), center.dy + r * math.sin(rad));
      planetPositions['outer_${p.name}'] = pos;

      canvas.drawCircle(pos, 3, Paint()..color = transitColor);
      _drawText(canvas, p.name.substring(0, math.min(2, p.name.length)), pos.translate(-6, -14), textStyleOuter);
    }

    // Draw Aspect Lines Across Center
    for (var aspect in aspectLines) {
      final pos1 = planetPositions['inner_${aspect.p1Name}'] ?? planetPositions['outer_${aspect.p1Name}'];
      final pos2 = planetPositions['outer_${aspect.p2Name}'] ?? planetPositions['inner_${aspect.p2Name}'];

      if (pos1 != null && pos2 != null) {
        final lineCol = isLight
            ? (aspect.aspectType == 'Trine'
                ? const Color(0xFF00796B)
                : aspect.aspectType == 'Square'
                    ? const Color(0xFFC62828)
                    : const Color(0xFFB87308))
            : aspect.color;

        final aspectPaint = Paint()
          ..color = lineCol.withOpacity(0.85)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(pos1, pos2, aspectPaint);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant BiWheelChartPainter oldDelegate) => true;
}

