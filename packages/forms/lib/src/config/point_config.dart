import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';
import 'field_config.dart';
import 'number_config.dart';

/// Конфигурация для поля точки
class PointFieldConfig extends FieldConfig<Point> {
  /// Конфигурация для поля X
  final NumberFieldConfig xConfig;

  /// Конфигурация для поля Y
  final NumberFieldConfig yConfig;

  PointFieldConfig({
    super.hint,
    super.isRequired = true,
    super.validator,
    super.label,
    NumberFieldConfig? xConfig,
    NumberFieldConfig? yConfig,
  }) : xConfig = xConfig ?? NumberFieldConfig(label: 'X'),
       yConfig = yConfig ?? NumberFieldConfig(label: 'Y');

  @override
  FormField<Point> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
