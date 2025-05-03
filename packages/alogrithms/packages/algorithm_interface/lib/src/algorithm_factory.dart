import 'algorithm_interface.dart';

/// Фабрика для создания экземпляров алгоритмов
abstract class AlgorithmFactory<T extends Algorithm> {
  /// Создает новый экземпляр алгоритма
  T create();

  /// Возвращает имя алгоритма
  String get name;

  /// Возвращается название в UI-е
  String get title;

  /// Возвращает описание алгоритма
  String get description;
}
