import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';

import 'canvas_calculator.dart';

/// Класс для отрисовки на Canvas с использованием FigureCollection
class CanvasPainterWithCollection extends CustomPainter {
  final FigureCollection collection;
  final bool needsRescale;
  final bool showCoordinates;
  final Function(double scale, Offset offset) onRescaled;

  // Отступы от краев
  final double _padding;

  // Калькулятор для расчётов
  late final CanvasCalculator _calculator;

  CanvasPainterWithCollection(
    this._padding, {
    required this.collection,
    required this.needsRescale,
    required this.onRescaled,
    this.showCoordinates = false,
  }) {
    _calculator = CanvasCalculator(_padding);
  }

  @override
  void paint(Canvas canvas, Size size) {
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

    if (needsRescale) {
      _calculator.calculateScaleAndOffsetForCollection(size, collection);
      onRescaled(
        _calculator.scale,
        Offset(_calculator.offsetX, _calculator.offsetY),
      );
    }

    // Отрисовка линий
    for (final line in collection.lines) {
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
    for (final point in collection.points) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(point.color)
            ..strokeWidth = point.thickness
            ..style = PaintingStyle.fill;

      final p = _calculator.transformPoint(point, size);

      canvas.drawCircle(p, point.thickness * 2, paint);
    }

    // Отрисовка треугольников
    for (final triangle in collection.triangles) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(triangle.color)
            ..strokeWidth = triangle.thickness
            ..style = PaintingStyle.stroke;

      final p1 = _calculator.transformPoint(triangle.a, size);
      final p2 = _calculator.transformPoint(triangle.b, size);
      final p3 = _calculator.transformPoint(triangle.c, size);

      final path =
          Path()
            ..moveTo(p1.dx, p1.dy)
            ..lineTo(p2.dx, p2.dy)
            ..lineTo(p3.dx, p3.dy)
            ..close();

      canvas.drawPath(path, paint);
    }

    // Отрисовка прямоугольников
    for (final rectangle in collection.rectangles) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(rectangle.color)
            ..strokeWidth = rectangle.thickness
            ..style = PaintingStyle.stroke;

      final topLeft = _calculator.transformPoint(rectangle.topLeft, size);
      final bottomRight = _calculator.transformPoint(
        rectangle.bottomRight,
        size,
      );

      final rect = Rect.fromPoints(topLeft, bottomRight);
      canvas.drawRect(rect, paint);
    }

    // Отрисовка квадратов
    for (final square in collection.squares) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(square.color)
            ..strokeWidth = square.thickness
            ..style = PaintingStyle.stroke;

      final center = _calculator.transformPoint(square.center, size);
      final sideLength = square.sideLength * _calculator.scale;

      final rect = Rect.fromCenter(
        center: center,
        width: sideLength,
        height: sideLength,
      );
      canvas.drawRect(rect, paint);
    }

    // Отрисовка кругов
    for (final circle in collection.circles) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(circle.color)
            ..strokeWidth = circle.thickness
            ..style = PaintingStyle.stroke;

      final center = _calculator.transformPoint(circle.center, size);
      final radius = circle.radius * _calculator.scale;

      canvas.drawCircle(center, radius, paint);
    }

    // Отрисовка эллипсов
    for (final ellipse in collection.ellipses) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(ellipse.color)
            ..strokeWidth = ellipse.thickness
            ..style = PaintingStyle.stroke;

      final center = _calculator.transformPoint(ellipse.center, size);
      final semiMajorAxis = ellipse.semiMajorAxis * _calculator.scale;
      final semiMinorAxis = ellipse.semiMinorAxis * _calculator.scale;

      final rect = Rect.fromCenter(
        center: center,
        width: semiMajorAxis * 2,
        height: semiMinorAxis * 2,
      );

      canvas.drawOval(rect, paint);
    }

    // Отрисовка дуг
    for (final arc in collection.arcs) {
      final paint =
          Paint()
            ..color = _calculator.parseColor(arc.color)
            ..strokeWidth = arc.thickness
            ..style = PaintingStyle.stroke;

      final center = _calculator.transformPoint(arc.center, size);
      final radius = arc.radius * _calculator.scale;

      // Преобразуем углы из градусов в радианы
      final startAngle = arc.startAngle * (3.14159265359 / 180);
      final endAngle = arc.endAngle * (3.14159265359 / 180);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
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

    // Множество для отслеживания уже отрисованных координат
    final processedPoints = <String>{};

    // Отрисовка координат для точек
    for (final point in collection.points) {
      final p = _calculator.transformPoint(point, size);
      final key = '${point.x},${point.y}';

      if (!processedPoints.contains(key)) {
        final text =
            '(${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, p, text, textStyle, bgPaint, borderPaint);
        processedPoints.add(key);
      }
    }

    // Отрисовка координат для начала и конца линий
    for (final line in collection.lines) {
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

    // Отрисовка координат для вершин треугольников
    for (final triangle in collection.triangles) {
      // Вершина A
      final pA = _calculator.transformPoint(triangle.a, size);
      final keyA = '${triangle.a.x},${triangle.a.y}';

      if (!processedPoints.contains(keyA)) {
        final textA =
            '(${triangle.a.x.toStringAsFixed(1)}, ${triangle.a.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, pA, textA, textStyle, bgPaint, borderPaint);
        processedPoints.add(keyA);
      }

      // Вершина B
      final pB = _calculator.transformPoint(triangle.b, size);
      final keyB = '${triangle.b.x},${triangle.b.y}';

      if (!processedPoints.contains(keyB)) {
        final textB =
            '(${triangle.b.x.toStringAsFixed(1)}, ${triangle.b.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, pB, textB, textStyle, bgPaint, borderPaint);
        processedPoints.add(keyB);
      }

      // Вершина C
      final pC = _calculator.transformPoint(triangle.c, size);
      final keyC = '${triangle.c.x},${triangle.c.y}';

      if (!processedPoints.contains(keyC)) {
        final textC =
            '(${triangle.c.x.toStringAsFixed(1)}, ${triangle.c.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, pC, textC, textStyle, bgPaint, borderPaint);
        processedPoints.add(keyC);
      }
    }

    // Отрисовка координат для углов прямоугольников
    for (final rectangle in collection.rectangles) {
      // Верхний левый угол
      final topLeft = _calculator.transformPoint(rectangle.topLeft, size);
      final keyTL = '${rectangle.topLeft.x},${rectangle.topLeft.y}';

      if (!processedPoints.contains(keyTL)) {
        final textTL =
            '(${rectangle.topLeft.x.toStringAsFixed(1)}, ${rectangle.topLeft.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          topLeft,
          textTL,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyTL);
      }

      // Нижний правый угол
      final bottomRight = _calculator.transformPoint(
        rectangle.bottomRight,
        size,
      );
      final keyBR = '${rectangle.bottomRight.x},${rectangle.bottomRight.y}';

      if (!processedPoints.contains(keyBR)) {
        final textBR =
            '(${rectangle.bottomRight.x.toStringAsFixed(1)}, ${rectangle.bottomRight.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          bottomRight,
          textBR,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyBR);
      }
    }

    // Отрисовка координат для центров квадратов
    for (final square in collection.squares) {
      final center = _calculator.transformPoint(square.center, size);
      final keyCenter = '${square.center.x},${square.center.y}';

      if (!processedPoints.contains(keyCenter)) {
        final textCenter =
            '(${square.center.x.toStringAsFixed(1)}, ${square.center.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          center,
          textCenter,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyCenter);
      }
    }

    // Отрисовка координат для центров кругов
    for (final circle in collection.circles) {
      final center = _calculator.transformPoint(circle.center, size);
      final keyCenter = '${circle.center.x},${circle.center.y}';

      if (!processedPoints.contains(keyCenter)) {
        final textCenter =
            '(${circle.center.x.toStringAsFixed(1)}, ${circle.center.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          center,
          textCenter,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyCenter);
      }
    }

    // Отрисовка координат для центров эллипсов
    for (final ellipse in collection.ellipses) {
      final center = _calculator.transformPoint(ellipse.center, size);
      final keyCenter = '${ellipse.center.x},${ellipse.center.y}';

      if (!processedPoints.contains(keyCenter)) {
        final textCenter =
            '(${ellipse.center.x.toStringAsFixed(1)}, ${ellipse.center.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          center,
          textCenter,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyCenter);
      }
    }

    // Отрисовка координат для центров дуг
    for (final arc in collection.arcs) {
      final center = _calculator.transformPoint(arc.center, size);
      final keyCenter = '${arc.center.x},${arc.center.y}';

      if (!processedPoints.contains(keyCenter)) {
        final textCenter =
            '(${arc.center.x.toStringAsFixed(1)}, ${arc.center.y.toStringAsFixed(1)})';
        _drawCoordinateText(
          canvas,
          center,
          textCenter,
          textStyle,
          bgPaint,
          borderPaint,
        );
        processedPoints.add(keyCenter);
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
  bool shouldRepaint(covariant CanvasPainterWithCollection oldDelegate) {
    return oldDelegate.collection != collection ||
        oldDelegate.needsRescale != needsRescale ||
        oldDelegate.showCoordinates != showCoordinates;
  }
}
