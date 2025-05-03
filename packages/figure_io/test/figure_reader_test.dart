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

      expect(collection.points[0].x, 10);
      expect(collection.points[0].y, 20);
      expect(collection.points[1].x, 30);
      expect(collection.points[1].y, 40);

      expect(collection.lines[0].a.x, 0);
      expect(collection.lines[0].a.y, 0);
      expect(collection.lines[0].b.x, 100);
      expect(collection.lines[0].b.y, 100);

      expect(collection.triangles[0].a.x, 0);
      expect(collection.triangles[0].a.y, 0);
      expect(collection.triangles[0].b.x, 100);
      expect(collection.triangles[0].b.y, 0);
      expect(collection.triangles[0].c.x, 50);
      expect(collection.triangles[0].c.y, 86.6);
    });

    test('toJson преобразует коллекцию в JSON', () {
      const collection = FigureCollection(
        points: [Point(x: 10, y: 20), Point(x: 30, y: 40)],
        lines: [Line(a: Point(x: 0, y: 0), b: Point(x: 100, y: 100))],
        triangles: [
          Triangle(
            a: Point(x: 0, y: 0),
            b: Point(x: 100, y: 0),
            c: Point(x: 50, y: 86.6),
          ),
        ],
      );

      final json = collection.toJson();

      expect(json['points'].length, 2);
      expect(json['lines'].length, 1);
      expect(json['triangles'].length, 1);

      // Проверяем, что JSON содержит нужные ключи и что их значения имеют правильную длину
      expect(json.containsKey('points'), isTrue);
      expect(json.containsKey('lines'), isTrue);
      expect(json.containsKey('triangles'), isTrue);

      expect(json['points'].length, 2);
      expect(json['lines'].length, 1);
      expect(json['triangles'].length, 1);

      // Проверяем, что исходная коллекция не изменилась
      expect(collection.points.length, 2);
      expect(collection.points[0].x, 10);
      expect(collection.points[0].y, 20);
      expect(collection.points[1].x, 30);
      expect(collection.points[1].y, 40);

      expect(collection.lines.length, 1);
      expect(collection.lines[0].a.x, 0);
      expect(collection.lines[0].a.y, 0);
      expect(collection.lines[0].b.x, 100);
      expect(collection.lines[0].b.y, 100);

      expect(collection.triangles.length, 1);
      expect(collection.triangles[0].a.x, 0);
      expect(collection.triangles[0].a.y, 0);
      expect(collection.triangles[0].b.x, 100);
      expect(collection.triangles[0].b.y, 0);
      expect(collection.triangles[0].c.x, 50);
      expect(collection.triangles[0].c.y, 86.6);
    });
  });

  group('FigureReader', () {
    test('readFromString читает фигуры из строки JSON', () async {
      const jsonString = '''
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
      const jsonString = '''
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
      reader.figuresStream.listen(
        expectAsync1((collection) {
          expect(collection.points.length, 2);
          expect(collection.lines.length, 0);
          expect(collection.triangles.length, 0);
        }),
      );

      // Чтение из строки
      await reader.readFromString(jsonString);

      reader.dispose();
    });
  });
}
