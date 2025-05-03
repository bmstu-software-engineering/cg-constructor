/// Базовый класс для всех исключений алгоритмов
abstract class AlgorithmException implements Exception {
  final String message;

  AlgorithmException(this.message);

  @override
  String toString() => message;
}
