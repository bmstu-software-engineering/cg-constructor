import 'package:models_ns/models_ns.dart';

import '../config/scale_config.dart';

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

      // Сначала вызываем пользовательский валидатор, если он есть
      if (config.validator != null) {
        final result = config.validator!(scale);
        if (result != null) return result;
      }

      // Затем вызываем встроенный валидатор
      return scale.validate();
    };
  }

  /// Получает поле для ввода x (масштаб по X)
  NumberField get xField => _xField;

  /// Получает поле для ввода y (масштаб по Y)
  NumberField get yField => _yField;

  /// Указывает, используется ли равномерное масштабирование
  bool get isUniform => config.uniform;

  /// Указывает, является ли поле обязательным
  bool get isRequired => config.isRequired;

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
    // Проверяем, есть ли значения в полях x и y
    final xValue = _xField.value;
    final yValue = _yField.value;

    // Если поле обязательное и одно из значений не установлено, возвращаем ошибку
    if (isRequired && (xValue == null || yValue == null)) {
      final error = 'Это поле обязательно';
      setError(error);
      return error;
    }

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

    // Если оба значения установлены, создаем объект Scale
    if (xValue != null && yValue != null) {
      // Затем валидируем масштабирование с помощью пользовательского валидатора
      if (config.validator != null) {
        final scale = Scale(x: xValue, y: yValue);
        final error = config.validator!(scale);
        if (error != null) {
          setError(error);
          return error;
        }
      }
    }

    // Если все проверки прошли успешно, сбрасываем ошибку
    setError(null);
    return null;
  }

  @override
  void reset() {
    _xField.reset();
    _yField.reset();
    super.reset();
  }
}
