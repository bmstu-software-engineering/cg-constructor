import 'dart:math';
import 'package:models_ns/models_ns.dart';

/// Класс для базовых геометрических вычислений
class GeometryCalculator {
  /// Вычисление расстояния между двумя точками
  static double calculateDistance(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }

  /// Вычисление угла между прямой и осью абсцисс
  static double calculateAngle(Point p1, Point p2) {
    // Используем atan2 для получения угла в диапазоне [-π, π]
    double angle = atan2(p2.y - p1.y, p2.x - p1.x);

    // Преобразуем в диапазон [0, π] для нашей задачи
    if (angle < 0) angle += pi;

    return angle;
  }
}
