import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

import 'data.dart';

/// Алгоритм поиска двух треугольников, таких что расстояние между барицентрами треугольников максимально
class AlgorithmL01V45 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V45.fromModel(this._model);

  factory AlgorithmL01V45() =>
      AlgorithmL01V45.fromModel(AlgorithmL01V45DataModelImpl());

  final AlgorithmL01V45DataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleAColor = '#00FF00'; // Зеленый для треугольника A
  static const String _triangleBColor = '#FF0000'; // Красный для треугольника B
  static const String _lineColor = '#0000FF'; // Синий для линии через центры
  static const String _barycenterAColor =
      '#00FFFF'; // Голубой для барицентра треугольника A
  static const String _barycenterBColor =
      '#FF00FF'; // Пурпурный для барицентра треугольника B

  /// Минимальное количество точек, необходимое для формирования двух треугольников
  static const int _minPointsRequired = 6;

  @override
  ViewerResultModel calculate() {
    final points = _model.data.points;

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

    if (triangles.length < 2) {
      throw CalculationException(
        'Недостаточно невырожденных треугольников для решения задачи',
      );
    }

    // Инициализируем переменные для хранения результатов
    double maxDistance = 0;
    Triangle? triangleA;
    Triangle? triangleB;
    Point? barycenterA;
    Point? barycenterB;

    // Перебираем все пары треугольников
    for (int i = 0; i < triangles.length - 1; i++) {
      for (int j = i + 1; j < triangles.length; j++) {
        // Проверяем, что треугольники не имеют общих вершин
        if (_haveCommonVertices(triangles[i], triangles[j])) {
          continue;
        }

        // Вычисляем барицентры треугольников
        final barycenterI = GeometryCalculator.calculateBarycenter(
          triangles[i],
        );
        final barycenterJ = GeometryCalculator.calculateBarycenter(
          triangles[j],
        );

        // Вычисляем расстояние между барицентрами
        final distance = GeometryCalculator.calculateDistance(
          barycenterI,
          barycenterJ,
        );

        // Обновляем результат, если нашли пару с большим расстоянием
        if (distance > maxDistance) {
          maxDistance = distance;
          triangleA = triangles[i];
          triangleB = triangles[j];
          barycenterA = barycenterI;
          barycenterB = barycenterJ;
        }
      }
    }

    // Если не нашли подходящую пару треугольников
    if (triangleA == null ||
        triangleB == null ||
        barycenterA == null ||
        barycenterB == null) {
      throw CalculationException(
        'Не удалось найти пару треугольников без общих вершин',
      );
    }

    // Формируем результат для визуализации
    return _buildResult(
      triangleA,
      triangleB,
      barycenterA,
      barycenterB,
      maxDistance,
    );
  }

  /// Проверяет, имеют ли два треугольника общие вершины
  bool _haveCommonVertices(Triangle t1, Triangle t2) {
    return _arePointsEqual(t1.a, t2.a) ||
        _arePointsEqual(t1.a, t2.b) ||
        _arePointsEqual(t1.a, t2.c) ||
        _arePointsEqual(t1.b, t2.a) ||
        _arePointsEqual(t1.b, t2.b) ||
        _arePointsEqual(t1.b, t2.c) ||
        _arePointsEqual(t1.c, t2.a) ||
        _arePointsEqual(t1.c, t2.b) ||
        _arePointsEqual(t1.c, t2.c);
  }

  /// Проверяет, совпадают ли две точки (с учетом погрешности вычислений)
  bool _arePointsEqual(Point p1, Point p2) {
    const epsilon = 1e-10;
    return (p1.x - p2.x).abs() < epsilon && (p1.y - p2.y).abs() < epsilon;
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangleA,
    Triangle triangleB,
    Point barycenterA,
    Point barycenterB,
    double distance,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Добавляем вершины треугольника A
    resultPoints.add(
      Point(
        x: triangleA.a.x,
        y: triangleA.a.y,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangleA.b.x,
        y: triangleA.b.y,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangleA.c.x,
        y: triangleA.c.y,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );

    // Добавляем стороны треугольника A
    resultLines.add(
      Line(
        a: triangleA.a,
        b: triangleA.b,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: triangleA.b,
        b: triangleA.c,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: triangleA.c,
        b: triangleA.a,
        color: _triangleAColor,
        thickness: 2.0,
      ),
    );

    // Добавляем вершины треугольника B
    resultPoints.add(
      Point(
        x: triangleB.a.x,
        y: triangleB.a.y,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangleB.b.x,
        y: triangleB.b.y,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );
    resultPoints.add(
      Point(
        x: triangleB.c.x,
        y: triangleB.c.y,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );

    // Добавляем стороны треугольника B
    resultLines.add(
      Line(
        a: triangleB.a,
        b: triangleB.b,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: triangleB.b,
        b: triangleB.c,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: triangleB.c,
        b: triangleB.a,
        color: _triangleBColor,
        thickness: 2.0,
      ),
    );

    // Добавляем барицентры треугольников
    resultPoints.add(
      Point(
        x: barycenterA.x,
        y: barycenterA.y,
        color: _barycenterAColor,
        thickness: 3.0,
      ),
    );
    resultPoints.add(
      Point(
        x: barycenterB.x,
        y: barycenterB.y,
        color: _barycenterBColor,
        thickness: 3.0,
      ),
    );

    // Добавляем линию, соединяющую барицентры треугольников
    resultLines.add(
      Line(a: barycenterA, b: barycenterB, color: _lineColor, thickness: 1.5),
    );

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа треугольников

### Координаты вершин треугольника A (зеленый)
- A: (${triangleA.a.x}, ${triangleA.a.y})
- B: (${triangleA.b.x}, ${triangleA.b.y})
- C: (${triangleA.c.x}, ${triangleA.c.y})

### Координаты вершин треугольника B (красный)
- A: (${triangleB.a.x}, ${triangleB.a.y})
- B: (${triangleB.b.x}, ${triangleB.b.y})
- C: (${triangleB.c.x}, ${triangleB.c.y})

### Барицентры треугольников
- Барицентр треугольника A: (${barycenterA.x.toStringAsFixed(4)}, ${barycenterA.y.toStringAsFixed(4)})
- Барицентр треугольника B: (${barycenterB.x.toStringAsFixed(4)}, ${barycenterB.y.toStringAsFixed(4)})

### Итоговые результаты
- Расстояние между барицентрами треугольников: **${distance.toStringAsFixed(4)}**

### Визуализация
- Зеленый: треугольник A
- Красный: треугольник B
- Голубой: барицентр треугольника A
- Пурпурный: барицентр треугольника B
- Синий: прямая, соединяющая барицентры треугольников
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
