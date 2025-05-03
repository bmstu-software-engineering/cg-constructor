import 'package:models_ns/models_ns.dart';

/// Класс для генерации треугольников из множества точек
class TriangleGenerator {
  /// Генерация всех возможных треугольников из множества точек
  static List<Triangle> generateTriangles(List<Point> points) {
    List<Triangle> triangles = [];
    for (int i = 0; i < points.length - 2; i++) {
      for (int j = i + 1; j < points.length - 1; j++) {
        for (int k = j + 1; k < points.length; k++) {
          triangles.add(Triangle(a: points[i], b: points[j], c: points[k]));
        }
      }
    }
    return triangles;
  }
}
