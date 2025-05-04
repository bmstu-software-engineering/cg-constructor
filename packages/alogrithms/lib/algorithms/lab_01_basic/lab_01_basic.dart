import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:models_data_ns/models_data_ns.dart';

class AlgorithmL01VBasic
    implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01VBasic.fromModel(this._model);

  factory AlgorithmL01VBasic() =>
      AlgorithmL01VBasic.fromModel(PointSetModelImpl());

  final PointSetModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  @override
  ViewerResultModel calculate() {
    final points = _model.data.points;

    // Формируем текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты базового алгоритма

### Количество точек
Всего точек: **${points.length}**

### Координаты точек
${_formatPointsList(points)}
''';

    return ViewerResultModel(
      points: points,
      lines: [],
      markdownInfo: markdownInfo,
    );
  }

  /// Форматирует список точек для отображения в Markdown
  String _formatPointsList(List<Point> points) {
    final buffer = StringBuffer();

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      buffer.writeln('- Точка ${i + 1}: (${point.x}, ${point.y})');
    }

    return buffer.toString();
  }
}
