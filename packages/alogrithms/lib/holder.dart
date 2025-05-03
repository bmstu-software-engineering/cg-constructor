import 'package:algorithm_interface/algorithm_interface.dart';

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
