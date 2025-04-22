import 'package:models_ns/models_ns.dart';

import '../config/triangle_config.dart';

import 'base_form_field.dart';
import 'point_field.dart';

/// Поле формы для ввода треугольника
class TriangleField extends BaseFormField<Triangle> {
  /// Конфигурация поля
  final TriangleFieldConfig config;

  /// Поле для ввода точки A
  final PointField _aField;

  /// Поле для ввода точки B
  final PointField _bField;

  /// Поле для ввода точки C
  final PointField _cField;

  /// Создает поле для ввода треугольника
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  TriangleField({required this.config, Triangle? initialValue})
      : _aField = PointField(
          config: config.aConfig,
          initialValue: initialValue?.a,
        ),
        _bField = PointField(
          config: config.bConfig,
          initialValue: initialValue?.b,
        ),
        _cField = PointField(
          config: config.cConfig,
          initialValue: initialValue?.c,
        ),
        super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Triangle?)? _createValidator(
    TriangleFieldConfig config,
  ) {
    return (Triangle? triangle) {
      if (triangle == null) return null;

      if (config.validator != null) {
        return config.validator!(triangle);
      }

      return null;
    };
  }

  /// Получает поле для ввода точки A
  PointField get aField => _aField;

  /// Получает поле для ввода точки B
  PointField get bField => _bField;

  /// Получает поле для ввода точки C
  PointField get cField => _cField;

  @override
  Triangle? get value {
    final a = _aField.value;
    final b = _bField.value;
    final c = _cField.value;

    if (a == null || b == null || c == null) return null;

    return Triangle(
      a: a,
      b: b,
      c: c,
      color: config.defaultColor,
      thickness: config.defaultThickness,
    );
  }

  @override
  set value(Triangle? newValue) {
    if (newValue == null) {
      _aField.value = null;
      _bField.value = null;
      _cField.value = null;
    } else {
      _aField.value = newValue.a;
      _bField.value = newValue.b;
      _cField.value = newValue.c;
    }

    validate();
  }

  @override
  String? validate() {
    // Сначала валидируем поля точек
    final aError = _aField.validate();
    if (aError != null) {
      setError('Ошибка в точке A: $aError');
      return aError;
    }

    final bError = _bField.validate();
    if (bError != null) {
      setError('Ошибка в точке B: $bError');
      return bError;
    }

    final cError = _cField.validate();
    if (cError != null) {
      setError('Ошибка в точке C: $cError');
      return cError;
    }

    // Затем валидируем треугольник
    return super.validate();
  }

  @override
  void reset() {
    _aField.reset();
    _bField.reset();
    _cField.reset();
    super.reset();
  }
}
