import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'validatable.dart';

part 'vector.freezed.dart';
part 'vector.g.dart';

/// Модель вектора перемещения
@freezed
@JsonSerializable()
class Vector with _$Vector, DiagnosticableTreeMixin implements Validatable {
  /// Приватный конструктор
  const Vector._();

  /// Создает вектор перемещения
  ///
  /// [dx] - смещение по оси X
  /// [dy] - смещение по оси Y
  const factory Vector({required double dx, required double dy}) = _Vector;

  /// Создает вектор из JSON
  factory Vector.fromJson(Map<String, dynamic> json) => _$VectorFromJson(json);

  /// Валидирует вектор
  @override
  String? validate() {
    // Вектор может иметь любые значения, поэтому нет специфической валидации
    return null;
  }

  /// Проверяет, валиден ли вектор
  @override
  bool isValid() => validate() == null;

  /// Вычисляет длину вектора
  double get length => math.sqrt(dx * dx + dy * dy);

  /// Вычисляет угол вектора в радианах
  double get angle => math.atan2(dy, dx);

  /// Создает единичный вектор (нормализованный)
  Vector get normalized {
    final len = length;
    if (len == 0) return Vector(dx: 0, dy: 0);
    return Vector(dx: dx / len, dy: dy / len);
  }

  /// Складывает два вектора
  Vector operator +(Vector other) {
    return Vector(dx: dx + other.dx, dy: dy + other.dy);
  }

  /// Вычитает вектор из текущего
  Vector operator -(Vector other) {
    return Vector(dx: dx - other.dx, dy: dy - other.dy);
  }

  /// Умножает вектор на скаляр
  Vector operator *(double scalar) {
    return Vector(dx: dx * scalar, dy: dy * scalar);
  }

  /// Делит вектор на скаляр
  Vector operator /(double scalar) {
    return Vector(dx: dx / scalar, dy: dy / scalar);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Vector(dx: $dx, dy: $dy)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('dx', dx));
    properties.add(DoubleProperty('dy', dy));
    properties.add(DoubleProperty('length', length));
    properties.add(DoubleProperty('angle', angle));
  }
}
