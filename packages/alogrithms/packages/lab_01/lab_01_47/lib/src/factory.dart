import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника максимального периметра, внутри которого располагается заданная точка
class AlgorithmL01V47Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V47();

  /// Название алгоритма
  @override
  String get name => 'lab_01_47';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 47';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника максимального периметра, внутри которого располагается заданная точка pB. '
      'Треугольник отображается зеленым цветом, '
      'точка pB - красным, '
      'остальные точки множества - синим.';
}
