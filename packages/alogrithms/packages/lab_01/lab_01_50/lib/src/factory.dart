import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания алгоритма поиска треугольника, включающего в себя большее число точек
class AlgorithmL01V50Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01V50();

  /// Название алгоритма
  @override
  String get name => 'lab_01_50';

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 50';

  /// Описание алгоритма
  @override
  String get description =>
      'Поиск треугольника, включающего в себя большее число точек. '
      'Треугольник отображается зеленым цветом, точки внутри треугольника - красным, '
      'а точки вне треугольника - синим.';
}
