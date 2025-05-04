import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Polygon', () {
    test('создание', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.points, points);
      expect(polygon.color, '#000000');
      expect(polygon.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(
        points: points,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(polygon.points, points);
      expect(polygon.color, '#FF0000');
      expect(polygon.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(
        points: points,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = polygon.toJson();
      final fromJson = Polygon.fromJson(json);
      expect(fromJson.points.length, polygon.points.length);
      for (int i = 0; i < polygon.points.length; i++) {
        expect(fromJson.points[i].x, polygon.points[i].x);
        expect(fromJson.points[i].y, polygon.points[i].y);
      }
      expect(fromJson.color, polygon.color);
      expect(fromJson.thickness, polygon.thickness);
    });

    test('toPoints', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      final resultPoints = polygon.toPoints();
      expect(resultPoints, points);
    });

    test('fromPoints', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final fromPoints = Figure.fromPoints(points, 'polygon',
          color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Polygon>());
      final polygonFromPoints = fromPoints as Polygon;
      expect(polygonFromPoints.points.length, points.length);
      for (int i = 0; i < points.length; i++) {
        expect(polygonFromPoints.points[i].x, points[i].x);
        expect(polygonFromPoints.points[i].y, points[i].y);
      }
      expect(polygonFromPoints.color, '#FF0000');
      expect(polygonFromPoints.thickness, 2.0);
    });

    test('move', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      final vector = Vector(dx: 5, dy: -3);
      final moved = polygon.move(vector);
      expect(moved.points.length, polygon.points.length);
      for (int i = 0; i < polygon.points.length; i++) {
        expect(moved.points[i].x, polygon.points[i].x + 5);
        expect(moved.points[i].y, polygon.points[i].y - 3);
      }
    });

    test('scale', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      final center = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = polygon.scale(center, scale);
      expect(scaled.points.length, polygon.points.length);
      expect(scaled.points[0].x, 0);
      expect(scaled.points[0].y, 0);
      expect(scaled.points[1].x, 20);
      expect(scaled.points[1].y, 0);
      expect(scaled.points[2].x, 20);
      expect(scaled.points[2].y, 5);
      expect(scaled.points[3].x, 0);
      expect(scaled.points[3].y, 5);
    });

    test('rotate', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      final center = Point(x: 0, y: 0);
      final rotated = polygon.rotate(center, 90);
      expect(rotated.points.length, polygon.points.length);
      expect(rotated.points[0].x, closeTo(0, 1e-10));
      expect(rotated.points[0].y, closeTo(0, 1e-10));
      expect(rotated.points[1].x, closeTo(0, 1e-10));
      expect(rotated.points[1].y, closeTo(10, 1e-10));
      expect(rotated.points[2].x, closeTo(-10, 1e-10));
      expect(rotated.points[2].y, closeTo(10, 1e-10));
      expect(rotated.points[3].x, closeTo(-10, 1e-10));
      expect(rotated.points[3].y, closeTo(0, 1e-10));
    });

    test('center', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.center.x, 5);
      expect(polygon.center.y, 5);
    });

    test('perimeter', () {
      // Квадрат со стороной 10
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.perimeter, 40);

      // Треугольник 3-4-5
      final trianglePoints = [
        Point(x: 0, y: 0),
        Point(x: 3, y: 0),
        Point(x: 0, y: 4),
      ];
      final triangle = Polygon(points: trianglePoints);
      expect(triangle.perimeter, 12);
    });

    test('area', () {
      // Квадрат со стороной 10
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.area, 100);

      // Треугольник с основанием 3 и высотой 4
      final trianglePoints = [
        Point(x: 0, y: 0),
        Point(x: 3, y: 0),
        Point(x: 0, y: 4),
      ];
      final triangle = Polygon(points: trianglePoints);
      expect(triangle.area, 6);
    });

    test('validate', () {
      // Валидный многоугольник (4 точки)
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.validate(), null);
      expect(polygon.isValid(), true);

      // Валидный многоугольник (3 точки - минимум)
      final trianglePoints = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 5, y: 10),
      ];
      final triangle = Polygon(points: trianglePoints);
      expect(triangle.validate(), null);
      expect(triangle.isValid(), true);

      // Невалидный многоугольник (2 точки)
      final invalidPoints = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
      ];
      final invalidPolygon = Polygon(points: invalidPoints);
      expect(invalidPolygon.validate(), isNotNull);
      expect(invalidPolygon.isValid(), false);

      // Невалидный многоугольник (пустой список точек)
      final emptyPolygon = Polygon(points: []);
      expect(emptyPolygon.validate(), isNotNull);
      expect(emptyPolygon.isValid(), false);
    });

    test('name', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.name, 'Многоугольник');
    });

    test('toString', () {
      final points = [
        Point(x: 0, y: 0),
        Point(x: 10, y: 0),
        Point(x: 10, y: 10),
        Point(x: 0, y: 10),
      ];
      final polygon = Polygon(points: points);
      expect(polygon.toString(), contains('Многоугольник'));
      expect(polygon.toString(), contains('points'));
    });
  });
}
