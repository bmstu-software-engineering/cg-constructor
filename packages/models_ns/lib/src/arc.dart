import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'figure.dart';
import 'point.dart';
import 'vector.dart';
import 'scale.dart';

part 'arc.freezed.dart';
part 'arc.g.dart';

/// Модель дуги
@freezed
class Arc with _$Arc, DiagnosticableTreeMixin implements Figure {
  /// Приватный конструктор
  const Arc._();

  /// Создает дугу
  ///
  /// [center] - центр дуги
  /// [radius] - радиус дуги
  /// [startAngle] - начальный угол дуги (в радианах)
  /// [endAngle] - конечный угол дуги (в радианах)
  /// [color] - цвет дуги (по умолчанию черный)
  /// [thickness] - толщина линии дуги (по умолчанию 1.0)
  const factory Arc({
    required Point center,
    required double radius,
    required double startAngle,
    required double endAngle,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Arc;

  /// Создает дугу из JSON
  factory Arc.fromJson(Map<String, dynamic> json) => _$ArcFromJson(json);

  /// Название фигуры
  @override
  String get name => 'Дуга';

  /// Преобразует дугу в список точек
  @override
  List<Point> toPoints() => [
        center,
        startPoint,
        endPoint,
      ];

  /// Перемещает дугу на вектор
  @override
  Arc move(Vector vector) => Arc(
        center: center.move(vector),
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        color: color,
        thickness: thickness,
      );

  /// Масштабирует дугу относительно центра
  @override
  Arc scale(Point scaleCenter, Scale scale) {
    // Для дуги используем среднее значение масштаба
    final newCenter = center.scale(scaleCenter, scale);
    final scaleFactor = (scale.x + scale.y) / 2;
    return Arc(
      center: newCenter,
      radius: radius * scaleFactor,
      startAngle: startAngle,
      endAngle: endAngle,
      color: color,
      thickness: thickness,
    );
  }

  /// Поворачивает дугу вокруг центра на угол в градусах
  @override
  Arc rotate(Point rotationCenter, double degrees) {
    final radians = degrees * (math.pi / 180);
    final newCenter = center.rotate(rotationCenter, degrees);
    return Arc(
      center: newCenter,
      radius: radius,
      startAngle: startAngle + radians,
      endAngle: endAngle + radians,
      color: color,
      thickness: thickness,
    );
  }

  /// Валидирует дугу
  @override
  String? validate() {
    if (radius <= 0) {
      return 'Радиус дуги должен быть положительным';
    }
    return null;
  }

  /// Проверяет, валидна ли дуга
  @override
  bool isValid() => validate() == null;

  /// Вычисляет угол дуги (в радианах)
  double get angle {
    // Нормализуем углы в диапазоне [0, 2π]
    final start = _normalizeAngle(startAngle);
    final end = _normalizeAngle(endAngle);

    // Проверяем, является ли дуга полной окружностью
    if ((end - start).abs() < 1e-10 ||
        (end - start - 2 * math.pi).abs() < 1e-10) {
      return 2 * math.pi;
    }

    // Вычисляем угол дуги
    if (end >= start) {
      return end - start;
    } else {
      return 2 * math.pi - (start - end);
    }
  }

  /// Нормализует угол в диапазоне [0, 2π]
  double _normalizeAngle(double angle) {
    final result = angle % (2 * math.pi);
    return result < 0 ? result + 2 * math.pi : result;
  }

  /// Вычисляет длину дуги
  double get length => radius * angle;

  /// Вычисляет периметр дуги (длина дуги + 2 радиуса, если не полная окружность)
  @override
  double get perimeter => isFullCircle ? length : length + 2 * radius;

  /// Вычисляет площадь сектора, образованного дугой
  double get sectorArea => 0.5 * radius * radius * angle;

  /// Вычисляет площадь сегмента, образованного дугой и хордой
  double get segmentArea {
    final theta = angle;
    return 0.5 * radius * radius * (theta - math.sin(theta));
  }

  /// Вычисляет площадь фигуры (площадь сектора)
  @override
  double get area => sectorArea;

  /// Преобразует дугу в строку JSON
  @override
  String toJsonString() => jsonEncode(toJson());

  /// Получает начальную точку дуги
  Point get startPoint => Point(
        x: center.x + radius * math.cos(startAngle),
        y: center.y + radius * math.sin(startAngle),
      );

  /// Получает конечную точку дуги
  Point get endPoint => Point(
        x: center.x + radius * math.cos(endAngle),
        y: center.y + radius * math.sin(endAngle),
      );

  /// Получает точку на дуге по заданному углу (в радианах)
  Point pointAtAngle(double angle) {
    // Проверяем, находится ли угол в пределах дуги
    final normalizedAngle = _normalizeAngle(angle);
    final normalizedStart = _normalizeAngle(startAngle);
    final normalizedEnd = _normalizeAngle(endAngle);

    bool isInArc;
    if (normalizedEnd >= normalizedStart) {
      isInArc = normalizedAngle >= normalizedStart &&
          normalizedAngle <= normalizedEnd;
    } else {
      isInArc = normalizedAngle >= normalizedStart ||
          normalizedAngle <= normalizedEnd;
    }

    if (!isInArc) {
      throw ArgumentError('Угол $angle находится за пределами дуги');
    }

    return Point(
      x: center.x + radius * math.cos(angle),
      y: center.y + radius * math.sin(angle),
    );
  }

  /// Проверяет, является ли дуга полной окружностью
  bool get isFullCircle {
    // Проверяем с небольшой погрешностью из-за вычислений с плавающей точкой
    const epsilon = 1e-10;
    return angle >= 2 * math.pi - epsilon;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'Дуга(center: $center, radius: $radius, startAngle: $startAngle, endAngle: $endAngle, color: $color, thickness: $thickness)';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Point>('center', center));
    properties.add(DoubleProperty('radius', radius));
    properties.add(DoubleProperty('startAngle', startAngle));
    properties.add(DoubleProperty('endAngle', endAngle));
    properties.add(StringProperty('color', color));
    properties.add(DoubleProperty('thickness', thickness));
    properties.add(DoubleProperty('angle', angle));
    properties.add(DoubleProperty('length', length));
    properties.add(DoubleProperty('perimeter', perimeter));
    properties.add(DoubleProperty('sectorArea', sectorArea));
    properties.add(DoubleProperty('segmentArea', segmentArea));
    properties.add(DoubleProperty('area', area));
    properties.add(DiagnosticsProperty<Point>('startPoint', startPoint));
    properties.add(DiagnosticsProperty<Point>('endPoint', endPoint));
    properties.add(DiagnosticsProperty<bool>('isFullCircle', isFullCircle));
  }
}
