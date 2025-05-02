import 'package:alogrithms/src/algorithm_interface.dart';

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

abstract interface class AlgorithmsHolder {
  void registerAll(List<AlgorithmFactory> algorithmsFactories);
  void unregister(AlgorithmFactory algorithmFactory);

  List<AlgorithmInfo> get algorithmsInfo;
  AlgorithmFactory get(String name);
  bool has(String name);
}

/// Информация об алгоритме
class AlgorithmInfo {
  /// Уникальный идентификатор алгоритма
  final String id;

  /// Название алгоритма
  final String name;

  /// Описание алгоритма
  final String description;

  const AlgorithmInfo({
    required this.id,
    required this.name,
    required this.description,
  });

  static AlgorithmInfo fromFactory(AlgorithmFactory entry) => AlgorithmInfo(
    id: entry.name,
    name: entry.title,
    description: entry.description,
  );
}
