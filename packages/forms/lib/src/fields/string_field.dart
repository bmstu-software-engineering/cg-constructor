import '../config/string_config.dart';
import 'base_form_field.dart';

/// Поле формы для ввода строки
class StringField extends BaseFormField<String> {
  /// Конфигурация поля
  final StringFieldConfig config;

  /// Создает поле для ввода строки
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  StringField({
    this.config = const StringFieldConfig(),
    String? initialValue,
  }) : super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(String?)? _createValidator(StringFieldConfig config) {
    return (String? value) {
      if (value == null) return null;

      // Проверка на обязательность поля
      if (config.isRequired && (value.isEmpty)) {
        return 'Поле обязательно для заполнения';
      }

      if (config.validator != null) {
        return config.validator!(value);
      }

      if (config.minLength != null && value.length < config.minLength!) {
        return 'Минимальная длина строки: ${config.minLength}';
      }

      if (config.maxLength != null && value.length > config.maxLength!) {
        return 'Максимальная длина строки: ${config.maxLength}';
      }

      if (config.pattern != null) {
        final regex = RegExp(config.pattern!);
        if (!regex.hasMatch(value)) {
          return 'Строка не соответствует шаблону';
        }
      }

      return null;
    };
  }
}
