import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';

import 'field_config.dart';
import 'number_config.dart';

/// Конфигурация для поля вектора
class VectorFieldConfig extends FieldConfig<Vector> {
  /// Конфигурация для поля dx (смещение по X)
  final NumberFieldConfig dxConfig;

  /// Конфигурация для поля dy (смещение по Y)
  final NumberFieldConfig dyConfig;

  const VectorFieldConfig({
    super.label,
    super.hint,
    super.isRequired,
    super.validator,
    this.dxConfig = const NumberFieldConfig(label: 'Смещение по X'),
    this.dyConfig = const NumberFieldConfig(label: 'Смещение по Y'),
  });

  @override
  FormField<Vector> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
