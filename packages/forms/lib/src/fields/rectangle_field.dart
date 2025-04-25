import 'package:models_ns/models_ns.dart';

import '../config/rectangle_config.dart';

import 'base_form_field.dart';
import 'point_field.dart';

/// Поле формы для ввода прямоугольника
class RectangleField extends BaseFormField<Rectangle> {
  /// Конфигурация поля
  final RectangleFieldConfig config;

  /// Поле для ввода верхней левой точки
  final PointField _topLeftField;

  /// Поле для ввода нижней правой точки (если useCorners = true)
  final PointField? _bottomRightField;

  /// Поле для ввода верхней правой точки (если useCorners = false)
  final PointField? _topRightField;

  /// Поле для ввода нижней левой точки (если useCorners = false)
  final PointField? _bottomLeftField;

  /// Создает поле для ввода прямоугольника
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  RectangleField({required this.config, super.initialValue})
      : _topLeftField = PointField(
          config: config.topLeftConfig,
          initialValue: initialValue?.topLeft,
        ),
        _bottomRightField = config.useCorners
            ? PointField(
                config: config.bottomRightConfig,
                initialValue: initialValue?.bottomRight,
              )
            : null,
        _topRightField = !config.useCorners
            ? PointField(
                config: config.topRightConfig ?? config.topLeftConfig,
                initialValue: initialValue?.topRight,
              )
            : null,
        _bottomLeftField = !config.useCorners
            ? PointField(
                config: config.bottomLeftConfig ?? config.bottomRightConfig,
                initialValue: initialValue?.bottomLeft,
              )
            : null,
        super(
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Rectangle?)? _createValidator(
    RectangleFieldConfig config,
  ) {
    return (Rectangle? rectangle) {
      if (rectangle == null) return null;

      if (config.validator != null) {
        return config.validator!(rectangle);
      }

      return null;
    };
  }

  /// Получает поле для ввода верхней левой точки
  PointField get topLeftField => _topLeftField;

  /// Получает поле для ввода нижней правой точки (если useCorners = true)
  PointField? get bottomRightField => _bottomRightField;

  /// Получает поле для ввода верхней правой точки (если useCorners = false)
  PointField? get topRightField => _topRightField;

  /// Получает поле для ввода нижней левой точки (если useCorners = false)
  PointField? get bottomLeftField => _bottomLeftField;

  /// Указывает, используется ли конструктор fromCorners
  bool get useCorners => config.useCorners;

  @override
  Rectangle? get value {
    final topLeft = _topLeftField.value;

    if (topLeft == null) return null;

    if (config.useCorners) {
      final bottomRight = _bottomRightField?.value;
      if (bottomRight == null) return null;

      return Rectangle.fromCorners(
        topLeft: topLeft,
        bottomRight: bottomRight,
        color: config.defaultColor,
        thickness: config.defaultThickness,
      );
    } else {
      final topRight = _topRightField?.value;
      final bottomLeft = _bottomLeftField?.value;
      final bottomRight = _bottomRightField?.value;

      if (topRight == null || bottomLeft == null || bottomRight == null) {
        return null;
      }

      return Rectangle(
        topLeft: topLeft,
        topRight: topRight,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        color: config.defaultColor,
        thickness: config.defaultThickness,
      );
    }
  }

  @override
  set value(Rectangle? newValue) {
    if (newValue == null) {
      _topLeftField.value = null;
      if (_bottomRightField != null) _bottomRightField.value = null;
      if (_topRightField != null) _topRightField.value = null;
      if (_bottomLeftField != null) _bottomLeftField.value = null;
    } else {
      _topLeftField.value = newValue.topLeft;
      if (_bottomRightField != null) {
        _bottomRightField.value = newValue.bottomRight;
      }
      if (_topRightField != null) _topRightField.value = newValue.topRight;
      if (_bottomLeftField != null) {
        _bottomLeftField.value = newValue.bottomLeft;
      }
    }

    validate();
  }

  @override
  String? validate() {
    // Сначала валидируем поля точек
    final topLeftError = _topLeftField.validate();
    if (topLeftError != null) {
      setError('Ошибка в верхней левой точке: $topLeftError');
      return topLeftError;
    }

    if (config.useCorners && _bottomRightField != null) {
      final bottomRightError = _bottomRightField.validate();
      if (bottomRightError != null) {
        setError('Ошибка в нижней правой точке: $bottomRightError');
        return bottomRightError;
      }
    } else {
      if (_topRightField != null) {
        final topRightError = _topRightField.validate();
        if (topRightError != null) {
          setError('Ошибка в верхней правой точке: $topRightError');
          return topRightError;
        }
      }

      if (_bottomLeftField != null) {
        final bottomLeftError = _bottomLeftField.validate();
        if (bottomLeftError != null) {
          setError('Ошибка в нижней левой точке: $bottomLeftError');
          return bottomLeftError;
        }
      }

      if (_bottomRightField != null) {
        final bottomRightError = _bottomRightField.validate();
        if (bottomRightError != null) {
          setError('Ошибка в нижней правой точке: $bottomRightError');
          return bottomRightError;
        }
      }
    }

    // Затем валидируем прямоугольник
    return super.validate();
  }

  @override
  void reset() {
    _topLeftField.reset();
    if (_bottomRightField != null) _bottomRightField.reset();
    if (_topRightField != null) _topRightField.reset();
    if (_bottomLeftField != null) _bottomLeftField.reset();
    super.reset();
  }
}
