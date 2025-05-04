import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';
import 'dart:math' as math;

/// Алгоритм поиска треугольника максимального периметра, образованного точками так,
/// чтобы все три точки не принадлежали одному из множеств
class AlgorithmL01V55 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V55.fromModel(this._model);

  factory AlgorithmL01V55() =>
      AlgorithmL01V55.fromModel(DualPointSetModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _firstSetPointsColor = '#0000FF'; // Синий
  static const String _secondSetPointsColor = '#FF0000'; // Красный

  /// Минимальное количество точек, необходимое в первом множестве
  static const int _minFirstSetPointsRequired = 1;

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

    // Проверка, что все точки не могут принадлежать одному множеству
    if (firstPoints.length < 1 || secondPoints.length < 1) {
      throw CalculationException(
        'Для формирования треугольника необходимо, чтобы в каждом множестве было хотя бы по одной точке',
      );
    }

    // Инициализируем переменные для хранения результатов
    double maxPerimeter = 0;
    List<Point> bestTrianglePoints = [];
    int bestCaseType =
        0; // 1 - две точки из первого множества, 2 - две точки из второго множества

    // Случай 1: Две точки из первого множества и одна точка из второго множества
    if (firstPoints.length >= 2) {
      for (int i = 0; i < firstPoints.length; i++) {
        for (int j = i + 1; j < firstPoints.length; j++) {
          final firstPointA = firstPoints[i];
          final firstPointB = firstPoints[j];

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
              bestTrianglePoints = [firstPointA, firstPointB, secondPoint];
              bestCaseType = 1;
            }
          }
        }
      }
    }

    // Случай 2: Одна точка из первого множества и две точки из второго множества
    if (secondPoints.length >= 2) {
      for (final firstPoint in firstPoints) {
        for (int i = 0; i < secondPoints.length; i++) {
          for (int j = i + 1; j < secondPoints.length; j++) {
            final secondPointA = secondPoints[i];
            final secondPointB = secondPoints[j];

            // Создаем треугольник
            final triangle = Triangle(
              a: firstPoint,
              b: secondPointA,
              c: secondPointB,
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
              bestTrianglePoints = [firstPoint, secondPointA, secondPointB];
              bestCaseType = 2;
            }
          }
        }
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestTrianglePoints.isEmpty) {
      throw CalculationException('Не удалось найти подходящий треугольник');
    }

    // Формируем результат для визуализации
    return _buildResult(
      bestTrianglePoints,
      bestCaseType,
      maxPerimeter,
      firstPoints,
      secondPoints,
    );
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    List<Point> trianglePoints,
    int caseType,
    double perimeter,
    List<Point> firstPoints,
    List<Point> secondPoints,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Определяем, какие точки из какого множества
    List<Point> firstSetTrianglePoints = [];
    List<Point> secondSetTrianglePoints = [];

    if (caseType == 1) {
      // Две точки из первого множества и одна из второго
      firstSetTrianglePoints = [trianglePoints[0], trianglePoints[1]];
      secondSetTrianglePoints = [trianglePoints[2]];
    } else {
      // Одна точка из первого множества и две из второго
      firstSetTrianglePoints = [trianglePoints[0]];
      secondSetTrianglePoints = [trianglePoints[1], trianglePoints[2]];
    }

    // Добавляем все точки из первого множества
    for (final point in firstPoints) {
      // Выделяем точки, образующие треугольник максимального периметра
      final color =
          firstSetTrianglePoints.contains(point)
              ? _triangleColor
              : _firstSetPointsColor;
      final thickness = firstSetTrianglePoints.contains(point) ? 2.0 : 1.0;

      resultPoints.add(
        Point(x: point.x, y: point.y, color: color, thickness: thickness),
      );
    }

    // Добавляем все точки из второго множества
    for (final point in secondPoints) {
      // Выделяем точки, образующие треугольник максимального периметра
      final color =
          secondSetTrianglePoints.contains(point)
              ? _triangleColor
              : _secondSetPointsColor;
      final thickness = secondSetTrianglePoints.contains(point) ? 2.0 : 1.0;

      resultPoints.add(
        Point(x: point.x, y: point.y, color: color, thickness: thickness),
      );
    }

    // Добавляем стороны треугольника
    resultLines.add(
      Line(
        a: trianglePoints[0],
        b: trianglePoints[1],
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: trianglePoints[1],
        b: trianglePoints[2],
        color: _triangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: trianglePoints[2],
        b: trianglePoints[0],
        color: _triangleColor,
        thickness: 2.0,
      ),
    );

    // Вычисляем площадь треугольника
    final triangle = Triangle(
      a: trianglePoints[0],
      b: trianglePoints[1],
      c: trianglePoints[2],
    );
    final area = GeometryCalculator.calculateTriangleArea(triangle);

    // Вычисляем длины сторон треугольника
    final sideAB = _calculateDistance(trianglePoints[0], trianglePoints[1]);
    final sideBC = _calculateDistance(trianglePoints[1], trianglePoints[2]);
    final sideCA = _calculateDistance(trianglePoints[2], trianglePoints[0]);

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Координаты вершин треугольника
${_formatTrianglePointsInfo(trianglePoints, caseType)}

### Параметры треугольника
- Длина стороны AB: **${sideAB.toStringAsFixed(2)}**
- Длина стороны BC: **${sideBC.toStringAsFixed(2)}**
- Длина стороны CA: **${sideCA.toStringAsFixed(2)}**
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

  /// Форматирует информацию о точках треугольника в зависимости от типа случая
  String _formatTrianglePointsInfo(List<Point> trianglePoints, int caseType) {
    if (caseType == 1) {
      // Две точки из первого множества и одна из второго
      return '''
- A (из первого множества): (${trianglePoints[0].x.toStringAsFixed(2)}, ${trianglePoints[0].y.toStringAsFixed(2)})
- B (из первого множества): (${trianglePoints[1].x.toStringAsFixed(2)}, ${trianglePoints[1].y.toStringAsFixed(2)})
- C (из второго множества): (${trianglePoints[2].x.toStringAsFixed(2)}, ${trianglePoints[2].y.toStringAsFixed(2)})
''';
    } else {
      // Одна точка из первого множества и две из второго
      return '''
- A (из первого множества): (${trianglePoints[0].x.toStringAsFixed(2)}, ${trianglePoints[0].y.toStringAsFixed(2)})
- B (из второго множества): (${trianglePoints[1].x.toStringAsFixed(2)}, ${trianglePoints[1].y.toStringAsFixed(2)})
- C (из второго множества): (${trianglePoints[2].x.toStringAsFixed(2)}, ${trianglePoints[2].y.toStringAsFixed(2)})
''';
    }
  }

  /// Вычисляет расстояние между двумя точками
  double _calculateDistance(Point a, Point b) {
    return math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));
  }
}
