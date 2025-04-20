/// Интерфейс для модели формы
abstract class FormModel {
  /// Проверяет, валидна ли форма
  bool isValid();

  /// Валидирует все поля формы
  void validate();

  /// Сбрасывает все поля формы
  void reset();
}
