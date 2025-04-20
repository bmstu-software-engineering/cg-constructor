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

  // Геттеры для тестирования
  List<Line> get lines => List.unmodifiable(_lines);
  List<Point> get points => List.unmodifiable(_points);
  double get currentScale => _currentScale;
  Offset get currentOffset => _currentOffset;
  Rect? get boundingBox => _boundingBox;

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
                  'canvas_viewer_${_lines.length}_${_points.length}',
                ),
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _CanvasPainter(
                  lines: _lines,
                  points: _points,
                  needsRescale: _needsRescale,
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

  /// Возвращает текущее состояние масштабирования для тестирования
  Map<String, dynamic> getScalingState() {
    return {
      'scale': _currentScale,
      'offset': _currentOffset,
      'boundingBox': _boundingBox,
      'needsRescale': _needsRescale,
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
  }

  @override
  String toStringShort() {
    return 'CanvasViewer(lines: ${_lines.length}, points: ${_points.length})';
  }
}

/// Класс для отрисовки на Canvas
class _CanvasPainter extends CustomPainter {
  final List<Line> lines;
  final List<Point> points;
  final bool needsRescale;
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
        oldDelegate.needsRescale != needsRescale;
  }
}

/// Фабрика для создания экземпляров CanvasViewer
class CanvasViewerFactory implements ViewerFactory {
  @override
  Viewer create() {
    return CanvasViewer();
  }
}
