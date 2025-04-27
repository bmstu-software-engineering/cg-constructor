import '../config/enum_select_config.dart';
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
    T? initialValue,
  }) : super(
          initialValue: initialValue,
          validator: config.validator,
          isRequired: config.isRequired,
        );

  /// Получает список возможных значений
  List<T> get values => config.values;

  /// Получает название значения
  String getTitle(T value) {
    if (config.titleBuilder != null) {
      return config.titleBuilder!(value);
    }
    return value.toString();
  }
}
