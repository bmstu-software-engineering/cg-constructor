import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма поиска треугольника с максимальной разностью
@FormGen()
class AlgorithmLab0127DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> points;

  /// Конструктор
  const AlgorithmLab0127DataModel({required this.points});
}

class AlgorithmL01V27DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab0127DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab0127DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
