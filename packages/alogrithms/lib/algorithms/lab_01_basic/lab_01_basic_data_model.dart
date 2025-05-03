import 'package:alogrithms/alogrithms.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'lab_01_basic_data_model.g.dart';

/// Модель данных для алгоритма Lab01Basic
@FormGen()
class AlgorithmLab01BasicDataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(label: 'Список точек', itemConfig: PointFieldGen())
  final List<Point> points;

  /// Конструктор
  const AlgorithmLab01BasicDataModel({required this.points});
}

class AlgorithmL01VBasicDataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab01BasicDataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab01BasicDataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
