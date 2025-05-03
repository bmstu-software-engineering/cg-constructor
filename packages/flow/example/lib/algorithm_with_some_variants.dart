import 'package:alogrithms/alogrithms.dart';
import 'package:example/src/algorithm_with_some_variants/custom_algorithm_provider.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'src/algorithm_with_some_variants/example_algorithm_with_variants.dart';

void main() {
  runApp(const FlowExampleApp());
}

class FlowExampleApp extends StatelessWidget {
  const FlowExampleApp({super.key});

  // Создаем экземпляр нашего алгоритма с вариантами
  static final exampleWithVariants = ExampleAlgorithmWithVariants();

  @override
  Widget build(BuildContext context) {
    // Создаем кастомный провайдер алгоритмов с нашим алгоритмом

    return AlgorithmProvider(
      algorithmsFactories: [ExampleWithVariantsFactory(exampleWithVariants)],
      child: MaterialApp(
        title: 'Flow Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FlowExamplePage(),
      ),
    );
  }
}
