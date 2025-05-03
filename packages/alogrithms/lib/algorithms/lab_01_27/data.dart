import 'package:alogrithms/alogrithms.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

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
