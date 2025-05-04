import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:forms_annotations/forms_annotations.dart';

part 'dual_point_set_model.g.dart';

/// Обобщенная модель данных для алгоритмов, работающих с двумя наборами точек
@FormGen()
class DualPointSetModel implements AlgorithmData {
  /// Первое множество точек
  @ListFieldGen(
    label: 'Первое множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> firstPoints;

  /// Второе множество точек
  @ListFieldGen(
    label: 'Второе множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> secondPoints;

  /// Конструктор
  const DualPointSetModel({
    required this.firstPoints,
    required this.secondPoints,
  });
}

/// Реализация модели данных для форм
class DualPointSetModelImpl implements FormsDataModel {
  final _config = DualPointSetModelFormConfig();
  late final _model = _config.createModel();

  @override
  DualPointSetModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
