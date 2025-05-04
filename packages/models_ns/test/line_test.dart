import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Line', () {
    test('создание', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.a, a);
      expect(line.b, b);
      expect(line.color, '#000000');
      expect(line.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b, color: '#FF0000', thickness: 2.0);
      expect(line.a, a);
      expect(line.b, b);
      expect(line.color, '#FF0000');
      expect(line.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b, color: '#FF0000', thickness: 2.0);
      final json = line.toJson();
      final fromJson = Line.fromJson(json);
      expect(fromJson.a.x, line.a.x);
      expect(fromJson.a.y, line.a.y);
      expect(fromJson.b.x, line.b.x);
      expect(fromJson.b.y, line.b.y);
      expect(fromJson.color, line.color);
      expect(fromJson.thickness, line.thickness);
    });

    test('toPoints', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      final points = line.toPoints();
      expect(points.length, 2);
      expect(points[0], a);
      expect(points[1], b);
    });

    test('fromPoints', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final points = [a, b];
      final fromPoints =
          Figure.fromPoints(points, 'line', color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Line>());
      final lineFromPoints = fromPoints as Line;
      expect(lineFromPoints.a.x, a.x);
      expect(lineFromPoints.a.y, a.y);
      expect(lineFromPoints.b.x, b.x);
      expect(lineFromPoints.b.y, b.y);
      expect(lineFromPoints.color, '#FF0000');
      expect(lineFromPoints.thickness, 2.0);
    });

    test('move', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      final vector = Vector(dx: 5, dy: -3);
      final moved = line.move(vector);
      expect(moved.a.x, 15);
      expect(moved.a.y, 17);
      expect(moved.b.x, 35);
      expect(moved.b.y, 37);
    });

    test('scale', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      final center = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = line.scale(center, scale);
      expect(scaled.a.x, 20);
      expect(scaled.a.y, 10);
      expect(scaled.b.x, 60);
      expect(scaled.b.y, 20);
    });

    test('rotate', () {
      final a = Point(x: 10, y: 0);
      final b = Point(x: 20, y: 0);
      final line = Line(a: a, b: b);
      final center = Point(x: 0, y: 0);
      final rotated = line.rotate(center, 90);
      expect(rotated.a.x, closeTo(0, 1e-10));
      expect(rotated.a.y, closeTo(10, 1e-10));
      expect(rotated.b.x, closeTo(0, 1e-10));
      expect(rotated.b.y, closeTo(20, 1e-10));
    });

    test('center', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.center.x, 20);
      expect(line.center.y, 30);
    });

    test('length', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 4);
      final line = Line(a: a, b: b);
      expect(line.length, 5);
    });

    test('perimeter', () {
      final a = Point(x: 0, y: 0);
      final b = Point(x: 3, y: 4);
      final line = Line(a: a, b: b);
      expect(line.perimeter, 10); // 2 * length
    });

    test('area', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.area, 0);
    });

    test('validate', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.validate(), null);
      expect(line.isValid(), true);
    });

    test('name', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.name, 'Линия');
    });

    test('toString', () {
      final a = Point(x: 10, y: 20);
      final b = Point(x: 30, y: 40);
      final line = Line(a: a, b: b);
      expect(line.toString(), contains('Линия'));
      expect(line.toString(), contains('a'));
      expect(line.toString(), contains('b'));
    });
  });
}
