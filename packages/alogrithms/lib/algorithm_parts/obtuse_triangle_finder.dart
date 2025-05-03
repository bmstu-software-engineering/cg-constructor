import 'package:models_ns/models_ns.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'geometry_calculator.dart';

/// Класс для поиска треугольников с тупыми углами и максимальным углом между ними
class ObtuseTriangleFinder {
  /// Минимальное количество точек, необходимое для формирования треугольника
  static const int minPointsRequired = 3;

  /// Проверяет достаточность точек для формирования треугольников
  static void validatePointsCount(
    List<Point> pointsFirst,
    List<Point> pointsSecond,
  ) {
    if (pointsFirst.length < minPointsRequired) {
      throw InsufficientPointsException(
        'Первое множество',
        minPointsRequired,
        pointsFirst.length,
      );
    }
    if (pointsSecond.length < minPointsRequired) {
      throw InsufficientPointsException(
        'Второе множество',
        minPointsRequired,
        pointsSecond.length,
      );
    }
  }

  /// Находит пару треугольников с максимальным углом между вершинами с тупыми углами
  static (Triangle, Triangle, Point, Point, Line) findMaxAnglePair(
    List<(Triangle, Point)> obtuseFirst,
    List<(Triangle, Point)> obtuseSecond,
    String resultLineColor,
  ) {
    double maxAngle = 0;
    Line? resultLine;
    Triangle? firstTriangle;
    Triangle? secondTriangle;
    Point? firstObtuseVertex;
    Point? secondObtuseVertex;

    for (var pair1 in obtuseFirst) {
      Point point1 = pair1.$2;
      for (var pair2 in obtuseSecond) {
        Point point2 = pair2.$2;
        double angle = GeometryCalculator.calculateAngle(point1, point2);
        if (angle > maxAngle) {
          maxAngle = angle;
          resultLine = Line(a: point1, b: point2, color: resultLineColor);
          firstTriangle = pair1.$1;
          secondTriangle = pair2.$1;
          firstObtuseVertex = point1;
          secondObtuseVertex = point2;
        }
      }
    }

    if (resultLine == null ||
        firstTriangle == null ||
        secondTriangle == null ||
        firstObtuseVertex == null ||
        secondObtuseVertex == null) {
      throw CalculationException('Не удалось найти линию с максимальным углом');
    }

    return (
      firstTriangle,
      secondTriangle,
      firstObtuseVertex,
      secondObtuseVertex,
      resultLine,
    );
  }
}
