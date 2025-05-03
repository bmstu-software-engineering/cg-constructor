import 'package:models_ns/models_ns.dart';

/// Класс для вычисления медиан треугольника и точки их пересечения
class TriangleMedianCalculator {
  /// Вычисляет медианы треугольника
  ///
  /// Возвращает список из трех медиан, где каждая медиана представлена как линия
  /// от вершины треугольника до середины противоположной стороны
  static List<Line> calculateMedians(Triangle triangle) {
    // Вершины треугольника
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Середины сторон
    final midAB = Point(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2);
    final midBC = Point(x: (b.x + c.x) / 2, y: (b.y + c.y) / 2);
    final midCA = Point(x: (c.x + a.x) / 2, y: (c.y + a.y) / 2);

    // Медианы
    final medianA = Line(a: a, b: midBC);
    final medianB = Line(a: b, b: midCA);
    final medianC = Line(a: c, b: midAB);

    return [medianA, medianB, medianC];
  }

  /// Вычисляет точку пересечения медиан треугольника (центроид)
  ///
  /// Центроид треугольника находится на расстоянии 2/3 от любой вершины
  /// до середины противоположной стороны
  static Point calculateCentroid(Triangle triangle) {
    // Вершины треугольника
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Центроид (точка пересечения медиан)
    final centroid = Point(x: (a.x + b.x + c.x) / 3, y: (a.y + b.y + c.y) / 3);

    return centroid;
  }

  /// Разбивает треугольник на 6 меньших треугольников с помощью медиан
  ///
  /// Возвращает список из 6 треугольников
  static List<Triangle> divideTriangleByMedians(Triangle triangle) {
    // Вершины треугольника
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Середины сторон
    final midAB = Point(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2);
    final midBC = Point(x: (b.x + c.x) / 2, y: (b.y + c.y) / 2);
    final midCA = Point(x: (c.x + a.x) / 2, y: (c.y + a.y) / 2);

    // Центроид (точка пересечения медиан)
    final centroid = calculateCentroid(triangle);

    // 6 треугольников, образованных медианами
    final triangles = [
      Triangle(a: a, b: midAB, c: centroid),
      Triangle(a: a, b: centroid, c: midCA),
      Triangle(a: b, b: midBC, c: centroid),
      Triangle(a: b, b: centroid, c: midAB),
      Triangle(a: c, b: midCA, c: centroid),
      Triangle(a: c, b: centroid, c: midBC),
    ];

    return triangles;
  }
}
