import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';
import 'lab_01_basic_data_model.dart';

class AlgorithmL01VBasic
    implements Algorithm<FormsDataModel, ViewerResultModel> {
  AlgorithmL01VBasic();

  @override
  FormsDataModel getDataModel() {
    return AlgorithmL01VBasicCodegenDataModelImpl();
  }

  @override
  ViewerResultModel calculate(FormsDataModel dataModel) {
    if (dataModel is! AlgorithmL01VBasicCodegenDataModelImpl) {
      throw InvalidDataException('Неверный тип модели данных');
    }

    final points = dataModel.data.points;

    // Пример обработки точек и создания результата
    List<Point> resultPoints =
        points.map((point) {
          return Point(
            x: point.x,
            y: point.y,
            color: '#FF0000',
            thickness: 1.0,
          );
        }).toList();

    return ViewerResultModel(points: resultPoints, lines: []);
  }
}

/// Класс данных для реализации с использованием кодогенерации
class _CodegenData implements AlgorithmData {
  final AlgorithmLab01BasicDataModel _model;
  List<Point> get points => _model.points;

  const _CodegenData(this._model);
}

/// Реализация модели данных с использованием кодогенерации
class AlgorithmL01VBasicCodegenDataModelImpl implements FormsDataModel {
  _CodegenData? _data;
  final _formConfig = AlgorithmLab01BasicDataModelFormConfig();
  late final _formModel = _formConfig.createModel();

  @override
  FormConfig get config => _formConfig.toFormConfig();

  @override
  _CodegenData get data => _data ?? (throw Exception('Данные не установлены'));

  @override
  set rawData(Map<String, dynamic>? rawData) {
    if (rawData == null) {
      throw InvalidDataException('Данные не предоставлены');
    }

    try {
      _formModel.fromMap(rawData);
      if (_formModel.isValid()) {
        final values = _formModel.values;
        _data = _CodegenData(values);
      } else {
        throw InvalidDataException('Данные не прошли валидацию');
      }
    } catch (e) {
      throw InvalidDataException(
        'Ошибка при обработке данных: ${e.toString()}',
      );
    }
  }
}
