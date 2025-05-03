import 'package:alogrithms/alogrithms.dart';

import 'example_algorithm_with_variants.dart';

/// Фабрика для создания алгоритма с вариантами
class ExampleWithVariantsFactory implements AlgorithmFactory<Algorithm> {
  final ExampleAlgorithmWithVariants _algorithm;

  ExampleWithVariantsFactory(this._algorithm);

  @override
  String get name => 'example_with_variants';

  @override
  String get title => 'Пример с вариантами';

  @override
  String get description =>
      'Пример алгоритма, поддерживающего различные варианты расчета (круг, квадрат, треугольник)';

  @override
  Algorithm create() => _algorithm;
}
