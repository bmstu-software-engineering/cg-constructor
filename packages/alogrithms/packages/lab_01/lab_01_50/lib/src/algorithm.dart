import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';

/// Алгоритм поиска треугольника, включающего в себя большее число точек
class AlgorithmL01V50 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V50.fromModel(this._model);

  factory AlgorithmL01V50() => AlgorithmL01V50.fromModel(PointSetModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _insidePointsColor = '#FF0000'; // Красный
  static const String _outsidePointsColor = '#0000FF'; // Синий

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minPointsRequired = 3;

  @override
  ViewerResultModel calculate() {
    // Получаем данные из модели
    final PointSetModel data = _model.data as PointSetModel;
    final points = data.points;

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
    int maxPointsInside = -1;
    Triangle? bestTriangle;
    List<Point>? pointsInside;

    // Перебираем все треугольники
    for (final triangle in triangles) {
      // Проверяем, не лежат ли точки треугольника на одной прямой
      if (PointsOnLineChecker.isTriangleDegenerate(triangle)) {
        continue;
      }

      // Находим точки, которые лежат внутри треугольника
      List<Point> insidePoints = [];
      for (final point in points) {
        // Пропускаем вершины треугольника
        if (point == triangle.a || point == triangle.b || point == triangle.c) {
          continue;
        }

        // Проверяем, лежит ли точка внутри треугольника
        if (_isPointInsideTriangle(point, triangle)) {
          insidePoints.add(point);
        }
      }

      // Обновляем результат, если нашли треугольник с большим количеством точек внутри
      if (insidePoints.length > maxPointsInside) {
        maxPointsInside = insidePoints.length;
        bestTriangle = triangle;
        pointsInside = insidePoints;
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestTriangle == null) {
      throw CalculationException('Не удалось найти подходящий треугольник');
    }

    // Формируем результат для визуализации
    return _buildResult(bestTriangle, pointsInside!, points);
  }

  /// Проверяет, лежит ли точка внутри треугольника
  bool _isPointInsideTriangle(Point point, Triangle triangle) {
    // Используем барицентрические координаты для проверки
    final a = triangle.a;
    final b = triangle.b;
    final c = triangle.c;

    // Вычисляем знаменатель для барицентрических координат
    final denominator = ((b.y - c.y) * (a.x - c.x) + (c.x - b.x) * (a.y - c.y));

    // Если знаменатель равен нулю, то точки треугольника лежат на одной прямой
    if (denominator.abs() < 1e-10) return false;

    // Вычисляем барицентрические координаты
    final alpha =
        ((b.y - c.y) * (point.x - c.x) + (c.x - b.x) * (point.y - c.y)) /
        denominator;
    final beta =
        ((c.y - a.y) * (point.x - c.x) + (a.x - c.x) * (point.y - c.y)) /
        denominator;
    final gamma = 1 - alpha - beta;

    // Точка лежит внутри треугольника, если все барицентрические координаты
    // положительны и их сумма равна 1
    return alpha >= 0 &&
        beta >= 0 &&
        gamma >= 0 &&
        alpha + beta + gamma <= 1 + 1e-10;
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangle,
    List<Point> pointsInside,
    List<Point> allPoints,
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

    // Добавляем точки внутри треугольника
    for (final point in pointsInside) {
      resultPoints.add(
        Point(
          x: point.x,
          y: point.y,
          color: _insidePointsColor,
          thickness: 1.5,
        ),
      );
    }

    // Добавляем точки вне треугольника
    for (final point in allPoints) {
      // Пропускаем вершины треугольника и точки внутри треугольника
      if (point == triangle.a ||
          point == triangle.b ||
          point == triangle.c ||
          pointsInside.any((p) => p.x == point.x && p.y == point.y)) {
        continue;
      }

      resultPoints.add(
        Point(
          x: point.x,
          y: point.y,
          color: _outsidePointsColor,
          thickness: 1.5,
        ),
      );
    }

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа треугольника

### Координаты вершин треугольника
- A: (${triangle.a.x}, ${triangle.a.y})
- B: (${triangle.b.x}, ${triangle.b.y})
- C: (${triangle.c.x}, ${triangle.c.y})

### Параметры треугольника
- Площадь: **${GeometryCalculator.calculateTriangleArea(triangle)}**
- Периметр: **${GeometryCalculator.calculateTrianglePerimeter(triangle)}**

### Количество точек
- Всего точек: **${allPoints.length}**
- Точек внутри треугольника: **${pointsInside.length}**
- Точек вне треугольника: **${allPoints.length - pointsInside.length - 3}** (исключая вершины треугольника)

### Визуализация
- Зеленый: треугольник с максимальным количеством точек внутри
- Красный: точки внутри треугольника
- Синий: точки вне треугольника
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
