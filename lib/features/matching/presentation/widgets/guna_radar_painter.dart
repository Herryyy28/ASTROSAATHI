import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GunaRadarPainter extends CustomPainter {
  final Map<String, double> scores; // normalized score 0.0 - 1.0 per Guna

  GunaRadarPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.4;

    final categories = scores.keys.toList();
    final count = categories.length;

    if (count == 0) return;

    final gridPaint = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = AppColors.glassBorder.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric polygon rings
    final rings = 4;
    for (int i = 1; i <= rings; i++) {
      final r = radius * (i / rings);
      final path = Path();
      for (int j = 0; j < count; j++) {
        final angle = (j * 2 * pi / count) - (pi / 2);
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (j == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw spokes and labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final scorePath = Path();
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * pi / count) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      // Axis spoke
      canvas.drawLine(center, Offset(x, y), axisPaint);

      // Score point
      final scoreRatio = (scores[categories[i]] ?? 0.5).clamp(0.1, 1.0);
      final scoreX = center.dx + (radius * scoreRatio) * cos(angle);
      final scoreY = center.dy + (radius * scoreRatio) * sin(angle);

      if (i == 0) scorePath.moveTo(scoreX, scoreY);
      else scorePath.lineTo(scoreX, scoreY);

      // Draw label
      final labelRadius = radius + 22;
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle);

      textPainter.text = TextSpan(
        text: categories[i],
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );
    }
    scorePath.close();

    // Fill score area with glow gradient
    final fillPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(scorePath, fillPaint);
    canvas.drawPath(scorePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant GunaRadarPainter oldDelegate) => true;
}
