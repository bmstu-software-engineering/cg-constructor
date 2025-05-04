import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

class AlgorithmL01V40 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V40.fromModel(this._model);

  factory AlgorithmL01V40() =>
      AlgorithmL01V40.fromModel(DualPointSetModelImpl());

  final DualPointSetModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Цвета для визуализации
  static const String _firstTriangleColor = '#00FF00'; // Зеленый
  static const String _secondTriangleColor = '#0000FF'; // Синий
  static const String _resultLineColor = '#FF0000'; // Красный

  @override
  ViewerResultModel calculate() {
    final pointsFirst = _model.data.firstPoints;
    final pointsSecond = _model.data.secondPoints;

    // Проверка на достаточное количество точек
    ObtuseTriangleFinder.validatePointsCount(pointsFirst, pointsSecond);

    // Генерируем все треугольники
    List<Triangle> trianglesFirst = TriangleGenerator.generateTriangles(
      pointsFirst,
    );
    List<Triangle> trianglesSecond = TriangleGenerator.generateTriangles(
      pointsSecond,
    );

    // Находим треугольники с тупыми углами и соответствующие вершины
    List<(Triangle, Point)> obtuseFirst = TriangleAnalyzer.findObtuseTriangles(
      trianglesFirst,
    );

    // Проверка на наличие треугольников с тупыми углами в первом множестве
    if (obtuseFirst.isEmpty) {
      throw NoObtuseAnglesException('Первое множество');
    }

    List<(Triangle, Point)> obtuseSecond = TriangleAnalyzer.findObtuseTriangles(
      trianglesSecond,
    );

    // Проверка на наличие треугольников с тупыми углами во втором множестве
    if (obtuseSecond.isEmpty) {
      throw NoObtuseAnglesException('Второе множество');
    }

    try {
      // Находим пару с максимальным углом
      final (
        firstTriangle,
        secondTriangle,
        firstObtuseVertex,
        secondObtuseVertex,
        resultLine,
      ) = ObtuseTriangleFinder.findMaxAnglePair(
        obtuseFirst,
        obtuseSecond,
        _resultLineColor,
      );

      // Создаем точки для треугольников с соответствующими цветами
      List<Point> resultPoints = [];

      // Точки первого треугольника (зеленый)
      resultPoints.add(
        Point(
          x: firstTriangle.a.x,
          y: firstTriangle.a.y,
          color: _firstTriangleColor,
          thickness:
              firstTriangle.a == firstObtuseVertex
                  ? 2.0
                  : 1.0, // Увеличиваем толщину для вершины с тупым углом
        ),
      );
      resultPoints.add(
        Point(
          x: firstTriangle.b.x,
          y: firstTriangle.b.y,
          color: _firstTriangleColor,
          thickness: firstTriangle.b == firstObtuseVertex ? 2.0 : 1.0,
        ),
      );
      resultPoints.add(
        Point(
          x: firstTriangle.c.x,
          y: firstTriangle.c.y,
          color: _firstTriangleColor,
          thickness: firstTriangle.c == firstObtuseVertex ? 2.0 : 1.0,
        ),
      );

      // Точки второго треугольника (синий)
      resultPoints.add(
        Point(
          x: secondTriangle.a.x,
          y: secondTriangle.a.y,
          color: _secondTriangleColor,
          thickness: secondTriangle.a == secondObtuseVertex ? 2.0 : 1.0,
        ),
      );
      resultPoints.add(
        Point(
          x: secondTriangle.b.x,
          y: secondTriangle.b.y,
          color: _secondTriangleColor,
          thickness: secondTriangle.b == secondObtuseVertex ? 2.0 : 1.0,
        ),
      );
      resultPoints.add(
        Point(
          x: secondTriangle.c.x,
          y: secondTriangle.c.y,
          color: _secondTriangleColor,
          thickness: secondTriangle.c == secondObtuseVertex ? 2.0 : 1.0,
        ),
      );

      // Создаем линии для треугольников
      List<Line> resultLines = [];

      // Линии первого треугольника (зеленый)
      resultLines.add(
        Line(
          a: firstTriangle.a,
          b: firstTriangle.b,
          color: _firstTriangleColor,
        ),
      );
      resultLines.add(
        Line(
          a: firstTriangle.b,
          b: firstTriangle.c,
          color: _firstTriangleColor,
        ),
      );
      resultLines.add(
        Line(
          a: firstTriangle.c,
          b: firstTriangle.a,
          color: _firstTriangleColor,
        ),
      );

      // Линии второго треугольника (синий)
      resultLines.add(
        Line(
          a: secondTriangle.a,
          b: secondTriangle.b,
          color: _secondTriangleColor,
        ),
      );
      resultLines.add(
        Line(
          a: secondTriangle.b,
          b: secondTriangle.c,
          color: _secondTriangleColor,
        ),
      );
      resultLines.add(
        Line(
          a: secondTriangle.c,
          b: secondTriangle.a,
          color: _secondTriangleColor,
        ),
      );

      // Добавляем результирующую линию (красная)
      resultLines.add(resultLine);

      // Формируем текстовую информацию в формате Markdown
      final angle =
          GeometryCalculator.calculateAngle(
            firstObtuseVertex,
            secondObtuseVertex,
          ) *
          180 /
          3.14159265359; // Преобразуем радианы в градусы

      final markdownInfo = '''
## Результаты анализа треугольников с тупыми углами

### Первый треугольник (зеленый)
- Координаты вершин:
  - A: (${firstTriangle.a.x}, ${firstTriangle.a.y})${firstTriangle.a == firstObtuseVertex ? ' (тупой угол)' : ''}
  - B: (${firstTriangle.b.x}, ${firstTriangle.b.y})${firstTriangle.b == firstObtuseVertex ? ' (тупой угол)' : ''}
  - C: (${firstTriangle.c.x}, ${firstTriangle.c.y})${firstTriangle.c == firstObtuseVertex ? ' (тупой угол)' : ''}

### Второй треугольник (синий)
- Координаты вершин:
  - A: (${secondTriangle.a.x}, ${secondTriangle.a.y})${secondTriangle.a == secondObtuseVertex ? ' (тупой угол)' : ''}
  - B: (${secondTriangle.b.x}, ${secondTriangle.b.y})${secondTriangle.b == secondObtuseVertex ? ' (тупой угол)' : ''}
  - C: (${secondTriangle.c.x}, ${secondTriangle.c.y})${secondTriangle.c == secondObtuseVertex ? ' (тупой угол)' : ''}

### Результирующая линия (красная)
- Соединяет вершины с тупыми углами:
  - Из первого треугольника: (${firstObtuseVertex.x}, ${firstObtuseVertex.y})
  - Из второго треугольника: (${secondObtuseVertex.x}, ${secondObtuseVertex.y})
- Угол с осью абсцисс: **${angle.toStringAsFixed(2)}°**

### Визуализация
- Зеленый: первый треугольник
- Синий: второй треугольник
- Красный: линия, соединяющая вершины с тупыми углами
- Вершины с тупыми углами имеют увеличенную толщину (2.0)
''';

      return ViewerResultModel(
        points: resultPoints,
        lines: resultLines,
        markdownInfo: markdownInfo,
      );
    } catch (e) {
      if (e is AlgorithmException) {
        rethrow;
      }
      throw CalculationException('Ошибка при вычислении: ${e.toString()}');
    }
  }
}
