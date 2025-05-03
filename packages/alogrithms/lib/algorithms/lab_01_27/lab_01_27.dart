import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithm_parts/triangle_median_calculator.dart';
import 'package:alogrithms/algorithm_parts/point_in_triangle_checker.dart';
import 'package:alogrithms/algorithm_parts/points_on_line_checker.dart';
import 'package:alogrithms/algorithm_parts/triangle_generator.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';

import 'data.dart';

/// Алгоритм поиска треугольника, максимизирующего разность между количеством точек
/// в подтреугольниках, образованных медианами
class AlgorithmL01V27 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V27.fromModel(this._model);

  factory AlgorithmL01V27() =>
      AlgorithmL01V27.fromModel(AlgorithmL01V27DataModelImpl());

  final AlgorithmL01V27DataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _medianColor = '#0000FF'; // Синий
  static const String _maxSubtriangleColor = '#FF0000'; // Красный
  static const String _minSubtriangleColor = '#FF00FF'; // Пурпурный
  static const String _centroidColor = '#000000'; // Черный

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minPointsRequired = 3;

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

    // Инициализируем переменные для хранения результатов
    int maxDifference = -1;
    Triangle? bestTriangle;
    List<int>? bestCounts;
    int? maxIndex;
    int? minIndex;

    // Перебираем все треугольники
    for (final triangle in triangles) {
      // Проверяем, не лежат ли точки треугольника на одной прямой
      if (PointsOnLineChecker.isTriangleDegenerate(triangle)) {
        continue;
      }

      // Разбиваем треугольник на 6 подтреугольников с помощью медиан
      final subtriangles = TriangleMedianCalculator.divideTriangleByMedians(
        triangle,
      );

      // Подсчитываем количество точек в каждом подтреугольнике
      final counts = PointInTriangleChecker.countPointsInsideSubtriangles(
        points,
        subtriangles,
      );

      // Находим максимальное и минимальное количество точек
      int maxCount = counts[0];
      int minCount = counts[0];
      int maxIdx = 0;
      int minIdx = 0;

      for (int i = 1; i < counts.length; i++) {
        if (counts[i] > maxCount) {
          maxCount = counts[i];
          maxIdx = i;
        }
        if (counts[i] < minCount) {
          minCount = counts[i];
          minIdx = i;
        }
      }

      // Вычисляем разность
      final difference = maxCount - minCount;

      // Обновляем результат, если нашли треугольник с большей разностью
      if (difference > maxDifference) {
        maxDifference = difference;
        bestTriangle = triangle;
        bestCounts = counts;
        maxIndex = maxIdx;
        minIndex = minIdx;
      }
    }

    // Если не нашли ни одного подходящего треугольника
    if (bestTriangle == null) {
      throw CalculationException('Не удалось найти подходящий треугольник');
    }

    // Формируем результат для визуализации
    return _buildResult(bestTriangle, bestCounts!, maxIndex!, minIndex!);
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    Triangle triangle,
    List<int> counts,
    int maxIndex,
    int minIndex,
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

    // Вычисляем медианы и центроид
    final medians = TriangleMedianCalculator.calculateMedians(triangle);
    final centroid = TriangleMedianCalculator.calculateCentroid(triangle);

    // Добавляем центроид
    resultPoints.add(
      Point(
        x: centroid.x,
        y: centroid.y,
        color: _centroidColor,
        thickness: 3.0,
      ),
    );

    // Добавляем медианы
    for (final median in medians) {
      resultLines.add(
        Line(a: median.a, b: median.b, color: _medianColor, thickness: 1.5),
      );
    }

    // Получаем подтреугольники
    final subtriangles = TriangleMedianCalculator.divideTriangleByMedians(
      triangle,
    );

    // Выделяем подтреугольники с максимальным и минимальным количеством точек
    final maxSubtriangle = subtriangles[maxIndex];
    final minSubtriangle = subtriangles[minIndex];

    // Добавляем линии для подтреугольника с максимальным количеством точек
    resultLines.add(
      Line(
        a: maxSubtriangle.a,
        b: maxSubtriangle.b,
        color: _maxSubtriangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: maxSubtriangle.b,
        b: maxSubtriangle.c,
        color: _maxSubtriangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: maxSubtriangle.c,
        b: maxSubtriangle.a,
        color: _maxSubtriangleColor,
        thickness: 2.0,
      ),
    );

    // Добавляем линии для подтреугольника с минимальным количеством точек
    resultLines.add(
      Line(
        a: minSubtriangle.a,
        b: minSubtriangle.b,
        color: _minSubtriangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: minSubtriangle.b,
        b: minSubtriangle.c,
        color: _minSubtriangleColor,
        thickness: 2.0,
      ),
    );
    resultLines.add(
      Line(
        a: minSubtriangle.c,
        b: minSubtriangle.a,
        color: _minSubtriangleColor,
        thickness: 2.0,
      ),
    );

    // Формируем текстовую информацию в формате Markdown
    final maxCount = counts[maxIndex];
    final minCount = counts[minIndex];
    final difference = maxCount - minCount;

    final markdownInfo = '''
## Результаты анализа треугольника

### Координаты вершин треугольника
- A: (${triangle.a.x}, ${triangle.a.y})
- B: (${triangle.b.x}, ${triangle.b.y})
- C: (${triangle.c.x}, ${triangle.c.y})

### Количество точек в подтреугольниках
${_formatSubtriangleCounts(counts, maxIndex, minIndex)}

### Итоговые результаты
- Максимальное количество точек: **$maxCount** (подтреугольник ${maxIndex + 1})
- Минимальное количество точек: **$minCount** (подтреугольник ${minIndex + 1})
- Разность: **$difference**

### Визуализация
- Зеленый: основной треугольник
- Синий: медианы треугольника
- Красный: подтреугольник с максимальным количеством точек
- Пурпурный: подтреугольник с минимальным количеством точек
- Черный: центроид (точка пересечения медиан)
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }

  /// Форматирует информацию о количестве точек в подтреугольниках
  String _formatSubtriangleCounts(
    List<int> counts,
    int maxIndex,
    int minIndex,
  ) {
    final buffer = StringBuffer();

    for (int i = 0; i < counts.length; i++) {
      final count = counts[i];
      String marker = '';

      if (i == maxIndex) {
        marker = ' (максимум)';
      } else if (i == minIndex) {
        marker = ' (минимум)';
      }

      buffer.writeln('- Подтреугольник ${i + 1}: **$count**$marker');
    }

    return buffer.toString();
  }
}
