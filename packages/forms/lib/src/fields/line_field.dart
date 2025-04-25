import 'package:models_ns/models_ns.dart';
import '../config/line_config.dart';
import 'base_form_field.dart';
import 'point_field.dart';

/// Поле формы для ввода линии
class LineField extends BaseFormField<Line> {
  /// Конфигурация поля
  final LineFieldConfig config;

  /// Поле для ввода начальной точки
  final PointField _startField;

  /// Поле для ввода конечной точки
  final PointField _endField;

  /// Создает поле для ввода линии
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  LineField({required this.config, Line? initialValue})
      : _startField = PointField(
          config: config.startConfig,
          initialValue: initialValue?.a,
        ),
        _endField = PointField(
          config: config.endConfig,
          initialValue: initialValue?.b,
        ),
        super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        );

  /// Создает валидатор на основе конфигурации
  static String? Function(Line?)? _createValidator(LineFieldConfig config) {
    return (Line? line) {
      if (line == null) return null;

      if (config.validator != null) {
        return config.validator!(line);
      }

      // Проверяем, что начальная и конечная точки не совпадают
      if (line.a.x == line.b.x && line.a.y == line.b.y) {
        return 'Начальная и конечная точки не могут совпадать';
      }

      return null;
    };
  }

  /// Получает поле для ввода начальной точки
  PointField get startField => _startField;

  /// Получает поле для ввода конечной точки
  PointField get endField => _endField;

  @override
  Line? get value {
    final startValue = _startField.value;
    final endValue = _endField.value;

    if (startValue == null || endValue == null) return null;

    return Line(a: startValue, b: endValue);
  }

  /// Проверяет, заполнены ли все поля
  bool get isComplete {
    return _startField.value != null && _endField.value != null;
  }

  @override
  set value(Line? newValue) {
    if (newValue == null) {
      _startField.value = null;
      _endField.value = null;
    } else {
      _startField.value = newValue.a;
      _endField.value = newValue.b;
    }

    validate();
  }

  @override
  String? validate() {
    // Проверяем, является ли поле обязательным и заполнены ли все поля
    if (config.isRequired && !isComplete) {
      setError('Это поле обязательно');
      return error;
    }

    // Если поля не заполнены, но поле не обязательное, то ошибки нет
    if (!isComplete) {
      setError(null);
      return null;
    }

    // Сначала валидируем поля start и end
    final startError = _startField.validate();
    if (startError != null) {
      setError(startError);
      return startError;
    }

    final endError = _endField.validate();
    if (endError != null) {
      setError(endError);
      return endError;
    }

    // Затем валидируем линию с помощью пользовательского валидатора или встроенного валидатора
    final line = value;
    if (line != null) {
      String? lineError;

      // Применяем пользовательский валидатор, если он есть
      if (config.validator != null) {
        lineError = config.validator!(line);
      }

      // Если пользовательский валидатор не вернул ошибку, применяем встроенный валидатор
      if (lineError == null && line.a.x == line.b.x && line.a.y == line.b.y) {
        lineError = 'Начальная и конечная точки не могут совпадать';
      }

      if (lineError != null) {
        setError(lineError);
        return lineError;
      }
    }

    // Если ошибок нет, сбрасываем ошибку и возвращаем null
    setError(null);
    return null;
  }

  @override
  void reset() {
    _startField.reset();
    _endField.reset();
    super.reset();
  }
}
