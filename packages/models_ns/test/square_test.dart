import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Square', () {
    test('создание', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.center, center);
      expect(square.sideLength, sideLength);
      expect(square.color, '#000000');
      expect(square.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(
        center: center,
        sideLength: sideLength,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(square.center, center);
      expect(square.sideLength, sideLength);
      expect(square.color, '#FF0000');
      expect(square.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(
        center: center,
        sideLength: sideLength,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = square.toJson();
      final fromJson = Square.fromJson(json);
      expect(fromJson.center.x, square.center.x);
      expect(fromJson.center.y, square.center.y);
      expect(fromJson.sideLength, square.sideLength);
      expect(fromJson.color, square.color);
      expect(fromJson.thickness, square.thickness);
    });

    test('toPoints', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      final points = square.toPoints();
      expect(points.length, 2);
      expect(points[0], center);
      expect(points[1].x, center.x + sideLength / 2);
      expect(points[1].y, center.y - sideLength / 2);
    });

    test('fromPoints', () {
      final center = Point(x: 5, y: 5);
      final vertex = Point(x: 10, y: 0);
      final points = [center, vertex];
      final fromPoints =
          Figure.fromPoints(points, 'square', color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Square>());
      final squareFromPoints = fromPoints as Square;
      expect(squareFromPoints.center.x, center.x);
      expect(squareFromPoints.center.y, center.y);
      expect(squareFromPoints.sideLength, closeTo(10, 1e-10));
      expect(squareFromPoints.color, '#FF0000');
      expect(squareFromPoints.thickness, 2.0);
    });

    test('move', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      final vector = Vector(dx: 3, dy: -2);
      final moved = square.move(vector);
      expect(moved.center.x, 8);
      expect(moved.center.y, 3);
      expect(moved.sideLength, sideLength);
    });

    test('scale', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      final scaleCenter = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = square.scale(scaleCenter, scale);
      expect(scaled.center.x, 10);
      expect(scaled.center.y, 2.5);
      // Для квадрата используется среднее значение масштаба
      expect(scaled.sideLength, 12.5);
    });

    test('rotate', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      final rotationCenter = Point(x: 0, y: 0);
      final rotated = square.rotate(rotationCenter, 90);
      expect(rotated.center.x, closeTo(-5, 1e-10));
      expect(rotated.center.y, closeTo(5, 1e-10));
      expect(rotated.sideLength, sideLength);
    });

    test('perimeter', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.perimeter, 40);
    });

    test('area', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.area, 100);
    });

    test('diagonal', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.diagonal, closeTo(10 * math.sqrt(2), 1e-10));
    });

    test('topLeft, topRight, bottomRight, bottomLeft', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);

      expect(square.topLeft.x, 0);
      expect(square.topLeft.y, 0);

      expect(square.topRight.x, 10);
      expect(square.topRight.y, 0);

      expect(square.bottomRight.x, 10);
      expect(square.bottomRight.y, 10);

      expect(square.bottomLeft.x, 0);
      expect(square.bottomLeft.y, 10);
    });

    test('points', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      final points = square.points;
      expect(points.length, 4);
      expect(points[0].x, 0);
      expect(points[0].y, 0);
      expect(points[1].x, 10);
      expect(points[1].y, 0);
      expect(points[2].x, 10);
      expect(points[2].y, 10);
      expect(points[3].x, 0);
      expect(points[3].y, 10);
    });

    test('validate', () {
      // Валидный квадрат
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.validate(), null);
      expect(square.isValid(), true);

      // Невалидный квадрат (отрицательная длина стороны)
      final invalidSquare = Square(center: center, sideLength: -5);
      expect(invalidSquare.validate(), isNotNull);
      expect(invalidSquare.isValid(), false);
    });

    test('name', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.name, 'Квадрат');
    });

    test('toString', () {
      final center = Point(x: 5, y: 5);
      final sideLength = 10.0;
      final square = Square(center: center, sideLength: sideLength);
      expect(square.toString(), contains('Квадрат'));
      expect(square.toString(), contains('center'));
      expect(square.toString(), contains('sideLength'));
    });
  });
}
