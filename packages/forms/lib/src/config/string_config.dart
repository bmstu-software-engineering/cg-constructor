import '../core/form_field.dart';
import '../fields/string_field.dart';

import 'field_config.dart';

/// Конфигурация для строкового поля
class StringFieldConfig extends FieldConfig<String> {
  /// Минимальная длина строки
  final int? minLength;

  /// Максимальная длина строки
  final int? maxLength;

  /// Регулярное выражение для валидации
  final String? pattern;

  /// Создает конфигурацию для строкового поля
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [minLength] - минимальная длина строки
  /// [maxLength] - максимальная длина строки
  /// [pattern] - регулярное выражение для валидации
  const StringFieldConfig({
    super.label,
    super.hint,
    super.isRequired,
    super.validator,
    this.minLength,
    this.maxLength,
    this.pattern,
  });

  @override
  FormField<String> createField() {
    return StringField(config: this);
  }
}
