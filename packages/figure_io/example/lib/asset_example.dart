import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:figure_io/figure_io.dart';
import 'package:models_ns/models_ns.dart';

/// Пример загрузки фигур из ассетов
void main() {
  runApp(const AssetExampleApp());
}

/// Приложение для демонстрации загрузки фигур из ассетов
class AssetExampleApp extends StatelessWidget {
  /// Создает приложение
  const AssetExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Figure IO Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const AssetExampleScreen(),
    );
  }
}

/// Экран с примером загрузки фигур из ассетов
class AssetExampleScreen extends StatefulWidget {
  /// Создает экран с примером
  const AssetExampleScreen({super.key});

  @override
  State<AssetExampleScreen> createState() => _AssetExampleScreenState();
}

class _AssetExampleScreenState extends State<AssetExampleScreen> {
  /// Сервис для чтения фигур
  final _figureReader = FigureReader();

  /// Загруженная коллекция фигур
  FigureCollection? _figureCollection;

  /// Флаг загрузки
  bool _isLoading = false;

  @override
  void dispose() {
    _figureReader.dispose();
    super.dispose();
  }

  /// Загружает фигуры из ассета
  Future<void> _loadFromAsset() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Загружаем JSON из ассета
      final jsonString = await rootBundle.loadString(
        'assets/example_figures.json',
      );

      // Читаем фигуры из JSON
      final collection = await _figureReader.readFromString(jsonString);

      setState(() {
        _figureCollection = collection;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Показываем ошибку
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Загрузка из ассетов'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка для загрузки из ассета
            ElevatedButton(
              onPressed: _isLoading ? null : _loadFromAsset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Загрузить из ассета'),
            ),
            const SizedBox(height: 20),

            // Отображение информации о загруженных фигурах
            if (_figureCollection != null) ...[
              Text(
                'Загружено из ассета:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 20),

              // Пример использования Stream
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
                  return const SizedBox.shrink();
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text('$title: $count', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
