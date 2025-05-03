import 'package:models_ns/models_ns.dart';
import 'geometry_calculator.dart';

/// Класс для анализа свойств треугольников
class TriangleAnalyzer {
  /// Определение вершины с тупым углом в треугольнике (если есть)
  static Point? findObtuseAngleVertex(Triangle triangle) {
    Point a = triangle.a, b = triangle.b, c = triangle.c;

    // Вычисляем длины сторон треугольника
    double ab = GeometryCalculator.calculateDistance(a, b);
    double bc = GeometryCalculator.calculateDistance(b, c);
    double ca = GeometryCalculator.calculateDistance(c, a);

    // Проверяем угол при вершине A
    double cosA = (ab * ab + ca * ca - bc * bc) / (2 * ab * ca);
    if (cosA < 0) return a;

    // Проверяем угол при вершине B
    double cosB = (ab * ab + bc * bc - ca * ca) / (2 * ab * bc);
    if (cosB < 0) return b;

    // Проверяем угол при вершине C
    double cosC = (bc * bc + ca * ca - ab * ab) / (2 * bc * ca);
    if (cosC < 0) return c;

    // Нет тупого угла
    return null;
  }

  /// Находит треугольники с тупыми углами и соответствующие вершины
  static List<(Triangle, Point)> findObtuseTriangles(List<Triangle> triangles) {
    List<(Triangle, Point)> obtuseTriangles = [];
    for (var triangle in triangles) {
      Point? obtuseVertex = findObtuseAngleVertex(triangle);
      if (obtuseVertex != null) {
        obtuseTriangles.add((triangle, obtuseVertex));
      }
    }
    return obtuseTriangles;
  }
}
