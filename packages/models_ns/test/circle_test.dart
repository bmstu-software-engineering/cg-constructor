import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Circle', () {
    test('создание', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.center, center);
      expect(circle.radius, radius);
      expect(circle.color, '#000000');
      expect(circle.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(
        center: center,
        radius: radius,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(circle.center, center);
      expect(circle.radius, radius);
      expect(circle.color, '#FF0000');
      expect(circle.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(
        center: center,
        radius: radius,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = circle.toJson();
      final fromJson = Circle.fromJson(json);
      expect(fromJson.center.x, circle.center.x);
      expect(fromJson.center.y, circle.center.y);
      expect(fromJson.radius, circle.radius);
      expect(fromJson.color, circle.color);
      expect(fromJson.thickness, circle.thickness);
    });

    test('toPoints', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      final points = circle.toPoints();
      expect(points.length, 2);
      expect(points[0], center);
      expect(points[1].x, center.x + radius);
      expect(points[1].y, center.y);
    });

    test('fromPoints', () {
      final center = Point(x: 5, y: 5);
      final pointOnCircle = Point(x: 15, y: 5);
      final points = [center, pointOnCircle];
      final fromPoints =
          Figure.fromPoints(points, 'circle', color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Circle>());
      final circleFromPoints = fromPoints as Circle;
      expect(circleFromPoints.center.x, center.x);
      expect(circleFromPoints.center.y, center.y);
      expect(circleFromPoints.radius, 10);
      expect(circleFromPoints.color, '#FF0000');
      expect(circleFromPoints.thickness, 2.0);
    });

    test('move', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      final vector = Vector(dx: 3, dy: -2);
      final moved = circle.move(vector);
      expect(moved.center.x, 8);
      expect(moved.center.y, 3);
      expect(moved.radius, radius);
    });

    test('scale', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      final scaleCenter = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = circle.scale(scaleCenter, scale);
      expect(scaled.center.x, 10);
      expect(scaled.center.y, 2.5);
      // Для круга используется среднее значение масштаба
      expect(scaled.radius, 12.5);
    });

    test('rotate', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      final rotationCenter = Point(x: 0, y: 0);
      final rotated = circle.rotate(rotationCenter, 90);
      expect(rotated.center.x, closeTo(-5, 1e-10));
      expect(rotated.center.y, closeTo(5, 1e-10));
      expect(rotated.radius, radius);
    });

    test('diameter', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.diameter, 20);
    });

    test('circumference', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.circumference, closeTo(2 * math.pi * radius, 1e-10));
    });

    test('perimeter', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.perimeter, closeTo(2 * math.pi * radius, 1e-10));
    });

    test('area', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.area, closeTo(math.pi * radius * radius, 1e-10));
    });

    test('pointAtAngle', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);

      // Точка на 0 градусов (справа)
      final point0 = circle.pointAtAngle(0);
      expect(point0.x, closeTo(15, 1e-10));
      expect(point0.y, closeTo(5, 1e-10));

      // Точка на 90 градусов (сверху)
      final point90 = circle.pointAtAngle(math.pi / 2);
      expect(point90.x, closeTo(5, 1e-10));
      expect(point90.y, closeTo(15, 1e-10));

      // Точка на 180 градусов (слева)
      final point180 = circle.pointAtAngle(math.pi);
      expect(point180.x, closeTo(-5, 1e-10));
      expect(point180.y, closeTo(5, 1e-10));

      // Точка на 270 градусов (снизу)
      final point270 = circle.pointAtAngle(3 * math.pi / 2);
      expect(point270.x, closeTo(5, 1e-10));
      expect(point270.y, closeTo(-5, 1e-10));
    });

    test('validate', () {
      // Валидный круг
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.validate(), null);
      expect(circle.isValid(), true);

      // Невалидный круг (отрицательный радиус)
      final invalidCircle = Circle(center: center, radius: -5);
      expect(invalidCircle.validate(), isNotNull);
      expect(invalidCircle.isValid(), false);
    });

    test('name', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.name, 'Круг');
    });

    test('toString', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final circle = Circle(center: center, radius: radius);
      expect(circle.toString(), contains('Круг'));
      expect(circle.toString(), contains('center'));
      expect(circle.toString(), contains('radius'));
    });
  });
}
