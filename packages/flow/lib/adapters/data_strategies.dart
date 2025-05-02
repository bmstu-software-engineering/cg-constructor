import 'package:flutter/widgets.dart';
import 'package:forms/forms.dart';

import '../flow.dart';

/// Стратегия данных для моделей, основанных на формах
class FormsDataStrategy<T extends FormsDataModelAdapter>
    implements FlowDataStrategy<T> {
  final T _dataModel;
  final DynamicFormModel _formModel;
  final String _submitButtonText;
  final void Function(Map<String, dynamic>)? _onSubmit;

  FormsDataStrategy(
    this._dataModel, {
    String submitButtonText = 'Отправить',
    void Function(Map<String, dynamic>)? onSubmit,
  }) : _formModel = DynamicFormModel(config: _dataModel.config),
       _submitButtonText = submitButtonText,
       _onSubmit = onSubmit;

  @override
  Widget buildWidget() {
    return DynamicFormWidget(
      model: _formModel,
      onSubmit: _onSubmit,
      submitButtonText: _submitButtonText,
    );
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
    DataModelAdapter dataModelAdapter, {
    String submitButtonText = 'Отправить',
    void Function(Map<String, dynamic>)? onSubmit,
  }) {
    if (dataModelAdapter is FormsDataModelAdapter) {
      return FormsDataStrategy(
        dataModelAdapter,
        submitButtonText: submitButtonText,
        onSubmit: onSubmit,
      );
    }

    throw Exception(
      'Неподдерживаемый тип адаптера модели данных: ${dataModelAdapter.runtimeType}',
    );
  }
}
