import 'package:flutter/foundation.dart';

import '../config/list_field_config.dart';
import '../core/form_field.dart';
import 'base_form_field.dart';

/// Поле формы для ввода списка значений
class ListField<T, F extends FormField<T>> extends BaseFormField<List<T>> {
  /// Конфигурация поля
  final ListFieldConfig<T> config;

  /// Список полей для ввода значений
  final List<F> _fields = [];

  /// Создает поле для ввода списка значений
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  ListField({required this.config, List<T>? initialValue})
    : super(
        initialValue: initialValue,
        validator: _createValidator(config),
        isRequired: config.isRequired,
      ) {
    // Инициализируем поля
    if (initialValue != null && initialValue.isNotEmpty) {
      for (final value in initialValue) {
        final field = config.createField() as F;
        field.value = value;
        _fields.add(field);
      }
    } else {
      // Создаем минимальное количество полей
      for (int i = 0; i < config.minItems; i++) {
        _fields.add(config.createField() as F);
      }
    }
  }

  /// Создает валидатор на основе конфигурации
  static String? Function(List<T>?)? _createValidator<T>(
    ListFieldConfig<T> config,
  ) {
    return (List<T>? values) {
      if (values == null) return null;

      if (values.length < config.minItems) {
        return 'Список должен содержать не менее ${config.minItems} элементов';
      }

      if (config.maxItems != null && values.length > config.maxItems!) {
        return 'Список должен содержать не более ${config.maxItems} элементов';
      }

      if (config.validator != null) {
        return config.validator!(values);
      }

      return null;
    };
  }

  /// Получает список полей
  List<F> get fields => _fields;

  /// Добавляет новое поле
  void addField() {
    if (config.maxItems != null && _fields.length >= config.maxItems!) {
      return;
    }

    _fields.add(config.createField() as F);

    validate();
  }

  /// Удаляет поле по индексу
  void removeField(int index) {
    if (index < 0 || index >= _fields.length) {
      return;
    }

    if (_fields.length <= config.minItems) {
      return;
    }

    _fields.removeAt(index);

    validate();
  }

  @override
  List<T>? get value {
    final values = <T>[];

    for (final field in _fields) {
      final value = field.value;
      if (value == null) return null;
      values.add(value);
    }

    if (values.isEmpty && config.isRequired) return null;

    return values;
  }

  @override
  set value(List<T>? newValue) {
    _fields.clear();

    if (newValue == null || newValue.isEmpty) {
      // Создаем минимальное количество полей
      for (int i = 0; i < config.minItems; i++) {
        _fields.add(config.createField() as F);
      }
    } else {
      // Создаем поля для каждого значения
      for (final value in newValue) {
        final field = config.createField() as F;
        field.value = value;
        _fields.add(field);
      }
    }

    validate();
  }

  @override
  String? validate() {
    // Валидируем каждое поле
    for (int i = 0; i < _fields.length; i++) {
      final field = _fields[i];
      final error = field.validate();
      if (error != null) {
        setError('Ошибка в элементе ${i + 1}: $error');
        return error;
      }
    }

    // Затем валидируем список
    return super.validate();
  }

  @override
  void reset() {
    for (final field in _fields) {
      field.reset();
    }

    _fields.clear();

    // Создаем минимальное количество полей
    for (int i = 0; i < config.minItems; i++) {
      _fields.add(config.createField() as F);
    }

    super.reset();
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ListField<$T>(value: $value, error: $error)';
  }
}
