import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';

/// Алгоритм поиска двух точек из первого множества и точки из второго,
/// образующих треугольник максимального периметра
class AlgorithmL01V51 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V51.fromModel(this._model);

  factory AlgorithmL01V51() =>
      AlgorithmL01V51.fromModel(DualPointSetModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _firstSetPointsColor = '#0000FF'; // Синий
  static const String _secondSetPointsColor = '#FF0000'; // Красный

  /// Минимальное количество точек, необходимое в первом множестве
  static const int _minFirstSetPointsRequired = 2;

  /// Минимальное количество точек, необходимое во втором множестве
  static const int _minSecondSetPointsRequired = 1;

  @override
  ViewerResultModel calculate() {
    final data = _model.data as DualPointSetModel;
    final firstPoints = data.firstPoints;
    final secondPoints = data.secondPoints;

    // Проверка на достаточное количество точек в первом множестве
    if (firstPoints.length < _minFirstSetPointsRequired) {
      throw InsufficientPointsException(
        'Первое множество точек',
        _minFirstSetPointsRequired,
        firstPoints.length,
      );
    }

    // Проверка на достаточное количество точек во втором множестве
    if (secondPoints.length < _minSecondSetPointsRequired) {
      throw InsufficientPointsException(
        'Второе множество точек',
        _minSecondSetPointsRequired,
        secondPoints.length,
      );
    }

    // Инициализируем переменные для хранения результатов
    double maxPerimeter = 0;
    Point? bestFirstPointA;
    Point? bestFirstPointB;
    Point? bestSecondPoint;

    // Перебираем все возможные комбинации двух точек из первого множества
    for (int i = 0; i < firstPoints.length; i++) {
      for (int j = i + 1; j < firstPoints.length; j++) {
        final firstPointA = firstPoints[i];
        final firstPointB = firstPoints[j];

        // Перебираем все точки из второго множества
        for (final secondPoint in secondPoints) {
          // Создаем треугольник
          final triangle = Triangle(
            a: firstPointA,
            b: firstPointB,
            c: secondPoint,
          );

          // Проверяем, не лежат ли точки треугольника на одной прямой
          if (PointsOnLineChecker.isTriangleDegenerate(triangle)) {
            continue;
          }

          // Вычисляем периметр треугольника
          final perimeter = GeometryCalculator.calculateTrianglePerimeter(
            triangle,
          );

          // Обновляем результат, если нашли треугольник с большим периметром
          if (perimeter > maxPerimeter) {
            maxPerimeter = perimeter;
            bestFirstPointA = firstPointA;
            bestFirstPointB = firstPointB;
            bestSecondPoint = secondPoint;
          }
        }
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestFirstPointA == null ||
        bestFirstPointB == null ||
        bestSecondPoint == null) {
      throw CalculationException('Не удалось найти подходящий треугольник');
    }

    // Формируем результат для визуализации
    return _buildResult(
      bestFirstPointA,
      bestFirstPointB,
      bestSecondPoint,
      maxPerimeter,
      firstPoints,
      secondPoints,
    );
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Point firstPointA,
    Point firstPointB,
    Point secondPoint,
    double perimeter,
    List<Point> firstPoints,
    List<Point> secondPoints,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Добавляем все точки из первого множества
    for (final point in firstPoints) {
      // Выделяем точки, образующие треугольник максимального периметра
      final color =
          (point == firstPointA || point == firstPointB)
              ? _triangleColor
              : _firstSetPointsColor;
      final thickness =
          (point == firstPointA || point == firstPointB) ? 2.0 : 1.0;

      resultPoints.add(
        Point(x: point.x, y: point.y, color: color, thickness: thickness),
      );
    }

    // Добавляем все точки из второго множества
    for (final point in secondPoints) {
      // Выделяем точку, образующую треугольник максимального периметра
      final color =
          (point == secondPoint) ? _triangleColor : _secondSetPointsColor;
      final thickness = (point == secondPoint) ? 2.0 : 1.0;

      resultPoints.add(
        Point(x: point.x, y: point.y, color: color, thickness: thickness),
      );
    }

    // Добавляем стороны треугольника
    resultLines.add(
      Line(
        a: firstPointA,
        b: firstPointB,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: firstPointB,
        b: secondPoint,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: secondPoint,
        b: firstPointA,
        color: _triangleColor,
        thickness: 2.0,
      ),
    );

    // Вычисляем площадь треугольника
    final triangle = Triangle(a: firstPointA, b: firstPointB, c: secondPoint);
    final area = GeometryCalculator.calculateTriangleArea(triangle);

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Координаты вершин треугольника
- A (из первого множества): (${firstPointA.x.toStringAsFixed(2)}, ${firstPointA.y.toStringAsFixed(2)})
- B (из первого множества): (${firstPointB.x.toStringAsFixed(2)}, ${firstPointB.y.toStringAsFixed(2)})
- C (из второго множества): (${secondPoint.x.toStringAsFixed(2)}, ${secondPoint.y.toStringAsFixed(2)})

### Параметры треугольника
- Периметр: **${perimeter.toStringAsFixed(2)}** (максимальный)
- Площадь: **${area.toStringAsFixed(2)}**

### Количество точек
- В первом множестве: **${firstPoints.length}**
- Во втором множестве: **${secondPoints.length}**

### Визуализация
- Зеленый: треугольник максимального периметра
- Синий: остальные точки из первого множества
- Красный: остальные точки из второго множества
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
