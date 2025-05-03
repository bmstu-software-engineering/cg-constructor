import 'dart:math';
import 'package:models_ns/models_ns.dart';

/// Класс для базовых геометрических вычислений
class GeometryCalculator {
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
}
