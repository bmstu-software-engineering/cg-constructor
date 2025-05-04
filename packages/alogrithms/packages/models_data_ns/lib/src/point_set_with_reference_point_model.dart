import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:forms_annotations/forms_annotations.dart';

part 'point_set_with_reference_point_model.g.dart';

/// Обобщенная модель данных для алгоритмов, работающих с набором точек и дополнительной точкой
@FormGen()
class PointSetWithReferencePointModel implements AlgorithmData {
  /// Множество точек
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3,
  )
  final List<Point> points;

  /// Дополнительная точка (точка отсчета, контрольная точка и т.д.)
  @PointFieldGen(label: 'Контрольная точка')
  final Point referencePoint;

  /// Конструктор
  const PointSetWithReferencePointModel({
    required this.points,
    required this.referencePoint,
  });
}

/// Реализация модели данных для форм
class PointSetWithReferencePointModelImpl implements FormsDataModel {
  final _config = PointSetWithReferencePointModelFormConfig();
  late final _model = _config.createModel();

  @override
  PointSetWithReferencePointModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
