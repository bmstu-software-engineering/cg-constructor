import 'package:flutter/widgets.dart';
import 'package:models_ns/models_ns.dart';

abstract interface class Viewer {
  void draw(List<Line> lines, List<Point> points);
  void clean();
  Widget buildWidget();
}

abstract interface class ViewerFactory {
  Viewer create();
}
