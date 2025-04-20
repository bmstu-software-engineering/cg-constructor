import 'package:models_ns/models_ns.dart';

import '../config/point_config.dart';
import '../core/form_field.dart';
import 'base_form_field.dart';
import 'number_field.dart';

/// Поле формы для ввода точки
class PointField extends BaseFormField<Point> {
  /// Конфигурация поля
  final PointFieldConfig config;

  /// Поле для ввода x
  final NumberField _xField;

  /// Поле для ввода y
  final NumberField _yField;

  /// Создает поле для ввода точки
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  PointField({required this.config, super.initialValue})
      : _xField = NumberField(
          config: config.xConfig,
          initialValue: initialValue?.x,
        ),
        _yField = NumberField(
          config: config.yConfig,
          initialValue: initialValue?.y,
        ),
        super(
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Point?)? _createValidator(PointFieldConfig config) {
    return (Point? point) {
      if (point == null) return null;

      if (config.validator != null) {
        return config.validator!(point);
      }

      return null;
    };
  }

  /// Получает поле для ввода x
  NumberField get xField => _xField;

  /// Получает поле для ввода y
  NumberField get yField => _yField;

  @override
  Point? get value {
    final xValue = _xField.value;
    final yValue = _yField.value;

    if (xValue == null || yValue == null) return null;

    return Point(x: xValue, y: yValue);
  }

  @override
  set value(Point? newValue) {
    if (newValue == null) {
      _xField.value = null;
      _yField.value = null;
    } else {
      _xField.value = newValue.x;
      _yField.value = newValue.y;
    }

    validate();
  }

  @override
  String? validate() {
    // Сначала валидируем поля x и y
    final xError = _xField.validate();
    if (xError != null) {
      setError(xError);
      return xError;
    }

    final yError = _yField.validate();
    if (yError != null) {
      setError(yError);
      return yError;
    }

    // Затем валидируем точку
    return super.validate();
  }

  @override
  void reset() {
    _xField.reset();
    _yField.reset();
    super.reset();
  }
}
