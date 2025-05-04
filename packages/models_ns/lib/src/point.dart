import 'dart:convert';
import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'figure.dart';
import 'vector.dart';
import 'scale.dart';

part 'point.freezed.dart';
part 'point.g.dart';

@freezed
class Point with _$Point, DiagnosticableTreeMixin implements Figure {
  const Point._();

  const factory Point({
    required double x,
    required double y,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Point;

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  @override
  bool operator ==(covariant Point other) => other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Название фигуры
  @override
  String get name => 'Точка';

  /// Преобразует точку в список точек (возвращает саму себя)
  @override
  List<Point> toPoints() => [this];

  /// Перемещает точку на вектор
  @override
  Point move(Vector vector) => Point(
        x: x + vector.dx,
        y: y + vector.dy,
        color: color,
        thickness: thickness,
      );

  /// Масштабирует точку относительно центра
  @override
  Point scale(Point center, Scale scale) => Point(
        x: center.x + (x - center.x) * scale.x,
        y: center.y + (y - center.y) * scale.y,
        color: color,
        thickness: thickness,
      );

  /// Поворачивает точку вокруг центра на угол в градусах
  @override
  Point rotate(Point center, double degrees) {
    final radians = degrees * (math.pi / 180);
    final cosA = math.cos(radians);
    final sinA = math.sin(radians);
    final dx = x - center.x;
    final dy = y - center.y;

    return Point(
      x: center.x + dx * cosA - dy * sinA,
      y: center.y + dx * sinA + dy * cosA,
      color: color,
      thickness: thickness,
    );
  }

  /// Центр точки - сама точка
  @override
  Point get center => this;

  /// Периметр точки равен 0
  @override
  double get perimeter => 0;

  /// Площадь точки равна 0
  @override
  double get area => 0;

  /// Преобразует точку в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Валидирует точку
  @override
  String? validate() => null;

  /// Проверяет, валидна ли точка
  @override
  bool isValid() => true;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Точка(x: $x, y: $y, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('x', x));
    properties.add(DoubleProperty('y', y));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
  }
}
