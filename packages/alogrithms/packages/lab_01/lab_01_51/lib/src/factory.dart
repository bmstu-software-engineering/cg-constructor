import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника максимального периметра
class AlgorithmL01V51Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V51();

  /// Название алгоритма
  @override
  String get name => 'lab_01_51';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 51';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск двух точек из первого множества и точки из второго, '
      'образующих треугольник максимального периметра. '
      'Треугольник отображается зеленым цветом, остальные точки из первого множества - синим, '
      'а остальные точки из второго множества - красным.';
}
