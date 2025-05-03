import 'package:alogrithms/alogrithms.dart';
import 'package:forms/forms.dart';

/// Базовый интерфейс для адаптеров моделей данных
abstract class DataModelAdapter<T extends DataModel> implements DataModel {
  /// Возвращает оригинальную модель данных
  T get dataModel;
}

/// Адаптер для моделей данных, основанных на формах
class FormsDataModelAdapter<T extends FormsDataModel>
    implements DataModelAdapter<T>, FormsDataModel {
  final T _dataModel;

  const FormsDataModelAdapter(this._dataModel);

  @override
  T get dataModel => _dataModel;

  @override
  DynamicFormModel get config => _dataModel.config;

  @override
  AlgorithmData get data => _dataModel.data;
}

/// Фабрика для создания адаптеров моделей данных
class DataModelAdapterFactory {
  /// Создает адаптер для модели данных
  static DataModelAdapter createAdapter(DataModel dataModel) {
    if (dataModel is FormsDataModel) {
      return FormsDataModelAdapter(dataModel);
    }

    throw Exception(
      'Неподдерживаемый тип модели данных: ${dataModel.runtimeType}',
    );
  }
}
