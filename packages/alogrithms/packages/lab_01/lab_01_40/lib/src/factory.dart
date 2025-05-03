import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания экземпляров алгоритма AlgorithmL01V40
class AlgorithmL01V40Factory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  AlgorithmL01V40 create() {
    return AlgorithmL01V40();
  }

  /// Название алгоритма
  @override
  String get title => 'Лабораторная работа 01, Вариант 40';

  /// Описание алгоритма
  @override
  String get description =>
      'Алгоритм для поиска прямой с максимальным углом к оси абсцисс, '
      'соединяющей вершины с тупыми углами из двух множеств треугольников. '
      'Первый треугольник отображается зеленым цветом, второй - синим, '
      'а результирующая линия - красным.';

  /// Имя алгоритма
  @override
  String get name => 'lab_01_40';
}
