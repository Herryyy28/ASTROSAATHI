import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:AstroSaathi/features/astrology/presentation/widgets/vedic_chart_painter.dart';

void main() {
  group('VedicChartGeometry Hit Detection Tests', () {
    const size = Size(360, 360);

    test('North Indian house hit detection - House 1 (Lagna)', () {
      final centerHouse1 = Offset(180, 90); // (w/2, h/4)
      final house = VedicChartGeometry.hitTestHouse(
        localPosition: centerHouse1,
        size: size,
        style: VedicChartStyle.northIndian,
        lagnaSignIndex: 1,
      );
      expect(house, equals(1));
    });

    test('North Indian house hit detection - All 12 Houses', () {
      for (int h = 1; h <= 12; h++) {
        final center = VedicChartGeometry.getNorthIndianHouseCenter(h, size);
        final detected = VedicChartGeometry.hitTestHouse(
          localPosition: center,
          size: size,
          style: VedicChartStyle.northIndian,
          lagnaSignIndex: 1,
        );
        expect(detected, equals(h), reason: 'House $h center should hit-test as house $h');
      }
    });

    test('South Indian perimeter grid house hit detection', () {
      // Cell [col=1, row=0] corresponds to Aries (Sign 1).
      // If lagna is Aries (1), sign 1 = House 1.
      final ariesCellCenter = Offset(3 * 90 / 2, 90 / 2); // col 1, row 0
      final house = VedicChartGeometry.hitTestHouse(
        localPosition: ariesCellCenter,
        size: size,
        style: VedicChartStyle.southIndian,
        lagnaSignIndex: 1,
      );
      expect(house, equals(1));
    });

    test('South Indian center cell returns 0 (Non-house area)', () {
      final centerPoint = Offset(180, 180); // col 1-2, row 1-2 (center box)
      final house = VedicChartGeometry.hitTestHouse(
        localPosition: centerPoint,
        size: size,
        style: VedicChartStyle.southIndian,
        lagnaSignIndex: 1,
      );
      expect(house, equals(0));
    });

    test('Planet hit detection', () {
      final housePlanets = {
        1: ['Sun', 'Mercury'],
        7: ['Jupiter'],
      };

      // House 7 center position
      final jupiterCenter = VedicChartGeometry.getNorthIndianHouseCenter(7, size);

      final planetHit = VedicChartGeometry.hitTestPlanet(
        localPosition: jupiterCenter,
        size: size,
        style: VedicChartStyle.northIndian,
        lagnaSignIndex: 1,
        housePlanets: housePlanets,
      );

      expect(planetHit, equals('Jupiter'));
    });

    test('Out of bounds touch returns house 0 and planet null', () {
      final outOfBounds = Offset(-10, 400);

      final house = VedicChartGeometry.hitTestHouse(
        localPosition: outOfBounds,
        size: size,
        style: VedicChartStyle.northIndian,
        lagnaSignIndex: 1,
      );
      expect(house, equals(0));

      final planet = VedicChartGeometry.hitTestPlanet(
        localPosition: outOfBounds,
        size: size,
        style: VedicChartStyle.northIndian,
        lagnaSignIndex: 1,
        housePlanets: {1: ['Sun']},
      );
      expect(planet, isNull);
    });
  });
}
