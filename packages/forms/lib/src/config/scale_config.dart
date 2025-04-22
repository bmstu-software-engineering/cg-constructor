import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';

import 'field_config.dart';
import 'number_config.dart';

/// Конфигурация для поля масштабирования
class ScaleFieldConfig extends FieldConfig<Scale> {
  /// Конфигурация для поля x (масштаб по X)
  final NumberFieldConfig xConfig;

  /// Конфигурация для поля y (масштаб по Y)
  final NumberFieldConfig yConfig;

  /// Использовать ли равномерное масштабирование (одинаковое по обеим осям)
  final bool uniform;

  ScaleFieldConfig({
    required String super.label,
    super.hint,
    super.isRequired,
    super.validator,
    NumberFieldConfig? xConfig,
    NumberFieldConfig? yConfig,
    this.uniform = false,
  })  : xConfig = xConfig ??
            const NumberFieldConfig(
              label: 'Масштаб по X',
              min: 0.0001, // Предотвращаем деление на ноль
            ),
        yConfig = yConfig ??
            const NumberFieldConfig(
              label: 'Масштаб по Y',
              min: 0.0001, // Предотвращаем деление на ноль
            );

  @override
  FormField<Scale> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
