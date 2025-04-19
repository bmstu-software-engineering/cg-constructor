import 'package:flutter/widgets.dart';

import 'models/models.dart';

abstract interface class Viewer {
  void draw(List<Line> lines, List<Point> points);
  void clean();
  Widget buildWidget();
}

abstract interface class ViewerFactory {
  Viewer create();
}
