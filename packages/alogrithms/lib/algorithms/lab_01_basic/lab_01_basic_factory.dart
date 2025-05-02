import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic.dart';
import 'package:alogrithms/algorithms/registry.dart';

/// Фабрика для создания экземпляров алгоритма AlgorithmL01VBasic
class AlgorithmL01VBasicFactory
    implements AlgorithmFactory<AlgorithmL01VBasic> {
  /// Конструктор фабрики
  const AlgorithmL01VBasicFactory();

  @override
  AlgorithmL01VBasic create() => AlgorithmL01VBasic();

  @override
  String get title => 'Ввод точек';

  @override
  String get name => 'lab_01_basic';

  @override
  String get description => 'Просто для дебага.';
}
