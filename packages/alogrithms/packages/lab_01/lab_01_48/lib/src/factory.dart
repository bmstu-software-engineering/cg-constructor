import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника максимальной площади, внутри описанной окружности которого располагается заданная точка
class AlgorithmL01V48Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V48();

  /// Название алгоритма
  @override
  String get name => 'lab_01_48';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 48';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника максимальной площади, внутри описанной окружности которого располагается заданная точка pB. '
      'Треугольник отображается зеленым цветом, '
      'центр описанной окружности - голубым, '
      'точка pB - красным, '
      'остальные точки множества - серым.';
}
