import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

class AlgorithmL01VBasic
    implements Algorithm<AlgorithmL01V41FormsDataModelImpl, ViewerResultModel> {
  @override
  AlgorithmL01V41FormsDataModelImpl getDataModel() =>
      AlgorithmL01V41FormsDataModelImpl();

  @override
  ViewerResultModel calculate(DataModel dataModel) {
    if (dataModel is! AlgorithmL01V41FormsDataModelImpl) {
      throw InvalidDataException('Неверный тип модели данных');
    }

    final formsDataModel = dataModel;
    final points = formsDataModel.data.points;

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

class _Data implements AlgorithmData {
  final List<Point> points;

  const _Data(this.points);
}

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
