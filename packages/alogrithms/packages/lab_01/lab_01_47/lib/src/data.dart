import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма поиска треугольника максимального периметра, внутри которого располагается заданная точка
@FormGen()
class AlgorithmLab0147DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3, // Минимум 3 точки для формирования треугольника
  )
  final List<Point> points;

  /// Точка, которая должна находиться внутри треугольника
  @PointFieldGen(label: 'Точка pB')
  final Point pointB;

  /// Конструктор
  const AlgorithmLab0147DataModel({required this.points, required this.pointB});
}

class AlgorithmL01V47DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab0147DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab0147DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
