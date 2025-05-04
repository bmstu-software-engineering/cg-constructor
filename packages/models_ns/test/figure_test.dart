import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Figure', () {
    group('fromJson', () {
      test('создание Point из JSON с указанием типа', () {
        final json = {
          'type': 'point',
          'x': 10.0,
          'y': 20.0,
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Point>());
        final point = figure as Point;
        expect(point.x, 10.0);
        expect(point.y, 20.0);
        expect(point.color, '#FF0000');
        expect(point.thickness, 2.0);
      });

      test('создание Line из JSON с указанием типа', () {
        final json = {
          'type': 'line',
          'a': {'x': 0.0, 'y': 0.0},
          'b': {'x': 10.0, 'y': 10.0},
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Line>());
        final line = figure as Line;
        expect(line.a.x, 0.0);
        expect(line.a.y, 0.0);
        expect(line.b.x, 10.0);
        expect(line.b.y, 10.0);
        expect(line.color, '#FF0000');
        expect(line.thickness, 2.0);
      });

      test('создание Triangle из JSON с указанием типа', () {
        final json = {
          'type': 'triangle',
          'a': {'x': 0.0, 'y': 0.0},
          'b': {'x': 10.0, 'y': 0.0},
          'c': {'x': 5.0, 'y': 8.0},
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Triangle>());
        final triangle = figure as Triangle;
        expect(triangle.a.x, 0.0);
        expect(triangle.a.y, 0.0);
        expect(triangle.b.x, 10.0);
        expect(triangle.b.y, 0.0);
        expect(triangle.c.x, 5.0);
        expect(triangle.c.y, 8.0);
        expect(triangle.color, '#FF0000');
        expect(triangle.thickness, 2.0);
      });

      test('создание Rectangle из JSON с указанием типа', () {
        final json = {
          'type': 'rectangle',
          'topLeft': {'x': 0.0, 'y': 0.0},
          'topRight': {'x': 10.0, 'y': 0.0},
          'bottomRight': {'x': 10.0, 'y': 8.0},
          'bottomLeft': {'x': 0.0, 'y': 8.0},
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Rectangle>());
        final rectangle = figure as Rectangle;
        expect(rectangle.topLeft.x, 0.0);
        expect(rectangle.topLeft.y, 0.0);
        expect(rectangle.topRight.x, 10.0);
        expect(rectangle.topRight.y, 0.0);
        expect(rectangle.bottomRight.x, 10.0);
        expect(rectangle.bottomRight.y, 8.0);
        expect(rectangle.bottomLeft.x, 0.0);
        expect(rectangle.bottomLeft.y, 8.0);
        expect(rectangle.color, '#FF0000');
        expect(rectangle.thickness, 2.0);
      });

      test('создание Square из JSON с указанием типа', () {
        final json = {
          'type': 'square',
          'center': {'x': 5.0, 'y': 5.0},
          'sideLength': 10.0,
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Square>());
        final square = figure as Square;
        expect(square.center.x, 5.0);
        expect(square.center.y, 5.0);
        expect(square.sideLength, 10.0);
        expect(square.color, '#FF0000');
        expect(square.thickness, 2.0);
      });

      test('создание Circle из JSON с указанием типа', () {
        final json = {
          'type': 'circle',
          'center': {'x': 5.0, 'y': 5.0},
          'radius': 10.0,
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Circle>());
        final circle = figure as Circle;
        expect(circle.center.x, 5.0);
        expect(circle.center.y, 5.0);
        expect(circle.radius, 10.0);
        expect(circle.color, '#FF0000');
        expect(circle.thickness, 2.0);
      });

      test('создание Ellipse из JSON с указанием типа', () {
        final json = {
          'type': 'ellipse',
          'center': {'x': 5.0, 'y': 5.0},
          'semiMajorAxis': 10.0,
          'semiMinorAxis': 6.0,
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Ellipse>());
        final ellipse = figure as Ellipse;
        expect(ellipse.center.x, 5.0);
        expect(ellipse.center.y, 5.0);
        expect(ellipse.semiMajorAxis, 10.0);
        expect(ellipse.semiMinorAxis, 6.0);
        expect(ellipse.color, '#FF0000');
        expect(ellipse.thickness, 2.0);
      });

      test('создание Arc из JSON с указанием типа', () {
        final json = {
          'type': 'arc',
          'center': {'x': 5.0, 'y': 5.0},
          'radius': 10.0,
          'startAngle': 0.0,
          'endAngle': 1.57, // примерно pi/2
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Arc>());
        final arc = figure as Arc;
        expect(arc.center.x, 5.0);
        expect(arc.center.y, 5.0);
        expect(arc.radius, 10.0);
        expect(arc.startAngle, 0.0);
        expect(arc.endAngle, closeTo(1.57, 1e-10));
        expect(arc.color, '#FF0000');
        expect(arc.thickness, 2.0);
      });

      test('создание Polygon из JSON с указанием типа', () {
        final json = {
          'type': 'polygon',
          'points': [
            {'x': 0.0, 'y': 0.0},
            {'x': 10.0, 'y': 0.0},
            {'x': 10.0, 'y': 10.0},
            {'x': 0.0, 'y': 10.0},
          ],
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Polygon>());
        final polygon = figure as Polygon;
        expect(polygon.points.length, 4);
        expect(polygon.points[0].x, 0.0);
        expect(polygon.points[0].y, 0.0);
        expect(polygon.points[1].x, 10.0);
        expect(polygon.points[1].y, 0.0);
        expect(polygon.points[2].x, 10.0);
        expect(polygon.points[2].y, 10.0);
        expect(polygon.points[3].x, 0.0);
        expect(polygon.points[3].y, 10.0);
        expect(polygon.color, '#FF0000');
        expect(polygon.thickness, 2.0);
      });

      test('создание Point из JSON без указания типа', () {
        final json = {
          'x': 10.0,
          'y': 20.0,
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Point>());
        final point = figure as Point;
        expect(point.x, 10.0);
        expect(point.y, 20.0);
        expect(point.color, '#FF0000');
        expect(point.thickness, 2.0);
      });

      test('создание Line из JSON без указания типа', () {
        final json = {
          'a': {'x': 0.0, 'y': 0.0},
          'b': {'x': 10.0, 'y': 10.0},
          'color': '#FF0000',
          'thickness': 2.0,
        };
        final figure = Figure.fromJson(json);
        expect(figure, isA<Line>());
        final line = figure as Line;
        expect(line.a.x, 0.0);
        expect(line.a.y, 0.0);
        expect(line.b.x, 10.0);
        expect(line.b.y, 10.0);
        expect(line.color, '#FF0000');
        expect(line.thickness, 2.0);
      });

      test('ошибка при неизвестном типе фигуры', () {
        final json = {
          'type': 'unknown',
          'x': 10.0,
          'y': 20.0,
        };
        expect(() => Figure.fromJson(json), throwsArgumentError);
      });

      test('ошибка при невозможности определить тип фигуры', () {
        final json = {
          'unknown': 'value',
        };
        expect(() => Figure.fromJson(json), throwsArgumentError);
      });
    });

    group('fromPoints', () {
      test('создание Point из списка точек', () {
        final points = [Point(x: 10, y: 20)];
        final figure = Figure.fromPoints(points, 'point',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Point>());
        final point = figure as Point;
        expect(point.x, 10);
        expect(point.y, 20);
        expect(point.color, '#FF0000');
        expect(point.thickness, 2.0);
      });

      test('создание Line из списка точек', () {
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 10),
        ];
        final figure =
            Figure.fromPoints(points, 'line', color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Line>());
        final line = figure as Line;
        expect(line.a.x, 0);
        expect(line.a.y, 0);
        expect(line.b.x, 10);
        expect(line.b.y, 10);
        expect(line.color, '#FF0000');
        expect(line.thickness, 2.0);
      });

      test('создание Triangle из списка точек', () {
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 5, y: 8),
        ];
        final figure = Figure.fromPoints(points, 'triangle',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Triangle>());
        final triangle = figure as Triangle;
        expect(triangle.a.x, 0);
        expect(triangle.a.y, 0);
        expect(triangle.b.x, 10);
        expect(triangle.b.y, 0);
        expect(triangle.c.x, 5);
        expect(triangle.c.y, 8);
        expect(triangle.color, '#FF0000');
        expect(triangle.thickness, 2.0);
      });

      test('создание Rectangle из списка точек', () {
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 10, y: 8),
          Point(x: 0, y: 8),
        ];
        final figure = Figure.fromPoints(points, 'rectangle',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Rectangle>());
        final rectangle = figure as Rectangle;
        expect(rectangle.topLeft.x, 0);
        expect(rectangle.topLeft.y, 0);
        expect(rectangle.topRight.x, 10);
        expect(rectangle.topRight.y, 0);
        expect(rectangle.bottomRight.x, 10);
        expect(rectangle.bottomRight.y, 8);
        expect(rectangle.bottomLeft.x, 0);
        expect(rectangle.bottomLeft.y, 8);
        expect(rectangle.color, '#FF0000');
        expect(rectangle.thickness, 2.0);
      });

      test('создание Square из списка точек', () {
        final points = [
          Point(x: 5, y: 5), // центр
          Point(x: 10, y: 0), // вершина
        ];
        final figure = Figure.fromPoints(points, 'square',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Square>());
        final square = figure as Square;
        expect(square.center.x, 5);
        expect(square.center.y, 5);
        expect(square.sideLength, closeTo(10, 1e-10));
        expect(square.color, '#FF0000');
        expect(square.thickness, 2.0);
      });

      test('создание Circle из списка точек', () {
        final points = [
          Point(x: 5, y: 5), // центр
          Point(x: 15, y: 5), // точка на окружности
        ];
        final figure = Figure.fromPoints(points, 'circle',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Circle>());
        final circle = figure as Circle;
        expect(circle.center.x, 5);
        expect(circle.center.y, 5);
        expect(circle.radius, 10);
        expect(circle.color, '#FF0000');
        expect(circle.thickness, 2.0);
      });

      test('создание Ellipse из списка точек', () {
        final points = [
          Point(x: 5, y: 5), // центр
          Point(x: 15, y: 5), // точка на главной оси
          Point(x: 5, y: 11), // точка на побочной оси
        ];
        final figure = Figure.fromPoints(points, 'ellipse',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Ellipse>());
        final ellipse = figure as Ellipse;
        expect(ellipse.center.x, 5);
        expect(ellipse.center.y, 5);
        expect(ellipse.semiMajorAxis, 10);
        expect(ellipse.semiMinorAxis, 6);
        expect(ellipse.color, '#FF0000');
        expect(ellipse.thickness, 2.0);
      });

      test('создание Arc из списка точек', () {
        final points = [
          Point(x: 5, y: 5), // центр
          Point(x: 15, y: 5), // начальная точка (0 градусов)
          Point(x: 5, y: 15), // конечная точка (90 градусов)
        ];
        final figure =
            Figure.fromPoints(points, 'arc', color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Arc>());
        final arc = figure as Arc;
        expect(arc.center.x, 5);
        expect(arc.center.y, 5);
        expect(arc.radius, 10);
        expect(arc.startAngle, closeTo(0, 1e-10));
        expect(arc.endAngle, closeTo(math.pi / 2, 1e-10));
        expect(arc.color, '#FF0000');
        expect(arc.thickness, 2.0);
      });

      test('создание Polygon из списка точек', () {
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 10, y: 10),
          Point(x: 0, y: 10),
        ];
        final figure = Figure.fromPoints(points, 'polygon',
            color: '#FF0000', thickness: 2.0);
        expect(figure, isA<Polygon>());
        final polygon = figure as Polygon;
        expect(polygon.points.length, 4);
        expect(polygon.points[0].x, 0);
        expect(polygon.points[0].y, 0);
        expect(polygon.points[1].x, 10);
        expect(polygon.points[1].y, 0);
        expect(polygon.points[2].x, 10);
        expect(polygon.points[2].y, 10);
        expect(polygon.points[3].x, 0);
        expect(polygon.points[3].y, 10);
        expect(polygon.color, '#FF0000');
        expect(polygon.thickness, 2.0);
      });

      test('ошибка при неизвестном типе фигуры', () {
        final points = [Point(x: 10, y: 20)];
        expect(() => Figure.fromPoints(points, 'unknown'), throwsArgumentError);
      });

      test('ошибка при неверном количестве точек', () {
        // Для точки нужна 1 точка
        final points1 = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 10),
        ];
        expect(() => Figure.fromPoints(points1, 'point'), throwsArgumentError);

        // Для линии нужно 2 точки
        final points2 = [Point(x: 0, y: 0)];
        expect(() => Figure.fromPoints(points2, 'line'), throwsArgumentError);

        // Для треугольника нужно 3 точки
        final points3 = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 10),
        ];
        expect(
            () => Figure.fromPoints(points3, 'triangle'), throwsArgumentError);

        // Для прямоугольника нужно 4 точки
        final points4 = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 10, y: 10),
        ];
        expect(
            () => Figure.fromPoints(points4, 'rectangle'), throwsArgumentError);

        // Для квадрата нужно 2 точки
        final points5 = [Point(x: 5, y: 5)];
        expect(() => Figure.fromPoints(points5, 'square'), throwsArgumentError);

        // Для круга нужно 2 точки
        final points6 = [Point(x: 5, y: 5)];
        expect(() => Figure.fromPoints(points6, 'circle'), throwsArgumentError);

        // Для эллипса нужно 3 точки
        final points7 = [
          Point(x: 5, y: 5),
          Point(x: 15, y: 5),
        ];
        expect(
            () => Figure.fromPoints(points7, 'ellipse'), throwsArgumentError);

        // Для дуги нужно 3 точки
        final points8 = [
          Point(x: 5, y: 5),
          Point(x: 15, y: 5),
        ];
        expect(() => Figure.fromPoints(points8, 'arc'), throwsArgumentError);

        // Для многоугольника нужно минимум 3 точки
        final points9 = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
        ];
        expect(
            () => Figure.fromPoints(points9, 'polygon'), throwsArgumentError);
      });
    });
  });
}
