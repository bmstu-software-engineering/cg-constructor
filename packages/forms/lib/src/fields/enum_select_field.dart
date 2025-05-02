import '../config/enum_select_config.dart';
import '../config/select_option.dart';
import 'base_form_field.dart';

/// Поле формы для выбора из enum
class EnumSelectField<T> extends BaseFormField<T> {
  /// Конфигурация поля
  final EnumSelectConfig<T> config;

  /// Создает поле для выбора из enum
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  EnumSelectField({
    required this.config,
    super.initialValue,
  }) : super(
          validator: config.validator,
          isRequired: config.isRequired,
        );

  /// Получает список возможных значений
  List<T> get values => config.values;

  /// Получает список опций выбора
  List<SelectOption<T>> get options => config.options;

  /// Находит опцию по значению
  SelectOption<T>? findOptionByValue(T value) {
    return options.firstWhere(
      (option) => option.value == value,
      orElse: () =>
          SelectOption.fromValue(value, titleBuilder: config.titleBuilder),
    );
  }

  /// Получает название значения
  String getTitle(T value) {
    return findOptionByValue(value)?.title ?? value.toString();
  }
}
