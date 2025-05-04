import 'dart:convert';
import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'line.freezed.dart';
part 'line.g.dart';

@freezed
class Line with _$Line, DiagnosticableTreeMixin implements Figure {
  const Line._();

  const factory Line({
    required Point a,
    required Point b,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  @override
  bool operator ==(covariant Line other) => other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);

  /// Название фигуры
  @override
  String get name => 'Линия';

  /// Преобразует линию в список точек
  @override
  List<Point> toPoints() => [a, b];

  /// Перемещает линию на вектор
  @override
  Line move(Vector vector) => Line(
        a: a.move(vector),
        b: b.move(vector),
        color: color,
        thickness: thickness,
      );

  /// Масштабирует линию относительно центра
  @override
  Line scale(Point center, Scale scale) => Line(
        a: a.scale(center, scale),
        b: b.scale(center, scale),
        color: color,
        thickness: thickness,
      );

  /// Поворачивает линию вокруг центра на угол в градусах
  @override
  Line rotate(Point center, double degrees) => Line(
        a: a.rotate(center, degrees),
        b: b.rotate(center, degrees),
        color: color,
        thickness: thickness,
      );

  /// Центр линии
  @override
  Point get center => Point(
        x: (a.x + b.x) / 2,
        y: (a.y + b.y) / 2,
      );

  /// Длина линии
  double get length =>
      math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));

  /// Периметр линии (удвоенная длина)
  @override
  double get perimeter => length * 2;

  /// Площадь линии равна 0
  @override
  double get area => 0;

  /// Преобразует линию в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Валидирует линию
  @override
  String? validate() => null;

  /// Проверяет, валидна ли линия
  @override
  bool isValid() => true;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Линия(a: $a, b: $b, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('a', a));
    properties.add(DiagnosticsProperty<Point>('b', b));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('length', length));
    properties.add(DiagnosticsProperty<Point>('center', center));
  }
}
