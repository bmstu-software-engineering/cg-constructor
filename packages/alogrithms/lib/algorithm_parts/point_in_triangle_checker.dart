import 'package:models_ns/models_ns.dart';

/// Класс для проверки, лежит ли точка внутри треугольника
class PointInTriangleChecker {
  /// Проверяет, лежит ли точка строго внутри треугольника
  ///
  /// Использует метод барицентрических координат
  static bool isPointInsideTriangle(Point point, Triangle triangle) {
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Вычисляем барицентрические координаты
    final denominator = ((b.y - c.y) * (a.x - c.x) + (c.x - b.x) * (a.y - c.y));

    // Если знаменатель равен нулю, то точки треугольника лежат на одной прямой
    if (denominator == 0) return false;

    final alpha =
        ((b.y - c.y) * (point.x - c.x) + (c.x - b.x) * (point.y - c.y)) /
        denominator;
    final beta =
        ((c.y - a.y) * (point.x - c.x) + (a.x - c.x) * (point.y - c.y)) /
        denominator;
    final gamma = 1 - alpha - beta;

    // Точка лежит строго внутри треугольника, если все барицентрические координаты
    // строго положительны (не включая границы)
    return alpha > 0 && beta > 0 && gamma > 0;
  }

  /// Подсчитывает количество точек из множества, которые лежат строго внутри треугольника
  static int countPointsInsideTriangle(List<Point> points, Triangle triangle) {
    int count = 0;
    for (final point in points) {
      if (isPointInsideTriangle(point, triangle)) {
        count++;
      }
    }
    return count;
  }

  /// Подсчитывает количество точек из множества, которые лежат строго внутри каждого из подтреугольников
  ///
  /// Возвращает список из количества точек для каждого подтреугольника
  static List<int> countPointsInsideSubtriangles(
    List<Point> points,
    List<Triangle> subtriangles,
  ) {
    return subtriangles
        .map((triangle) => countPointsInsideTriangle(points, triangle))
        .toList();
  }
}
