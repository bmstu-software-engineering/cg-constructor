import '../core/form_field.dart';

/// Конфигурация для поля списка
class ListFieldConfig<T> {
  /// Метка поля
  final String? label;

  /// Минимальное количество элементов
  final int minItems;

  /// Максимальное количество элементов (null - без ограничений)
  final int? maxItems;

  /// Является ли поле обязательным
  final bool isRequired;

  /// Функция для создания нового поля
  final FormField<T> Function() createField;

  /// Функция валидации
  final String? Function(List<T>?)? validator;

  /// Создает конфигурацию для поля списка
  ///
  /// [label] - метка поля
  /// [minItems] - минимальное количество элементов
  /// [maxItems] - максимальное количество элементов (null - без ограничений)
  /// [isRequired] - является ли поле обязательным
  /// [createField] - функция для создания нового поля
  /// [validator] - функция валидации
  const ListFieldConfig({
    this.label,
    this.minItems = 0,
    this.maxItems,
    this.isRequired = true,
    required this.createField,
    this.validator,
  });
}
