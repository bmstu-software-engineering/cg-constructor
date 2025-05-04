import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'point.dart';
import 'validatable.dart';

part 'circle.freezed.dart';
part 'circle.g.dart';

/// Модель круга
@freezed
class Circle with _$Circle, DiagnosticableTreeMixin implements Validatable {
  /// Приватный конструктор
  const Circle._();

  /// Создает круг
  ///
  /// [center] - центр круга
  /// [radius] - радиус круга
  /// [color] - цвет круга (по умолчанию черный)
  /// [thickness] - толщина линии круга (по умолчанию 1.0)
  const factory Circle({
    required Point center,
    required double radius,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Circle;

  /// Создает круг из JSON
  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

  /// Валидирует круг
  @override
  String? validate() {
    if (radius <= 0) {
      return 'Радиус круга должен быть положительным';
    }
    return null;
  }

  /// Проверяет, валиден ли круг
  @override
  bool isValid() => validate() == null;

  /// Вычисляет диаметр круга
  double get diameter => 2 * radius;

  /// Вычисляет длину окружности
  double get circumference => 2 * math.pi * radius;

  /// Вычисляет площадь круга
  double get area => math.pi * radius * radius;

  /// Получает точку на окружности по заданному углу (в радианах)
  Point pointAtAngle(double angle) {
    return Point(
      x: center.x + radius * math.cos(angle),
      y: center.y + radius * math.sin(angle),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Circle(center: $center, radius: $radius, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DoubleProperty('radius', radius));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('diameter', diameter));
    properties.add(DoubleProperty('circumference', circumference));
    properties.add(DoubleProperty('area', area));
  }
}
