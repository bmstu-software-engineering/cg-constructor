import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models_ns/models_ns.dart';

import '../core/validatable.dart';

part 'polygon.freezed.dart';
part 'polygon.g.dart';

/// Модель многоугольника
@freezed
class Polygon with _$Polygon, DiagnosticableTreeMixin implements Validatable {
  /// Приватный конструктор
  const Polygon._();

  /// Создает многоугольник
  ///
  /// [points] - список точек многоугольника
  /// [color] - цвет многоугольника (по умолчанию черный)
  /// [thickness] - толщина линий многоугольника (по умолчанию 1.0)
  @JsonSerializable()
  const factory Polygon({
    required List<Point> points,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Polygon;

  /// Создает многоугольник из JSON
  factory Polygon.fromJson(Map<String, dynamic> json) =>
      _$PolygonFromJson(json);

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

  /// Вспомогательный метод для вычисления расстояния
  double _distance(double dx, double dy) {
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Polygon(points: $points, color: $color, thickness: $thickness)';

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
