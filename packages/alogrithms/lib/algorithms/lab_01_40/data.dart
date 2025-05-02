import 'package:alogrithms/alogrithms.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'data.g.dart';

/// Модель данных для алгоритма Lab01Basic
@FormGen()
class AlgorithmLab01V40DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(label: 'Первое множество точек', itemConfig: PointFieldGen())
  final List<Point> pointsFirst;
  @ListFieldGen(label: 'Второе множество точек', itemConfig: PointFieldGen())
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
  FormConfig get config => _model.config;
}
