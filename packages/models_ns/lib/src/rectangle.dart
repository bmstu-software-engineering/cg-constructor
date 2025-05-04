import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'rectangle.freezed.dart';
part 'rectangle.g.dart';

/// Модель прямоугольника
@freezed
class Rectangle with _$Rectangle, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Rectangle._();

  /// Создает прямоугольник
  ///
  /// [topLeft] - верхняя левая точка
  /// [topRight] - верхняя правая точка
  /// [bottomRight] - нижняя правая точка
  /// [bottomLeft] - нижняя левая точка
  /// [color] - цвет прямоугольника (по умолчанию черный)
  /// [thickness] - толщина линий прямоугольника (по умолчанию 1.0)
  const factory Rectangle({
    required Point topLeft,
    required Point topRight,
    required Point bottomRight,
    required Point bottomLeft,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Rectangle;

  /// Создает прямоугольник из двух точек (верхний левый и нижний правый углы)
  factory Rectangle.fromCorners({
    required Point topLeft,
    required Point bottomRight,
    String color = '#000000',
    double thickness = 1.0,
  }) {
    final topRight = Point(x: bottomRight.x, y: topLeft.y);
    final bottomLeft = Point(x: topLeft.x, y: bottomRight.y);

    return Rectangle(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
      color: color,
      thickness: thickness,
    );
  }

  /// Создает прямоугольник из JSON
  factory Rectangle.fromJson(Map<String, dynamic> json) =>
      _$RectangleFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Прямоугольник';

  /// Список точек прямоугольника
  @override
  List<Point> toPoints() => [topLeft, topRight, bottomRight, bottomLeft];

  /// Перемещает прямоугольник на вектор
  @override
  Rectangle move(Vector vector) => Rectangle(
        topLeft: topLeft.move(vector),
        topRight: topRight.move(vector),
        bottomRight: bottomRight.move(vector),
        bottomLeft: bottomLeft.move(vector),
        color: color,
        thickness: thickness,
      );

  /// Масштабирует прямоугольник относительно центра
  @override
  Rectangle scale(Point center, Scale scale) => Rectangle(
        topLeft: topLeft.scale(center, scale),
        topRight: topRight.scale(center, scale),
        bottomRight: bottomRight.scale(center, scale),
        bottomLeft: bottomLeft.scale(center, scale),
        color: color,
        thickness: thickness,
      );

  /// Поворачивает прямоугольник вокруг центра на угол в градусах
  @override
  Rectangle rotate(Point center, double degrees) => Rectangle(
        topLeft: topLeft.rotate(center, degrees),
        topRight: topRight.rotate(center, degrees),
        bottomRight: bottomRight.rotate(center, degrees),
        bottomLeft: bottomLeft.rotate(center, degrees),
        color: color,
        thickness: thickness,
      );

  /// Валидирует прямоугольник
  @override
  String? validate() {
    // Прямоугольник всегда имеет 4 точки, поэтому нет специфической валидации
    return null;
  }

  /// Проверяет, валиден ли прямоугольник
  @override
  bool isValid() => validate() == null;

  /// Ширина прямоугольника
  double get width =>
      _calculateDistance(topRight.x - topLeft.x, topRight.y - topLeft.y);

  /// Высота прямоугольника
  double get height =>
      _calculateDistance(bottomLeft.x - topLeft.x, bottomLeft.y - topLeft.y);

  /// Вычисляет периметр прямоугольника
  @override
  double get perimeter => 2 * (width + height);

  /// Вычисляет площадь прямоугольника
  @override
  double get area => width * height;

  /// Вычисляет центр прямоугольника
  @override
  Point get center {
    final sumX = topLeft.x + topRight.x + bottomRight.x + bottomLeft.x;
    final sumY = topLeft.y + topRight.y + bottomRight.y + bottomLeft.y;
    return Point(x: sumX / 4, y: sumY / 4);
  }

  /// Преобразует прямоугольник в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Вспомогательный метод для вычисления расстояния
  double _calculateDistance(double dx, double dy) {
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Проверяет, является ли прямоугольник квадратом
  bool get isSquare {
    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return (width - height).abs() < epsilon;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Прямоугольник(topLeft: $topLeft, topRight: $topRight, bottomRight: $bottomRight, bottomLeft: $bottomLeft, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('topLeft', topLeft));
    properties.add(DiagnosticsProperty<Point>('topRight', topRight));
    properties.add(DiagnosticsProperty<Point>('bottomRight', bottomRight));
    properties.add(DiagnosticsProperty<Point>('bottomLeft', bottomLeft));
    properties.add(IterableProperty<Point>('points', toPoints()));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('area', area));
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DiagnosticsProperty<bool>('isSquare', isSquare));
  }
}
