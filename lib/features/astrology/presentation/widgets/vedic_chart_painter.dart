import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum VedicChartStyle { northIndian, southIndian }

/// Static geometry hit-testing utilities for Vedic Chart
class VedicChartGeometry {
  /// Ray-casting point-in-polygon algorithm
  static bool isPointInPolygon(Offset p, List<Offset> polygon) {
    if (polygon.length < 3) return false;
    bool isInside = false;
    int j = polygon.length - 1;
    for (int i = 0; i < polygon.length; i++) {
      if ((polygon[i].dy > p.dy) != (polygon[j].dy > p.dy) &&
          (p.dx <
              (polygon[j].dx - polygon[i].dx) *
                      (p.dy - polygon[i].dy) /
                      (polygon[j].dy - polygon[i].dy) +
                  polygon[i].dx)) {
        isInside = !isInside;
      }
      j = i;
    }
    return isInside;
  }

  /// North Indian 12 House Polygons
  static List<Offset> getNorthIndianHousePolygon(int house, Size size) {
    final w = size.width;
    final h = size.height;
    switch (house) {
      case 1:
        return [Offset(w / 2, 0), Offset(3 * w / 4, h / 4), Offset(w / 2, h / 2), Offset(w / 4, h / 4)];
      case 2:
        return [Offset(0, 0), Offset(w / 2, 0), Offset(w / 4, h / 4)];
      case 3:
        return [Offset(0, 0), Offset(w / 4, h / 4), Offset(0, h / 2)];
      case 4:
        return [Offset(0, h / 2), Offset(w / 4, h / 4), Offset(w / 2, h / 2), Offset(w / 4, 3 * h / 4)];
      case 5:
        return [Offset(0, h / 2), Offset(w / 4, 3 * h / 4), Offset(0, h)];
      case 6:
        return [Offset(0, h), Offset(w / 4, 3 * h / 4), Offset(w / 2, h)];
      case 7:
        return [Offset(w / 2, h / 2), Offset(3 * w / 4, 3 * h / 4), Offset(w / 2, h), Offset(w / 4, 3 * h / 4)];
      case 8:
        return [Offset(w / 2, h), Offset(3 * w / 4, 3 * h / 4), Offset(w, h)];
      case 9:
        return [Offset(w, h / 2), Offset(3 * w / 4, 3 * h / 4), Offset(w, h)];
      case 10:
        return [Offset(w / 2, h / 2), Offset(3 * w / 4, h / 4), Offset(w, h / 2), Offset(3 * w / 4, 3 * h / 4)];
      case 11:
        return [Offset(w, 0), Offset(3 * w / 4, h / 4), Offset(w, h / 2)];
      case 12:
        return [Offset(w / 2, 0), Offset(3 * w / 4, h / 4), Offset(w, 0)];
      default:
        return [];
    }
  }

  /// Center positions for the 12 North Indian Houses
  static Offset getNorthIndianHouseCenter(int house, Size size) {
    final w = size.width;
    final h = size.height;
    final Map<int, Offset> centers = {
      1: Offset(w / 2, h / 4),
      2: Offset(w / 4, h / 8),
      3: Offset(w / 8, h / 4),
      4: Offset(w / 4, h / 2),
      5: Offset(w / 8, 3 * h / 4),
      6: Offset(w / 4, 7 * h / 8),
      7: Offset(w / 2, 3 * h / 4),
      8: Offset(3 * w / 4, 7 * h / 8),
      9: Offset(7 * w / 8, 3 * h / 4),
      10: Offset(3 * w / 4, h / 2),
      11: Offset(7 * w / 8, h / 4),
      12: Offset(3 * w / 4, h / 8),
    };
    return centers[house] ?? Offset(w / 2, h / 2);
  }

  /// South Indian 4x4 Perimeter Grid Mapping
  static const List<List<int>> southIndianGrid = [
    [12, 1, 2, 3],
    [11, -1, -1, 4],
    [10, -1, -1, 5],
    [9, 8, 7, 6],
  ];

  static int getSouthIndianSignAt(Offset p, Size size) {
    final colW = size.width / 4;
    final rowH = size.height / 4;
    final col = (p.dx / colW).floor().clamp(0, 3);
    final row = (p.dy / rowH).floor().clamp(0, 3);
    return southIndianGrid[row][col];
  }

  static Offset getSouthIndianCellCenter(int sign, Size size) {
    final colW = size.width / 4;
    final rowH = size.height / 4;
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (southIndianGrid[r][c] == sign) {
          return Offset(c * colW + colW / 2, r * rowH + rowH / 2);
        }
      }
    }
    return Offset(size.width / 2, size.height / 2);
  }

  /// Hit test house at local touch position
  static int hitTestHouse({
    required Offset localPosition,
    required Size size,
    required VedicChartStyle style,
    required int lagnaSignIndex,
  }) {
    if (localPosition.dx < 0 || localPosition.dx > size.width ||
        localPosition.dy < 0 || localPosition.dy > size.height) {
      return 0;
    }

    if (style == VedicChartStyle.southIndian) {
      final sign = getSouthIndianSignAt(localPosition, size);
      if (sign <= 0) return 0;
      int house = ((sign - lagnaSignIndex + 12) % 12) + 1;
      return house;
    } else {
      for (int h = 1; h <= 12; h++) {
        final poly = getNorthIndianHousePolygon(h, size);
        if (isPointInPolygon(localPosition, poly)) {
          return h;
        }
      }
      return 0;
    }
  }

  /// Hit test planet at local touch position
  static String? hitTestPlanet({
    required Offset localPosition,
    required Size size,
    required VedicChartStyle style,
    required int lagnaSignIndex,
    required Map<int, List<String>> housePlanets,
    double touchRadius = 26.0,
  }) {
    final Map<String, Offset> planetPositions = getPlanetPositions(
      size: size,
      style: style,
      lagnaSignIndex: lagnaSignIndex,
      housePlanets: housePlanets,
    );

    String? closestPlanet;
    double minDistance = touchRadius;

    planetPositions.forEach((planet, center) {
      final dist = (localPosition - center).distance;
      if (dist < minDistance) {
        minDistance = dist;
        closestPlanet = planet;
      }
    });

    return closestPlanet;
  }

  /// Calculate offsets of each planet rendered on the chart
  static Map<String, Offset> getPlanetPositions({
    required Size size,
    required VedicChartStyle style,
    required int lagnaSignIndex,
    required Map<int, List<String>> housePlanets,
  }) {
    final Map<String, Offset> positions = {};

    housePlanets.forEach((house, planets) {
      if (planets.isEmpty) return;

      Offset baseCenter;
      if (style == VedicChartStyle.southIndian) {
        final sign = ((house - 1 + lagnaSignIndex - 1) % 12) + 1;
        baseCenter = getSouthIndianCellCenter(sign, size);
      } else {
        baseCenter = getNorthIndianHouseCenter(house, size);
      }

      if (planets.length == 1) {
        positions[planets[0]] = baseCenter;
      } else {
        final double spacing = 16.0;
        final int count = planets.length;
        final double startX = baseCenter.dx - ((count - 1) * spacing) / 2;
        for (int i = 0; i < count; i++) {
          positions[planets[i]] = Offset(startX + i * spacing, baseCenter.dy);
        }
      }
    });

    return positions;
  }
}

class VedicChartPainter extends CustomPainter {
  final Map<int, List<String>> housePlanets;
  final BuildContext context;
  final VedicChartStyle style;
  final int lagnaSignIndex;
  final int? selectedHouse;
  final String? selectedPlanet;

  VedicChartPainter({
    required this.housePlanets,
    required this.context,
    this.style = VedicChartStyle.northIndian,
    this.lagnaSignIndex = 1,
    this.selectedHouse,
    this.selectedPlanet,
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
      ..color = lineColor.withValues(alpha: 0.18)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Outer box
    final Rect outerRect = Rect.fromLTWH(0, 0, width, height);
    final RRect outerRRect = RRect.fromRectAndRadius(outerRect, const Radius.circular(14));

    // ── Selected House Highlight ─────────────────────────────
    if (selectedHouse != null && selectedHouse! >= 1 && selectedHouse! <= 12) {
      final highlightFill = Paint()
        ..color = lineColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;
      final highlightStroke = Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      if (style == VedicChartStyle.southIndian) {
        final sign = ((selectedHouse! - 1 + lagnaSignIndex - 1) % 12) + 1;
        final colW = width / 4;
        final rowH = height / 4;
        for (int r = 0; r < 4; r++) {
          for (int c = 0; c < 4; c++) {
            if (VedicChartGeometry.southIndianGrid[r][c] == sign) {
              final cellRect = Rect.fromLTWH(c * colW, r * rowH, colW, rowH);
              canvas.drawRect(cellRect, highlightFill);
              canvas.drawRect(cellRect, highlightStroke);
            }
          }
        }
      } else {
        final polygon = VedicChartGeometry.getNorthIndianHousePolygon(selectedHouse!, size);
        if (polygon.isNotEmpty) {
          final path = Path()..moveTo(polygon[0].dx, polygon[0].dy);
          for (int i = 1; i < polygon.length; i++) {
            path.lineTo(polygon[i].dx, polygon[i].dy);
          }
          path.close();
          canvas.drawPath(path, highlightFill);
          canvas.drawPath(path, highlightStroke);
        }
      }
    }

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
          color: lineColor.withValues(alpha: 0.4),
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

      final Map<int, List<int>> southIndianGridMap = {
        12: [0, 0], 1: [1, 0], 2: [2, 0], 3: [3, 0],
        4: [3, 1], 5: [3, 2], 6: [3, 3], 7: [2, 3],
        8: [1, 3], 9: [0, 3], 10: [0, 2], 11: [0, 1],
      };

      final signLabels = {
        1: 'Mesha (Ar)', 2: 'Vrish (Ta)', 3: 'Mith (Ge)', 4: 'Kark (Ca)',
        5: 'Simh (Le)', 6: 'Kany (Vi)', 7: 'Tula (Li)', 8: 'Vrisch (Sc)',
        9: 'Dhan (Sg)', 10: 'Maka (Cp)', 11: 'Kumb (Aq)', 12: 'Meen (Pi)',
      };

      southIndianGridMap.forEach((sign, pos) {
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
            color: isLagna ? lineColor : lineColor.withValues(alpha: 0.65),
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

      // Draw diagonals
      canvas.drawLine(const Offset(0, 0), Offset(width, height), glowPaint);
      canvas.drawLine(const Offset(0, 0), Offset(width, height), paint);

      canvas.drawLine(Offset(width, 0), Offset(0, height), glowPaint);
      canvas.drawLine(Offset(width, 0), Offset(0, height), paint);

      // Draw inner diamond
      final Path diamondPath = Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width, height / 2)
        ..lineTo(width / 2, height)
        ..lineTo(0, height / 2)
        ..close();

      canvas.drawPath(diamondPath, glowPaint);
      canvas.drawPath(diamondPath, paint);

      canvas.restore();

      // Draw Sign Numbers inside North Indian Houses
      for (int h = 1; h <= 12; h++) {
        final signNumber = ((lagnaSignIndex - 1 + h - 1) % 12) + 1;
        final center = VedicChartGeometry.getNorthIndianHouseCenter(h, size);
        final isLagnaHouse = h == 1;

        // Position sign number slightly offset from center
        textPainter.text = TextSpan(
          text: '$signNumber',
          style: TextStyle(
            color: isLagnaHouse ? lineColor : lineColor.withValues(alpha: 0.4),
            fontSize: isLagnaHouse ? 10.0 : 8.5,
            fontWeight: isLagnaHouse ? FontWeight.bold : FontWeight.w600,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 - 12),
        );
      }

      // Draw Planets inside North Indian Houses
      for (int h = 1; h <= 12; h++) {
        final planets = housePlanets[h] ?? [];
        if (planets.isEmpty) continue;

        final center = VedicChartGeometry.getNorthIndianHouseCenter(h, size);
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
          Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 + 2),
        );
      }
    }

    // ── Selected Planet Highlight Ring ─────────────────────────────
    if (selectedPlanet != null && selectedPlanet!.isNotEmpty) {
      final planetPositions = VedicChartGeometry.getPlanetPositions(
        size: size,
        style: style,
        lagnaSignIndex: lagnaSignIndex,
        housePlanets: housePlanets,
      );

      final center = planetPositions[selectedPlanet];
      if (center != null) {
        final ringPaint = Paint()
          ..color = lineColor
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        final ringGlow = Paint()
          ..color = lineColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(center, 15.0, ringGlow);
        canvas.drawCircle(center, 15.0, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VedicChartPainter oldDelegate) =>
      oldDelegate.housePlanets != housePlanets ||
      oldDelegate.context != context ||
      oldDelegate.style != style ||
      oldDelegate.lagnaSignIndex != lagnaSignIndex ||
      oldDelegate.selectedHouse != selectedHouse ||
      oldDelegate.selectedPlanet != selectedPlanet;
}

