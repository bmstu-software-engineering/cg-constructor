import 'field_config_entry.dart';

/// Конфигурация формы
class FormConfig {
  /// Название формы
  final String name;

  /// Список конфигураций полей
  final List<FieldConfigEntry> fields;

  /// Функция валидации всей формы
  final String? Function(Map<String, dynamic>)? validator;

  /// Создает конфигурацию формы
  ///
  /// [name] - название формы
  /// [fields] - список конфигураций полей
  /// [validator] - функция валидации всей формы
  const FormConfig({
    required this.name,
    required this.fields,
    this.validator,
  });

  @override
  String toString() => 'FormConfig(name: $name, fields: ${fields.length})';
}
