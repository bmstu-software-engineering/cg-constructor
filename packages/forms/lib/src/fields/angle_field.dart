import 'package:models_ns/models_ns.dart';

import '../config/angle_config.dart';

import 'base_form_field.dart';
import 'number_field.dart';

/// Поле формы для ввода угла
class AngleField extends BaseFormField<Angle> {
  /// Конфигурация поля
  final AngleFieldConfig config;

  /// Поле для ввода значения угла
  final NumberField _valueField;

  /// Создает поле для ввода угла
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  AngleField({required this.config, super.initialValue})
      : _valueField = NumberField(
          config: config.valueConfig,
          initialValue: initialValue?.value,
        ),
        super(
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Angle?)? _createValidator(AngleFieldConfig config) {
    return (Angle? angle) {
      if (angle == null) return null;

      if (config.validator != null) {
        return config.validator!(angle);
      }

      return angle.validate();
    };
  }

  /// Получает поле для ввода значения угла
  NumberField get valueField {
    return _valueField;
  }

  @override
  Angle? get value {
    final valueValue = _valueField.value;
    if (valueValue == null) return null;

    Angle angle = Angle(value: valueValue);

    // Нормализуем угол, если это требуется
    if (config.normalize) {
      angle = angle.normalize();
    }

    return angle;
  }

  @override
  set value(Angle? newValue) {
    if (newValue == null) {
      _valueField.value = null;
    } else {
      // Нормализуем угол, если это требуется
      final normalizedValue =
          config.normalize ? newValue.normalize() : newValue;
      _valueField.value = normalizedValue.value;
    }

    validate();
  }

  @override
  String? validate() {
    // Сначала валидируем поле значения
    final valueError = _valueField.validate();
    if (valueError != null) {
      setError(valueError);
      return valueError;
    }

    // Затем валидируем угол
    return super.validate();
  }

  @override
  void reset() {
    _valueField.reset();
    super.reset();
  }
}
