import 'package:flutter/widgets.dart';
import 'package:forms/forms.dart';

import '../flow.dart';

/// Стратегия данных для моделей, основанных на формах
class FormsDataStrategy<T extends FormsDataModelAdapter>
    implements FlowDataStrategy<T> {
  final T _dataModel;
  final DynamicFormModel _formModel;

  FormsDataStrategy(this._dataModel)
    : _formModel = DynamicFormModel(config: _dataModel.config);

  @override
  Widget buildWidget() {
    return DynamicFormWidget(model: _formModel, onSubmit: null);
  }

  @override
  Future<T> getData() async {
    _dataModel.rawData = _formModel.getValues();
    return _dataModel;
  }
}

/// Фабрика для создания стратегий данных
class DataStrategyFactory {
  /// Создает стратегию данных для указанной модели данных
  static FlowDataStrategy createDataStrategy(
    DataModelAdapter dataModelAdapter,
  ) {
    if (dataModelAdapter is FormsDataModelAdapter) {
      return FormsDataStrategy(dataModelAdapter);
    }

    throw Exception(
      'Неподдерживаемый тип адаптера модели данных: ${dataModelAdapter.runtimeType}',
    );
  }
}
