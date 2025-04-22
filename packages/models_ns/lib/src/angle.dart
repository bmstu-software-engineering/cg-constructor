import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'validatable.dart';

part 'angle.freezed.dart';
part 'angle.g.dart';

/// Модель угла поворота
@freezed
@JsonSerializable()
class Angle with _$Angle, DiagnosticableTreeMixin implements Validatable {
  /// Приватный конструктор
  const Angle._();

  /// Создает угол поворота
  ///
  /// [value] - значение угла в градусах
  const factory Angle({required double value}) = _Angle;

  /// Создает угол из JSON
  factory Angle.fromJson(Map<String, dynamic> json) => _$AngleFromJson(json);

  /// Валидирует угол
  @override
  String? validate() {
    // Угол может быть любым числом, поэтому нет специфической валидации
    return null;
  }

  /// Проверяет, валиден ли угол
  @override
  bool isValid() => validate() == null;

  /// Нормализует угол в диапазон [0, 360)
  Angle normalize() {
    double normalizedValue = value % 360;
    if (normalizedValue < 0) {
      normalizedValue += 360;
    }
    return Angle(value: normalizedValue);
  }

  /// Конвертирует угол в радианы
  double toRadians() {
    return value * (math.pi / 180.0);
  }

  /// Создает угол из радиан
  factory Angle.fromRadians(double radians) {
    return Angle(value: radians * (180.0 / math.pi));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Angle(value: $value°)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('radians', toRadians()));
    properties.add(StringProperty('normalized', normalize().value.toString()));
  }
}
