import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Rectangle', () {
    test('создание', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.topLeft, topLeft);
      expect(rectangle.topRight, topRight);
      expect(rectangle.bottomRight, bottomRight);
      expect(rectangle.bottomLeft, bottomLeft);
      expect(rectangle.color, '#000000');
      expect(rectangle.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(rectangle.topLeft, topLeft);
      expect(rectangle.topRight, topRight);
      expect(rectangle.bottomRight, bottomRight);
      expect(rectangle.bottomLeft, bottomLeft);
      expect(rectangle.color, '#FF0000');
      expect(rectangle.thickness, 2.0);
    });

    test('создание из углов', () {
      final topLeft = Point(x: 0, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final rectangle = Rectangle.fromCorners(
        topLeft: topLeft,
        bottomRight: bottomRight,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(rectangle.topLeft, topLeft);
      expect(rectangle.topRight.x, bottomRight.x);
      expect(rectangle.topRight.y, topLeft.y);
      expect(rectangle.bottomRight, bottomRight);
      expect(rectangle.bottomLeft.x, topLeft.x);
      expect(rectangle.bottomLeft.y, bottomRight.y);
      expect(rectangle.color, '#FF0000');
      expect(rectangle.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = rectangle.toJson();
      final fromJson = Rectangle.fromJson(json);
      expect(fromJson.topLeft.x, rectangle.topLeft.x);
      expect(fromJson.topLeft.y, rectangle.topLeft.y);
      expect(fromJson.topRight.x, rectangle.topRight.x);
      expect(fromJson.topRight.y, rectangle.topRight.y);
      expect(fromJson.bottomRight.x, rectangle.bottomRight.x);
      expect(fromJson.bottomRight.y, rectangle.bottomRight.y);
      expect(fromJson.bottomLeft.x, rectangle.bottomLeft.x);
      expect(fromJson.bottomLeft.y, rectangle.bottomLeft.y);
      expect(fromJson.color, rectangle.color);
      expect(fromJson.thickness, rectangle.thickness);
    });

    test('toPoints', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      final points = rectangle.toPoints();
      expect(points.length, 4);
      expect(points[0], topLeft);
      expect(points[1], topRight);
      expect(points[2], bottomRight);
      expect(points[3], bottomLeft);
    });

    test('fromPoints', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final points = [topLeft, topRight, bottomRight, bottomLeft];
      final fromPoints = Figure.fromPoints(points, 'rectangle',
          color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Rectangle>());
      final rectangleFromPoints = fromPoints as Rectangle;
      expect(rectangleFromPoints.topLeft.x, topLeft.x);
      expect(rectangleFromPoints.topLeft.y, topLeft.y);
      expect(rectangleFromPoints.topRight.x, topRight.x);
      expect(rectangleFromPoints.topRight.y, topRight.y);
      expect(rectangleFromPoints.bottomRight.x, bottomRight.x);
      expect(rectangleFromPoints.bottomRight.y, bottomRight.y);
      expect(rectangleFromPoints.bottomLeft.x, bottomLeft.x);
      expect(rectangleFromPoints.bottomLeft.y, bottomLeft.y);
      expect(rectangleFromPoints.color, '#FF0000');
      expect(rectangleFromPoints.thickness, 2.0);
    });

    test('move', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      final vector = Vector(dx: 5, dy: -3);
      final moved = rectangle.move(vector);
      expect(moved.topLeft.x, 5);
      expect(moved.topLeft.y, -3);
      expect(moved.topRight.x, 15);
      expect(moved.topRight.y, -3);
      expect(moved.bottomRight.x, 15);
      expect(moved.bottomRight.y, 5);
      expect(moved.bottomLeft.x, 5);
      expect(moved.bottomLeft.y, 5);
    });

    test('scale', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      final center = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = rectangle.scale(center, scale);
      expect(scaled.topLeft.x, 0);
      expect(scaled.topLeft.y, 0);
      expect(scaled.topRight.x, 20);
      expect(scaled.topRight.y, 0);
      expect(scaled.bottomRight.x, 20);
      expect(scaled.bottomRight.y, 4);
      expect(scaled.bottomLeft.x, 0);
      expect(scaled.bottomLeft.y, 4);
    });

    test('rotate', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      final center = Point(x: 0, y: 0);
      final rotated = rectangle.rotate(center, 90);
      expect(rotated.topLeft.x, closeTo(0, 1e-10));
      expect(rotated.topLeft.y, closeTo(0, 1e-10));
      expect(rotated.topRight.x, closeTo(0, 1e-10));
      expect(rotated.topRight.y, closeTo(10, 1e-10));
      expect(rotated.bottomRight.x, closeTo(-8, 1e-10));
      expect(rotated.bottomRight.y, closeTo(10, 1e-10));
      expect(rotated.bottomLeft.x, closeTo(-8, 1e-10));
      expect(rotated.bottomLeft.y, closeTo(0, 1e-10));
    });

    test('center', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.center.x, 5);
      expect(rectangle.center.y, 4);
    });

    test('width и height', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.width, 10);
      expect(rectangle.height, 8);
    });

    test('perimeter', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.perimeter, 36);
    });

    test('area', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.area, 80);
    });

    test('isSquare', () {
      // Квадрат
      final topLeft1 = Point(x: 0, y: 0);
      final topRight1 = Point(x: 10, y: 0);
      final bottomRight1 = Point(x: 10, y: 10);
      final bottomLeft1 = Point(x: 0, y: 10);
      final square = Rectangle(
        topLeft: topLeft1,
        topRight: topRight1,
        bottomRight: bottomRight1,
        bottomLeft: bottomLeft1,
      );
      expect(square.isSquare, true);

      // Прямоугольник
      final topLeft2 = Point(x: 0, y: 0);
      final topRight2 = Point(x: 10, y: 0);
      final bottomRight2 = Point(x: 10, y: 8);
      final bottomLeft2 = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft2,
        topRight: topRight2,
        bottomRight: bottomRight2,
        bottomLeft: bottomLeft2,
      );
      expect(rectangle.isSquare, false);
    });

    test('validate', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.validate(), null);
      expect(rectangle.isValid(), true);
    });

    test('name', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.name, 'Прямоугольник');
    });

    test('toString', () {
      final topLeft = Point(x: 0, y: 0);
      final topRight = Point(x: 10, y: 0);
      final bottomRight = Point(x: 10, y: 8);
      final bottomLeft = Point(x: 0, y: 8);
      final rectangle = Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
      );
      expect(rectangle.toString(), contains('Прямоугольник'));
      expect(rectangle.toString(), contains('topLeft'));
      expect(rectangle.toString(), contains('topRight'));
      expect(rectangle.toString(), contains('bottomRight'));
      expect(rectangle.toString(), contains('bottomLeft'));
    });
  });
}
