import 'package:flutter/widgets.dart';
import 'package:models_ns/models_ns.dart';

abstract interface class Viewer {
  void draw(List<Line> lines, List<Point> points);
  void clean();
  Widget buildWidget();

  /// Устанавливает режим отображения координат точек
  ///
  /// Если [show] равно true, то координаты точек и концов линий будут отображаться
  void setShowCoordinates(bool show);

  /// Возвращает текущее состояние отображения координат
  bool get showCoordinates;
}

abstract interface class ViewerFactory {
  /// Создает экземпляр Viewer
  ///
  /// Если [showCoordinates] равно true, то координаты точек и концов линий будут отображаться
  Viewer create({bool showCoordinates = false});
}
