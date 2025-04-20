import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';
import '../models/triangle.dart';
import 'field_config.dart';
import 'point_config.dart';

/// Конфигурация для поля треугольника
class TriangleFieldConfig extends FieldConfig<Triangle> {
  /// Конфигурация для первой точки треугольника
  final PointFieldConfig aConfig;

  /// Конфигурация для второй точки треугольника
  final PointFieldConfig bConfig;

  /// Конфигурация для третьей точки треугольника
  final PointFieldConfig cConfig;

  /// Цвет треугольника по умолчанию
  final String defaultColor;

  /// Толщина линий треугольника по умолчанию
  final double defaultThickness;

  TriangleFieldConfig({
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(Triangle?)? validator,
    PointFieldConfig? aConfig,
    PointFieldConfig? bConfig,
    PointFieldConfig? cConfig,
    this.defaultColor = '#000000',
    this.defaultThickness = 1.0,
  }) : aConfig = aConfig ?? PointFieldConfig(label: 'Точка A'),
       bConfig = bConfig ?? PointFieldConfig(label: 'Точка B'),
       cConfig = cConfig ?? PointFieldConfig(label: 'Точка C'),
       super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator,
       );

  @override
  FormField<Triangle> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
