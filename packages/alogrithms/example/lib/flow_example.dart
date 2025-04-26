import 'package:alogrithms/algorithms/registry.dart';
import 'package:flow/flow.dart';
import 'package:flutter/material.dart';
import 'package:viewer/viewer.dart';

void main() {
  // Регистрируем алгоритмы при запуске приложения
  registerAlgorithms();

  runApp(const FlowExampleApp());
}

class FlowExampleApp extends StatelessWidget {
  const FlowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlowExamplePage(),
    );
  }
}

class FlowExamplePage extends StatefulWidget {
  const FlowExamplePage({super.key});

  @override
  State<FlowExamplePage> createState() => _FlowExamplePageState();
}

class _FlowExamplePageState extends State<FlowExamplePage> {
  // Список доступных алгоритмов
  late final List<AlgorithmInfo> _algorithms;

  // Выбранный алгоритм
  String? _selectedAlgorithmId;

  // Текущий FlowBuilder
  FlowBuilder? _flowBuilder;

  @override
  void initState() {
    super.initState();

    // Получаем список доступных алгоритмов
    _algorithms = AlgorithmRegistry.getAlgorithmsInfo();

    // Если есть алгоритмы, выбираем первый
    if (_algorithms.isNotEmpty) {
      _selectAlgorithm(_algorithms.first.id);
    }
  }

  // Выбор алгоритма
  void _selectAlgorithm(String algorithmId) {
    setState(() {
      _selectedAlgorithmId = algorithmId;

      // Создаем FlowBuilder для выбранного алгоритма
      _flowBuilder =
          GenericAlgorithmFlowFactory(
            algorithmId,
            viewerFactory: const CanvasViewerFactory(),
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
                _algorithms.map((algorithm) {
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
