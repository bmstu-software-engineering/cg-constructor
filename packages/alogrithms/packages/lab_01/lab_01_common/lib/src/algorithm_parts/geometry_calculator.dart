import 'dart:math';
import 'package:models_ns/models_ns.dart';
import '../exceptions.dart';

/// Класс для базовых геометрических вычислений
class GeometryCalculator {
  /// Проверка, что три точки не лежат на одной прямой
  static bool isValidTriangle(Triangle triangle) {
    final area = calculateTriangleArea(triangle);
    return area > 1e-10; // Если площадь близка к нулю, то точки на одной прямой
  }

  /// Вычисление расстояния между двумя точками
  static double calculateDistance(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }

  /// Вычисление угла между прямой и осью абсцисс
  static double calculateAngle(Point p1, Point p2) {
    // Используем atan2 для получения угла в диапазоне [-π, π]
    double angle = atan2(p2.y - p1.y, p2.x - p1.x);

    // Преобразуем в диапазон [0, π] для нашей задачи
    if (angle < 0) angle += pi;

    return angle;
  }

  /// Вычисление площади треугольника по формуле Герона
  static double calculateTriangleArea(Triangle triangle) {
    final a = calculateDistance(triangle.b, triangle.c);
    final b = calculateDistance(triangle.a, triangle.c);
    final c = calculateDistance(triangle.a, triangle.b);

    final s = (a + b + c) / 2; // полупериметр
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  /// Вычисление периметра треугольника
  static double calculateTrianglePerimeter(Triangle triangle) {
    final a = calculateDistance(triangle.b, triangle.c);
    final b = calculateDistance(triangle.a, triangle.c);
    final c = calculateDistance(triangle.a, triangle.b);

    return a + b + c;
  }

  /// Вычисление центра вписанной окружности треугольника
  static Point calculateIncenter(Triangle triangle) {
    final a = calculateDistance(triangle.b, triangle.c);
    final b = calculateDistance(triangle.a, triangle.c);
    final c = calculateDistance(triangle.a, triangle.b);

    final perimeter = a + b + c;

    // Координаты центра вписанной окружности
    final x =
        (a * triangle.a.x + b * triangle.b.x + c * triangle.c.x) / perimeter;
    final y =
        (a * triangle.a.y + b * triangle.b.y + c * triangle.c.y) / perimeter;

    return Point(x: x, y: y);
  }

  /// Вычисление центра описанной окружности треугольника
  static Point calculateCircumcenter(Triangle triangle) {
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Проверка, что треугольник не вырожденный
    if (!isValidTriangle(triangle)) {
      throw CalculationException(
        'Невозможно вычислить центр описанной окружности для вырожденного треугольника',
      );
    }

    // Вычисляем определитель для знаменателя
    final d = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y));

    if (d.abs() < 1e-10) {
      throw CalculationException(
        'Невозможно вычислить центр описанной окружности (деление на ноль)',
      );
    }

    // Вычисляем координаты центра описанной окружности
    final x =
        ((a.x * a.x + a.y * a.y) * (b.y - c.y) +
            (b.x * b.x + b.y * b.y) * (c.y - a.y) +
            (c.x * c.x + c.y * c.y) * (a.y - b.y)) /
        d;

    final y =
        ((a.x * a.x + a.y * a.y) * (c.x - b.x) +
            (b.x * b.x + b.y * b.y) * (a.x - c.x) +
            (c.x * c.x + c.y * c.y) * (b.x - a.x)) /
        d;

    return Point(x: x, y: y);
  }

  /// Вычисление барицентра (центра масс) треугольника
  static Point calculateBarycenter(Triangle triangle) {
    // Барицентр - это среднее арифметическое координат вершин треугольника
    final x = (triangle.a.x + triangle.b.x + triangle.c.x) / 3;
    final y = (triangle.a.y + triangle.b.y + triangle.c.y) / 3;

    return Point(x: x, y: y);
  }
}
