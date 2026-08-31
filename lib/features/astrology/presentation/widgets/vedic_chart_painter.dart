import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class VedicChartPainter extends CustomPainter {
  final Map<int, List<String>> housePlanets;

  VedicChartPainter({required this.housePlanets});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    // Draw the outer square
    final Rect outerRect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(outerRect, glowPaint);
    canvas.drawRect(outerRect, paint);

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

    // Draw text for houses
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    void drawPlanets(int house, Offset center) {
      final planets = housePlanets[house] ?? [];
      if (planets.isEmpty) return;

      final text = planets.join(', ');
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 9.5,
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

  @override
  bool shouldRepaint(covariant VedicChartPainter oldDelegate) =>
      oldDelegate.housePlanets != housePlanets;
}
