import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска двух треугольников с минимальным отношением периметров
class AlgorithmL01V42Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V42();

  /// Название алгоритма
  @override
  String get name => 'lab_01_42';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 42';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск двух треугольников A и B, таких что отношение периметров Pa/Pb минимально. '
      'Никакие две точки обоих треугольников не совпадают. '
      'Треугольник A (с большим периметром) отображается зеленым цветом, '
      'треугольник B (с меньшим периметром) - красным.';
}
