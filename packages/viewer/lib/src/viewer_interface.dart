import 'package:flutter/widgets.dart';
import 'package:models_ns/models_ns.dart';

abstract interface class Viewer {
  void draw(List<Line> lines, List<Point> points);
  void drawCollection(FigureCollection points);
  void clean();
  Widget buildWidget();

  /// Устанавливает режим отображения координат точек
  ///
  /// Если [show] равно true, то координаты точек и концов линий будут отображаться
  void setShowCoordinates(bool show);

  /// Возвращает текущее состояние отображения координат
  bool get showCoordinates;

  /// Устанавливает режим добавления точек по нажатию
  ///
  /// Если [enabled] равно true, то при нажатии на поверхность будут добавляться точки
  void setPointInputMode(bool enabled);

  /// Возвращает текущее состояние режима добавления точек
  bool get pointInputModeEnabled;

  /// Устанавливает обработчик для добавленных точек
  ///
  /// [onPointAdded] будет вызываться при добавлении новой точки
  void setOnPointAddedCallback(void Function(Point point)? onPointAdded);

  /// Возвращает поток добавленных точек
  ///
  /// Этот поток можно использовать для получения добавленных точек
  Stream<Point> get pointsStream;
}

abstract interface class ViewerFactory {
  /// Создает экземпляр Viewer
  ///
  /// Если [showCoordinates] равно true, то координаты точек и концов линий будут отображаться
  /// Если [pointInputModeEnabled] равно true, то будет включен режим добавления точек по нажатию
  /// [onPointAdded] - обработчик, который будет вызываться при добавлении новой точки
  Viewer create({
    bool showCoordinates = false,
    bool pointInputModeEnabled = false,
    void Function(Point point)? onPointAdded,
  });
}
