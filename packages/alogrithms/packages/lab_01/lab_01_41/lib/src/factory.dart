import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска двух треугольников с максимальным отношением площадей
class AlgorithmL01V41Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V41();

  /// Название алгоритма
  @override
  String get name => 'lab_01_41';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 41';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск двух треугольников A и B, таких что отношение площадей Sa/Sb максимально. '
      'Никакие две точки обоих треугольников не совпадают. '
      'Треугольник A (с большей площадью) отображается зеленым цветом, '
      'треугольник B (с меньшей площадью) - красным.';
}
