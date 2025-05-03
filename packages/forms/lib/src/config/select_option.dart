import 'enum_select_config.dart';

/// Абстрактный интерфейс для опций выбора в EnumSelectConfig
abstract class SelectOption<T> {
  /// Возвращает значение опции
  T get value;

  /// Возвращает отображаемое название опции
  String get title;

  /// Создает опцию из значения
  static SelectOption<T> fromValue<T>(T value,
      {String Function(T)? titleBuilder}) {
    if (value is Enum) {
      return EnumSelectOptionImpl<T>(value as T, titleBuilder: titleBuilder);
    }
    return SimpleSelectOptionImpl<T>(value, titleBuilder: titleBuilder);
  }

  /// Создает список опций из списка значений
  static List<SelectOption<T>> fromValues<T>(
    List<T> values, {
    String Function(T)? titleBuilder,
  }) {
    return values
        .map((value) =>
            SelectOption.fromValue<T>(value, titleBuilder: titleBuilder))
        .toList();
  }
}

/// Реализация SelectOption для Enum
class EnumSelectOptionImpl<T> implements SelectOption<T> {
  final T _value;
  final String Function(T)? _titleBuilder;

  EnumSelectOptionImpl(this._value, {String Function(T)? titleBuilder})
      : _titleBuilder = titleBuilder;

  @override
  T get value => _value;

  @override
  String get title {
    if (_titleBuilder != null) {
      return _titleBuilder(_value);
    }

    if (_value is EnumSelectEnum) {
      return (_value as EnumSelectEnum).title;
    }

    return _value.toString();
  }
}

/// Реализация SelectOption для простых типов
class SimpleSelectOptionImpl<T> implements SelectOption<T> {
  final T _value;
  final String Function(T)? _titleBuilder;

  SimpleSelectOptionImpl(this._value, {String Function(T)? titleBuilder})
      : _titleBuilder = titleBuilder;

  @override
  T get value => _value;

  @override
  String get title {
    if (_titleBuilder != null) {
      return _titleBuilder(_value);
    }
    return _value.toString();
  }
}
