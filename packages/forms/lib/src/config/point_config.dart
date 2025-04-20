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

  const PointFieldConfig({
    super.hint,
    super.isRequired = false,
    super.validator,
    super.label,
    NumberFieldConfig? xConfig,
    NumberFieldConfig? yConfig,
  })  : xConfig = xConfig ?? const NumberFieldConfig(label: 'X'),
        yConfig = yConfig ?? const NumberFieldConfig(label: 'Y');

  @override
  FormField<Point> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
