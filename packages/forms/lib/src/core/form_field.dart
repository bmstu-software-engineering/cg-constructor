/// Интерфейс для поля формы
abstract class FormField<T> {
  /// Текущее значение поля
  T? get value;

  /// Устанавливает значение поля
  set value(T? newValue);

  /// Ошибка валидации (null, если ошибок нет)
  String? get error;

  /// Валидирует поле и возвращает результат
  String? validate();

  /// Сбрасывает значение поля
  void reset();
}
