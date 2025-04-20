import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';
import '../models/polygon.dart';
import 'field_config.dart';
import 'point_config.dart';

/// Конфигурация для поля многоугольника
class PolygonFieldConfig extends FieldConfig<Polygon> {
  /// Конфигурация для точек многоугольника
  final PointFieldConfig pointConfig;

  /// Минимальное количество точек
  final int minPoints;

  /// Максимальное количество точек
  final int? maxPoints;

  /// Цвет многоугольника по умолчанию
  final String defaultColor;

  /// Толщина линий многоугольника по умолчанию
  final double defaultThickness;

  PolygonFieldConfig({
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(Polygon?)? validator,
    PointFieldConfig? pointConfig,
    this.minPoints = 3,
    this.maxPoints,
    this.defaultColor = '#000000',
    this.defaultThickness = 1.0,
  }) : pointConfig = pointConfig ?? PointFieldConfig(label: 'Точка'),
       super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator ?? _defaultValidator,
       );

  /// Валидатор по умолчанию для многоугольника
  static String? _defaultValidator(Polygon? polygon) {
    if (polygon == null) return null;
    return polygon.validate();
  }

  @override
  FormField<Polygon> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
