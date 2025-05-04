import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

/// Алгоритм поиска двух треугольников с минимальным отношением периметров
class AlgorithmL01V42 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V42.fromModel(this._model);

  factory AlgorithmL01V42() => AlgorithmL01V42.fromModel(PointSetModelImpl());

  final PointSetModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleAColor = '#00FF00'; // Зеленый для треугольника A
  static const String _triangleBColor = '#FF0000'; // Красный для треугольника B

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
    double minRatio = double.infinity;
    Triangle? triangleA; // Треугольник с большим периметром
    Triangle? triangleB; // Треугольник с меньшим периметром

    // Перебираем все пары треугольников
    for (int i = 0; i < triangles.length - 1; i++) {
      for (int j = i + 1; j < triangles.length; j++) {
        // Проверяем, что треугольники не имеют общих вершин
        if (_haveCommonVertices(triangles[i], triangles[j])) {
          continue;
        }

        // Вычисляем периметры треугольников
        double perimeterI = GeometryCalculator.calculateTrianglePerimeter(
          triangles[i],
        );
        double perimeterJ = GeometryCalculator.calculateTrianglePerimeter(
          triangles[j],
        );

        // Пропускаем треугольники с нулевым периметром (хотя такого быть не должно)
        if (perimeterI <= 0 || perimeterJ <= 0) {
          continue;
        }

        // Вычисляем отношение периметров (всегда берем большую / меньшую)
        double ratio;
        Triangle larger, smaller;
        if (perimeterI >= perimeterJ) {
          ratio = perimeterI / perimeterJ;
          larger = triangles[i];
          smaller = triangles[j];
        } else {
          ratio = perimeterJ / perimeterI;
          larger = triangles[j];
          smaller = triangles[i];
        }

        // Обновляем результат, если нашли пару с меньшим отношением
        if (ratio < minRatio) {
          minRatio = ratio;
          triangleA = larger;
          triangleB = smaller;
        }
      }
    }

    // Если не нашли подходящую пару треугольников
    if (triangleA == null || triangleB == null) {
      throw CalculationException(
        'Не удалось найти пару треугольников без общих вершин',
      );
    }

    // Формируем результат для визуализации
    return _buildResult(triangleA, triangleB, minRatio);
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
    double ratio,
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

    // Вычисляем периметры треугольников
    final perimeterA = GeometryCalculator.calculateTrianglePerimeter(triangleA);
    final perimeterB = GeometryCalculator.calculateTrianglePerimeter(triangleB);

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

### Итоговые результаты
- Периметр треугольника A: **${perimeterA.toStringAsFixed(4)}**
- Периметр треугольника B: **${perimeterB.toStringAsFixed(4)}**
- Отношение периметров (Pa/Pb): **${ratio.toStringAsFixed(4)}**

### Визуализация
- Зеленый: треугольник A (с большим периметром)
- Красный: треугольник B (с меньшим периметром)
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
