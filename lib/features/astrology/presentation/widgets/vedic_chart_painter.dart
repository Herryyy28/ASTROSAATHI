import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum VedicChartStyle { northIndian, southIndian }

class VedicChartPainter extends CustomPainter {
  final Map<int, List<String>> housePlanets;
  final BuildContext context;
  final VedicChartStyle style;
  final int lagnaSignIndex;

  VedicChartPainter({
    required this.housePlanets,
    required this.context,
    this.style = VedicChartStyle.northIndian,
    this.lagnaSignIndex = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final isLight = AppColors.isLight(context);

    // Fixed Chart Background: #FFFFFF (Light) / #111827 (Dark)
    final bgPaint = Paint()
      ..color = isLight ? const Color(0xFFFFFFFF) : const Color(0xFF111827)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, height), const Radius.circular(14)),
      bgPaint,
    );

    // Fixed Chart Lines: #D9901A (Light) / #E0A13A (Dark)
    final lineColor = isLight ? const Color(0xFFD9901A) : const Color(0xFFE0A13A);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = lineColor.withOpacity(0.18)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Draw the outer square
    final Rect outerRect = Rect.fromLTWH(0, 0, width, height);
    final RRect outerRRect = RRect.fromRectAndRadius(outerRect, const Radius.circular(14));
    
    // Draw outer rounded box border
    canvas.drawRRect(outerRRect, glowPaint);
    canvas.drawRRect(outerRRect, paint);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    if (style == VedicChartStyle.southIndian) {
      // ── South Indian 4x4 Perimeter Grid ────────────────
      final colW = width / 4;
      final rowH = height / 4;

      canvas.save();
      canvas.clipRRect(outerRRect);

      // Horizontal lines
      for (int r = 1; r < 4; r++) {
        canvas.drawLine(Offset(0, r * rowH), Offset(width, r * rowH), paint);
      }
      // Vertical lines
      for (int c = 1; c < 4; c++) {
        canvas.drawLine(Offset(c * colW, 0), Offset(c * colW, height), paint);
      }

      // Fill center 2x2 box with subtle dark tint
      final centerRect = Rect.fromLTWH(colW, rowH, 2 * colW, 2 * rowH);
      final centerPaint = Paint()
        ..color = isLight ? const Color(0xFFF3F4F6) : const Color(0xFF0F172A)
        ..style = PaintingStyle.fill;
      canvas.drawRect(centerRect, centerPaint);

      // Center Watermark
      textPainter.text = TextSpan(
        text: 'SOUTH INDIAN\nKUNDLI',
        style: TextStyle(
          color: lineColor.withOpacity(0.4),
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          height: 1.3,
        ),
      );
      textPainter.layout(maxWidth: 2 * colW);
      textPainter.paint(
        canvas,
        Offset(width / 2 - textPainter.width / 2, height / 2 - textPainter.height / 2),
      );

      // Map 12 perimeter cells: {sign: (col, row)}
      final Map<int, List<int>> southIndianGrid = {
        12: [0, 0], // Pisces
        1: [1, 0],  // Aries
        2: [2, 0],  // Taurus
        3: [3, 0],  // Gemini
        4: [3, 1],  // Cancer
        5: [3, 2],  // Leo
        6: [3, 3],  // Virgo
        7: [2, 3],  // Libra
        8: [1, 3],  // Scorpio
        9: [0, 3],  // Sagittarius
        10: [0, 2], // Capricorn
        11: [0, 1], // Aquarius
      };

      final signLabels = {
        1: 'Mesha (Ar)', 2: 'Vrish (Ta)', 3: 'Mith (Ge)', 4: 'Kark (Ca)',
        5: 'Simh (Le)', 6: 'Kany (Vi)', 7: 'Tula (Li)', 8: 'Vrisch (Sc)',
        9: 'Dhan (Sg)', 10: 'Maka (Cp)', 11: 'Kumb (Aq)', 12: 'Meen (Pi)',
      };

      southIndianGrid.forEach((sign, pos) {
        final col = pos[0];
        final row = pos[1];
        final cellLeft = col * colW;
        final cellTop = row * rowH;

        final int house = ((sign - lagnaSignIndex + 12) % 12) + 1;
        final isLagna = house == 1;

        // Draw Sign Header & House / ASC
        final headerText = isLagna ? '★ Lagna (H1)' : 'H$house ${signLabels[sign]!.split(' ').last}';
        textPainter.text = TextSpan(
          text: headerText,
          style: TextStyle(
            color: isLagna ? lineColor : lineColor.withOpacity(0.65),
            fontSize: isLagna ? 8.5 : 7.5,
            fontWeight: isLagna ? FontWeight.bold : FontWeight.w500,
          ),
        );
        textPainter.layout(maxWidth: colW - 6);
        textPainter.paint(canvas, Offset(cellLeft + (colW - textPainter.width) / 2, cellTop + 4));

        // Draw Planets residing in this house
        final planets = housePlanets[house] ?? [];
        if (planets.isNotEmpty) {
          textPainter.text = TextSpan(
            text: planets.join(', '),
            style: TextStyle(
              color: lineColor,
              fontSize: 9.0,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          );
          textPainter.layout(maxWidth: colW - 8);
          textPainter.paint(
            canvas,
            Offset(cellLeft + (colW - textPainter.width) / 2, cellTop + rowH / 2 - textPainter.height / 2 + 3),
          );
        }
      });

      canvas.restore();
    } else {
      // ── North Indian Diamond Layout ────────────────────
      canvas.save();
      canvas.clipRRect(outerRRect);

      // Draw the diagonals
      canvas.drawLine(const Offset(0, 0), Offset(width, height), glowPaint);
      canvas.drawLine(const Offset(0, 0), Offset(width, height), paint);

      canvas.drawLine(Offset(width, 0), Offset(0, height), glowPaint);
      canvas.drawLine(Offset(width, 0), Offset(0, height), paint);

      // Draw the inner diamond
      final Path diamondPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height / 2)
        ..lineTo(width / 2, height)
        ..lineTo(0, height / 2)
        ..close();

      canvas.drawPath(diamondPath, glowPaint);
      canvas.drawPath(diamondPath, paint);

      canvas.restore();

      void drawPlanets(int house, Offset center) {
        final planets = housePlanets[house] ?? [];
        if (planets.isEmpty) return;

        final text = planets.join(', ');
        textPainter.text = TextSpan(
          text: text,
          style: TextStyle(
            color: lineColor,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        );
        textPainter.layout(maxWidth: width / 3.8);
        textPainter.paint(
          canvas,
          Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
        );
      }

      // Coordinates for the 12 houses (Vedic layout)
      final Map<int, Offset> houseCenters = {
        1: Offset(width / 2, height / 4),
        2: Offset(width / 4, height / 8),
        3: Offset(width / 8, height / 4),
        4: Offset(width / 4, height / 2),
        5: Offset(width / 8, height * 0.75),
        6: Offset(width / 4, height * 0.875),
        7: Offset(width / 2, height * 0.75),
        8: Offset(width * 0.75, height * 0.875),
        9: Offset(width * 0.875, height * 0.75),
        10: Offset(width * 0.75, height / 2),
        11: Offset(width * 0.875, height / 4),
        12: Offset(width * 0.75, height / 8),
      };

      houseCenters.forEach((house, center) {
        drawPlanets(house, center);
      });
    }
  }

  @override
  bool shouldRepaint(covariant VedicChartPainter oldDelegate) =>
      oldDelegate.housePlanets != housePlanets || oldDelegate.context != context;
}
