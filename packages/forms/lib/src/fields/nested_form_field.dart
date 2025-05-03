import '../config/form_field_config.dart';
import '../core/form_model.dart';
import '../typed_form_base.dart';

import 'base_form_field.dart';

/// Поле формы для вложенной формы
class NestedFormField<T> extends BaseFormField<T> {
  /// Конфигурация поля
  final FormFieldConfig<T> config;

  /// Модель вложенной формы
  final TypedFormModel _formModel;

  /// Создает поле для вложенной формы
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  NestedFormField({
    required this.config,
    T? initialValue,
  })  : _formModel = config.createFormModel(),
        super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(T?)? _createValidator<T>(FormFieldConfig<T> config) {
    return (T? value) {
      if (value == null) return null;

      if (config.validator != null) {
        return config.validator!(value);
      }

      return null;
    };
  }

  /// Получает модель вложенной формы
  TypedFormModel get formModel => _formModel;

  @override
  T? get value {
    try {
      return _formModel.values as T?;
    } catch (e) {
      return null;
    }
  }

  @override
  set value(T? newValue) {
    if (newValue != null) {
      _formModel.values = newValue;
    }

    // Обновляем значение в родительском классе
    super.value = newValue;
  }

  @override
  String? validate() {
    // Сначала валидируем вложенную форму
    _formModel.validate();
    if (!_formModel.isValid()) {
      final error = 'Вложенная форма содержит ошибки';
      setError(error);
      return error;
    }

    // Затем валидируем само поле
    return super.validate();
  }

  @override
  bool isValid() {
    return _formModel.isValid() && super.isValid();
  }

  @override
  void reset() {
    _formModel.reset();
    super.value = null;
    super.reset();
  }

  /// Преобразует значение в Map
  Map<String, dynamic> toMap() {
    return _formModel.toMap();
  }

  /// Устанавливает значение из Map
  void fromMap(Map<String, dynamic> map) {
    _formModel.fromMap(map);
  }
}
