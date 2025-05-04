import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';

import 'canvas_calculator.dart';

/// Класс для отрисовки на Canvas
class CanvasPainter extends CustomPainter {
  final List<Line> lines;
  final List<Point> points;
  final bool needsRescale;
  final bool showCoordinates;
  final Function(double scale, Offset offset) onRescaled;

  // Отступы от краев
  final double _padding;

  // Калькулятор для расчётов
  late final CanvasCalculator _calculator;

  CanvasPainter(
    this._padding, {
    required this.lines,
    required this.points,
    required this.needsRescale,
    required this.onRescaled,
    this.showCoordinates = false,
  }) {
    _calculator = CanvasCalculator(_padding);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Проверяем, есть ли что отрисовывать
    bool hasContent = lines.isNotEmpty || points.isNotEmpty;

    if (!hasContent) return;

    if (needsRescale) {
      _calculator.calculateScaleAndOffset(size, lines, points);
      onRescaled(
        _calculator.scale,
        Offset(_calculator.offsetX, _calculator.offsetY),
      );
    }

    // Отрисовка линий
    for (final line in lines) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(line.color)
            ..strokeWidth = line.thickness
            ..style = PaintingStyle.stroke;

      final p1 = _calculator.transformPoint(line.a, size);
      final p2 = _calculator.transformPoint(line.b, size);

      canvas.drawLine(p1, p2, paint);
    }

    // Отрисовка точек
    for (final point in points) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(point.color)
            ..strokeWidth = point.thickness
            ..style = PaintingStyle.fill;

      final p = _calculator.transformPoint(point, size);

      canvas.drawCircle(p, point.thickness * 2, paint);
    }

    // Отрисовка координат, если включено
    if (showCoordinates) {
      _drawCoordinates(canvas, size);
    }
  }

  /// Отрисовывает координаты точек и концов линий
  void _drawCoordinates(Canvas canvas, Size size) {
    // Определяем размер текста в зависимости от масштаба
    final fontSize = max(10.0, min(14.0, _calculator.scale * 3));

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    final bgPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Отрисовка координат для точек
    for (final point in points) {
      final p = _calculator.transformPoint(point, size);
      final text =
          '(${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)})';

      _drawCoordinateText(canvas, p, text, textStyle, bgPaint, borderPaint);
    }

    // Отрисовка координат для начала и конца линий
    final processedPoints = <String>{};

    for (final line in lines) {
      // Для начала линии
      final p1 = _calculator.transformPoint(line.a, size);
      final key1 = '${line.a.x},${line.a.y}';

      if (!processedPoints.contains(key1)) {
        final text1 =
            '(${line.a.x.toStringAsFixed(1)}, ${line.a.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, p1, text1, textStyle, bgPaint, borderPaint);
        processedPoints.add(key1);
      }

      // Для конца линии
      final p2 = _calculator.transformPoint(line.b, size);
      final key2 = '${line.b.x},${line.b.y}';

      if (!processedPoints.contains(key2)) {
        final text2 =
            '(${line.b.x.toStringAsFixed(1)}, ${line.b.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, p2, text2, textStyle, bgPaint, borderPaint);
        processedPoints.add(key2);
      }
    }
  }

  /// Отрисовывает текст с координатами рядом с точкой
  void _drawCoordinateText(
    Canvas canvas,
    Offset point,
    String text,
    TextStyle textStyle,
    Paint bgPaint,
    Paint borderPaint,
  ) {
    // Создаем текстовый спан
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Рассчитываем позицию для текста
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // Смещение текста от точки
    final offsetX = 10.0;
    final offsetY = -textHeight / 2;

    final bgRect = Rect.fromLTWH(
      point.dx + offsetX,
      point.dy + offsetY,
      textWidth + 6,
      textHeight + 4,
    );

    // Если масштаб слишком мал, рисуем линию от точки к тексту
    if (_calculator.scale < 0.5) {
      canvas.drawLine(
        point,
        Offset(bgRect.left, bgRect.center.dy),
        borderPaint,
      );
    }

    // Рисуем фон для текста
    final bgRRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(4));
    canvas.drawRRect(bgRRect, bgPaint);
    canvas.drawRRect(bgRRect, borderPaint);

    // Рисуем текст
    textPainter.paint(canvas, Offset(bgRect.left + 3, bgRect.top + 2));
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.points != points ||
        oldDelegate.needsRescale != needsRescale ||
        oldDelegate.showCoordinates != showCoordinates;
  }
}
