import '../core/form_field.dart';
import '../models/vector.dart';
import 'field_config.dart';
import 'number_config.dart';

/// Конфигурация для поля вектора
class VectorFieldConfig extends FieldConfig<Vector> {
  /// Конфигурация для поля dx (смещение по X)
  final NumberFieldConfig dxConfig;

  /// Конфигурация для поля dy (смещение по Y)
  final NumberFieldConfig dyConfig;

  VectorFieldConfig({
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(Vector?)? validator,
    NumberFieldConfig? dxConfig,
    NumberFieldConfig? dyConfig,
  }) : dxConfig = dxConfig ?? NumberFieldConfig(label: 'Смещение по X'),
       dyConfig = dyConfig ?? NumberFieldConfig(label: 'Смещение по Y'),
       super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator,
       );

  @override
  FormField<Vector> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
