import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма поиска двух треугольников с максимальным расстоянием между барицентрами
@FormGen()
class AlgorithmLab0145DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 6, // Минимум 6 точек для формирования двух треугольников
  )
  final List<Point> points;

  /// Конструктор
  const AlgorithmLab0145DataModel({required this.points});
}

class AlgorithmL01V45DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab0145DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab0145DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
