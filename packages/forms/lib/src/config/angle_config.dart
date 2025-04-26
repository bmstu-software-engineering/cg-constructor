import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';

import 'field_config.dart';
import 'number_config.dart';

/// Конфигурация для поля угла
class AngleFieldConfig extends FieldConfig<Angle> {
  /// Конфигурация для поля значения угла
  final NumberFieldConfig valueConfig;

  /// Минимальное значение угла
  final double? min;

  /// Максимальное значение угла
  final double? max;

  /// Нормализовать ли угол в диапазон [0, 360)
  final bool normalize;

  AngleFieldConfig({
    required String super.label,
    super.hint,
    super.isRequired,
    super.validator,
    NumberFieldConfig? valueConfig,
    this.min,
    this.max,
    this.normalize = false,
  }) : valueConfig = valueConfig ??
            NumberFieldConfig(label: 'Значение угла', min: min, max: max);

  @override
  FormField<Angle> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
