import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника с максимальной разностью
class AlgorithmL01V27Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V27();

  /// Название алгоритма
  @override
  String get name => 'lab_01_27';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 27';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника, максимизирующего разность между количеством точек '
      'в подтреугольниках, образованных медианами. '
      'Треугольник отображается зеленым цветом, медианы - синим, '
      'подтреугольник с максимальным количеством точек - красным, '
      'а с минимальным - пурпурным.';
}
