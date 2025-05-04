import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:forms_annotations/forms_annotations.dart';

part 'geometric_transformation_model.g.dart';

/// Модель для параметров масштабирования
@FormGen()
class ScaleTransformationModel {
  /// Центр масштабирования
  @PointFieldGen(label: 'Центр масштабирования')
  final Point center;

  /// Коэффициенты масштабирования
  @ScaleFieldGen(label: 'Коэффициенты масштабирования')
  final Scale scale;

  /// Конструктор
  const ScaleTransformationModel({required this.center, required this.scale});
}

/// Модель для параметров поворотма
@FormGen()
class RotateTransformationModel {
  /// Центр масштабирования
  @PointFieldGen(label: 'Центр поворота')
  final Point center;

  /// Коэффициенты масштабирования
  @AngleFieldGen(label: 'Угол поворота')
  final Angle angle;

  /// Конструктор
  const RotateTransformationModel({required this.center, required this.angle});
}

/// Обобщенная модель данных для алгоритмов геометрических преобразований
@FormGen()
class GeometricTransformationModel implements AlgorithmData {
  /// Вектор перемещения
  @VectorFieldGen(label: 'Вектор перемещения')
  final Vector translation;

  /// Угол поворота
  @FieldGenAnnotation(label: 'Параметры поворота')
  final RotateTransformationModel rotation;

  /// Параметры масштабирования
  @FieldGenAnnotation(label: 'Параметры масштабирования')
  final ScaleTransformationModel scaling;

  /// Конструктор
  const GeometricTransformationModel({
    required this.translation,
    required this.rotation,
    required this.scaling,
  });
}

/// Реализация модели данных для форм
class GeometricTransformationModelImpl implements FormsDataModel {
  final _config = GeometricTransformationModelFormConfig();
  late final _model = _config.createModel();

  @override
  GeometricTransformationModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
