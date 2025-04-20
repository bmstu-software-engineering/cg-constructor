import '../core/form_field.dart';
import 'field_config.dart';
import 'field_type.dart';

/// Класс для описания поля в конфиге формы
class FieldConfigEntry {
  /// Уникальный идентификатор поля
  final String id;

  /// Тип поля
  final FieldType type;

  /// Конфигурация поля
  final FieldConfig config;

  /// Создает описание поля в конфиге формы
  ///
  /// [id] - уникальный идентификатор поля
  /// [type] - тип поля
  /// [config] - конфигурация поля
  const FieldConfigEntry({
    required this.id,
    required this.type,
    required this.config,
  });

  @override
  String toString() => 'FieldConfigEntry(id: $id, type: $type)';
}
