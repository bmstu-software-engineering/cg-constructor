import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('FigureCollection', () {
    test('создание', () {
      final point = Point(x: 10, y: 20);
      final line = Line(a: Point(x: 0, y: 0), b: Point(x: 10, y: 10));
      final collection = FigureCollection(
        points: [point],
        lines: [line],
      );
      expect(collection.points, [point]);
      expect(collection.lines, [line]);
      expect(collection.triangles, isEmpty);
      expect(collection.rectangles, isEmpty);
      expect(collection.squares, isEmpty);
      expect(collection.circles, isEmpty);
      expect(collection.ellipses, isEmpty);
      expect(collection.arcs, isEmpty);
    });

    test('создание с пустыми списками', () {
      final collection = FigureCollection();
      expect(collection.points, isEmpty);
      expect(collection.lines, isEmpty);
      expect(collection.triangles, isEmpty);
      expect(collection.rectangles, isEmpty);
      expect(collection.squares, isEmpty);
      expect(collection.circles, isEmpty);
      expect(collection.ellipses, isEmpty);
      expect(collection.arcs, isEmpty);
    });

    test('toJson и fromJson', () {
      final point = Point(x: 10, y: 20, color: '#FF0000', thickness: 2.0);
      final line = Line(
        a: Point(x: 0, y: 0),
        b: Point(x: 10, y: 10),
        color: '#00FF00',
        thickness: 1.5,
      );
      final triangle = Triangle(
        a: Point(x: 0, y: 0),
        b: Point(x: 10, y: 0),
        c: Point(x: 5, y: 8),
        color: '#0000FF',
        thickness: 1.0,
      );
      final collection = FigureCollection(
        points: [point],
        lines: [line],
        triangles: [triangle],
      );

      final json = collection.toJson();
      final fromJson = FigureCollection.fromJson(json);

      expect(fromJson.points.length, 1);
      expect(fromJson.lines.length, 1);
      expect(fromJson.triangles.length, 1);

      // Проверяем точку
      expect(fromJson.points[0].x, 10);
      expect(fromJson.points[0].y, 20);
      expect(fromJson.points[0].color, '#FF0000');
      expect(fromJson.points[0].thickness, 2.0);

      // Проверяем линию
      expect(fromJson.lines[0].a.x, 0);
      expect(fromJson.lines[0].a.y, 0);
      expect(fromJson.lines[0].b.x, 10);
      expect(fromJson.lines[0].b.y, 10);
      expect(fromJson.lines[0].color, '#00FF00');
      expect(fromJson.lines[0].thickness, 1.5);

      // Проверяем треугольник
      expect(fromJson.triangles[0].a.x, 0);
      expect(fromJson.triangles[0].a.y, 0);
      expect(fromJson.triangles[0].b.x, 10);
      expect(fromJson.triangles[0].b.y, 0);
      expect(fromJson.triangles[0].c.x, 5);
      expect(fromJson.triangles[0].c.y, 8);
      expect(fromJson.triangles[0].color, '#0000FF');
      expect(fromJson.triangles[0].thickness, 1.0);
    });

    test('toJsonString', () {
      final point = Point(x: 10, y: 20);
      final collection = FigureCollection(points: [point]);
      final jsonString = collection.toJsonString();
      expect(jsonString, isA<String>());

      // Проверяем, что строка может быть декодирована обратно в JSON
      final decodedJson = jsonDecode(jsonString);
      expect(decodedJson, isA<Map<String, dynamic>>());

      // Проверяем, что из декодированного JSON можно создать коллекцию
      final fromJson = FigureCollection.fromJson(decodedJson);
      expect(fromJson.points.length, 1);
      expect(fromJson.points[0].x, 10);
      expect(fromJson.points[0].y, 20);
    });

    group('групповые операции', () {
      late FigureCollection collection;

      setUp(() {
        // Создаем коллекцию с разными фигурами для тестирования
        final point = Point(x: 10, y: 20);
        final line = Line(a: Point(x: 0, y: 0), b: Point(x: 10, y: 10));
        final triangle = Triangle(
          a: Point(x: 0, y: 0),
          b: Point(x: 10, y: 0),
          c: Point(x: 5, y: 8),
        );
        final rectangle = Rectangle(
          topLeft: Point(x: 0, y: 0),
          topRight: Point(x: 10, y: 0),
          bottomRight: Point(x: 10, y: 10),
          bottomLeft: Point(x: 0, y: 10),
        );
        final square = Square(
          center: Point(x: 5, y: 5),
          sideLength: 10,
        );
        final circle = Circle(
          center: Point(x: 5, y: 5),
          radius: 5,
        );
        final ellipse = Ellipse(
          center: Point(x: 5, y: 5),
          semiMajorAxis: 10,
          semiMinorAxis: 5,
        );
        final arc = Arc(
          center: Point(x: 5, y: 5),
          radius: 5,
          startAngle: 0,
          endAngle: 3.14,
        );

        collection = FigureCollection(
          points: [point],
          lines: [line],
          triangles: [triangle],
          rectangles: [rectangle],
          squares: [square],
          circles: [circle],
          ellipses: [ellipse],
          arcs: [arc],
        );
      });

      test('масштабирование', () {
        final center = Point(x: 0, y: 0);
        final scale = Scale(x: 2, y: 2);

        final scaledCollection = collection.scale(center, scale);

        // Проверяем, что исходная коллекция не изменилась
        expect(collection.points[0].x, 10);
        expect(collection.points[0].y, 20);

        // Проверяем, что точка масштабировалась правильно
        expect(scaledCollection.points[0].x, 20);
        expect(scaledCollection.points[0].y, 40);

        // Проверяем, что линия масштабировалась правильно
        expect(scaledCollection.lines[0].a.x, 0);
        expect(scaledCollection.lines[0].a.y, 0);
        expect(scaledCollection.lines[0].b.x, 20);
        expect(scaledCollection.lines[0].b.y, 20);

        // Проверяем, что круг масштабировался правильно
        expect(scaledCollection.circles[0].center.x, 10);
        expect(scaledCollection.circles[0].center.y, 10);
        expect(scaledCollection.circles[0].radius, 10);
      });

      test('перемещение', () {
        final vector = Vector(dx: 5, dy: 10);

        final movedCollection = collection.move(vector);

        // Проверяем, что исходная коллекция не изменилась
        expect(collection.points[0].x, 10);
        expect(collection.points[0].y, 20);

        // Проверяем, что точка переместилась правильно
        expect(movedCollection.points[0].x, 15);
        expect(movedCollection.points[0].y, 30);

        // Проверяем, что линия переместилась правильно
        expect(movedCollection.lines[0].a.x, 5);
        expect(movedCollection.lines[0].a.y, 10);
        expect(movedCollection.lines[0].b.x, 15);
        expect(movedCollection.lines[0].b.y, 20);

        // Проверяем, что круг переместился правильно
        expect(movedCollection.circles[0].center.x, 10);
        expect(movedCollection.circles[0].center.y, 15);
        expect(movedCollection.circles[0].radius, 5);
      });

      test('поворот', () {
        final center = Point(x: 0, y: 0);
        final degree = 90.0;

        final rotatedCollection = collection.rotate(center, degree);

        // Проверяем, что исходная коллекция не изменилась
        expect(collection.points[0].x, 10);
        expect(collection.points[0].y, 20);

        // Проверяем, что точка повернулась правильно (90 градусов вокруг начала координат)
        // x' = -y, y' = x
        expect(rotatedCollection.points[0].x, closeTo(-20, 0.001));
        expect(rotatedCollection.points[0].y, closeTo(10, 0.001));

        // Проверяем, что линия повернулась правильно
        expect(rotatedCollection.lines[0].a.x, closeTo(0, 0.001));
        expect(rotatedCollection.lines[0].a.y, closeTo(0, 0.001));
        expect(rotatedCollection.lines[0].b.x, closeTo(-10, 0.001));
        expect(rotatedCollection.lines[0].b.y, closeTo(10, 0.001));

        // Проверяем, что круг повернулся правильно (центр должен повернуться, радиус не меняется)
        expect(rotatedCollection.circles[0].center.x, closeTo(-5, 0.001));
        expect(rotatedCollection.circles[0].center.y, closeTo(5, 0.001));
        expect(rotatedCollection.circles[0].radius, 5);
      });
    });
  });
}
