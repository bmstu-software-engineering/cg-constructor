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
  DynamicFormModel? _formModel;

  // Создаем конфигурацию формы вручную
  @override
  FormConfig get config => FormConfig(
    name: '',
    fields: [
      FieldConfigEntry(
        id: 'points',
        type: FieldType.list,
        config: ListFieldConfig<Point>(
          label: 'Список точек',
          minItems: 0,
          maxItems: 10,
          createItemField:
              () => PointField(config: PointFieldConfig(label: 'Точка')),
        ),
      ),
    ],
  );

  @override
  _CodegenData get data => _data ?? (throw Exception('Данные не установлены'));

  @override
  set rawData(Map<String, dynamic>? rawData) {
    if (rawData == null) {
      throw InvalidDataException('Данные не предоставлены');
    }

    try {
      // Создаем модель формы, если она еще не создана
      _formModel ??= DynamicFormModel(config: config);

      // Устанавливаем значения формы
      _formModel!.setValues(rawData);

      // Проверяем валидность формы
      if (_formModel!.isValid()) {
        // Получаем значения формы
        final formValues = _formModel!.getValues();

        // Создаем модель данных из значений формы
        if (formValues.containsKey('points')) {
          final points =
              (formValues['points'] as List<dynamic>)
                  .whereType<Point>()
                  .toList();
          _data = _CodegenData(AlgorithmLab01BasicDataModel(points: points));
        } else {
          throw InvalidDataException('Отсутствуют обязательные поля данных');
        }
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
