import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:flutter/foundation.dart';
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
  ViewerResultModel calculate() =>
      ViewerResultModel(points: _model.data.points, lines: []);
}
