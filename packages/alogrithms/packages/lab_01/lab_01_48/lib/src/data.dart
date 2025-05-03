import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для алгоритма поиска треугольника максимальной площади, внутри описанной окружности которого располагается заданная точка
@FormGen()
class AlgorithmLab0148DataModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3, // Минимум 3 точки для формирования треугольника
  )
  final List<Point> points;

  /// Точка, которая должна находиться внутри описанной окружности треугольника
  @PointFieldGen(label: 'Точка pB')
  final Point pointB;

  /// Конструктор
  const AlgorithmLab0148DataModel({required this.points, required this.pointB});
}

class AlgorithmL01V48DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab0148DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab0148DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
