import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic.dart';
import 'package:alogrithms/algorithms/registry.dart';

/// Фабрика для создания экземпляров алгоритма AlgorithmL01VBasic
class AlgorithmL01VBasicFactory
    implements AlgorithmFactory<AlgorithmL01VBasic> {
  /// Флаг для переключения между реализациями
  final bool useFormsCodegen;

  /// Конструктор фабрики
  AlgorithmL01VBasicFactory({this.useFormsCodegen = false});

  @override
  AlgorithmL01VBasic create() {
    return AlgorithmL01VBasic(useFormsCodegen: useFormsCodegen);
  }

  @override
  String get name => 'Лабораторная работа 01, Вариант 41';

  @override
  String get description =>
      'Алгоритм для обработки множества точек и их отображения на Viewer-е.';
}

/// Регистрация фабрики алгоритма в реестре
void registerAlgorithmL01VBasic() {
  // Регистрация текущей реализации
  AlgorithmRegistry.register('lab_01_41', AlgorithmL01VBasicFactory());

  // Регистрация реализации с использованием кодогенерации
  AlgorithmRegistry.register(
    'lab_01_41_codegen',
    AlgorithmL01VBasicFactory(useFormsCodegen: true),
  );
}
