import '../core/diagnosticable_form_field.dart';

/// Базовая реализация поля формы
class BaseFormField<T> extends DiagnosticableFormField<T> {
  /// Текущее значение поля
  T? _value;

  /// Ошибка валидации
  String? _error;

  /// Функция валидации
  final String? Function(T?)? _validator;

  /// Является ли поле обязательным
  final bool _isRequired;

  /// Создает базовое поле формы
  ///
  /// [initialValue] - начальное значение поля
  /// [validator] - функция валидации
  /// [isRequired] - является ли поле обязательным
  BaseFormField({
    T? initialValue,
    String? Function(T?)? validator,
    bool isRequired = true,
  })  : _value = initialValue,
        _validator = validator,
        _isRequired = isRequired;

  @override
  T? get value => _value;

  @override
  set value(T? newValue) {
    _value = newValue;
    validate();
  }

  @override
  String? get error => _error;

  @override
  String? validate() {
    if (_isRequired && _value == null) {
      // throw UnimplementedError();
      _error = 'Это поле обязательно';
      return _error;
    }

    if (_validator != null) {
      _error = _validator(_value);
      return _error;
    }

    _error = null;
    return null;
  }

  @override
  void reset() {
    _value = null;
    _error = null;
  }

  @override
  bool isValid() => validate() == null;

  /// Устанавливает ошибку валидации напрямую
  /// Этот метод используется для установки ошибок, которые не связаны с валидацией значения
  void setError(String? errorMessage) {
    _error = errorMessage;
  }
}
