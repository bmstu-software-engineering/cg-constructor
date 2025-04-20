import '../core/form_field.dart';
import 'field_config.dart';

/// Конфигурация для числового поля
class NumberFieldConfig extends FieldConfig<double> {
  /// Минимальное значение
  final double? min;

  /// Максимальное значение
  final double? max;

  const NumberFieldConfig({
    required String super.label,
    super.hint,
    super.isRequired,
    super.validator,
    this.min,
    this.max,
  });

  @override
  FormField<double> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
