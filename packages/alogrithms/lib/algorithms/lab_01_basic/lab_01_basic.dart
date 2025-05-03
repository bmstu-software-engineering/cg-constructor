import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:models_ns/models_ns.dart';
import 'lab_01_basic_data_model.dart';

class AlgorithmL01VBasic
    implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01VBasic.fromModel(this._model);

  factory AlgorithmL01VBasic() =>
      AlgorithmL01VBasic.fromModel(AlgorithmL01VBasicDataModelImpl());

  final AlgorithmL01VBasicDataModelImpl _model;

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
