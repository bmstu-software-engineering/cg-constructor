import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('Arc', () {
    test('создание', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      expect(arc.center, center);
      expect(arc.radius, radius);
      expect(arc.startAngle, startAngle);
      expect(arc.endAngle, endAngle);
      expect(arc.color, '#000000');
      expect(arc.thickness, 1.0);
    });

    test('создание с цветом и толщиной', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        color: '#FF0000',
        thickness: 2.0,
      );
      expect(arc.center, center);
      expect(arc.radius, radius);
      expect(arc.startAngle, startAngle);
      expect(arc.endAngle, endAngle);
      expect(arc.color, '#FF0000');
      expect(arc.thickness, 2.0);
    });

    test('toJson и fromJson', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        color: '#FF0000',
        thickness: 2.0,
      );
      final json = arc.toJson();
      final fromJson = Arc.fromJson(json);
      expect(fromJson.center.x, arc.center.x);
      expect(fromJson.center.y, arc.center.y);
      expect(fromJson.radius, arc.radius);
      expect(fromJson.startAngle, arc.startAngle);
      expect(fromJson.endAngle, arc.endAngle);
      expect(fromJson.color, arc.color);
      expect(fromJson.thickness, arc.thickness);
    });

    test('toPoints', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      final points = arc.toPoints();
      expect(points.length, 3);
      expect(points[0], center);
      expect(points[1].x, closeTo(15, 1e-10)); // startPoint
      expect(points[1].y, closeTo(5, 1e-10));
      expect(points[2].x, closeTo(5, 1e-10)); // endPoint
      expect(points[2].y, closeTo(15, 1e-10));
    });

    test('fromPoints', () {
      final center = Point(x: 5, y: 5);
      final startPoint = Point(x: 15, y: 5);
      final endPoint = Point(x: 5, y: 15);
      final points = [center, startPoint, endPoint];
      final fromPoints =
          Figure.fromPoints(points, 'arc', color: '#FF0000', thickness: 2.0);
      expect(fromPoints, isA<Arc>());
      final arcFromPoints = fromPoints as Arc;
      expect(arcFromPoints.center.x, center.x);
      expect(arcFromPoints.center.y, center.y);
      expect(arcFromPoints.radius, 10);
      expect(arcFromPoints.startAngle, closeTo(0, 1e-10));
      expect(arcFromPoints.endAngle, closeTo(math.pi / 2, 1e-10));
      expect(arcFromPoints.color, '#FF0000');
      expect(arcFromPoints.thickness, 2.0);
    });

    test('move', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      final vector = Vector(dx: 3, dy: -2);
      final moved = arc.move(vector);
      expect(moved.center.x, 8);
      expect(moved.center.y, 3);
      expect(moved.radius, radius);
      expect(moved.startAngle, startAngle);
      expect(moved.endAngle, endAngle);
    });

    test('scale', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      final scaleCenter = Point(x: 0, y: 0);
      final scale = Scale(x: 2, y: 0.5);
      final scaled = arc.scale(scaleCenter, scale);
      expect(scaled.center.x, 10);
      expect(scaled.center.y, 2.5);
      // Для дуги используется среднее значение масштаба
      expect(scaled.radius, 12.5);
      expect(scaled.startAngle, startAngle);
      expect(scaled.endAngle, endAngle);
    });

    test('rotate', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      final rotationCenter = Point(x: 0, y: 0);
      final rotated = arc.rotate(rotationCenter, 90);
      expect(rotated.center.x, closeTo(-5, 1e-10));
      expect(rotated.center.y, closeTo(5, 1e-10));
      expect(rotated.radius, radius);
      // При повороте на 90 градусов углы увеличиваются на pi/2
      expect(rotated.startAngle, closeTo(math.pi / 2, 1e-10));
      expect(rotated.endAngle, closeTo(math.pi, 1e-10));
    });

    test('angle', () {
      // Дуга от 0 до pi/2 (90 градусов)
      final arc1 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      expect(arc1.angle, closeTo(math.pi / 2, 1e-10));

      // Дуга от pi/2 до 0 (270 градусов, т.к. идем против часовой стрелки)
      final arc2 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: math.pi / 2,
        endAngle: 0,
      );
      expect(arc2.angle, closeTo(3 * math.pi / 2, 1e-10));

      // Полная окружность
      final arc3 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: 2 * math.pi,
      );
      expect(arc3.angle, closeTo(2 * math.pi, 1e-10));
    });

    test('length', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      // Длина дуги = радиус * угол
      expect(arc.length, closeTo(radius * (math.pi / 2), 1e-10));
    });

    test('perimeter', () {
      // Дуга (не полная окружность)
      final arc1 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      // Периметр = длина дуги + 2 радиуса
      expect(arc1.perimeter, closeTo(10 * (math.pi / 2) + 2 * 10, 1e-10));

      // Полная окружность
      final arc2 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: 2 * math.pi,
      );
      // Периметр = длина окружности
      expect(arc2.perimeter, closeTo(2 * math.pi * 10, 1e-10));
    });

    test('sectorArea', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      // Площадь сектора = 0.5 * радиус^2 * угол
      expect(arc.sectorArea,
          closeTo(0.5 * radius * radius * (math.pi / 2), 1e-10));
    });

    test('segmentArea', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      // Площадь сегмента = 0.5 * радиус^2 * (угол - sin(угол))
      final theta = math.pi / 2;
      expect(arc.segmentArea,
          closeTo(0.5 * radius * radius * (theta - math.sin(theta)), 1e-10));
    });

    test('area', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      // Площадь дуги = площадь сектора
      expect(arc.area, closeTo(arc.sectorArea, 1e-10));
    });

    test('startPoint и endPoint', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi / 2;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );

      // Начальная точка (справа)
      expect(arc.startPoint.x, closeTo(15, 1e-10));
      expect(arc.startPoint.y, closeTo(5, 1e-10));

      // Конечная точка (сверху)
      expect(arc.endPoint.x, closeTo(5, 1e-10));
      expect(arc.endPoint.y, closeTo(15, 1e-10));
    });

    test('pointAtAngle', () {
      final center = Point(x: 5, y: 5);
      final radius = 10.0;
      final startAngle = 0.0;
      final endAngle = math.pi;
      final arc = Arc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
      );

      // Точка на 0 градусов (справа)
      final point0 = arc.pointAtAngle(0);
      expect(point0.x, closeTo(15, 1e-10));
      expect(point0.y, closeTo(5, 1e-10));

      // Точка на 90 градусов (сверху)
      final point90 = arc.pointAtAngle(math.pi / 2);
      expect(point90.x, closeTo(5, 1e-10));
      expect(point90.y, closeTo(15, 1e-10));

      // Точка на 180 градусов (слева)
      final point180 = arc.pointAtAngle(math.pi);
      expect(point180.x, closeTo(-5, 1e-10));
      expect(point180.y, closeTo(5, 1e-10));

      // Точка вне дуги должна вызвать ошибку
      expect(() => arc.pointAtAngle(3 * math.pi / 2), throwsArgumentError);
    });

    test('isFullCircle', () {
      // Дуга (не полная окружность)
      final arc1 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi,
      );
      expect(arc1.isFullCircle, false);

      // Полная окружность
      final arc2 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: 2 * math.pi,
      );
      expect(arc2.isFullCircle, true);

      // Почти полная окружность (с небольшой погрешностью)
      final arc3 = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: 2 * math.pi - 1e-11,
      );
      expect(arc3.isFullCircle, true);
    });

    test('validate', () {
      // Валидная дуга
      final arc = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      expect(arc.validate(), null);
      expect(arc.isValid(), true);

      // Невалидная дуга (отрицательный радиус)
      final invalidArc = Arc(
        center: Point(x: 5, y: 5),
        radius: -10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      expect(invalidArc.validate(), isNotNull);
      expect(invalidArc.isValid(), false);
    });

    test('name', () {
      final arc = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      expect(arc.name, 'Дуга');
    });

    test('toString', () {
      final arc = Arc(
        center: Point(x: 5, y: 5),
        radius: 10,
        startAngle: 0,
        endAngle: math.pi / 2,
      );
      expect(arc.toString(), contains('Дуга'));
      expect(arc.toString(), contains('center'));
      expect(arc.toString(), contains('radius'));
      expect(arc.toString(), contains('startAngle'));
      expect(arc.toString(), contains('endAngle'));
    });
  });
}
