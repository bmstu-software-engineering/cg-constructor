import 'package:alogrithms/alogrithms.dart';
import 'package:alogrithms/algorithms/registry.dart';
import 'package:alogrithms/src/algorithm_provider.dart';
import 'package:flutter/widgets.dart';

import 'custom_algorithm_provider.dart';
import 'example_algorithm_with_variants.dart';

/// Кастомный провайдер алгоритмов, который добавляет наш алгоритм с вариантами
class CustomAlgorithmProviderScope extends StatefulWidget {
  final Widget child;
  final ExampleAlgorithmWithVariants exampleWithVariants;

  const CustomAlgorithmProviderScope({
    super.key,
    required this.child,
    required this.exampleWithVariants,
  });

  @override
  State<CustomAlgorithmProviderScope> createState() =>
      _CustomAlgorithmProviderScopeState();
}

class _CustomAlgorithmProviderScopeState
    extends State<CustomAlgorithmProviderScope> {
  late final AlgorithmsHolder _holder;

  @override
  void initState() {
    super.initState();

    // Создаем держатель алгоритмов
    _holder = _createAlgorithmsHolder();
  }

  /// Создает держатель алгоритмов с нашим алгоритмом
  AlgorithmsHolder _createAlgorithmsHolder() {
    // Создаем фабрику для нашего алгоритма
    final factory = ExampleWithVariantsFactory(widget.exampleWithVariants);

    // Создаем держатель алгоритмов
    final holder = _AlgorithmsHolderImpl();

    // Регистрируем наш алгоритм
    holder.registerAll([factory]);

    return holder;
  }

  @override
  Widget build(BuildContext context) {
    return AlgorithmProvider(_holder, child: widget.child);
  }
}

/// Реализация держателя алгоритмов
class _AlgorithmsHolderImpl implements AlgorithmsHolder {
  final Map<String, AlgorithmFactory> _map = {};

  _AlgorithmsHolderImpl();

  @override
  List<AlgorithmInfo> get algorithmsInfo =>
      _map.values.map((e) => AlgorithmInfo.fromFactory(e)).toList();

  @override
  AlgorithmFactory get(String name) =>
      _map[name] ?? (throw Exception('Algorithm $name not registered'));

  @override
  bool has(String name) => _map.containsKey(name);

  @override
  void registerAll(List<AlgorithmFactory> algorithmsFactories) =>
      _map.addAll(Map.fromIterable(algorithmsFactories, key: (e) => e.name));

  @override
  void unregister(AlgorithmFactory algorithmFactory) =>
      _map.remove(algorithmFactory.name);
}
