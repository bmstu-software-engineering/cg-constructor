import 'package:models_ns/models_ns.dart';

/// Класс для проверки, лежат ли точки на одной прямой
class PointsOnLineChecker {
  /// Проверяет, лежат ли три точки на одной прямой
  ///
  /// Использует формулу площади треугольника через векторное произведение
  static bool arePointsOnLine(Point a, Point b, Point c) {
    // Вычисляем площадь треугольника через векторное произведение
    // Если площадь равна нулю, то точки лежат на одной прямой
    final area =
        0.5 * ((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)).abs();

    // Используем небольшую погрешность для сравнения с нулем из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return area < epsilon;
  }

  /// Проверяет, лежат ли три точки треугольника на одной прямой
  static bool isTriangleDegenerate(Triangle triangle) {
    return arePointsOnLine(triangle.a, triangle.b, triangle.c);
  }
}
