import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'triangle.freezed.dart';
part 'triangle.g.dart';

/// Модель треугольника
@freezed
class Triangle with _$Triangle, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Triangle._();

  /// Создает треугольник
  ///
  /// [a] - первая точка треугольника
  /// [b] - вторая точка треугольника
  /// [c] - третья точка треугольника
  /// [color] - цвет треугольника (по умолчанию черный)
  /// [thickness] - толщина линий треугольника (по умолчанию 1.0)
  const factory Triangle({
    required Point a,
    required Point b,
    required Point c,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Triangle;

  /// Создает треугольник из JSON
  factory Triangle.fromJson(Map<String, dynamic> json) =>
      _$TriangleFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Треугольник';

  /// Список точек треугольника
  @override
  List<Point> toPoints() => [a, b, c];

  /// Перемещает треугольник на вектор
  @override
  Triangle move(Vector vector) => Triangle(
        a: a.move(vector),
        b: b.move(vector),
        c: c.move(vector),
        color: color,
        thickness: thickness,
      );

  /// Масштабирует треугольник относительно центра
  @override
  Triangle scale(Point center, Scale scale) => Triangle(
        a: a.scale(center, scale),
        b: b.scale(center, scale),
        c: c.scale(center, scale),
        color: color,
        thickness: thickness,
      );

  /// Поворачивает треугольник вокруг центра на угол в градусах
  @override
  Triangle rotate(Point center, double degrees) => Triangle(
        a: a.rotate(center, degrees),
        b: b.rotate(center, degrees),
        c: c.rotate(center, degrees),
        color: color,
        thickness: thickness,
      );

  /// Валидирует треугольник
  @override
  String? validate() {
    // Треугольник всегда имеет 3 точки, поэтому нет специфической валидации
    return null;
  }

  /// Проверяет, валиден ли треугольник
  @override
  bool isValid() => validate() == null;

  /// Длина стороны AB
  double get sideAB => _calculateDistance(b.x - a.x, b.y - a.y);

  /// Длина стороны BC
  double get sideBC => _calculateDistance(c.x - b.x, c.y - b.y);

  /// Длина стороны CA
  double get sideCA => _calculateDistance(a.x - c.x, a.y - c.y);

  /// Вычисляет периметр треугольника
  @override
  double get perimeter => sideAB + sideBC + sideCA;

  /// Вычисляет площадь треугольника по формуле Герона
  @override
  double get area {
    final s = perimeter / 2;
    return math.sqrt(s * (s - sideAB) * (s - sideBC) * (s - sideCA));
  }

  /// Вычисляет центр треугольника (центроид)
  @override
  Point get center {
    final sumX = a.x + b.x + c.x;
    final sumY = a.y + b.y + c.y;
    return Point(x: sumX / 3, y: sumY / 3);
  }

  /// Преобразует треугольник в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Вспомогательный метод для вычисления расстояния
  double _calculateDistance(double dx, double dy) {
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Проверяет, является ли треугольник равносторонним
  bool get isEquilateral {
    final ab = sideAB;
    final bc = sideBC;
    final ca = sideCA;

    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return (ab - bc).abs() < epsilon &&
        (bc - ca).abs() < epsilon &&
        (ca - ab).abs() < epsilon;
  }

  /// Проверяет, является ли треугольник равнобедренным
  bool get isIsosceles {
    final ab = sideAB;
    final bc = sideBC;
    final ca = sideCA;

    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return (ab - bc).abs() < epsilon ||
        (bc - ca).abs() < epsilon ||
        (ca - ab).abs() < epsilon;
  }

  /// Проверяет, является ли треугольник прямоугольным
  bool get isRightAngled {
    final ab2 = sideAB * sideAB;
    final bc2 = sideBC * sideBC;
    final ca2 = sideCA * sideCA;

    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return (ab2 + bc2 - ca2).abs() < epsilon ||
        (bc2 + ca2 - ab2).abs() < epsilon ||
        (ca2 + ab2 - bc2).abs() < epsilon;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Треугольник(a: $a, b: $b, c: $c, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('a', a));
    properties.add(DiagnosticsProperty<Point>('b', b));
    properties.add(DiagnosticsProperty<Point>('c', c));
    properties.add(IterableProperty<Point>('points', toPoints()));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('sideAB', sideAB));
    properties.add(DoubleProperty('sideBC', sideBC));
    properties.add(DoubleProperty('sideCA', sideCA));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('area', area));
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DiagnosticsProperty<bool>('isEquilateral', isEquilateral));
    properties.add(DiagnosticsProperty<bool>('isIsosceles', isIsosceles));
    properties.add(DiagnosticsProperty<bool>('isRightAngled', isRightAngled));
  }
}
