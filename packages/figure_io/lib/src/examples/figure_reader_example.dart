import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';
import 'package:models_ns/models_ns.dart';

/// Пример использования виджета для чтения фигур
class FigureReaderExample extends StatefulWidget {
  /// Создает пример использования виджета для чтения фигур
  const FigureReaderExample({super.key});

  @override
  State<FigureReaderExample> createState() => _FigureReaderExampleState();
}

class _FigureReaderExampleState extends State<FigureReaderExample> {
  /// Загруженная коллекция фигур
  FigureCollection? _figureCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример чтения фигур')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Виджет для чтения фигур
            FigureReaderWidget(
              buttonText: 'Выбрать файл с фигурами',
              buttonStyle: ElevatedButton.styleFrom(
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
              Text('Загружено:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text('Точек: ${_figureCollection!.points.length}'),
              Text('Линий: ${_figureCollection!.lines.length}'),
              Text('Треугольников: ${_figureCollection!.triangles.length}'),
              const SizedBox(height: 20),
              // Пример подписки на Stream
              StreamBuilder<FigureCollection>(
                stream:
                    _figureCollection!.points.isEmpty
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
