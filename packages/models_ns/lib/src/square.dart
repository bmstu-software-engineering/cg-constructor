import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'square.freezed.dart';
part 'square.g.dart';

/// Модель квадрата
@freezed
class Square with _$Square, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Square._();

  /// Создает квадрат
  ///
  /// [center] - центр квадрата
  /// [sideLength] - длина стороны квадрата
  /// [color] - цвет квадрата (по умолчанию черный)
  /// [thickness] - толщина линий квадрата (по умолчанию 1.0)
  const factory Square({
    required Point center,
    required double sideLength,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Square;

  /// Создает квадрат из JSON
  factory Square.fromJson(Map<String, dynamic> json) => _$SquareFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Квадрат';

  /// Преобразует квадрат в список точек
  @override
  List<Point> toPoints() => [center, topRight];

  /// Перемещает квадрат на вектор
  @override
  Square move(Vector vector) => Square(
        center: center.move(vector),
        sideLength: sideLength,
        color: color,
        thickness: thickness,
      );

  /// Масштабирует квадрат относительно центра
  @override
  Square scale(Point scaleCenter, Scale scale) {
    // Для квадрата используем только один коэффициент масштабирования,
    // чтобы сохранить пропорции
    final newCenter = center.scale(scaleCenter, scale);
    final scaleFactor = (scale.x + scale.y) / 2;
    return Square(
      center: newCenter,
      sideLength: sideLength * scaleFactor,
      color: color,
      thickness: thickness,
    );
  }

  /// Поворачивает квадрат вокруг центра на угол в градусах
  @override
  Square rotate(Point rotationCenter, double degrees) {
    // Для квадрата поворот вокруг его центра не меняет его форму,
    // только положение центра
    final newCenter = center.rotate(rotationCenter, degrees);
    return Square(
      center: newCenter,
      sideLength: sideLength,
      color: color,
      thickness: thickness,
    );
  }

  /// Валидирует квадрат
  @override
  String? validate() {
    if (sideLength <= 0) {
      return 'Длина стороны квадрата должна быть положительной';
    }
    return null;
  }

  /// Проверяет, валиден ли квадрат
  @override
  bool isValid() => validate() == null;

  /// Вычисляет периметр квадрата
  @override
  double get perimeter => 4 * sideLength;

  /// Вычисляет площадь квадрата
  @override
  double get area => sideLength * sideLength;

  /// Преобразует квадрат в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Вычисляет диагональ квадрата
  double get diagonal => sideLength * math.sqrt(2);

  /// Получает верхнюю левую точку квадрата
  Point get topLeft => Point(
        x: center.x - sideLength / 2,
        y: center.y - sideLength / 2,
      );

  /// Получает верхнюю правую точку квадрата
  Point get topRight => Point(
        x: center.x + sideLength / 2,
        y: center.y - sideLength / 2,
      );

  /// Получает нижнюю правую точку квадрата
  Point get bottomRight => Point(
        x: center.x + sideLength / 2,
        y: center.y + sideLength / 2,
      );

  /// Получает нижнюю левую точку квадрата
  Point get bottomLeft => Point(
        x: center.x - sideLength / 2,
        y: center.y + sideLength / 2,
      );

  /// Получает список всех точек квадрата
  List<Point> get points => [topLeft, topRight, bottomRight, bottomLeft];

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Квадрат(center: $center, sideLength: $sideLength, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DoubleProperty('sideLength', sideLength));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('area', area));
    properties.add(DoubleProperty('diagonal', diagonal));
    properties.add(DiagnosticsProperty<Point>('topLeft', topLeft));
    properties.add(DiagnosticsProperty<Point>('topRight', topRight));
    properties.add(DiagnosticsProperty<Point>('bottomRight', bottomRight));
    properties.add(DiagnosticsProperty<Point>('bottomLeft', bottomLeft));
    properties.add(IterableProperty<Point>('points', points));
  }
}
