import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

import 'data.dart';

/// Алгоритм поиска треугольника максимальной площади, внутри описанной окружности которого располагается заданная точка
class AlgorithmL01V48 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V48.fromModel(this._model);

  factory AlgorithmL01V48() =>
      AlgorithmL01V48.fromModel(AlgorithmL01V48DataModelImpl());

  final AlgorithmL01V48DataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый для треугольника
  static const String _pointBColor = '#FF0000'; // Красный для точки pB
  static const String _circumcenterColor =
      '#00FFFF'; // Голубой для центра описанной окружности
  static const String _otherPointsColor =
      '#808080'; // Серый для остальных точек

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

    // Отфильтровываем треугольники, внутри описанной окружности которых находится точка pB
    List<Triangle> trianglesWithPointBInCircumcircle = [];
    List<Point> circumcenters = [];
    List<double> circumradii = [];

    for (var triangle in triangles) {
      try {
        // Вычисляем центр описанной окружности
        final circumcenter = GeometryCalculator.calculateCircumcenter(triangle);

        // Вычисляем радиус описанной окружности
        final circumradius = GeometryCalculator.calculateDistance(
          circumcenter,
          triangle.a,
        );

        // Вычисляем расстояние от точки pB до центра описанной окружности
        final distanceToPointB = GeometryCalculator.calculateDistance(
          circumcenter,
          pointB,
        );

        // Проверяем, находится ли точка pB внутри описанной окружности
        if (distanceToPointB <= circumradius) {
          trianglesWithPointBInCircumcircle.add(triangle);
          circumcenters.add(circumcenter);
          circumradii.add(circumradius);
        }
      } catch (e) {
        // Пропускаем треугольники, для которых невозможно вычислить центр описанной окружности
        continue;
      }
    }

    if (trianglesWithPointBInCircumcircle.isEmpty) {
      throw CalculationException(
        'Не найдено треугольников, внутри описанной окружности которых находится точка pB',
      );
    }

    // Находим треугольник с максимальной площадью
    Triangle? maxAreaTriangle;
    Point? maxAreaCircumcenter;
    double? maxAreaCircumradius;
    double maxArea = 0;

    for (int i = 0; i < trianglesWithPointBInCircumcircle.length; i++) {
      final triangle = trianglesWithPointBInCircumcircle[i];
      final area = GeometryCalculator.calculateTriangleArea(triangle);

      if (area > maxArea) {
        maxArea = area;
        maxAreaTriangle = triangle;
        maxAreaCircumcenter = circumcenters[i];
        maxAreaCircumradius = circumradii[i];
      }
    }

    // Формируем результат для визуализации
    return _buildResult(
      maxAreaTriangle!,
      pointB,
      points,
      maxAreaCircumcenter!,
      maxAreaCircumradius!,
      maxArea,
    );
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangle,
    Point pointB,
    List<Point> allPoints,
    Point circumcenter,
    double circumradius,
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

    // Добавляем центр описанной окружности
    resultPoints.add(
      Point(
        x: circumcenter.x,
        y: circumcenter.y,
        color: _circumcenterColor,
        thickness: 3.0,
      ),
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

### Координаты вершин треугольника максимальной площади (зеленый)
- A: (${triangle.a.x}, ${triangle.a.y})
- B: (${triangle.b.x}, ${triangle.b.y})
- C: (${triangle.c.x}, ${triangle.c.y})

### Описанная окружность
- Центр: (${circumcenter.x.toStringAsFixed(4)}, ${circumcenter.y.toStringAsFixed(4)})
- Радиус: ${circumradius.toStringAsFixed(4)}

### Точка pB (красная)
- Координаты: (${pointB.x}, ${pointB.y})

### Итоговые результаты
- Площадь треугольника: **${area.toStringAsFixed(4)}**

### Визуализация
- Зеленый: треугольник максимальной площади
- Голубой: центр описанной окружности
- Красный: точка pB
- Серый: остальные точки множества
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
