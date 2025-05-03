import 'package:models_ns/models_ns.dart';

import '../config/vector_config.dart';

import 'base_form_field.dart';
import 'number_field.dart';

/// Поле формы для ввода вектора
class VectorField extends BaseFormField<Vector> {
  /// Конфигурация поля
  final VectorFieldConfig config;

  /// Поле для ввода dx (смещение по X)
  final NumberField _dxField;

  /// Поле для ввода dy (смещение по Y)
  final NumberField _dyField;

  /// Создает поле для ввода вектора
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  VectorField({this.config = const VectorFieldConfig(), Vector? initialValue})
      : _dxField = NumberField(
          config: config.dxConfig,
          initialValue: initialValue?.dx,
        ),
        _dyField = NumberField(
          config: config.dyConfig,
          initialValue: initialValue?.dy,
        ),
        super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Vector?)? _createValidator(VectorFieldConfig config) {
    return (Vector? vector) {
      if (vector == null) return null;

      if (config.validator != null) {
        return config.validator!(vector);
      }

      return vector.validate();
    };
  }

  /// Получает поле для ввода dx (смещение по X)
  NumberField get dxField => _dxField;

  /// Получает поле для ввода dy (смещение по Y)
  NumberField get dyField => _dyField;

  @override
  Vector? get value {
    final dxValue = _dxField.value;
    final dyValue = _dyField.value;

    if (dxValue == null || dyValue == null) return null;

    return Vector(dx: dxValue, dy: dyValue);
  }

  @override
  set value(Vector? newValue) {
    if (newValue == null) {
      _dxField.value = null;
      _dyField.value = null;
    } else {
      _dxField.value = newValue.dx;
      _dyField.value = newValue.dy;
    }

    // Обновляем значение в родительском классе
    super.value = newValue;
  }

  @override
  String? validate() {
    // Сначала валидируем поля dx и dy
    final dxError = _dxField.validate();
    if (dxError != null) {
      setError(dxError);
      return dxError;
    }

    final dyError = _dyField.validate();
    if (dyError != null) {
      setError(dyError);
      return dyError;
    }

    // Затем валидируем вектор
    return super.validate();
  }

  @override
  void reset() {
    _dxField.reset();
    _dyField.reset();
    super.reset();
  }
}
