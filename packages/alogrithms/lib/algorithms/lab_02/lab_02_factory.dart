import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:alogrithms/algorithms/lab_02/lab_02.dart';

/// Фабрика для создания экземпляров алгоритма AlgorithmL01VBasic
class AlgorithmL02Factory implements AlgorithmFactory<AlgorithmL02> {
  /// Конструктор фабрики
  const AlgorithmL02Factory();

  @override
  AlgorithmL02 create() => AlgorithmL02();

  @override
  String get title => 'Лабораторная работа 02';

  @override
  String get name => 'lab_02';

  @override
  String get description => 'Универсальная реализация ЛР2';
}
