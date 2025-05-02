import 'package:alogrithms/alogrithms.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:flow/flow.dart';
import 'package:flutter/material.dart';
import 'package:viewer/viewer.dart';

void main() {
  runApp(const FlowExampleApp());
}

class FlowExampleApp extends StatelessWidget {
  const FlowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmProviderScope(
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

class FlowExamplePage extends StatefulWidget {
  const FlowExamplePage({super.key});

  @override
  State<FlowExamplePage> createState() => _FlowExamplePageState();
}

class _FlowExamplePageState extends State<FlowExamplePage> {
  // Выбранный алгоритм
  String? _selectedAlgorithmId;

  // Текущий FlowBuilder
  FlowBuilder? _flowBuilder;

  @override
  void initState() {
    super.initState();

    // Если есть алгоритмы, выбираем первый
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final algorithms = context.algorithms;
      if (algorithms.isNotEmpty) {
        _selectAlgorithm(algorithms.first.id);
      }
    });
  }

  // Выбор алгоритма
  void _selectAlgorithm(String algorithmId) {
    setState(() {
      _selectedAlgorithmId = algorithmId;

      // Создаем экземпляр алгоритма из провайдера
      final algorithm = context.createAlgorithm(algorithmId);

      // Создаем FlowBuilder для выбранного алгоритма
      _flowBuilder =
          AlgorithmFlowBuilderFactory(
            algorithm,
            viewerFactory: const CanvasViewerFactory(padding: 200.0),
            submitButtonText: 'Рассчитать',
            onSubmit: (_) {
              // После отправки формы выполняем расчеты и отображаем результат
              _calculateAndDraw();
            },
          ).create();
    });
  }

  // Расчет и отображение результата
  Future<void> _calculateAndDraw() async {
    if (_flowBuilder == null) return;

    try {
      // Получаем данные из формы
      await _flowBuilder!.reciveData();

      // Выполняем расчеты
      await _flowBuilder!.calculate();

      // Отображаем результат
      await _flowBuilder!.draw();

      // Показываем сообщение об успешном выполнении
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Расчеты выполнены успешно')),
        );
      }
    } catch (e) {
      // Показываем сообщение об ошибке
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем список алгоритмов из провайдера
    final algorithms = context.algorithms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Example'),
        actions: [
          // Выпадающий список алгоритмов
          DropdownButton<String>(
            value: _selectedAlgorithmId,
            onChanged: (value) {
              if (value != null) {
                _selectAlgorithm(value);
              }
            },
            items:
                algorithms.map((algorithm) {
                  return DropdownMenuItem<String>(
                    value: algorithm.id,
                    child: Text(algorithm.name),
                  );
                }).toList(),
          ),
        ],
      ),
      body:
          _flowBuilder == null
              ? const Center(child: Text('Нет доступных алгоритмов'))
              : Row(
                children: [
                  // Форма для ввода данных
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _flowBuilder!.buildDataWidget(),
                    ),
                  ),

                  // Разделитель
                  const VerticalDivider(),

                  // Область для отображения результата
                  Expanded(flex: 2, child: _flowBuilder!.buildViewerWidget()),
                ],
              ),
    );
  }
}
