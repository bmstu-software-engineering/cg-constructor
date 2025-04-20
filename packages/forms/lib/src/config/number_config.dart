import '../core/form_field.dart';
import 'field_config.dart';

/// Конфигурация для числового поля
class NumberFieldConfig extends FieldConfig<double> {
  /// Минимальное значение
  final double? min;

  /// Максимальное значение
  final double? max;

  NumberFieldConfig({
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(double?)? validator,
    this.min,
    this.max,
  }) : super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator,
       );

  @override
  FormField<double> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
