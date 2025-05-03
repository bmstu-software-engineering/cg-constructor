import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

import 'data.dart';

/// Алгоритм поиска треугольника минимальной площади, внутри которого располагается заданная точка
class AlgorithmL01V46 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V46.fromModel(this._model);

  factory AlgorithmL01V46() =>
      AlgorithmL01V46.fromModel(AlgorithmL01V46DataModelImpl());

  final AlgorithmL01V46DataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый для треугольника
  static const String _pointBColor = '#FF0000'; // Красный для точки pB
  static const String _otherPointsColor =
      '#0000FF'; // Синий для остальных точек

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minPointsRequired = 3;

  @override
  ViewerResultModel calculate() {
    final points = _model.data.points;
    final pointB = _model.data.pointB;

    // Проверка на достаточное количество точек
    if (points.length < _minPointsRequired) {
      throw InsufficientPointsException(
        'Множество точек',
        _minPointsRequired,
        points.length,
      );
    }

    // Генерируем все возможные треугольники
    List<Triangle> triangles = TriangleGenerator.generateTriangles(points);

    // Отфильтровываем вырожденные треугольники (точки на одной прямой)
    triangles =
        triangles
            .where((t) => !PointsOnLineChecker.isTriangleDegenerate(t))
            .toList();

    if (triangles.isEmpty) {
      throw CalculationException(
        'Недостаточно невырожденных треугольников для решения задачи',
      );
    }

    // Отфильтровываем треугольники, внутри которых находится точка pB
    List<Triangle> trianglesWithPointB =
        triangles
            .where(
              (t) => PointInTriangleChecker.isPointInsideTriangle(pointB, t),
            )
            .toList();

    if (trianglesWithPointB.isEmpty) {
      throw CalculationException(
        'Не найдено треугольников, внутри которых находится точка pB',
      );
    }

    // Находим треугольник с минимальной площадью
    Triangle? minAreaTriangle;
    double minArea = double.infinity;

    for (var triangle in trianglesWithPointB) {
      final area = GeometryCalculator.calculateTriangleArea(triangle);
      if (area < minArea) {
        minArea = area;
        minAreaTriangle = triangle;
      }
    }

    // Формируем результат для визуализации
    return _buildResult(minAreaTriangle!, pointB, points, minArea);
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangle,
    Point pointB,
    List<Point> allPoints,
    double area,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Добавляем вершины треугольника
    resultPoints.add(
      Point(
        x: triangle.a.x,
        y: triangle.a.y,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangle.b.x,
        y: triangle.b.y,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangle.c.x,
        y: triangle.c.y,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );

    // Добавляем стороны треугольника
    resultLines.add(
      Line(a: triangle.a, b: triangle.b, color: _triangleColor, thickness: 2.0),
    );
    resultLines.add(
      Line(a: triangle.b, b: triangle.c, color: _triangleColor, thickness: 2.0),
    );
    resultLines.add(
      Line(a: triangle.c, b: triangle.a, color: _triangleColor, thickness: 2.0),
    );

    // Добавляем точку pB
    resultPoints.add(
      Point(x: pointB.x, y: pointB.y, color: _pointBColor, thickness: 3.0),
    );

    // Добавляем остальные точки
    for (var point in allPoints) {
      // Проверяем, что точка не является вершиной треугольника
      if (!_isPointEqualToAny(point, [triangle.a, triangle.b, triangle.c])) {
        resultPoints.add(
          Point(
            x: point.x,
            y: point.y,
            color: _otherPointsColor,
            thickness: 1.5,
          ),
        );
      }
    }

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Координаты вершин треугольника минимальной площади (зеленый)
- A: (${triangle.a.x}, ${triangle.a.y})
- B: (${triangle.b.x}, ${triangle.b.y})
- C: (${triangle.c.x}, ${triangle.c.y})

### Точка pB (красная)
- Координаты: (${pointB.x}, ${pointB.y})

### Итоговые результаты
- Площадь треугольника: **${area.toStringAsFixed(4)}**

### Визуализация
- Зеленый: треугольник минимальной площади
- Красный: точка pB
- Синий: остальные точки множества
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }

  /// Проверяет, совпадает ли точка с любой из точек в списке
  bool _isPointEqualToAny(Point point, List<Point> points) {
    for (var p in points) {
      if (_arePointsEqual(point, p)) {
        return true;
      }
    }
    return false;
  }

  /// Проверяет, совпадают ли две точки (с учетом погрешности вычислений)
  bool _arePointsEqual(Point p1, Point p2) {
    const epsilon = 1e-10;
    return (p1.x - p2.x).abs() < epsilon && (p1.y - p2.y).abs() < epsilon;
  }
}
