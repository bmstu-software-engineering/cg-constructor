import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';
import 'package:models_ns/models_ns.dart';

/// Пример использования пакета figure_io в реальном приложении
void main() {
  runApp(const FigureIOExampleApp());
}

/// Пример приложения для демонстрации работы пакета figure_io
class FigureIOExampleApp extends StatelessWidget {
  /// Создает пример приложения
  const FigureIOExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figure IO Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FigureIOExampleScreen(),
    );
  }
}

/// Экран с примером использования виджета для чтения фигур
class FigureIOExampleScreen extends StatefulWidget {
  /// Создает экран с примером
  const FigureIOExampleScreen({super.key});

  @override
  State<FigureIOExampleScreen> createState() => _FigureIOExampleScreenState();
}

class _FigureIOExampleScreenState extends State<FigureIOExampleScreen> {
  /// Сервис для чтения фигур
  final _figureReader = FigureReader();

  /// Загруженная коллекция фигур
  FigureCollection? _figureCollection;

  @override
  void dispose() {
    _figureReader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Figure IO Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Виджет для чтения фигур
            FigureReaderWidget(
              buttonText: 'Выбрать JSON-файл с фигурами',
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

                // Также отправляем фигуры в наш Stream для демонстрации
                _figureReader.readFromString(figures.toJsonString());
              },
            ),
            const SizedBox(height: 24),

            // Отображение информации о загруженных фигурах
            if (_figureCollection != null) ...[
              Text(
                'Загруженные фигуры:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Информация о точках
              _buildFigureInfo(
                context,
                'Точки',
                _figureCollection!.points.length,
                Icons.circle,
                Colors.blue,
              ),
              const SizedBox(height: 8),

              // Информация о линиях
              _buildFigureInfo(
                context,
                'Линии',
                _figureCollection!.lines.length,
                Icons.linear_scale,
                Colors.green,
              ),
              const SizedBox(height: 8),

              // Информация о треугольниках
              _buildFigureInfo(
                context,
                'Треугольники',
                _figureCollection!.triangles.length,
                Icons.change_history,
                Colors.orange,
              ),
              const SizedBox(height: 24),

              // Пример использования Stream
              Text(
                'Пример использования Stream:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // StreamBuilder для отображения данных из Stream
              StreamBuilder<FigureCollection>(
                stream: _figureReader.figuresStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final figures = snapshot.data!;
                    return Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Данные получены из Stream:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Всего фигур: $figures',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Ожидание данных из Stream...'),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Создает виджет с информацией о фигурах определенного типа
  Widget _buildFigureInfo(
    BuildContext context,
    String title,
    int count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text('$title: $count', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
