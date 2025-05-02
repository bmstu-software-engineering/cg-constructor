import 'dart:math';

import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';

import 'data.dart';

// Вспомогательный класс для представления треугольника
class _Triangle {
  final Point a;
  final Point b;
  final Point c;

  _Triangle({required this.a, required this.b, required this.c});
}

class AlgorithmL01V40 implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01V40.fromModel(this._model);

  factory AlgorithmL01V40() =>
      AlgorithmL01V40.fromModel(AlgorithmL01VBasicDataModelImpl());

  final AlgorithmL01VBasicDataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Вычисление расстояния между двумя точками
  double _distance(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }

  // Генерация всех возможных треугольников из множества точек
  List<_Triangle> _generateTriangles(List<Point> points) {
    List<_Triangle> triangles = [];
    for (int i = 0; i < points.length - 2; i++) {
      for (int j = i + 1; j < points.length - 1; j++) {
        for (int k = j + 1; k < points.length; k++) {
          triangles.add(_Triangle(a: points[i], b: points[j], c: points[k]));
        }
      }
    }
    return triangles;
  }

  // Определение вершины с тупым углом в треугольнике (если есть)
  Point? _findObtuseAngleVertex(_Triangle triangle) {
    Point a = triangle.a, b = triangle.b, c = triangle.c;

    // Вычисляем длины сторон треугольника
    double ab = _distance(a, b);
    double bc = _distance(b, c);
    double ca = _distance(c, a);

    // Проверяем угол при вершине A
    double cosA = (ab * ab + ca * ca - bc * bc) / (2 * ab * ca);
    if (cosA < 0) return a;

    // Проверяем угол при вершине B
    double cosB = (ab * ab + bc * bc - ca * ca) / (2 * ab * bc);
    if (cosB < 0) return b;

    // Проверяем угол при вершине C
    double cosC = (bc * bc + ca * ca - ab * ab) / (2 * bc * ca);
    if (cosC < 0) return c;

    // Нет тупого угла
    return null;
  }

  // Вычисление угла между прямой и осью абсцисс
  double _calculateAngle(Point p1, Point p2) {
    // Используем atan2 для получения угла в диапазоне [-π, π]
    double angle = atan2(p2.y - p1.y, p2.x - p1.x);

    // Преобразуем в диапазон [0, π] для нашей задачи
    if (angle < 0) angle += pi;

    return angle;
  }

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
    if (pointsFirst.length < _minPointsRequired) {
      throw InsufficientPointsException(
        'Первое множество',
        _minPointsRequired,
        pointsFirst.length,
      );
    }
    if (pointsSecond.length < _minPointsRequired) {
      throw InsufficientPointsException(
        'Второе множество',
        _minPointsRequired,
        pointsSecond.length,
      );
    }

    // Генерируем все треугольники
    List<_Triangle> trianglesFirst = _generateTriangles(pointsFirst);
    List<_Triangle> trianglesSecond = _generateTriangles(pointsSecond);

    // Находим треугольники с тупыми углами и соответствующие вершины
    List<(_Triangle, Point)> obtuseFirst = [];
    for (var triangle in trianglesFirst) {
      Point? obtuseVertex = _findObtuseAngleVertex(triangle);
      if (obtuseVertex != null) {
        obtuseFirst.add((triangle, obtuseVertex));
      }
    }

    // Проверка на наличие треугольников с тупыми углами в первом множестве
    if (obtuseFirst.isEmpty) {
      throw NoObtuseAnglesException('Первое множество');
    }

    List<(_Triangle, Point)> obtuseSecond = [];
    for (var triangle in trianglesSecond) {
      Point? obtuseVertex = _findObtuseAngleVertex(triangle);
      if (obtuseVertex != null) {
        obtuseSecond.add((triangle, obtuseVertex));
      }
    }

    // Проверка на наличие треугольников с тупыми углами во втором множестве
    if (obtuseSecond.isEmpty) {
      throw NoObtuseAnglesException('Второе множество');
    }

    try {
      // Находим пару с максимальным углом
      double maxAngle = 0;
      Line? resultLine;
      _Triangle? firstTriangle;
      _Triangle? secondTriangle;
      Point? firstObtuseVertex;
      Point? secondObtuseVertex;

      for (var pair1 in obtuseFirst) {
        Point point1 = pair1.$2;
        for (var pair2 in obtuseSecond) {
          Point point2 = pair2.$2;
          double angle = _calculateAngle(point1, point2);
          if (angle > maxAngle) {
            maxAngle = angle;
            resultLine = Line(a: point1, b: point2, color: _resultLineColor);
            firstTriangle = pair1.$1;
            secondTriangle = pair2.$1;
            firstObtuseVertex = point1;
            secondObtuseVertex = point2;
          }
        }
      }

      if (resultLine == null ||
          firstTriangle == null ||
          secondTriangle == null) {
        throw CalculationException(
          'Не удалось найти линию с максимальным углом',
        );
      }

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
