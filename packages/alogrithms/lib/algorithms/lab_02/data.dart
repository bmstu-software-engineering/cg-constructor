import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:forms_annotations/forms_annotations.dart';

part 'data.g.dart';

@FormGen()
class AlgorithmLab02DataModelScale {
  @PointFieldGen(label: 'Центр вращения')
  final Point center;

  @ScaleFieldGen(label: 'Коэфициенты масшабирования')
  final Scale scale;

  const AlgorithmLab02DataModelScale({
    required this.center,
    required this.scale,
  });
}

/// Модель данных для алгоритма Lab01Basic
@FormGen()
class AlgorithmLab02DataModel implements AlgorithmData {
  /// Множество точек
  @VectorFieldGen(label: 'Вектор перемещения')
  final Vector move;

  @AngleFieldGen(label: 'Угол поворота')
  final Angle rotate;

  // final AlgorithmLab02DataModelScale scale;

  /// Конструктор
  const AlgorithmLab02DataModel({
    required this.move,
    required this.rotate,
    // required this.scale,
  });
}

class AlgorithmLab02DataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab02DataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab02DataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
