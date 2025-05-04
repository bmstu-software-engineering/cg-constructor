import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Triangle', () {
    test('создание', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.a, a);
      expect(triangle.b, b);
      expect(triangle.c, c);
      expect(triangle.color, '#000000');
      expect(triangle.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle =
          Triangle(a: a, b: b, c: c, color: '#FF0000', thickness: 2.0);
      expect(triangle.a, a);
      expect(triangle.b, b);
      expect(triangle.c, c);
      expect(triangle.color, '#FF0000');
      expect(triangle.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle =
          Triangle(a: a, b: b, c: c, color: '#FF0000', thickness: 2.0);
      final json = triangle.toJson();
      final fromJson = Triangle.fromJson(json);
      expect(fromJson.a.x, triangle.a.x);
      expect(fromJson.a.y, triangle.a.y);
      expect(fromJson.b.x, triangle.b.x);
      expect(fromJson.b.y, triangle.b.y);
      expect(fromJson.c.x, triangle.c.x);
      expect(fromJson.c.y, triangle.c.y);
      expect(fromJson.color, triangle.color);
      expect(fromJson.thickness, triangle.thickness);
    });

    test('toPoints', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      final points = triangle.toPoints();
      expect(points.length, 3);
      expect(points[0], a);
      expect(points[1], b);
      expect(points[2], c);
    });

    test('fromPoints', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final points = [a, b, c];
      final fromPoints = Figure.fromPoints(points, 'triangle',
          color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Triangle>());
      final triangleFromPoints = fromPoints as Triangle;
      expect(triangleFromPoints.a.x, a.x);
      expect(triangleFromPoints.a.y, a.y);
      expect(triangleFromPoints.b.x, b.x);
      expect(triangleFromPoints.b.y, b.y);
      expect(triangleFromPoints.c.x, c.x);
      expect(triangleFromPoints.c.y, c.y);
      expect(triangleFromPoints.color, '#FF0000');
      expect(triangleFromPoints.thickness, 2.0);
    });

    test('move', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      final vector = Vector(dx: 5, dy: -3);
      final moved = triangle.move(vector);
      expect(moved.a.x, 5);
      expect(moved.a.y, -3);
      expect(moved.b.x, 15);
      expect(moved.b.y, -3);
      expect(moved.c.x, 10);
      expect(moved.c.y, 5);
    });

    test('scale', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      final center = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = triangle.scale(center, scale);
      expect(scaled.a.x, 0);
      expect(scaled.a.y, 0);
      expect(scaled.b.x, 20);
      expect(scaled.b.y, 0);
      expect(scaled.c.x, 10);
      expect(scaled.c.y, 4);
    });

    test('rotate', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      final center = Point(x: 0, y: 0);
      final rotated = triangle.rotate(center, 90);
      expect(rotated.a.x, closeTo(0, 1e-10));
      expect(rotated.a.y, closeTo(0, 1e-10));
      expect(rotated.b.x, closeTo(0, 1e-10));
      expect(rotated.b.y, closeTo(10, 1e-10));
      expect(rotated.c.x, closeTo(-8, 1e-10));
      expect(rotated.c.y, closeTo(5, 1e-10));
    });

    test('center', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 9, y: 0);
      final c = Point(x: 0, y: 12);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.center.x, 3);
      expect(triangle.center.y, 4);
    });

    test('sideAB, sideBC, sideCA', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 0);
      final c = Point(x: 0, y: 4);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.sideAB, 3);
      expect(triangle.sideBC, 5);
      expect(triangle.sideCA, 4);
    });

    test('perimeter', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 0);
      final c = Point(x: 0, y: 4);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.perimeter, 12);
    });

    test('area', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 0);
      final c = Point(x: 0, y: 4);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.area, 6);
    });

    test('isEquilateral', () {
      // Равносторонний треугольник
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(
          x: 5,
          y: 8.660254037844386); // высота равностороннего треугольника со стороной 10 (10 * sqrt(3) / 2)
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.isEquilateral, true);

      // Неравносторонний треугольник
      final d = Point(x: 0, y: 0);
      final e = Point(x: 10, y: 0);
      final f = Point(x: 5, y: 5);
      final triangle2 = Triangle(a: d, b: e, c: f);
      expect(triangle2.isEquilateral, false);
    });

    test('isIsosceles', () {
      // Равнобедренный треугольник
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.isIsosceles, true);

      // Неравнобедренный треугольник
      final d = Point(x: 0, y: 0);
      final e = Point(x: 10, y: 0);
      final f = Point(x: 3, y: 5);
      final triangle2 = Triangle(a: d, b: e, c: f);
      expect(triangle2.isIsosceles, false);
    });

    test('isRightAngled', () {
      // Прямоугольный треугольник
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 0);
      final c = Point(x: 0, y: 4);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.isRightAngled, true);

      // Непрямоугольный треугольник
      final d = Point(x: 0, y: 0);
      final e = Point(x: 10, y: 0);
      final f = Point(x: 5, y: 8);
      final triangle2 = Triangle(a: d, b: e, c: f);
      expect(triangle2.isRightAngled, false);
    });

    test('validate', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.validate(), null);
      expect(triangle.isValid(), true);
    });

    test('name', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.name, 'Треугольник');
    });

    test('toString', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 10, y: 0);
      final c = Point(x: 5, y: 8);
      final triangle = Triangle(a: a, b: b, c: c);
      expect(triangle.toString(), contains('Треугольник'));
      expect(triangle.toString(), contains('a'));
      expect(triangle.toString(), contains('b'));
      expect(triangle.toString(), contains('c'));
    });
  });
}
