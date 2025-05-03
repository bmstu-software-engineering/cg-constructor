import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма Lab01V40
@FormGen()
class AlgorithmLab01V40DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Первое множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> pointsFirst;
  @ListFieldGen(
    label: 'Второе множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> pointsSecond;

  /// Конструктор
  const AlgorithmLab01V40DataModel({
    required this.pointsFirst,
    required this.pointsSecond,
  });
}

class AlgorithmL01VBasicDataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab01V40DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab01V40DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
