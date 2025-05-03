import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма поиска двух треугольников с минимальным отношением периметров
@FormGen()
class AlgorithmLab0142DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 6, // Минимум 6 точек для формирования двух треугольников
  )
  final List<Point> points;

  /// Конструктор
  const AlgorithmLab0142DataModel({required this.points});
}

class AlgorithmL01V42DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab0142DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab0142DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
