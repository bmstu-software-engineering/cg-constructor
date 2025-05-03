import 'package:flutter/widgets.dart';
import 'package:forms/forms.dart';

import '../flow.dart';

/// Стратегия данных для моделей, основанных на формах
class FormsDataStrategy<T extends FormsDataModelAdapter>
    implements FlowDataStrategy {
  final DynamicFormModel _formModel;

  FormsDataStrategy(T dataModel) : _formModel = dataModel.config;

  @override
  Widget buildWidget() => DynamicFormWidget(model: _formModel, onSubmit: null);

  @override
  bool get isValid => _formModel.isValid();
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
