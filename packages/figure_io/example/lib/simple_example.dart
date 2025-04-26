import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';

/// Простой пример использования виджета для чтения фигур
void main() {
  runApp(const SimpleExampleApp());
}

/// Простое приложение для демонстрации работы виджета FigureReaderWidget
class SimpleExampleApp extends StatelessWidget {
  /// Создает простое приложение
  const SimpleExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Figure IO Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SimpleExampleScreen(),
    );
  }
}

/// Экран с простым примером использования виджета для чтения фигур
class SimpleExampleScreen extends StatefulWidget {
  /// Создает экран с простым примером
  const SimpleExampleScreen({super.key});

  @override
  State<SimpleExampleScreen> createState() => _SimpleExampleScreenState();
}

class _SimpleExampleScreenState extends State<SimpleExampleScreen> {
  /// Загруженная коллекция фигур
  FigureCollection? _figureCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Простой пример Figure IO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Виджет для чтения фигур
            FigureReaderWidget(
              buttonText: 'Выбрать файл с фигурами',
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onFiguresLoaded: (figures) {
                setState(() {
                  _figureCollection = figures;
                });
              },
            ),
            const SizedBox(height: 20),
            
            // Отображение информации о загруженных фигурах
            if (_figureCollection != null) ...[
              Text(
                'Загружено:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text('Точек: ${_figureCollection!.points.length}'),
              Text('Линий: ${_figureCollection!.lines.length}'),
              Text('Треугольников: ${_figureCollection!.triangles.length}'),
              const SizedBox(height: 20),
              
              // Пример подписки на Stream
              StreamBuilder<FigureCollection>(
                stream: _figureCollection!.points.isEmpty
                    ? null
                    : Stream.value(_figureCollection!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Данные получены из Stream',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
