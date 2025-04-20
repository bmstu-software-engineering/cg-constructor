import '../core/form_field.dart';
import '../models/scale.dart';
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
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(Scale?)? validator,
    NumberFieldConfig? xConfig,
    NumberFieldConfig? yConfig,
    this.uniform = false,
  }) : xConfig =
           xConfig ??
           NumberFieldConfig(
             label: 'Масштаб по X',
             min: 0.0001, // Предотвращаем деление на ноль
           ),
       yConfig =
           yConfig ??
           NumberFieldConfig(
             label: 'Масштаб по Y',
             min: 0.0001, // Предотвращаем деление на ноль
           ),
       super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator,
       );

  @override
  FormField<Scale> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
