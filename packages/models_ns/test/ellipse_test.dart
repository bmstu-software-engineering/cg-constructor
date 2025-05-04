import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Ellipse', () {
    test('создание', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.center, center);
      expect(ellipse.semiMajorAxis, semiMajorAxis);
      expect(ellipse.semiMinorAxis, semiMinorAxis);
      expect(ellipse.color, '#000000');
      expect(ellipse.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(ellipse.center, center);
      expect(ellipse.semiMajorAxis, semiMajorAxis);
      expect(ellipse.semiMinorAxis, semiMinorAxis);
      expect(ellipse.color, '#FF0000');
      expect(ellipse.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = ellipse.toJson();
      final fromJson = Ellipse.fromJson(json);
      expect(fromJson.center.x, ellipse.center.x);
      expect(fromJson.center.y, ellipse.center.y);
      expect(fromJson.semiMajorAxis, ellipse.semiMajorAxis);
      expect(fromJson.semiMinorAxis, ellipse.semiMinorAxis);
      expect(fromJson.color, ellipse.color);
      expect(fromJson.thickness, ellipse.thickness);
    });

    test('toPoints', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      final points = ellipse.toPoints();
      expect(points.length, 3);
      expect(points[0], center);
      expect(points[1].x, center.x + semiMajorAxis);
      expect(points[1].y, center.y);
      expect(points[2].x, center.x);
      expect(points[2].y, center.y + semiMinorAxis);
    });

    test('fromPoints', () {
      final center = Point(x: 5, y: 5);
      final pointOnMajorAxis = Point(x: 15, y: 5);
      final pointOnMinorAxis = Point(x: 5, y: 11);
      final points = [center, pointOnMajorAxis, pointOnMinorAxis];
      final fromPoints = Figure.fromPoints(points, 'ellipse',
          color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Ellipse>());
      final ellipseFromPoints = fromPoints as Ellipse;
      expect(ellipseFromPoints.center.x, center.x);
      expect(ellipseFromPoints.center.y, center.y);
      expect(ellipseFromPoints.semiMajorAxis, 10);
      expect(ellipseFromPoints.semiMinorAxis, 6);
      expect(ellipseFromPoints.color, '#FF0000');
      expect(ellipseFromPoints.thickness, 2.0);
    });

    test('move', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      final vector = Vector(dx: 3, dy: -2);
      final moved = ellipse.move(vector);
      expect(moved.center.x, 8);
      expect(moved.center.y, 3);
      expect(moved.semiMajorAxis, semiMajorAxis);
      expect(moved.semiMinorAxis, semiMinorAxis);
    });

    test('scale', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      final scaleCenter = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = ellipse.scale(scaleCenter, scale);
      expect(scaled.center.x, 10);
      expect(scaled.center.y, 2.5);
      expect(scaled.semiMajorAxis, 20);
      expect(scaled.semiMinorAxis, 3);
    });

    test('rotate', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      final rotationCenter = Point(x: 0, y: 0);
      final rotated = ellipse.rotate(rotationCenter, 90);
      expect(rotated.center.x, closeTo(-5, 1e-10));
      expect(rotated.center.y, closeTo(5, 1e-10));
      expect(rotated.semiMajorAxis, semiMajorAxis);
      expect(rotated.semiMinorAxis, semiMinorAxis);
    });

    test('majorAxis и minorAxis', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.majorAxis, 20);
      expect(ellipse.minorAxis, 12);
    });

    test('eccentricity', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      final expectedEccentricity = math.sqrt(1 -
          (semiMinorAxis * semiMinorAxis) / (semiMajorAxis * semiMajorAxis));
      expect(ellipse.eccentricity, closeTo(expectedEccentricity, 1e-10));
    });

    test('perimeter', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      // Приближенная формула Рамануджана
      final a = semiMajorAxis;
      final b = semiMinorAxis;
      final h = math.pow(a - b, 2) / math.pow(a + b, 2);
      final expectedPerimeter =
          math.pi * (a + b) * (1 + (3 * h) / (10 + math.sqrt(4 - 3 * h)));
      expect(ellipse.perimeter, closeTo(expectedPerimeter, 1e-10));
    });

    test('area', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.area,
          closeTo(math.pi * semiMajorAxis * semiMinorAxis, 1e-10));
    });

    test('pointAtAngle', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );

      // Точка на 0 градусов (справа)
      final point0 = ellipse.pointAtAngle(0);
      expect(point0.x, closeTo(15, 1e-10));
      expect(point0.y, closeTo(5, 1e-10));

      // Точка на 90 градусов (сверху)
      final point90 = ellipse.pointAtAngle(math.pi / 2);
      expect(point90.x, closeTo(5, 1e-10));
      expect(point90.y, closeTo(11, 1e-10));

      // Точка на 180 градусов (слева)
      final point180 = ellipse.pointAtAngle(math.pi);
      expect(point180.x, closeTo(-5, 1e-10));
      expect(point180.y, closeTo(5, 1e-10));

      // Точка на 270 градусов (снизу)
      final point270 = ellipse.pointAtAngle(3 * math.pi / 2);
      expect(point270.x, closeTo(5, 1e-10));
      expect(point270.y, closeTo(-1, 1e-10));
    });

    test('isCircle', () {
      // Эллипс (не круг)
      final center1 = Point(x: 5, y: 5);
      final semiMajorAxis1 = 10.0;
      final semiMinorAxis1 = 6.0;
      final ellipse1 = Ellipse(
        center: center1,
        semiMajorAxis: semiMajorAxis1,
        semiMinorAxis: semiMinorAxis1,
      );
      expect(ellipse1.isCircle, false);

      // Круг (эллипс с равными полуосями)
      final center2 = Point(x: 5, y: 5);
      final semiMajorAxis2 = 10.0;
      final semiMinorAxis2 = 10.0;
      final ellipse2 = Ellipse(
        center: center2,
        semiMajorAxis: semiMajorAxis2,
        semiMinorAxis: semiMinorAxis2,
      );
      expect(ellipse2.isCircle, true);
    });

    test('validate', () {
      // Валидный эллипс
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.validate(), null);
      expect(ellipse.isValid(), true);

      // Невалидный эллипс (отрицательная большая полуось)
      final invalidEllipse1 = Ellipse(
        center: center,
        semiMajorAxis: -10,
        semiMinorAxis: 6,
      );
      expect(invalidEllipse1.validate(), isNotNull);
      expect(invalidEllipse1.isValid(), false);

      // Невалидный эллипс (отрицательная малая полуось)
      final invalidEllipse2 = Ellipse(
        center: center,
        semiMajorAxis: 10,
        semiMinorAxis: -6,
      );
      expect(invalidEllipse2.validate(), isNotNull);
      expect(invalidEllipse2.isValid(), false);

      // Невалидный эллипс (малая полуось больше большой)
      final invalidEllipse3 = Ellipse(
        center: center,
        semiMajorAxis: 6,
        semiMinorAxis: 10,
      );
      expect(invalidEllipse3.validate(), isNotNull);
      expect(invalidEllipse3.isValid(), false);
    });

    test('name', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.name, 'Эллипс');
    });

    test('toString', () {
      final center = Point(x: 5, y: 5);
      final semiMajorAxis = 10.0;
      final semiMinorAxis = 6.0;
      final ellipse = Ellipse(
        center: center,
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
      );
      expect(ellipse.toString(), contains('Эллипс'));
      expect(ellipse.toString(), contains('center'));
      expect(ellipse.toString(), contains('semiMajorAxis'));
      expect(ellipse.toString(), contains('semiMinorAxis'));
    });
  });
}
