import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:rxdart/subjects.dart';
import 'package:viewer/src/canvas_viewer/canvas_painter_with_collection.dart';

import '../viewer_interface.dart';
import 'canvas_calculator.dart';
import 'canvas_painter.dart';

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
  @Deprecated('Не используется в этом виджете')
  Rect? _boundingBox;

  // Флаг, указывающий, нужно ли отображать координаты
  bool _showCoordinates = false;

  // Флаг, указывающий, включен ли режим добавления точек
  bool _pointInputModeEnabled = false;

  // Обработчик для добавленных точек
  void Function(Point point)? _onPointAddedCallback;

  // Поток для отправки добавленных точек
  final StreamController<Point> _pointsStreamController =
      StreamController.broadcast();

  // Отступы от краев
  final double padding;

  // Геттеры для тестирования
  List<Line> get lines => List.unmodifiable(_lines);
  List<Point> get points => List.unmodifiable(_points);
  double get currentScale => _currentScale;
  Offset get currentOffset => _currentOffset;
  Rect? get boundingBox => _boundingBox;
  @override
  bool get showCoordinates => _showCoordinates;

  @override
  bool get pointInputModeEnabled => _pointInputModeEnabled;

  @override
  Stream<Point> get pointsStream => _pointsStreamController.stream;

  // Калькулятор для расчётов
  late final CanvasCalculator _calculator;

  CanvasViewer({this.padding = 40.0, bool useCollection = false})
    : _useCollection = useCollection {
    _calculator = CanvasCalculator(padding);
  }

  @override
  void draw(List<Line> lines, List<Point> points) {
    _collection = _collection.copyWith(lines: lines, points: points);

    _lines = List.from(lines);
    _points = List.from(points);
    _needsRescale = true;
    _updateBoundingBox();
    _draw();
  }

  var _collection = FigureCollection();

  @override
  void drawCollection(FigureCollection collection) {
    _collection = collection;
    // Создаем списки для хранения всех линий и точек
    final allLines = <Line>[];
    final allPoints = <Point>[];

    // Добавляем точки из коллекции
    allPoints.addAll(collection.points);

    // Добавляем линии из коллекции
    allLines.addAll(collection.lines);

    // Преобразуем треугольники в линии
    for (final triangle in collection.triangles) {
      allLines.add(
        Line(
          a: triangle.a,
          b: triangle.b,
          color: triangle.color,
          thickness: triangle.thickness,
        ),
      );
      allLines.add(
        Line(
          a: triangle.b,
          b: triangle.c,
          color: triangle.color,
          thickness: triangle.thickness,
        ),
      );
      allLines.add(
        Line(
          a: triangle.c,
          b: triangle.a,
          color: triangle.color,
          thickness: triangle.thickness,
        ),
      );
    }

    // Преобразуем прямоугольники в линии
    for (final rectangle in collection.rectangles) {
      allLines.add(
        Line(
          a: rectangle.topLeft,
          b: rectangle.topRight,
          color: rectangle.color,
          thickness: rectangle.thickness,
        ),
      );
      allLines.add(
        Line(
          a: rectangle.topRight,
          b: rectangle.bottomRight,
          color: rectangle.color,
          thickness: rectangle.thickness,
        ),
      );
      allLines.add(
        Line(
          a: rectangle.bottomRight,
          b: rectangle.bottomLeft,
          color: rectangle.color,
          thickness: rectangle.thickness,
        ),
      );
      allLines.add(
        Line(
          a: rectangle.bottomLeft,
          b: rectangle.topLeft,
          color: rectangle.color,
          thickness: rectangle.thickness,
        ),
      );
    }

    // Преобразуем квадраты в линии
    for (final square in collection.squares) {
      final points = square.points;
      allLines.add(
        Line(
          a: points[0],
          b: points[1],
          color: square.color,
          thickness: square.thickness,
        ),
      );
      allLines.add(
        Line(
          a: points[1],
          b: points[2],
          color: square.color,
          thickness: square.thickness,
        ),
      );
      allLines.add(
        Line(
          a: points[2],
          b: points[3],
          color: square.color,
          thickness: square.thickness,
        ),
      );
      allLines.add(
        Line(
          a: points[3],
          b: points[0],
          color: square.color,
          thickness: square.thickness,
        ),
      );
    }

    // Преобразуем круги в набор линий (аппроксимация)
    for (final circle in collection.circles) {
      _approximateCircle(circle, allLines);
    }

    // Преобразуем эллипсы в набор линий (аппроксимация)
    for (final ellipse in collection.ellipses) {
      _approximateEllipse(ellipse, allLines);
    }

    // Преобразуем дуги в набор линий (аппроксимация)
    for (final arc in collection.arcs) {
      _approximateArc(arc, allLines);
    }

    // Отрисовываем все линии и точки
    draw(allLines, allPoints);
  }

  /// Аппроксимирует круг набором линий
  void _approximateCircle(Circle circle, List<Line> lines) {
    const segments = 36; // Количество сегментов для аппроксимации
    final angleStep = 2 * pi / segments;

    for (int i = 0; i < segments; i++) {
      final angle1 = i * angleStep;
      final angle2 = (i + 1) * angleStep;

      final p1 = Point(
        x: circle.center.x + circle.radius * cos(angle1),
        y: circle.center.y + circle.radius * sin(angle1),
      );

      final p2 = Point(
        x: circle.center.x + circle.radius * cos(angle2),
        y: circle.center.y + circle.radius * sin(angle2),
      );

      lines.add(
        Line(a: p1, b: p2, color: circle.color, thickness: circle.thickness),
      );
    }
  }

  /// Аппроксимирует эллипс набором линий
  void _approximateEllipse(Ellipse ellipse, List<Line> lines) {
    const segments = 36; // Количество сегментов для аппроксимации
    final angleStep = 2 * pi / segments;

    for (int i = 0; i < segments; i++) {
      final angle1 = i * angleStep;
      final angle2 = (i + 1) * angleStep;

      final p1 = Point(
        x: ellipse.center.x + ellipse.semiMajorAxis * cos(angle1),
        y: ellipse.center.y + ellipse.semiMinorAxis * sin(angle1),
      );

      final p2 = Point(
        x: ellipse.center.x + ellipse.semiMajorAxis * cos(angle2),
        y: ellipse.center.y + ellipse.semiMinorAxis * sin(angle2),
      );

      lines.add(
        Line(a: p1, b: p2, color: ellipse.color, thickness: ellipse.thickness),
      );
    }
  }

  /// Аппроксимирует дугу набором линий
  void _approximateArc(Arc arc, List<Line> lines) {
    const segmentsPerFullCircle =
        36; // Количество сегментов для полной окружности

    // Нормализуем углы в диапазоне [0, 2π]
    final startAngle = arc.startAngle % (2 * pi);
    final endAngle = arc.endAngle % (2 * pi);

    // Вычисляем угол дуги
    var arcAngle = endAngle - startAngle;
    if (arcAngle < 0) arcAngle += 2 * pi;

    // Вычисляем количество сегментов для дуги
    final segments = max(
      1,
      (segmentsPerFullCircle * arcAngle / (2 * pi)).round(),
    );
    final angleStep = arcAngle / segments;

    for (int i = 0; i < segments; i++) {
      final angle1 = startAngle + i * angleStep;
      final angle2 = startAngle + (i + 1) * angleStep;

      final p1 = Point(
        x: arc.center.x + arc.radius * cos(angle1),
        y: arc.center.y + arc.radius * sin(angle1),
      );

      final p2 = Point(
        x: arc.center.x + arc.radius * cos(angle2),
        y: arc.center.y + arc.radius * sin(angle2),
      );

      lines.add(Line(a: p1, b: p2, color: arc.color, thickness: arc.thickness));
    }
  }

  final _updateStream = BehaviorSubject.seeded(null);
  final bool _useCollection;

  void _draw() => _updateStream.add(null);

  @override
  void clean() {
    _collection = FigureCollection();
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
  }

  @override
  void setPointInputMode(bool enabled) {
    if (_pointInputModeEnabled != enabled) {
      _pointInputModeEnabled = enabled;
      _draw();
      // Обновляем ключ CustomPaint
      _updateStream.add(null);
    }
  }

  @override
  void setOnPointAddedCallback(void Function(Point point)? onPointAdded) {
    _onPointAddedCallback = onPointAdded;
  }

  /// Добавляет точку по координатам экрана
  void _addPoint(double screenX, double screenY) {
    if (!_pointInputModeEnabled) return;

    // Преобразуем координаты экрана в координаты модели
    final modelCoordinates = _convertToModelCoordinates(screenX, screenY);

    // Создаем новую точку
    final point = Point(
      x: modelCoordinates.dx,
      y: modelCoordinates.dy,
      color: '#000000', // Можно сделать настраиваемым
      thickness: 5.0, // Можно сделать настраиваемым
    );

    _collection = _collection.copyWith(points: [..._collection.points, point]);
    // Добавляем точку к существующим
    _points = [..._points, point];

    // Обновляем ограничивающий прямоугольник и перерисовываем
    _updateBoundingBox();
    _draw();

    // Вызываем обработчик, если он установлен
    _onPointAddedCallback?.call(point);

    // Отправляем точку в поток
    _pointsStreamController.add(point);
  }

  /// Преобразует координаты экрана в координаты модели
  Offset _convertToModelCoordinates(double screenX, double screenY) {
    // Обновляем значения калькулятора текущими значениями масштаба и смещения
    _calculator.scale = _currentScale;
    _calculator.offsetX = _currentOffset.dx;
    _calculator.offsetY = _currentOffset.dy;

    // Обратное преобразование с учетом масштаба и смещения
    final modelX = (screenX - _calculator.offsetX) / _calculator.scale;
    final modelY = (screenY - _calculator.offsetY) / _calculator.scale;
    return Offset(modelX, modelY);
  }

  /// Обновляет ограничивающий прямоугольник на основе текущих точек и линий
  void _updateBoundingBox() {
    if (_lines.isEmpty && _points.isEmpty) {
      _boundingBox = null;
      return;
    }

    // Используем калькулятор для расчета ограничивающего прямоугольника
    // Создаем временный размер для вызова метода калькулятора
    final tempSize = Size(800, 600); // Размер не важен для расчета boundingBox

    // Вызываем метод калькулятора для расчета ограничивающего прямоугольника
    if (_useCollection) {
      _calculator.calculateScaleAndOffsetForCollection(tempSize, _collection);
    } else {
      _calculator.calculateScaleAndOffset(tempSize, _lines, _points);
    }

    // Получаем минимальные и максимальные координаты из результатов расчета
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
              child: GestureDetector(
                onTapDown:
                    _pointInputModeEnabled
                        ? (details) {
                          _addPoint(
                            details.localPosition.dx,
                            details.localPosition.dy,
                          );
                        }
                        : null,
                child: CustomPaint(
                  key: ValueKey(
                    'canvas_viewer_${_lines.length}_${_points.length}_${_showCoordinates ? 'with_coords' : 'no_coords'}_${_pointInputModeEnabled ? 'input_mode' : 'view_mode'}',
                  ),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _buildPainter(),
                ),
              ),
            );
          },
        ),
  );

  CustomPainter _buildPainter() =>
      _useCollection
          ? CanvasPainterWithCollection(
            padding,
            collection: _collection,
            needsRescale: _needsRescale,
            showCoordinates: _showCoordinates,
            onRescaled: (scale, offset) {
              _currentScale = scale;
              _currentOffset = offset;
              // НИКОГДА НЕ ИЗМЕНЯЙ ЭТО ЗНАЧЕНИЕ
              // ТУТ ТОЧНО ДОЛЖЕН БЫТЬ true
              _needsRescale = true;
            },
          )
          : CanvasPainter(
            padding,
            lines: _lines,
            points: _points,
            needsRescale: _needsRescale,
            showCoordinates: _showCoordinates,
            onRescaled: (scale, offset) {
              _currentScale = scale;
              _currentOffset = offset;
              // НИКОГДА НЕ ИЗМЕНЯЙ ЭТО ЗНАЧЕНИЕ
              // ТУТ ТОЧНО ДОЛЖЕН БЫТЬ true
              _needsRescale = true;
            },
          );

  /// Возвращает текущее состояние масштабирования и отображения для тестирования
  Map<String, dynamic> getScalingState() {
    return {
      'scale': _currentScale,
      'offset': _currentOffset,
      'boundingBox': _boundingBox,
      'needsRescale': _needsRescale,
      'showCoordinates': _showCoordinates,
      'pointInputModeEnabled': _pointInputModeEnabled,
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
      DiagnosticsProperty<bool>(
        'pointInputModeEnabled',
        _pointInputModeEnabled,
      ),
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
    properties.add(
      FlagProperty(
        'pointInputModeEnabled',
        value: _pointInputModeEnabled,
        ifTrue: 'point input enabled',
        ifFalse: 'point input disabled',
      ),
    );
  }

  @override
  String toStringShort() {
    return 'CanvasViewer(lines: ${_lines.length}, points: ${_points.length}, showCoordinates: $_showCoordinates, pointInputMode: $_pointInputModeEnabled)';
  }
}

/// Фабрика для создания экземпляров CanvasViewer
class CanvasViewerFactory implements ViewerFactory {
  final bool useCollection;
  final double padding;
  final bool pointInputModeEnabled;
  final void Function(Point point)? onPointAdded;

  const CanvasViewerFactory({
    this.padding = 40.0,
    this.pointInputModeEnabled = false,
    this.onPointAdded,
    this.useCollection = false,
  });

  @override
  Viewer create({
    bool showCoordinates = false,
    bool pointInputModeEnabled = false,
    void Function(Point point)? onPointAdded,
  }) {
    final viewer = CanvasViewer(padding: padding, useCollection: useCollection);

    // Применяем настройки из параметров конструктора, если не переопределены
    final usePointInputMode =
        pointInputModeEnabled || this.pointInputModeEnabled;
    final useOnPointAdded = onPointAdded ?? this.onPointAdded;

    if (showCoordinates) {
      viewer.setShowCoordinates(true);
    }

    if (usePointInputMode) {
      viewer.setPointInputMode(true);
    }

    if (useOnPointAdded != null) {
      viewer.setOnPointAddedCallback(useOnPointAdded);
    }

    return viewer;
  }
}
