import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';

/// Класс для выполнения расчётов, связанных с отображением на Canvas
class CanvasCalculator {
  // Параметры масштабирования
  double scale = 1.0;
  double offsetX = 0.0;
  double offsetY = 0.0;

  // Отступы от краев
  final double padding;

  CanvasCalculator(this.padding);

  /// Преобразует строку цвета в объект Color
  Color parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) | 0xFF000000);
    }
    return Colors.black;
  }

  /// Преобразует координаты точки с учетом масштаба и смещения
  Offset transformPoint(Point point, Size size) {
    return Offset(point.x * scale + offsetX, point.y * scale + offsetY);
  }

  /// Рассчитывает масштаб и смещение для оптимального отображения
  void calculateScaleAndOffset(
    Size size,
    List<Line> lines,
    List<Point> points,
  ) {
    // Проверяем, есть ли что отрисовывать
    bool hasContent = lines.isNotEmpty || points.isNotEmpty;

    if (!hasContent) return;

    // Находим минимальные и максимальные координаты
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    // Проверяем точки в линиях
    for (final line in lines) {
      minX = min(minX, min(line.a.x, line.b.x));
      minY = min(minY, min(line.a.y, line.b.y));
      maxX = max(maxX, max(line.a.x, line.b.x));
      maxY = max(maxY, max(line.a.y, line.b.y));
    }

    // Проверяем отдельные точки
    for (final point in points) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }

    _calculateScaleAndOffsetFromBounds(size, minX, minY, maxX, maxY);
  }

  /// Рассчитывает масштаб и смещение для коллекции фигур
  void calculateScaleAndOffsetForCollection(
    Size size,
    FigureCollection collection,
  ) {
    // Проверяем, есть ли что отрисовывать
    bool hasContent =
        collection.points.isNotEmpty ||
        collection.lines.isNotEmpty ||
        collection.triangles.isNotEmpty ||
        collection.rectangles.isNotEmpty ||
        collection.squares.isNotEmpty ||
        collection.circles.isNotEmpty ||
        collection.ellipses.isNotEmpty ||
        collection.arcs.isNotEmpty;

    if (!hasContent) return;

    // Находим минимальные и максимальные координаты
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    // Проверяем точки в линиях
    for (final line in collection.lines) {
      minX = min(minX, min(line.a.x, line.b.x));
      minY = min(minY, min(line.a.y, line.b.y));
      maxX = max(maxX, max(line.a.x, line.b.x));
      maxY = max(maxY, max(line.a.y, line.b.y));
    }

    // Проверяем отдельные точки
    for (final point in collection.points) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }

    // Проверяем треугольники
    for (final triangle in collection.triangles) {
      minX = min(minX, min(min(triangle.a.x, triangle.b.x), triangle.c.x));
      minY = min(minY, min(min(triangle.a.y, triangle.b.y), triangle.c.y));
      maxX = max(maxX, max(max(triangle.a.x, triangle.b.x), triangle.c.x));
      maxY = max(maxY, max(max(triangle.a.y, triangle.b.y), triangle.c.y));
    }

    // Проверяем прямоугольники
    for (final rectangle in collection.rectangles) {
      minX = min(minX, min(rectangle.topLeft.x, rectangle.bottomRight.x));
      minY = min(minY, min(rectangle.topLeft.y, rectangle.bottomRight.y));
      maxX = max(maxX, max(rectangle.topLeft.x, rectangle.bottomRight.x));
      maxY = max(maxY, max(rectangle.topLeft.y, rectangle.bottomRight.y));
    }

    // Проверяем квадраты
    for (final square in collection.squares) {
      final halfSide = square.sideLength / 2;
      minX = min(minX, square.center.x - halfSide);
      minY = min(minY, square.center.y - halfSide);
      maxX = max(maxX, square.center.x + halfSide);
      maxY = max(maxY, square.center.y + halfSide);
    }

    // Проверяем круги
    for (final circle in collection.circles) {
      minX = min(minX, circle.center.x - circle.radius);
      minY = min(minY, circle.center.y - circle.radius);
      maxX = max(maxX, circle.center.x + circle.radius);
      maxY = max(maxY, circle.center.y + circle.radius);
    }

    // Проверяем эллипсы
    for (final ellipse in collection.ellipses) {
      minX = min(minX, ellipse.center.x - ellipse.semiMajorAxis);
      minY = min(minY, ellipse.center.y - ellipse.semiMinorAxis);
      maxX = max(maxX, ellipse.center.x + ellipse.semiMajorAxis);
      maxY = max(maxY, ellipse.center.y + ellipse.semiMinorAxis);
    }

    // Проверяем дуги
    for (final arc in collection.arcs) {
      minX = min(minX, arc.center.x - arc.radius);
      minY = min(minY, arc.center.y - arc.radius);
      maxX = max(maxX, arc.center.x + arc.radius);
      maxY = max(maxY, arc.center.y + arc.radius);
    }

    _calculateScaleAndOffsetFromBounds(size, minX, minY, maxX, maxY);
  }

  /// Вспомогательный метод для расчета масштаба и смещения на основе границ
  void _calculateScaleAndOffsetFromBounds(
    Size size,
    double minX,
    double minY,
    double maxX,
    double maxY,
  ) {
    // Рассчитываем масштаб с учетом отступов
    final width = maxX - minX;
    final height = maxY - minY;

    if (width <= 0 || height <= 0) return;

    final scaleX = (size.width - 2 * padding) / width;
    final scaleY = (size.height - 2 * padding) / height;

    // Выбираем минимальный масштаб, чтобы все поместилось
    scale = min(scaleX, scaleY);

    // Рассчитываем смещение для центрирования
    offsetX = (size.width - width * scale) / 2 - minX * scale;
    offsetY = (size.height - height * scale) / 2 - minY * scale;
  }
}
