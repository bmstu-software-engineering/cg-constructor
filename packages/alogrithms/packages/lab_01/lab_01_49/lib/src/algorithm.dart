import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';
import 'dart:math' as math;

/// Алгоритм поиска треугольника минимального периметра, внутри описанной окружности
/// которого располагается заданная точка
class AlgorithmL01V49 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V49.fromModel(this._model);

  factory AlgorithmL01V49() =>
      AlgorithmL01V49.fromModel(PointSetWithReferencePointModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _circumcircleColor = '#0000FF'; // Синий
  static const String _referencePointColor = '#FF0000'; // Красный

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minPointsRequired = 3;

  @override
  ViewerResultModel calculate() {
    final data = _model.data as PointSetWithReferencePointModel;
    final points = data.points;
    final referencePoint = data.referencePoint;

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

    // Инициализируем переменные для хранения результатов
    double minPerimeter = double.infinity;
    Triangle? bestTriangle;
    Point? circumcenter;
    double? circumradius;

    // Перебираем все треугольники
    for (final triangle in triangles) {
      // Проверяем, не лежат ли точки треугольника на одной прямой
      if (PointsOnLineChecker.isTriangleDegenerate(triangle)) {
        continue;
      }

      // Вычисляем центр и радиус описанной окружности
      final center = GeometryCalculator.calculateCircumcenter(triangle);
      final radius = GeometryCalculator.calculateDistance(center, triangle.a);

      // Проверяем, находится ли контрольная точка внутри описанной окружности
      final distanceToReference = GeometryCalculator.calculateDistance(
        center,
        referencePoint,
      );
      if (distanceToReference > radius) {
        continue; // Точка находится вне описанной окружности
      }

      // Вычисляем периметр треугольника
      final perimeter = GeometryCalculator.calculateTrianglePerimeter(triangle);

      // Обновляем результат, если нашли треугольник с меньшим периметром
      if (perimeter < minPerimeter) {
        minPerimeter = perimeter;
        bestTriangle = triangle;
        circumcenter = center;
        circumradius = radius;
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestTriangle == null) {
      throw CalculationException(
        'Не удалось найти треугольник, в описанной окружности которого находится заданная точка',
      );
    }

    // Формируем результат для визуализации
    return _buildResult(
      bestTriangle,
      referencePoint,
      circumcenter!,
      circumradius!,
      minPerimeter,
    );
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangle,
    Point referencePoint,
    Point circumcenter,
    double circumradius,
    double perimeter,
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

    // Добавляем контрольную точку
    resultPoints.add(
      Point(
        x: referencePoint.x,
        y: referencePoint.y,
        color: _referencePointColor,
        thickness: 3.0,
      ),
    );

    // Добавляем центр описанной окружности
    resultPoints.add(
      Point(
        x: circumcenter.x,
        y: circumcenter.y,
        color: _circumcircleColor,
        thickness: 2.0,
      ),
    );

    // Добавляем описанную окружность (аппроксимируем многоугольником)
    const int segments = 36;
    for (int i = 0; i < segments; i++) {
      final angle1 = 2 * math.pi * i / segments;
      final angle2 = 2 * math.pi * (i + 1) / segments;

      final x1 = circumcenter.x + circumradius * math.cos(angle1);
      final y1 = circumcenter.y + circumradius * math.sin(angle1);
      final x2 = circumcenter.x + circumradius * math.cos(angle2);
      final y2 = circumcenter.y + circumradius * math.sin(angle2);

      resultLines.add(
        Line(
          a: Point(x: x1, y: y1),
          b: Point(x: x2, y: y2),
          color: _circumcircleColor,
          thickness: 1.0,
        ),
      );
    }

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Координаты вершин треугольника
- A: (${triangle.a.x.toStringAsFixed(2)}, ${triangle.a.y.toStringAsFixed(2)})
- B: (${triangle.b.x.toStringAsFixed(2)}, ${triangle.b.y.toStringAsFixed(2)})
- C: (${triangle.c.x.toStringAsFixed(2)}, ${triangle.c.y.toStringAsFixed(2)})

### Параметры треугольника
- Периметр: **${perimeter.toStringAsFixed(2)}**
- Центр описанной окружности: (${circumcenter.x.toStringAsFixed(2)}, ${circumcenter.y.toStringAsFixed(2)})
- Радиус описанной окружности: **${circumradius.toStringAsFixed(2)}**

### Контрольная точка
- Координаты: (${referencePoint.x.toStringAsFixed(2)}, ${referencePoint.y.toStringAsFixed(2)})
- Расстояние до центра окружности: **${GeometryCalculator.calculateDistance(circumcenter, referencePoint).toStringAsFixed(2)}**

### Визуализация
- Зеленый: треугольник минимального периметра
- Синий: описанная окружность и ее центр
- Красный: контрольная точка
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
