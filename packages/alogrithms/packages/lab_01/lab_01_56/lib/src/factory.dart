import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника минимальной площади
class AlgorithmL01V56Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V56();

  /// Название алгоритма
  @override
  String get name => 'lab_01_56';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 56';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника минимальной площади, образованного точками так, '
      'чтобы все три точки не принадлежали одному из множеств. '
      'Треугольник отображается зеленым цветом, остальные точки из первого множества - синим, '
      'а остальные точки из второго множества - красным.';
}
