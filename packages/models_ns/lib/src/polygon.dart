import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'polygon.freezed.dart';
part 'polygon.g.dart';

/// Модель многоугольника
@freezed
class Polygon with _$Polygon, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Polygon._();

  /// Создает многоугольник
  ///
  /// [points] - список точек многоугольника
  /// [color] - цвет многоугольника (по умолчанию черный)
  /// [thickness] - толщина линий многоугольника (по умолчанию 1.0)
  const factory Polygon({
    required List<Point> points,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Polygon;

  /// Создает многоугольник из JSON
  factory Polygon.fromJson(Map<String, dynamic> json) =>
      _$PolygonFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Многоугольник';

  /// Преобразует многоугольник в список точек
  @override
  List<Point> toPoints() => points;

  /// Перемещает многоугольник на вектор
  @override
  Polygon move(Vector vector) => Polygon(
        points: points.map((p) => p.move(vector)).toList(),
        color: color,
        thickness: thickness,
      );

  /// Масштабирует многоугольник относительно центра
  @override
  Polygon scale(Point scaleCenter, Scale scale) => Polygon(
        points: points.map((p) => p.scale(scaleCenter, scale)).toList(),
        color: color,
        thickness: thickness,
      );

  /// Поворачивает многоугольник вокруг центра на угол в градусах
  @override
  Polygon rotate(Point rotationCenter, double degrees) => Polygon(
        points: points.map((p) => p.rotate(rotationCenter, degrees)).toList(),
        color: color,
        thickness: thickness,
      );

  /// Валидирует многоугольник
  @override
  String? validate() {
    if (points.length < 3) {
      return 'Многоугольник должен иметь не менее 3 точек';
    }
    return null;
  }

  /// Проверяет, валиден ли многоугольник
  @override
  bool isValid() => validate() == null;

  /// Вычисляет периметр многоугольника
  @override
  double get perimeter {
    if (points.isEmpty) return 0;

    double result = 0;
    for (int i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];

      final dx = next.x - current.x;
      final dy = next.y - current.y;
      result += _distance(dx, dy);
    }

    return result;
  }

  /// Вычисляет площадь многоугольника
  @override
  double get area {
    if (points.length < 3) return 0;

    double result = 0;
    for (int i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];

      result += (current.x * next.y - next.x * current.y);
    }

    return result.abs() / 2;
  }

  /// Вычисляет центр многоугольника (центроид)
  @override
  Point get center {
    if (points.isEmpty) {
      return const Point(x: 0, y: 0);
    }

    double sumX = 0;
    double sumY = 0;

    for (final point in points) {
      sumX += point.x;
      sumY += point.y;
    }

    return Point(x: sumX / points.length, y: sumY / points.length);
  }

  /// Преобразует многоугольник в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Вспомогательный метод для вычисления расстояния
  double _distance(double dx, double dy) {
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Многоугольник(points: $points, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Point>('points', points));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('area', area));
    properties.add(DiagnosticsProperty<Point>('center', center));
  }
}
