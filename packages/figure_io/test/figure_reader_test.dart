import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:figure_io/figure_io.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('FigureCollection', () {
    test('fromJson создает коллекцию из JSON', () {
      final json = {
        'points': [
          {'x': 10, 'y': 20},
          {'x': 30, 'y': 40},
        ],
        'lines': [
          {
            'a': {'x': 0, 'y': 0},
            'b': {'x': 100, 'y': 100},
          },
        ],
        'triangles': [
          {
            'a': {'x': 0, 'y': 0},
            'b': {'x': 100, 'y': 0},
            'c': {'x': 50, 'y': 86.6},
          },
        ],
      };

      final collection = FigureCollection.fromJson(json);

      expect(collection.points.length, 2);
      expect(collection.lines.length, 1);
      expect(collection.triangles.length, 1);

      expect(collection.points[0].point.x, 10);
      expect(collection.points[0].point.y, 20);
      expect(collection.points[1].point.x, 30);
      expect(collection.points[1].point.y, 40);

      expect(collection.lines[0].line.a.x, 0);
      expect(collection.lines[0].line.a.y, 0);
      expect(collection.lines[0].line.b.x, 100);
      expect(collection.lines[0].line.b.y, 100);

      expect(collection.triangles[0].triangle.a.x, 0);
      expect(collection.triangles[0].triangle.a.y, 0);
      expect(collection.triangles[0].triangle.b.x, 100);
      expect(collection.triangles[0].triangle.b.y, 0);
      expect(collection.triangles[0].triangle.c.x, 50);
      expect(collection.triangles[0].triangle.c.y, 86.6);
    });

    test('toJson преобразует коллекцию в JSON', () {
      final collection = FigureCollection(
        points: [
          PointFigure(Point(x: 10, y: 20)),
          PointFigure(Point(x: 30, y: 40)),
        ],
        lines: [
          LineFigure(Line(
            a: Point(x: 0, y: 0),
            b: Point(x: 100, y: 100),
          )),
        ],
        triangles: [
          TriangleFigure(Triangle(
            a: Point(x: 0, y: 0),
            b: Point(x: 100, y: 0),
            c: Point(x: 50, y: 86.6),
          )),
        ],
      );

      final json = collection.toJson();

      expect(json['points'].length, 2);
      expect(json['lines'].length, 1);
      expect(json['triangles'].length, 1);

      expect(json['points'][0]['x'], 10);
      expect(json['points'][0]['y'], 20);
      expect(json['points'][1]['x'], 30);
      expect(json['points'][1]['y'], 40);

      expect(json['lines'][0]['a']['x'], 0);
      expect(json['lines'][0]['a']['y'], 0);
      expect(json['lines'][0]['b']['x'], 100);
      expect(json['lines'][0]['b']['y'], 100);

      expect(json['triangles'][0]['a']['x'], 0);
      expect(json['triangles'][0]['a']['y'], 0);
      expect(json['triangles'][0]['b']['x'], 100);
      expect(json['triangles'][0]['b']['y'], 0);
      expect(json['triangles'][0]['c']['x'], 50);
      expect(json['triangles'][0]['c']['y'], 86.6);
    });

    test('allFigures возвращает все фигуры в виде плоского списка', () {
      final collection = FigureCollection(
        points: [
          PointFigure(Point(x: 10, y: 20)),
          PointFigure(Point(x: 30, y: 40)),
        ],
        lines: [
          LineFigure(Line(
            a: Point(x: 0, y: 0),
            b: Point(x: 100, y: 100),
          )),
        ],
        triangles: [
          TriangleFigure(Triangle(
            a: Point(x: 0, y: 0),
            b: Point(x: 100, y: 0),
            c: Point(x: 50, y: 86.6),
          )),
        ],
      );

      final allFigures = collection.allFigures;

      expect(allFigures.length, 4);
      expect(allFigures[0], isA<PointFigure>());
      expect(allFigures[1], isA<PointFigure>());
      expect(allFigures[2], isA<LineFigure>());
      expect(allFigures[3], isA<TriangleFigure>());
    });

    test('addPoint добавляет точку в коллекцию', () {
      final collection = FigureCollection();
      final newCollection = collection.addPoint(Point(x: 10, y: 20));

      expect(collection.points.length, 0);
      expect(newCollection.points.length, 1);
      expect(newCollection.points[0].point.x, 10);
      expect(newCollection.points[0].point.y, 20);
    });

    test('addLine добавляет линию в коллекцию', () {
      final collection = FigureCollection();
      final newCollection = collection.addLine(Line(
        a: Point(x: 0, y: 0),
        b: Point(x: 100, y: 100),
      ));

      expect(collection.lines.length, 0);
      expect(newCollection.lines.length, 1);
      expect(newCollection.lines[0].line.a.x, 0);
      expect(newCollection.lines[0].line.a.y, 0);
      expect(newCollection.lines[0].line.b.x, 100);
      expect(newCollection.lines[0].line.b.y, 100);
    });

    test('addTriangle добавляет треугольник в коллекцию', () {
      final collection = FigureCollection();
      final newCollection = collection.addTriangle(Triangle(
        a: Point(x: 0, y: 0),
        b: Point(x: 100, y: 0),
        c: Point(x: 50, y: 86.6),
      ));

      expect(collection.triangles.length, 0);
      expect(newCollection.triangles.length, 1);
      expect(newCollection.triangles[0].triangle.a.x, 0);
      expect(newCollection.triangles[0].triangle.a.y, 0);
      expect(newCollection.triangles[0].triangle.b.x, 100);
      expect(newCollection.triangles[0].triangle.b.y, 0);
      expect(newCollection.triangles[0].triangle.c.x, 50);
      expect(newCollection.triangles[0].triangle.c.y, 86.6);
    });
  });

  group('FigureReader', () {
    test('readFromString читает фигуры из строки JSON', () async {
      final jsonString = '''
      {
        "points": [
          {"x": 10, "y": 20},
          {"x": 30, "y": 40}
        ],
        "lines": [
          {
            "a": {"x": 0, "y": 0},
            "b": {"x": 100, "y": 100}
          }
        ],
        "triangles": [
          {
            "a": {"x": 0, "y": 0},
            "b": {"x": 100, "y": 0},
            "c": {"x": 50, "y": 86.6}
          }
        ]
      }
      ''';

      final reader = FigureReader();
      final collection = await reader.readFromString(jsonString);

      expect(collection.points.length, 2);
      expect(collection.lines.length, 1);
      expect(collection.triangles.length, 1);

      reader.dispose();
    });

    test('figuresStream передает прочитанные фигуры', () async {
      final jsonString = '''
      {
        "points": [
          {"x": 10, "y": 20},
          {"x": 30, "y": 40}
        ],
        "lines": [],
        "triangles": []
      }
      ''';

      final reader = FigureReader();
      
      // Подписка на Stream
      reader.figuresStream.listen(expectAsync1((collection) {
        expect(collection.points.length, 2);
        expect(collection.lines.length, 0);
        expect(collection.triangles.length, 0);
      }));

      // Чтение из строки
      await reader.readFromString(jsonString);

      reader.dispose();
    });
  });
}
