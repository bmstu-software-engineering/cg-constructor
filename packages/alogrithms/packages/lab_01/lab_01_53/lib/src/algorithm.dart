import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';
import 'dart:math' as math;

/// Алгоритм поиска двух точек из первого множества и точки из второго,
/// образующих треугольник с максимальным азимутом барицентра
class AlgorithmL01V53 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V53.fromModel(this._model);

  factory AlgorithmL01V53() =>
      AlgorithmL01V53.fromModel(DualPointSetModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _firstSetPointsColor = '#0000FF'; // Синий
  static const String _secondSetPointsColor = '#FF0000'; // Красный
  static const String _barycenterColor = '#FF00FF'; // Пурпурный
  static const String _azimuthLineColor = '#FFA500'; // Оранжевый

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
    double maxAzimuth = -1;
    Point? bestFirstPointA;
    Point? bestFirstPointB;
    Point? bestSecondPoint;
    Point? bestBarycenter;

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

          // Вычисляем барицентр треугольника
          final barycenter = GeometryCalculator.calculateBarycenter(triangle);

          // Вычисляем азимут барицентра (угол между прямой, проходящей через начало координат и барицентр, и осью абсцисс)
          final azimuth = _calculateAzimuth(barycenter);

          // Обновляем результат, если нашли треугольник с большим азимутом барицентра
          if (azimuth > maxAzimuth) {
            maxAzimuth = azimuth;
            bestFirstPointA = firstPointA;
            bestFirstPointB = firstPointB;
            bestSecondPoint = secondPoint;
            bestBarycenter = barycenter;
          }
        }
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestFirstPointA == null ||
        bestFirstPointB == null ||
        bestSecondPoint == null ||
        bestBarycenter == null) {
      throw CalculationException('Не удалось найти подходящий треугольник');
    }

    // Формируем результат для визуализации
    return _buildResult(
      bestFirstPointA,
      bestFirstPointB,
      bestSecondPoint,
      bestBarycenter,
      maxAzimuth,
      firstPoints,
      secondPoints,
    );
  }

  /// Вычисляет азимут точки (угол между прямой, проходящей через начало координат и точку, и осью абсцисс)
  double _calculateAzimuth(Point point) {
    // Используем atan2 для получения угла в диапазоне [-π, π]
    double angle = math.atan2(point.y, point.x);

    // Преобразуем в диапазон [0, 2π]
    if (angle < 0) {
      angle += 2 * math.pi;
    }

    return angle;
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Point firstPointA,
    Point firstPointB,
    Point secondPoint,
    Point barycenter,
    double azimuth,
    List<Point> firstPoints,
    List<Point> secondPoints,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Добавляем все точки из первого множества
    for (final point in firstPoints) {
      // Выделяем точки, образующие треугольник с максимальным азимутом барицентра
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
      // Выделяем точку, образующую треугольник с максимальным азимутом барицентра
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

    // Добавляем барицентр треугольника
    resultPoints.add(
      Point(
        x: barycenter.x,
        y: barycenter.y,
        color: _barycenterColor,
        thickness: 3.0,
      ),
    );

    // Добавляем линию от начала координат до барицентра (для визуализации азимута)
    resultLines.add(
      Line(
        a: Point(x: 0, y: 0),
        b: barycenter,
        color: _azimuthLineColor,
        thickness: 1.5,
      ),
    );

    // Вычисляем площадь треугольника
    final triangle = Triangle(a: firstPointA, b: firstPointB, c: secondPoint);
    final area = GeometryCalculator.calculateTriangleArea(triangle);
    final perimeter = GeometryCalculator.calculateTrianglePerimeter(triangle);

    // Преобразуем азимут из радиан в градусы для отображения
    final azimuthDegrees = azimuth * 180 / math.pi;

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Координаты вершин треугольника
- A (из первого множества): (${firstPointA.x.toStringAsFixed(2)}, ${firstPointA.y.toStringAsFixed(2)})
- B (из первого множества): (${firstPointB.x.toStringAsFixed(2)}, ${firstPointB.y.toStringAsFixed(2)})
- C (из второго множества): (${secondPoint.x.toStringAsFixed(2)}, ${secondPoint.y.toStringAsFixed(2)})

### Барицентр треугольника
- Координаты: (${barycenter.x.toStringAsFixed(2)}, ${barycenter.y.toStringAsFixed(2)})
- Азимут: **${azimuthDegrees.toStringAsFixed(2)}°** (максимальный)

### Параметры треугольника
- Периметр: **${perimeter.toStringAsFixed(2)}**
- Площадь: **${area.toStringAsFixed(2)}**

### Количество точек
- В первом множестве: **${firstPoints.length}**
- Во втором множестве: **${secondPoints.length}**

### Визуализация
- Зеленый: треугольник с максимальным азимутом барицентра
- Синий: остальные точки из первого множества
- Красный: остальные точки из второго множества
- Пурпурный: барицентр треугольника
- Оранжевый: линия от начала координат до барицентра (для визуализации азимута)
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }
}
