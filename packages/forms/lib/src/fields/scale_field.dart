import '../config/scale_config.dart';
import '../core/form_field.dart';
import '../models/scale.dart';
import 'base_form_field.dart';
import 'number_field.dart';

/// Поле формы для ввода масштабирования
class ScaleField extends BaseFormField<Scale> {
  /// Конфигурация поля
  final ScaleFieldConfig config;

  /// Поле для ввода x (масштаб по X)
  final NumberField _xField;

  /// Поле для ввода y (масштаб по Y)
  final NumberField _yField;

  /// Создает поле для ввода масштабирования
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  ScaleField({required this.config, Scale? initialValue})
    : _xField = NumberField(
        config: config.xConfig,
        initialValue: initialValue?.x,
      ),
      _yField = NumberField(
        config: config.yConfig,
        initialValue: initialValue?.y,
      ),
      super(
        initialValue: initialValue,
        validator: _createValidator(config),
        isRequired: config.isRequired,
      );

  /// Создает валидатор на основе конфигурации
  static String? Function(Scale?)? _createValidator(ScaleFieldConfig config) {
    return (Scale? scale) {
      if (scale == null) return null;

      if (config.validator != null) {
        return config.validator!(scale);
      }

      return scale.validate();
    };
  }

  /// Получает поле для ввода x (масштаб по X)
  NumberField get xField => _xField;

  /// Получает поле для ввода y (масштаб по Y)
  NumberField get yField => _yField;

  /// Указывает, используется ли равномерное масштабирование
  bool get isUniform => config.uniform;

  @override
  Scale? get value {
    final xValue = _xField.value;
    final yValue = _yField.value;

    if (xValue == null || yValue == null) return null;

    return Scale(x: xValue, y: yValue);
  }

  @override
  set value(Scale? newValue) {
    if (newValue == null) {
      _xField.value = null;
      _yField.value = null;
    } else {
      _xField.value = newValue.x;
      _yField.value = newValue.y;
    }

    validate();
  }

  /// Устанавливает равномерное масштабирование
  void setUniformValue(double value) {
    if (config.uniform) {
      _xField.value = value;
      _yField.value = value;
      validate();
    }
  }

  /// Синхронизирует значения x и y при равномерном масштабировании
  void syncValues(bool fromX) {
    if (!config.uniform) return;

    if (fromX && _xField.value != null) {
      _yField.value = _xField.value;
    } else if (!fromX && _yField.value != null) {
      _xField.value = _yField.value;
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

    // Затем валидируем масштабирование
    return super.validate();
  }

  @override
  void reset() {
    _xField.reset();
    _yField.reset();
    super.reset();
  }
}
