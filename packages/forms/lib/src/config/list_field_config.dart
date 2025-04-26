import '../core/form_field.dart';
import '../fields/list_field.dart';
import 'field_config.dart';

/// Конфигурация для поля списка
class ListFieldConfig<T> extends FieldConfig<List<T>> {
  /// Минимальное количество элементов
  final int minItems;

  /// Максимальное количество элементов (null - без ограничений)
  final int? maxItems;

  /// Функция для создания нового поля элемента списка
  final FormField<T> Function() createItemField;

  /// Создает конфигурацию для поля списка
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [minItems] - минимальное количество элементов
  /// [maxItems] - максимальное количество элементов (null - без ограничений)
  /// [isRequired] - является ли поле обязательным
  /// [createItemField] - функция для создания нового поля элемента списка
  /// [validator] - функция валидации
  ListFieldConfig({
    super.label,
    super.hint,
    this.minItems = 0,
    this.maxItems,
    super.isRequired = false,
    required this.createItemField,
    super.validator,
  });

  @override
  FormField<List<T>> createField() {
    return ListField<T, FormField<T>>(
      config: this,
      initialValue: null,
    );
  }
}
