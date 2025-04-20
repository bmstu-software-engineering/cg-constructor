import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';

import 'viewer_interface.dart';

/// Реализация Viewer с использованием Canvas для отрисовки
class CanvasViewer with DiagnosticableTreeMixin implements Viewer {
  // Данные для отрисовки
  List<Line> _lines = [];
  List<Point> _points = [];

  // Флаг, указывающий, нужно ли пересчитывать масштаб
  bool _needsRescale = true;

  // Информация о текущем масштабе и смещении
  double _currentScale = 1.0;
  Offset _currentOffset = Offset.zero;

  // Ограничивающий прямоугольник для всех точек и линий
  Rect? _boundingBox;

  // Флаг, указывающий, нужно ли отображать координаты
  bool _showCoordinates = false;

  // Геттеры для тестирования
  List<Line> get lines => List.unmodifiable(_lines);
  List<Point> get points => List.unmodifiable(_points);
  double get currentScale => _currentScale;
  Offset get currentOffset => _currentOffset;
  Rect? get boundingBox => _boundingBox;
  bool get showCoordinates => _showCoordinates;

  @override
  void draw(List<Line> lines, List<Point> points) {
    _lines = List.from(lines);
    _points = List.from(points);
    _needsRescale = true;
    _updateBoundingBox();
    _draw();
  }

  final _updateStream = StreamController.broadcast();
  void _draw() => _updateStream.add(null);

  @override
  void clean() {
    _lines = [];
    _points = [];
    _boundingBox = null;
    _needsRescale = true;
    _draw();
  }

  @override
  void setShowCoordinates(bool show) {
    if (_showCoordinates != show) {
      _showCoordinates = show;
      _draw();
      // Обновляем ключ CustomPaint
      _updateStream.add(null);
    }
    if (_showCoordinates != show) {
      _showCoordinates = show;
      _draw();
      // Обновляем ключ CustomPaint
      _updateStream.add(null);
    }
  }

  /// Обновляет ограничивающий прямоугольник на основе текущих точек и линий
  void _updateBoundingBox() {
    if (_lines.isEmpty && _points.isEmpty) {
      _boundingBox = null;
      return;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    // Проверяем точки в линиях
    for (final line in _lines) {
      minX = min(minX, min(line.a.x, line.b.x));
      minY = min(minY, min(line.a.y, line.b.y));
      maxX = max(maxX, max(line.a.x, line.b.x));
      maxY = max(maxY, max(line.a.y, line.b.y));
    }

    // Проверяем отдельные точки
    for (final point in _points) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }

    _boundingBox = Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  Widget buildWidget() => LayoutBuilder(
    builder:
        (context, constraints) => StreamBuilder(
          stream: _updateStream.stream,
          builder: (context, snapshot) {
            return Semantics(
              label:
                  'Canvas with ${_lines.length} lines and ${_points.length} points',
              value: 'Scale: $_currentScale',
              child: CustomPaint(
                key: ValueKey(
                  'canvas_viewer_${_lines.length}_${_points.length}_${_showCoordinates ? 'with_coords' : 'no_coords'}',
                ),
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _CanvasPainter(
                  lines: _lines,
                  points: _points,
                  needsRescale: _needsRescale,
                  showCoordinates: _showCoordinates,
                  onRescaled: (scale, offset) {
                    _currentScale = scale;
                    _currentOffset = offset;
                    _needsRescale = true;
                  },
                ),
              ),
            );
          },
        ),
  );

  /// Возвращает текущее состояние масштабирования и отображения для тестирования
  Map<String, dynamic> getScalingState() {
    return {
      'scale': _currentScale,
      'offset': _currentOffset,
      'boundingBox': _boundingBox,
      'needsRescale': _needsRescale,
      'showCoordinates': _showCoordinates,
    };
  }

  // Реализация методов DiagnosticableTree для улучшения тестирования
  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return [
      if (_boundingBox != null)
        DiagnosticsProperty<Rect>('boundingBox', _boundingBox!),
      DiagnosticsProperty<double>('scale', _currentScale),
      DiagnosticsProperty<Offset>('offset', _currentOffset),
      DiagnosticsProperty<int>('lineCount', _lines.length),
      DiagnosticsProperty<int>('pointCount', _points.length),
      DiagnosticsProperty<bool>('showCoordinates', _showCoordinates),
    ];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>('scale', _currentScale));
    properties.add(DiagnosticsProperty<Offset>('offset', _currentOffset));
    properties.add(DiagnosticsProperty<int>('lineCount', _lines.length));
    properties.add(DiagnosticsProperty<int>('pointCount', _points.length));
    properties.add(DiagnosticsProperty<Rect?>('boundingBox', _boundingBox));
    properties.add(
      FlagProperty(
        'needsRescale',
        value: _needsRescale,
        ifTrue: 'pending rescale',
        ifFalse: 'scale applied',
      ),
    );
    properties.add(
      FlagProperty(
        'showCoordinates',
        value: _showCoordinates,
        ifTrue: 'coordinates visible',
        ifFalse: 'coordinates hidden',
      ),
    );
  }

  @override
  String toStringShort() {
    return 'CanvasViewer(lines: ${_lines.length}, points: ${_points.length}, showCoordinates: $_showCoordinates)';
  }
}

/// Класс для отрисовки на Canvas
class _CanvasPainter extends CustomPainter {
  final List<Line> lines;
  final List<Point> points;
  final bool needsRescale;
  final bool showCoordinates;
  final Function(double scale, Offset offset) onRescaled;

  // Параметры масштабирования
  double _scale = 1.0;
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  // Отступы от краев
  static const double _padding = 20.0;

  _CanvasPainter({
    required this.lines,
    required this.points,
    required this.needsRescale,
    required this.onRescaled,
    this.showCoordinates = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty && points.isEmpty) return;

    if (needsRescale) {
      _calculateScaleAndOffset(size);
      onRescaled(_scale, Offset(_offsetX, _offsetY));
    }

    // Отрисовка линий
    for (final line in lines) {
      final paint =
          Paint()
            ..color = _parseColor(line.color)
            ..strokeWidth = line.thickness
            ..style = PaintingStyle.stroke;

      final p1 = _transformPoint(line.a, size);
      final p2 = _transformPoint(line.b, size);

      canvas.drawLine(p1, p2, paint);
    }

    // Отрисовка точек
    for (final point in points) {
      final paint =
          Paint()
            ..color = _parseColor(point.color)
            ..strokeWidth = point.thickness
            ..style = PaintingStyle.fill;

      final p = _transformPoint(point, size);

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
    final fontSize = max(10.0, min(14.0, _scale * 3));

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
      final p = _transformPoint(point, size);
      final text =
          '(${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)})';

      _drawCoordinateText(canvas, p, text, textStyle, bgPaint, borderPaint);
    }

    // Отрисовка координат для начала и конца линий
    final processedPoints = <String>{};

    for (final line in lines) {
      // Для начала линии
      final p1 = _transformPoint(line.a, size);
      final key1 = '${line.a.x},${line.a.y}';

      if (!processedPoints.contains(key1)) {
        final text1 =
            '(${line.a.x.toStringAsFixed(1)}, ${line.a.y.toStringAsFixed(1)})';
        _drawCoordinateText(canvas, p1, text1, textStyle, bgPaint, borderPaint);
        processedPoints.add(key1);
      }

      // Для конца линии
      final p2 = _transformPoint(line.b, size);
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
    if (_scale < 0.5) {
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

  /// Преобразует строку цвета в объект Color
  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) | 0xFF000000);
    }
    return Colors.black;
  }

  /// Преобразует координаты точки с учетом масштаба и смещения
  Offset _transformPoint(Point point, Size size) {
    return Offset(point.x * _scale + _offsetX, point.y * _scale + _offsetY);
  }

  /// Рассчитывает масштаб и смещение для оптимального отображения
  void _calculateScaleAndOffset(Size size) {
    if (lines.isEmpty && points.isEmpty) return;

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

    // Рассчитываем масштаб с учетом отступов
    final width = maxX - minX;
    final height = maxY - minY;

    if (width <= 0 || height <= 0) return;

    final scaleX = (size.width - 2 * _padding) / width;
    final scaleY = (size.height - 2 * _padding) / height;

    // Выбираем минимальный масштаб, чтобы все поместилось
    _scale = min(scaleX, scaleY);

    // Рассчитываем смещение для центрирования
    _offsetX = (size.width - width * _scale) / 2 - minX * _scale;
    _offsetY = (size.height - height * _scale) / 2 - minY * _scale;
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.points != points ||
        oldDelegate.needsRescale != needsRescale ||
        oldDelegate.showCoordinates != showCoordinates;
  }
}

/// Фабрика для создания экземпляров CanvasViewer
class CanvasViewerFactory implements ViewerFactory {
  const CanvasViewerFactory();

  @override
  Viewer create({bool showCoordinates = false}) {
    final viewer = CanvasViewer();
    if (showCoordinates) {
      viewer.setShowCoordinates(true);
    }
    return viewer;
  }
}
