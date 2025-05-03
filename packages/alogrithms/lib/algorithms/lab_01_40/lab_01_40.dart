import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:alogrithms/algorithm_parts/geometry_calculator.dart';
import 'package:alogrithms/algorithm_parts/triangle_generator.dart';
import 'package:alogrithms/algorithm_parts/triangle_analyzer.dart';
import 'package:alogrithms/algorithm_parts/obtuse_triangle_finder.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';

import 'data.dart';

class AlgorithmL01V40 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V40.fromModel(this._model);

  factory AlgorithmL01V40() =>
      AlgorithmL01V40.fromModel(AlgorithmL01VBasicDataModelImpl());

  final AlgorithmL01VBasicDataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int _minPointsRequired = 3;

  // Цвета для визуализации
  static const String _firstTriangleColor = '#00FF00'; // Зеленый
  static const String _secondTriangleColor = '#0000FF'; // Синий
  static const String _resultLineColor = '#FF0000'; // Красный

  @override
  ViewerResultModel calculate() {
    final pointsFirst = _model.data.pointsFirst;
    final pointsSecond = _model.data.pointsSecond;

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

      return ViewerResultModel(points: resultPoints, lines: resultLines);
    } catch (e) {
      if (e is AlgorithmException) {
        rethrow;
      }
      throw CalculationException('Ошибка при вычислении: ${e.toString()}');
    }
  }
}
