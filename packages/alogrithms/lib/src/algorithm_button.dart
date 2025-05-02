/// Класс для описания кнопки алгоритма
class AlgorithmButton {
  /// Текст кнопки
  final String text;

  /// Обработчик нажатия на кнопку
  final void Function(Map<String, dynamic>)? onPressed;

  /// Конструктор
  const AlgorithmButton({required this.text, this.onPressed});
}
