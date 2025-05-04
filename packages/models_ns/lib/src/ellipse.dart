import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'ellipse.freezed.dart';
part 'ellipse.g.dart';

/// Модель эллипса
@freezed
class Ellipse with _$Ellipse, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Ellipse._();

  /// Создает эллипс
  ///
  /// [center] - центр эллипса
  /// [semiMajorAxis] - большая полуось эллипса
  /// [semiMinorAxis] - малая полуось эллипса
  /// [color] - цвет эллипса (по умолчанию черный)
  /// [thickness] - толщина линии эллипса (по умолчанию 1.0)
  const factory Ellipse({
    required Point center,
    required double semiMajorAxis,
    required double semiMinorAxis,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Ellipse;

  /// Создает эллипс из JSON
  factory Ellipse.fromJson(Map<String, dynamic> json) =>
      _$EllipseFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Эллипс';

  /// Преобразует эллипс в список точек
  @override
  List<Point> toPoints() => [
        center,
        Point(
          x: center.x + semiMajorAxis,
          y: center.y,
          color: color,
          thickness: thickness,
        ),
        Point(
          x: center.x,
          y: center.y + semiMinorAxis,
          color: color,
          thickness: thickness,
        ),
      ];

  /// Перемещает эллипс на вектор
  @override
  Ellipse move(Vector vector) => Ellipse(
        center: center.move(vector),
        semiMajorAxis: semiMajorAxis,
        semiMinorAxis: semiMinorAxis,
        color: color,
        thickness: thickness,
      );

  /// Масштабирует эллипс относительно центра
  @override
  Ellipse scale(Point scaleCenter, Scale scale) {
    final newCenter = center.scale(scaleCenter, scale);
    return Ellipse(
      center: newCenter,
      semiMajorAxis: semiMajorAxis * scale.x,
      semiMinorAxis: semiMinorAxis * scale.y,
      color: color,
      thickness: thickness,
    );
  }

  /// Поворачивает эллипс вокруг центра на угол в градусах
  @override
  Ellipse rotate(Point rotationCenter, double degrees) {
    // Для эллипса поворот вокруг его центра не меняет его форму,
    // только положение центра
    final newCenter = center.rotate(rotationCenter, degrees);
    return Ellipse(
      center: newCenter,
      semiMajorAxis: semiMajorAxis,
      semiMinorAxis: semiMinorAxis,
      color: color,
      thickness: thickness,
    );
  }

  /// Валидирует эллипс
  @override
  String? validate() {
    if (semiMajorAxis <= 0) {
      return 'Большая полуось эллипса должна быть положительной';
    }
    if (semiMinorAxis <= 0) {
      return 'Малая полуось эллипса должна быть положительной';
    }
    if (semiMinorAxis > semiMajorAxis) {
      return 'Малая полуось не может быть больше большой полуоси';
    }
    return null;
  }

  /// Проверяет, валиден ли эллипс
  @override
  bool isValid() => validate() == null;

  /// Вычисляет длину большой оси эллипса
  double get majorAxis => 2 * semiMajorAxis;

  /// Вычисляет длину малой оси эллипса
  double get minorAxis => 2 * semiMinorAxis;

  /// Вычисляет эксцентриситет эллипса
  double get eccentricity {
    if (semiMajorAxis == 0) return 0;
    return math.sqrt(
        1 - (semiMinorAxis * semiMinorAxis) / (semiMajorAxis * semiMajorAxis));
  }

  /// Вычисляет периметр эллипса (приближенно по формуле Рамануджана)
  @override
  double get perimeter {
    final a = semiMajorAxis;
    final b = semiMinorAxis;
    final h = math.pow(a - b, 2) / math.pow(a + b, 2);
    return math.pi * (a + b) * (1 + (3 * h) / (10 + math.sqrt(4 - 3 * h)));
  }

  /// Вычисляет площадь эллипса
  @override
  double get area => math.pi * semiMajorAxis * semiMinorAxis;

  /// Преобразует эллипс в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Получает точку на эллипсе по заданному углу (в радианах)
  Point pointAtAngle(double angle) {
    return Point(
      x: center.x + semiMajorAxis * math.cos(angle),
      y: center.y + semiMinorAxis * math.sin(angle),
    );
  }

  /// Проверяет, является ли эллипс кругом
  bool get isCircle {
    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return (semiMajorAxis - semiMinorAxis).abs() < epsilon;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Эллипс(center: $center, semiMajorAxis: $semiMajorAxis, semiMinorAxis: $semiMinorAxis, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DoubleProperty('semiMajorAxis', semiMajorAxis));
    properties.add(DoubleProperty('semiMinorAxis', semiMinorAxis));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('majorAxis', majorAxis));
    properties.add(DoubleProperty('minorAxis', minorAxis));
    properties.add(DoubleProperty('eccentricity', eccentricity));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('area', area));
    properties.add(DiagnosticsProperty<bool>('isCircle', isCircle));
  }
}
