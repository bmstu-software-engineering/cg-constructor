import '../core/form_field.dart';
import '../fields/enum_select_field.dart';
import 'field_config.dart';
import 'select_option.dart';

abstract class EnumSelectEnum implements Enum {
  String get title;
}

/// Конфигурация для поля выбора из списка значений
class EnumSelectConfig<T> extends FieldConfig<T> {
  /// Список возможных значений
  List<T> _values;

  /// Список опций выбора
  List<SelectOption<T>> _options = [];

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
    required List<T> values,
    this.titleBuilder,
    super.validator,
  }) : _values = values {
    _updateOptions();
  }

  /// Возвращает список возможных значений
  List<T> get values => _values;

  /// Устанавливает список возможных значений
  set values(List<T> newValues) {
    _values = newValues;
    _updateOptions();
  }

  /// Возвращает список опций выбора
  List<SelectOption<T>> get options => _options;

  /// Обновляет список опций на основе списка значений
  void _updateOptions() {
    _options = SelectOption.fromValues(_values, titleBuilder: titleBuilder);
  }

  @override
  FormField<T> createField() {
    return EnumSelectField<T>(
      config: this,
      initialValue: null,
    );
  }
}
