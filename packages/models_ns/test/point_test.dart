import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Point', () {
    test('создание', () {
      final point = Point(x: 10, y: 20);
      expect(point.x, 10);
      expect(point.y, 20);
      expect(point.color, '#000000');
      expect(point.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final point = Point(x: 10, y: 20, color: '#FF0000', thickness: 2.0);
      expect(point.x, 10);
      expect(point.y, 20);
      expect(point.color, '#FF0000');
      expect(point.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final point = Point(x: 10, y: 20, color: '#FF0000', thickness: 2.0);
      final json = point.toJson();
      final fromJson = Point.fromJson(json);
      expect(fromJson.x, point.x);
      expect(fromJson.y, point.y);
      expect(fromJson.color, point.color);
      expect(fromJson.thickness, point.thickness);
    });

    test('toPoints', () {
      final point = Point(x: 10, y: 20);
      final points = point.toPoints();
      expect(points.length, 1);
      expect(points[0], point);
    });

    test('fromPoints', () {
      final point = Point(x: 10, y: 20, color: '#FF0000', thickness: 2.0);
      final points = [point];
      final fromPoints =
          Figure.fromPoints(points, 'point', color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Point>());
      final pointFromPoints = fromPoints as Point;
      expect(pointFromPoints.x, point.x);
      expect(pointFromPoints.y, point.y);
      expect(pointFromPoints.color, point.color);
      expect(pointFromPoints.thickness, point.thickness);
    });

    test('move', () {
      final point = Point(x: 10, y: 20);
      final vector = Vector(dx: 5, dy: -3);
      final moved = point.move(vector);
      expect(moved.x, 15);
      expect(moved.y, 17);
    });

    test('scale', () {
      final point = Point(x: 10, y: 20);
      final center = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = point.scale(center, scale);
      expect(scaled.x, 20);
      expect(scaled.y, 10);
    });

    test('rotate', () {
      final point = Point(x: 10, y: 0);
      final center = Point(x: 0, y: 0);
      final rotated = point.rotate(center, 90);
      expect(rotated.x, closeTo(0, 1e-10));
      expect(rotated.y, closeTo(10, 1e-10));
    });

    test('center', () {
      final point = Point(x: 10, y: 20);
      expect(point.center, point);
    });

    test('perimeter', () {
      final point = Point(x: 10, y: 20);
      expect(point.perimeter, 0);
    });

    test('area', () {
      final point = Point(x: 10, y: 20);
      expect(point.area, 0);
    });

    test('validate', () {
      final point = Point(x: 10, y: 20);
      expect(point.validate(), null);
      expect(point.isValid(), true);
    });

    test('name', () {
      final point = Point(x: 10, y: 20);
      expect(point.name, 'Точка');
    });

    test('toString', () {
      final point = Point(x: 10, y: 20);
      expect(point.toString(), contains('Точка'));
      expect(point.toString(), contains('10'));
      expect(point.toString(), contains('20'));
    });
  });
}
