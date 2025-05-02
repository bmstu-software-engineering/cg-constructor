import 'package:models_ns/models_ns.dart';
import '../core/form_field.dart';
import '../fields/line_field.dart';
import 'field_config.dart';
import 'point_config.dart';

/// Конфигурация для поля линии
class LineFieldConfig extends FieldConfig<Line> {
  /// Конфигурация для поля начальной точки
  final PointFieldConfig startConfig;

  /// Конфигурация для поля конечной точки
  final PointFieldConfig endConfig;

  /// Можно ли задать цвет для линии
  final bool canSetColor;

  /// Цвет линии по умолчанию
  final String defaultColor;

  /// Можно ли задать толщину линии
  final bool canSetThickness;

  /// Толщина линии по умолчанию
  final double defaultThickness;

  /// Создает конфигурацию для поля линии
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [validator] - функция валидации
  /// [startConfig] - конфигурация для поля начальной точки
  /// [endConfig] - конфигурация для поля конечной точки
  /// [canSetColor] - можно ли задать цвет для линии
  /// [defaultColor] - цвет линии по умолчанию
  /// [canSetThickness] - можно ли задать толщину линии
  /// [defaultThickness] - толщина линии по умолчанию
  LineFieldConfig({
    super.label,
    super.hint,
    super.isRequired = true,
    super.validator,
    PointFieldConfig? startConfig,
    PointFieldConfig? endConfig,
    this.canSetColor = false,
    this.defaultColor = '#000000',
    this.canSetThickness = false,
    this.defaultThickness = 1.0,
  })  : startConfig = startConfig ?? PointFieldConfig(label: 'Начало'),
        endConfig = endConfig ?? PointFieldConfig(label: 'Конец');

  @override
  FormField<Line> createField() {
    return LineField(config: this);
  }
}
