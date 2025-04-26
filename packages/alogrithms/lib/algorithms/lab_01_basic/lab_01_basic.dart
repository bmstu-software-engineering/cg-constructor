import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';
import 'lab_01_basic_data_model.dart';

class AlgorithmL01VBasic implements Algorithm<DataModel, ViewerResultModel> {
  /// Флаг для переключения между реализациями
  final bool useFormsCodegen;

  AlgorithmL01VBasic({this.useFormsCodegen = false});

  @override
  DataModel getDataModel() {
    if (useFormsCodegen) {
      return AlgorithmL01VBasicCodegenDataModelImpl();
    } else {
      return AlgorithmL01V41FormsDataModelImpl();
    }
  }

  @override
  ViewerResultModel calculate(DataModel dataModel) {
    List<Point> points;

    if (useFormsCodegen &&
        dataModel is AlgorithmL01VBasicCodegenDataModelImpl) {
      points = dataModel.data.points;
    } else if (!useFormsCodegen &&
        dataModel is AlgorithmL01V41FormsDataModelImpl) {
      points = dataModel.data.points;
    } else {
      throw InvalidDataException('Неверный тип модели данных');
    }

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

/// Класс данных для текущей реализации
class _Data implements AlgorithmData {
  final List<Point> points;

  const _Data(this.points);
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

/// Текущая реализация модели данных
class AlgorithmL01V41FormsDataModelImpl implements FormsDataModel {
  _Data? _data;

  @override
  FormConfig get config => FormConfig(
    name: 'Lab 01, Variant 41',
    fields: [
      FieldConfigEntry(
        id: 'points',
        type: FieldType.list,
        config: ListFieldConfig<Point>(
          label: 'Множество точек',
          minItems: 1,
          maxItems: 999,
          createItemField: () => PointField(config: PointFieldConfig()),
        ),
      ),
    ],
  );

  @override
  _Data get data => _data ?? (throw Exception('Данные не установлены'));

  @override
  set rawData(Map<String, dynamic>? rawData) {
    if (rawData == null) {
      throw InvalidDataException('Данные не предоставлены');
    }

    if (!rawData.containsKey('points')) {
      throw InvalidDataException('Отсутствуют обязательные поля данных');
    }

    try {
      _data = _Data((rawData['points'] as List).whereType<Point>().toList());
    } catch (e) {
      throw InvalidDataException(
        'Ошибка при обработке данных: ${e.toString()}',
      );
    }
  }
}
