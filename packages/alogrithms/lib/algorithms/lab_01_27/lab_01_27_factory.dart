import 'package:alogrithms/algorithms/registry.dart';
import 'lab_01_27.dart';

/// Фабрика для создания алгоритма поиска треугольника с максимальной разностью
class AlgorithmL01V27Factory implements AlgorithmFactory<AlgorithmL01V27> {
  @override
  AlgorithmL01V27 create() {
    return AlgorithmL01V27();
  }

  @override
  String get name => 'lab_01_27';

  @override
  String get title => 'Лабораторная работа 01, Вариант 27';

  @override
  String get description =>
      'Поиск треугольника, максимизирующего разность между количеством точек '
      'в подтреугольниках, образованных медианами. '
      'Треугольник отображается зеленым цветом, медианы - синим, '
      'подтреугольник с максимальным количеством точек - красным, '
      'а с минимальным - пурпурным.';
}
