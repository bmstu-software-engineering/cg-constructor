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
    // Создаем копии точек с установленным цветом
    final points =
        _model.data.points
            .map(
              (point) => Point(
                x: point.x,
                y: point.y,
                color: '#FF0000',
                thickness: 1.0,
              ),
            )
            .toList();

    return ViewerResultModel(points: points, lines: []);
  }
}
