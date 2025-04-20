import 'package:alogrithms/algorithms/lab_01_40.dart';
import 'package:alogrithms/algorithms/registry.dart';
import 'package:alogrithms/src/algorithm_interface.dart';

/// Фабрика для создания экземпляров алгоритма AlgorithmL01V40
class AlgorithmL01V40Factory implements AlgorithmFactory<AlgorithmL01V40> {
  @override
  AlgorithmL01V40 create() {
    return AlgorithmL01V40();
  }

  @override
  String get name => 'Лабораторная работа 01, Вариант 40';

  @override
  String get description =>
      'Алгоритм для поиска прямой с максимальным углом к оси абсцисс, '
      'соединяющей вершины с тупыми углами из двух множеств треугольников. '
      'Первый треугольник отображается зеленым цветом, второй - синим, '
      'а результирующая линия - красным.';
}

/// Регистрация фабрики алгоритма в реестре
void registerAlgorithmL01V40() {
  AlgorithmRegistry.register('lab_01_40', AlgorithmL01V40Factory());
}
