import 'package:models_ns/models_ns.dart';

import '../core/form_field.dart';
import '../models/rectangle.dart';
import 'field_config.dart';
import 'point_config.dart';

/// Конфигурация для поля прямоугольника
class RectangleFieldConfig extends FieldConfig<Rectangle> {
  /// Конфигурация для верхней левой точки
  final PointFieldConfig topLeftConfig;

  /// Конфигурация для нижней правой точки
  final PointFieldConfig bottomRightConfig;

  /// Использовать ли конструктор fromCorners (только две точки)
  final bool useCorners;

  /// Конфигурация для верхней правой точки (если не useCorners)
  final PointFieldConfig? topRightConfig;

  /// Конфигурация для нижней левой точки (если не useCorners)
  final PointFieldConfig? bottomLeftConfig;

  /// Цвет прямоугольника по умолчанию
  final String defaultColor;

  /// Толщина линий прямоугольника по умолчанию
  final double defaultThickness;

  RectangleFieldConfig({
    required String label,
    String? hint,
    bool isRequired = true,
    String? Function(Rectangle?)? validator,
    PointFieldConfig? topLeftConfig,
    PointFieldConfig? bottomRightConfig,
    this.useCorners = true,
    this.topRightConfig,
    this.bottomLeftConfig,
    this.defaultColor = '#000000',
    this.defaultThickness = 1.0,
  }) : topLeftConfig =
           topLeftConfig ?? PointFieldConfig(label: 'Верхний левый угол'),
       bottomRightConfig =
           bottomRightConfig ?? PointFieldConfig(label: 'Нижний правый угол'),
       super(
         label: label,
         hint: hint,
         isRequired: isRequired,
         validator: validator,
       );

  @override
  FormField<Rectangle> createField() {
    // Реализация будет добавлена позже
    throw UnimplementedError();
  }
}
