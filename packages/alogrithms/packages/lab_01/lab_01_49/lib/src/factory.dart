import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника минимального периметра
class AlgorithmL01V49Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V49();

  /// Название алгоритма
  @override
  String get name => 'lab_01_49';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 49';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника минимального периметра, внутри описанной окружности '
      'которого располагается заданная точка. '
      'Треугольник отображается зеленым цветом, описанная окружность - синим, '
      'а контрольная точка - красным.';
}
