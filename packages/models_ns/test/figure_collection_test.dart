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
  });
}
