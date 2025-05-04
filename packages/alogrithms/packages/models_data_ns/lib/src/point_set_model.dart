import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:forms_annotations/forms_annotations.dart';

part 'point_set_model.g.dart';

/// Обобщенная модель данных для алгоритмов, работающих с одним набором точек
@FormGen()
class PointSetModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> points;

  /// Конструктор
  const PointSetModel({required this.points});
}

/// Реализация модели данных для форм
class PointSetModelImpl implements FormsDataModel {
  final _config = PointSetModelFormConfig();
  late final _model = _config.createModel();

  @override
  PointSetModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
