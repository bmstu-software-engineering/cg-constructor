import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

/// Алгоритм поиска двух треугольников, таких что прямая, проходящая через центры вписанных окружностей,
/// образует с осью абсцисс максимальный угол
class AlgorithmL01V43 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V43.fromModel(this._model);

  factory AlgorithmL01V43() => AlgorithmL01V43.fromModel(PointSetModelImpl());

  final PointSetModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleAColor = '#00FF00'; // Зеленый для треугольника A
  static const String _triangleBColor = '#FF0000'; // Красный для треугольника B
  static const String _lineColor = '#0000FF'; // Синий для линии через центры
  static const String _incenterAColor =
      '#00FFFF'; // Голубой для центра вписанной окружности A
  static const String _incenterBColor =
      '#FF00FF'; // Пурпурный для центра вписанной окружности B

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
    double maxAngle = 0;
    Triangle? triangleA;
    Triangle? triangleB;
    Point? incenterA;
    Point? incenterB;

    // Перебираем все пары треугольников
    for (int i = 0; i < triangles.length - 1; i++) {
      for (int j = i + 1; j < triangles.length; j++) {
        // Проверяем, что треугольники не имеют общих вершин
        if (_haveCommonVertices(triangles[i], triangles[j])) {
          continue;
        }

        // Вычисляем центры вписанных окружностей
        final incenterI = GeometryCalculator.calculateIncenter(triangles[i]);
        final incenterJ = GeometryCalculator.calculateIncenter(triangles[j]);

        // Вычисляем угол между прямой, проходящей через центры, и осью абсцисс
        final angle = GeometryCalculator.calculateAngle(incenterI, incenterJ);

        // Нормализуем угол к диапазону [0, π/2]
        double normalizedAngle = angle;
        if (normalizedAngle > pi / 2) {
          normalizedAngle = pi - normalizedAngle;
        }

        // Обновляем результат, если нашли пару с большим углом
        if (normalizedAngle > maxAngle) {
          maxAngle = normalizedAngle;
          triangleA = triangles[i];
          triangleB = triangles[j];
          incenterA = incenterI;
          incenterB = incenterJ;
        }
      }
    }

    // Если не нашли подходящую пару треугольников
    if (triangleA == null ||
        triangleB == null ||
        incenterA == null ||
        incenterB == null) {
      throw CalculationException(
        'Не удалось найти пару треугольников без общих вершин',
      );
    }

    // Формируем результат для визуализации
    return _buildResult(triangleA, triangleB, incenterA, incenterB, maxAngle);
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
    Point incenterA,
    Point incenterB,
    double angle,
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

    // Добавляем центры вписанных окружностей
    resultPoints.add(
      Point(
        x: incenterA.x,
        y: incenterA.y,
        color: _incenterAColor,
        thickness: 3.0,
      ),
    );
    resultPoints.add(
      Point(
        x: incenterB.x,
        y: incenterB.y,
        color: _incenterBColor,
        thickness: 3.0,
      ),
    );

    // Добавляем линию, соединяющую центры вписанных окружностей
    resultLines.add(
      Line(a: incenterA, b: incenterB, color: _lineColor, thickness: 1.5),
    );

    // Преобразуем угол из радиан в градусы для отображения
    final angleDegrees = angle * 180 / pi;

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

### Центры вписанных окружностей
- Центр вписанной окружности треугольника A: (${incenterA.x.toStringAsFixed(4)}, ${incenterA.y.toStringAsFixed(4)})
- Центр вписанной окружности треугольника B: (${incenterB.x.toStringAsFixed(4)}, ${incenterB.y.toStringAsFixed(4)})

### Итоговые результаты
- Угол между прямой через центры вписанных окружностей и осью абсцисс: **${angleDegrees.toStringAsFixed(4)}°**

### Визуализация
- Зеленый: треугольник A
- Красный: треугольник B
- Голубой: центр вписанной окружности треугольника A
- Пурпурный: центр вписанной окружности треугольника B
- Синий: прямая, проходящая через центры вписанных окружностей
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
