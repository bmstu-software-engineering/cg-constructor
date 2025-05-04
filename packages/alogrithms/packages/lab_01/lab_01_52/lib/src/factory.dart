import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника минимальной площади
class AlgorithmL01V52Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V52();

  /// Название алгоритма
  @override
  String get name => 'lab_01_52';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 52';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника минимальной площади, образованного '
      'точкой из первого множества и двумя точками из второго. '
      'Треугольник отображается зеленым цветом, остальные точки из первого множества - красным, '
      'а остальные точки из второго множества - синим.';
}
