import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника максимального периметра
class AlgorithmL01V55Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V55();

  /// Название алгоритма
  @override
  String get name => 'lab_01_55';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 55';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника максимального периметра, образованного точками так, '
      'чтобы все три точки не принадлежали одному из множеств. '
      'Треугольник отображается зеленым цветом, остальные точки из первого множества - синим, '
      'а остальные точки из второго множества - красным.';
}
