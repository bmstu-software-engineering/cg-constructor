import 'dart:math' as math;
import 'package:models_ns/models_ns.dart';

/// Абстрактный класс для геометрических фигур
abstract class Figure {
  /// Цвет фигуры
  String get color;

  /// Толщина линии
  double get thickness;

  /// Название фигуры
  String get name;

  /// Центр фигуры
  Point get center;

  /// Периметр фигуры
  double get perimeter;

  /// Площадь фигуры
  double get area;

  /// Преобразует фигуру в список точек
  List<Point> toPoints();

  /// Перемещает фигуру на вектор
  Figure move(Vector vector);

  /// Масштабирует фигуру относительно центра
  Figure scale(Point center, Scale scale);

  /// Поворачивает фигуру относительно центра
  Figure rotate(Point center, double degree);

  /// Проверяет валидность фигуры
  String? validate();

  /// Проверяет валидность фигуры
  bool isValid() => validate() == null;

  /// Преобразует фигуру в JSON
  Map<String, dynamic> toJson();

  /// Создает фигуру из JSON
  static Figure fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    if (type != null) {
      switch (type) {
        case 'point':
          return Point.fromJson(json);
        case 'line':
          return Line.fromJson(json);
        case 'triangle':
          return Triangle.fromJson(json);
        case 'rectangle':
          return Rectangle.fromJson(json);
        case 'square':
          return Square.fromJson(json);
        case 'circle':
          return Circle.fromJson(json);
        case 'ellipse':
          return Ellipse.fromJson(json);
        case 'arc':
          return Arc.fromJson(json);
        case 'polygon':
          return Polygon.fromJson(json);
        default:
          throw ArgumentError('Неизвестный тип фигуры: $type');
      }
    } else {
      // Пытаемся определить тип фигуры по полям
      if (json.containsKey('x') && json.containsKey('y')) {
        return Point.fromJson(json);
      } else if (json.containsKey('a') && json.containsKey('b')) {
        return Line.fromJson(json);
      } else {
        throw ArgumentError('Невозможно определить тип фигуры');
      }
    }
  }

  /// Создает фигуру из списка точек
  static Figure fromPoints(List<Point> points, String type,
      {String color = '#000000', double thickness = 1.0}) {
    switch (type) {
      case 'point':
        if (points.length != 1) {
          throw ArgumentError('Для создания точки нужна 1 точка');
        }
        return Point(
          x: points[0].x,
          y: points[0].y,
          color: color,
          thickness: thickness,
        );
      case 'line':
        if (points.length != 2) {
          throw ArgumentError('Для создания линии нужно 2 точки');
        }
        return Line(
          a: points[0],
          b: points[1],
          color: color,
          thickness: thickness,
        );
      case 'triangle':
        if (points.length != 3) {
          throw ArgumentError('Для создания треугольника нужно 3 точки');
        }
        return Triangle(
          a: points[0],
          b: points[1],
          c: points[2],
          color: color,
          thickness: thickness,
        );
      case 'rectangle':
        if (points.length != 4) {
          throw ArgumentError('Для создания прямоугольника нужно 4 точки');
        }
        return Rectangle(
          topLeft: points[0],
          topRight: points[1],
          bottomRight: points[2],
          bottomLeft: points[3],
          color: color,
          thickness: thickness,
        );
      case 'square':
        if (points.length != 2) {
          throw ArgumentError(
              'Для создания квадрата нужно 2 точки (центр и вершина)');
        }
        // Вычисляем длину стороны как расстояние от центра до вершины * sqrt(2)
        final center = points[0];
        final vertex = points[1];
        final dx = vertex.x - center.x;
        final dy = vertex.y - center.y;
        final distance = math.sqrt(dx * dx + dy * dy);
        // Расстояние от центра до вершины = (sideLength / 2) * sqrt(2)
        // Поэтому sideLength = distance * 2 / sqrt(2) = distance * sqrt(2)
        final sideLength = distance * math.sqrt(2);
        return Square(
          center: center,
          sideLength: sideLength,
          color: color,
          thickness: thickness,
        );
      case 'circle':
        if (points.length != 2) {
          throw ArgumentError(
              'Для создания круга нужно 2 точки (центр и точка на окружности)');
        }
        // Вычисляем радиус как расстояние от центра до точки на окружности
        final center = points[0];
        final pointOnCircle = points[1];
        final dx = pointOnCircle.x - center.x;
        final dy = pointOnCircle.y - center.y;
        final radius = math.sqrt(dx * dx + dy * dy);
        return Circle(
          center: center,
          radius: radius,
          color: color,
          thickness: thickness,
        );
      case 'ellipse':
        if (points.length != 3) {
          throw ArgumentError(
              'Для создания эллипса нужно 3 точки (центр, точка на главной оси, точка на побочной оси)');
        }
        // Вычисляем полуоси как расстояния от центра до точек на осях
        final center = points[0];
        final pointOnMajorAxis = points[1];
        final pointOnMinorAxis = points[2];
        final dx1 = pointOnMajorAxis.x - center.x;
        final dy1 = pointOnMajorAxis.y - center.y;
        final dx2 = pointOnMinorAxis.x - center.x;
        final dy2 = pointOnMinorAxis.y - center.y;
        final semiMajorAxis = math.sqrt(dx1 * dx1 + dy1 * dy1);
        final semiMinorAxis = math.sqrt(dx2 * dx2 + dy2 * dy2);
        return Ellipse(
          center: center,
          semiMajorAxis: semiMajorAxis,
          semiMinorAxis: semiMinorAxis,
          color: color,
          thickness: thickness,
        );
      case 'arc':
        if (points.length != 3) {
          throw ArgumentError(
              'Для создания дуги нужно 3 точки (центр, начальная точка, конечная точка)');
        }
        // Вычисляем радиус и углы
        final center = points[0];
        final startPoint = points[1];
        final endPoint = points[2];
        final dx1 = startPoint.x - center.x;
        final dy1 = startPoint.y - center.y;
        final dx2 = endPoint.x - center.x;
        final dy2 = endPoint.y - center.y;
        final radius = math.sqrt(dx1 * dx1 + dy1 * dy1);
        final startAngle = math.atan2(dy1, dx1);
        final endAngle = math.atan2(dy2, dx2);
        return Arc(
          center: center,
          radius: radius,
          startAngle: startAngle,
          endAngle: endAngle,
          color: color,
          thickness: thickness,
        );
      case 'polygon':
        if (points.length < 3) {
          throw ArgumentError(
              'Для создания многоугольника нужно минимум 3 точки');
        }
        return Polygon(
          points: points,
          color: color,
          thickness: thickness,
        );
      default:
        throw ArgumentError('Неизвестный тип фигуры: $type');
    }
  }
}
