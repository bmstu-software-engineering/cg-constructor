import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'validatable.dart';

part 'scale.freezed.dart';
part 'scale.g.dart';

/// Модель коэффициентов масштабирования
@freezed
class Scale with _$Scale, DiagnosticableTreeMixin implements Validatable {
  /// Приватный конструктор
  const Scale._();

  /// Создает коэффициенты масштабирования
  ///
  /// [x] - коэффициент масштабирования по оси X
  /// [y] - коэффициент масштабирования по оси Y
  @JsonSerializable()
  const factory Scale({required double x, required double y}) = _Scale;

  /// Создает равномерное масштабирование (одинаковое по обеим осям)
  factory Scale.uniform(double value) => Scale(x: value, y: value);

  /// Создает масштабирование из JSON
  factory Scale.fromJson(Map<String, dynamic> json) => _$ScaleFromJson(json);

  /// Валидирует масштабирование
  @override
  String? validate() {
    if (x == 0) {
      return 'Коэффициент масштабирования по X не может быть равен 0';
    }
    if (y == 0) {
      return 'Коэффициент масштабирования по Y не может быть равен 0';
    }
    return null;
  }

  /// Проверяет, валидно ли масштабирование
  @override
  bool isValid() => validate() == null;

  /// Проверяет, является ли масштабирование равномерным
  bool get isUniform => x == y;

  /// Умножает масштабирование на другое масштабирование
  Scale operator *(Scale other) {
    return Scale(x: x * other.x, y: y * other.y);
  }

  /// Делит масштабирование на другое масштабирование
  Scale operator /(Scale other) {
    return Scale(x: x / other.x, y: y / other.y);
  }

  /// Инвертирует масштабирование (1/x, 1/y)
  Scale get inverted => Scale(x: 1 / x, y: 1 / y);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Scale(x: $x, y: $y)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('x', x));
    properties.add(DoubleProperty('y', y));
    properties.add(DiagnosticsProperty<bool>('isUniform', isUniform));
  }
}
