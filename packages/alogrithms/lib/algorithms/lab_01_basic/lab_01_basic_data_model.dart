import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'lab_01_basic_data_model.g.dart';

@FormGenAnnotation(name: '')
class AlgorithmLab01BasicDataModel {
  /// Множество точек
  @ListFieldAnnotation(
    label: 'Список точек',
    minItems: 0,
    maxItems: 10,
    itemConfig: PointFieldAnnotation(
      label: 'Точка',
      xConfig: NumberFieldAnnotation(label: 'X', min: 0, max: 100),
      yConfig: NumberFieldAnnotation(label: 'Y', min: 0, max: 100),
    ),
  )
  final List<Point> points;

  const AlgorithmLab01BasicDataModel({required this.points});
}
