import '../core/form_field.dart';
import '../fields/enum_select_field.dart';
import 'field_config.dart';

abstract class EnumSelectEnum implements Enum {
  String get title;
}

/// Конфигурация для поля выбора из списка значений
class EnumSelectConfig<T> extends FieldConfig<T> {
  /// Список возможных значений
  List<T> values;

  /// Функция для получения названия значения
  final String Function(T)? titleBuilder;

  /// Создает конфигурацию для поля выбора из списка значений
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [values] - список возможных значений
  /// [titleBuilder] - функция для получения названия значения
  /// [validator] - функция валидации
  EnumSelectConfig({
    super.label,
    super.hint,
    super.isRequired = true,
    required this.values,
    this.titleBuilder,
    super.validator,
  });

  @override
  FormField<T> createField() {
    return EnumSelectField<T>(
      config: this,
      initialValue: null,
    );
  }
}
