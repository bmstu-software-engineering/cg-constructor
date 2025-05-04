import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';
import 'dart:math' as math;

/// Алгоритм поиска треугольника минимальной площади, образованного
/// точкой из первого множества и двумя точками из второго
class AlgorithmL01V52 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V52.fromModel(this._model);

  factory AlgorithmL01V52() =>
      AlgorithmL01V52.fromModel(DualPointSetModelImpl());

  final FormsDataModel _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _triangleColor = '#00FF00'; // Зеленый
  static const String _firstSetPointsColor = '#FF0000'; // Красный
  static const String _secondSetPointsColor = '#0000FF'; // Синий

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minFirstSetPointsRequired = 1;
  static const int _minSecondSetPointsRequired = 2;

  @override
  ViewerResultModel calculate() {
    // Получаем данные из модели
    final DualPointSetModel data = _model.data as DualPointSetModel;
    final firstPoints = data.firstPoints;
    final secondPoints = data.secondPoints;

    // Проверка на достаточное количество точек
    if (firstPoints.length < _minFirstSetPointsRequired) {
      throw InsufficientPointsException(
        'Первое множество точек',
        _minFirstSetPointsRequired,
        firstPoints.length,
      );
    }

    if (secondPoints.length < _minSecondSetPointsRequired) {
      throw InsufficientPointsException(
        'Второе множество точек',
        _minSecondSetPointsRequired,
        secondPoints.length,
      );
    }

    // Инициализируем переменные для хранения результатов
    double minArea = double.infinity;
    List<Point> bestTrianglePoints = [];
    Point? firstPoint;
    Point? secondPointA;
    Point? secondPointB;

    // Перебираем все возможные комбинации точек
    for (int i = 0; i < firstPoints.length; i++) {
      for (int j = 0; j < secondPoints.length - 1; j++) {
        for (int k = j + 1; k < secondPoints.length; k++) {
          final a = firstPoints[i];
          final b = secondPoints[j];
          final c = secondPoints[k];

          // Проверяем, не лежат ли точки треугольника на одной прямой
          if (_arePointsCollinear(a, b, c)) {
            continue;
          }

          // Вычисляем площадь треугольника
          final area = _calculateTriangleArea(a, b, c);

          // Обновляем результат, если нашли треугольник с меньшей площадью
          if (area < minArea) {
            minArea = area;
            bestTrianglePoints = [a, b, c];
            firstPoint = a;
            secondPointA = b;
            secondPointB = c;
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
      firstPoint!,
      secondPointA!,
      secondPointB!,
      firstPoints,
      secondPoints,
      minArea,
    );
  }

  /// Проверяет, лежат ли три точки на одной прямой
  bool _arePointsCollinear(Point a, Point b, Point c) {
    // Вычисляем определитель матрицы
    // | a.x a.y 1 |
    // | b.x b.y 1 |
    // | c.x c.y 1 |
    // Если определитель равен нулю, то точки лежат на одной прямой
    final det = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    return det.abs() < 1e-10;
  }

  /// Вычисляет площадь треугольника по координатам вершин
  double _calculateTriangleArea(Point a, Point b, Point c) {
    // Используем формулу площади треугольника через координаты вершин
    // S = 0.5 * |x1(y2 - y3) + x2(y3 - y1) + x3(y1 - y2)|
    final area =
        0.5 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)).abs();
    return area;
  }

  /// Формирует результат для визуализации
  ViewerResultModel _buildResult(
    List<Point> trianglePoints,
    Point firstPoint,
    Point secondPointA,
    Point secondPointB,
    List<Point> firstPoints,
    List<Point> secondPoints,
    double area,
  ) {
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];

    // Добавляем точки из первого множества
    for (final point in firstPoints) {
      // Выделяем точку, которая образует треугольник
      final color =
          (point.x == firstPoint.x && point.y == firstPoint.y)
              ? _triangleColor
              : _firstSetPointsColor;
      final thickness =
          (point.x == firstPoint.x && point.y == firstPoint.y) ? 2.0 : 1.5;

      resultPoints.add(
        Point(x: point.x, y: point.y, color: color, thickness: thickness),
      );
    }

    // Добавляем точки из второго множества
    for (final point in secondPoints) {
      // Выделяем точки, которые образуют треугольник
      final color =
          ((point.x == secondPointA.x && point.y == secondPointA.y) ||
                  (point.x == secondPointB.x && point.y == secondPointB.y))
              ? _triangleColor
              : _secondSetPointsColor;
      final thickness =
          ((point.x == secondPointA.x && point.y == secondPointA.y) ||
                  (point.x == secondPointB.x && point.y == secondPointB.y))
              ? 2.0
              : 1.5;

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

    // Вычисляем длины сторон треугольника
    final sideAB = _calculateDistance(trianglePoints[0], trianglePoints[1]);
    final sideBC = _calculateDistance(trianglePoints[1], trianglePoints[2]);
    final sideCA = _calculateDistance(trianglePoints[2], trianglePoints[0]);

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа треугольника

### Координаты вершин треугольника
- A: (${trianglePoints[0].x}, ${trianglePoints[0].y}) - точка из первого множества
- B: (${trianglePoints[1].x}, ${trianglePoints[1].y}) - точка из второго множества
- C: (${trianglePoints[2].x}, ${trianglePoints[2].y}) - точка из второго множества

### Параметры треугольника
- Длина стороны AB: **$sideAB**
- Длина стороны BC: **$sideBC**
- Длина стороны CA: **$sideCA**
- Периметр: **${sideAB + sideBC + sideCA}**
- Площадь: **$area**

### Количество точек
- Точек в первом множестве: **${firstPoints.length}**
- Точек во втором множестве: **${secondPoints.length}**

### Визуализация
- Зеленый: треугольник с минимальной площадью
- Красный: остальные точки из первого множества
- Синий: остальные точки из второго множества
''';

    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }

  /// Вычисляет расстояние между двумя точками
  double _calculateDistance(Point a, Point b) {
    return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
  }

  /// Вычисляет квадрат числа
  double pow(double x, int power) {
    if (power == 2) {
      return x * x;
    }
    throw ArgumentError('Поддерживается только возведение в квадрат');
  }

  /// Вычисляет квадратный корень
  double sqrt(double x) {
    return math.sqrt(x);
  }
}
