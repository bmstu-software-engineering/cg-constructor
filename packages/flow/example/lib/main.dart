import 'package:alogrithms/alogrithms.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:flow/flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rxdart/rxdart.dart';
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

  @override
  void dispose() {
    // Закрываем поток при уничтожении виджета
    _flowBuilder?.dispose();
    super.dispose();
  }

  // Выбор алгоритма
  void _selectAlgorithm(String algorithmId) {
    // Закрываем предыдущий поток
    _flowBuilder?.dispose();

    setState(() {
      _selectedAlgorithmId = algorithmId;

      // Создаем экземпляр алгоритма из провайдера
      final algorithm = context.createAlgorithm(algorithmId);

      // Создаем FlowBuilder для выбранного алгоритма
      _flowBuilder =
          AlgorithmFlowBuilderFactory(
            algorithm,
            viewerFactory: const CanvasViewerFactory(padding: 200.0),
          ).create();
    });
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
              : Column(
                children: [
                  Expanded(
                    child: Row(
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
                        Expanded(
                          flex: 2,
                          child: _flowBuilder!.buildViewerWidget(),
                        ),
                      ],
                    ),
                  ),

                  // Область для отображения информационных сообщений
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(top: BorderSide(color: Colors.grey[400]!)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Информационные сообщения:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _Messages(_flowBuilder?.infoStream),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class _Messages extends StatelessWidget {
  _Messages(this._infoStream);

  final _scrollController = ScrollController();
  final BehaviorSubject<List<String>>? _infoStream;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          _infoStream == null
              ? const Center(child: Text('Нет сообщений'))
              : StreamBuilder<List<String>>(
                stream: _infoStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет сообщений'));
                  }

                  _scrollToBottom();

                  // Получаем список сообщений
                  final messages = snapshot.requireData;

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: MarkdownBody(data: messages[index]),
                      );
                    },
                  );
                },
              ),
    );
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback(
    (_) => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
  );
}
