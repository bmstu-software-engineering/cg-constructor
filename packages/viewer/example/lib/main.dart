import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'coordinates_demo.dart';
import 'point_input_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viewer Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Модель данных для вариантов демонстрации
class DemoOption {
  final String title;
  final String description;
  final Widget Function(BuildContext) builder;

  const DemoOption({
    required this.title,
    required this.description,
    required this.builder,
  });
}

/// Главный экран с выбором вариантов демонстрации
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DemoOption> options = [
      DemoOption(
        title: 'Пустой виджет',
        description: 'Viewer без точек и линий',
        builder: (context) => const EmptyViewerDemo(),
      ),
      DemoOption(
        title: 'Виджет с точками',
        description: 'Viewer с набором точек разных цветов',
        builder: (context) => const PointsViewerDemo(),
      ),
      DemoOption(
        title: 'Виджет с линиями',
        description: 'Viewer с набором линий разных цветов',
        builder: (context) => const LinesViewerDemo(),
      ),
      DemoOption(
        title: 'Виджет с точками и линиями',
        description: 'Viewer с комбинацией точек и линий',
        builder: (context) => const PointsAndLinesViewerDemo(),
      ),
      DemoOption(
        title: 'Виджет с отображением координат',
        description:
            'Viewer с возможностью включения/выключения отображения координат',
        builder: (context) => const CoordinatesViewerDemo(),
      ),
      DemoOption(
        title: 'Два пустых виджета рядом',
        description: 'Два пустых Viewer расположены рядом',
        builder: (context) => const TwoViewersDemo(),
      ),
      DemoOption(
        title: 'Два виджета с точками рядом',
        description: 'Два Viewer с точками расположены рядом',
        builder: (context) => const TwoViewersWithPointsDemo(),
      ),
      DemoOption(
        title: 'Два виджета с линиями рядом',
        description: 'Два Viewer с линиями расположены рядом',
        builder: (context) => const TwoViewersWithLinesDemo(),
      ),
      DemoOption(
        title: 'Два виджета с точками и линиями рядом',
        description: 'Два Viewer с точками и линиями расположены рядом',
        builder: (context) => const TwoViewersWithPointsAndLinesDemo(),
      ),
      DemoOption(
        title: 'Два виджета с разными настройками координат',
        description: 'Два Viewer с разными настройками отображения координат',
        builder: (context) => const TwoViewersWithCoordinatesDemo(),
      ),
      DemoOption(
        title: 'Три виджета с точками и линиями рядом',
        description: 'Три Viewer с точками и линиями расположены рядом',
        builder: (context) => const ThreeViewersWithPointsAndLinesDemo(),
      ),
      DemoOption(
        title: 'Ввод точек по нажатию',
        description: 'Viewer с возможностью добавления точек по нажатию',
        builder: (context) => const PointInputDemo(),
      ),
      DemoOption(
        title: 'Два виджета с вводом точек',
        description: 'Два Viewer с разными настройками ввода точек',
        builder: (context) => const TwoViewersWithPointInputDemo(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Демонстрация Viewer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(option.title),
              subtitle: Text(option.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DemoScreen(option: option),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Экран демонстрации выбранного варианта
class DemoScreen extends StatelessWidget {
  final DemoOption option;

  const DemoScreen({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: option.builder(context),
    );
  }
}

/// Демонстрация пустого Viewer
class EmptyViewerDemo extends StatefulWidget {
  const EmptyViewerDemo({super.key});

  @override
  State<EmptyViewerDemo> createState() => _EmptyViewerDemoState();
}

class _EmptyViewerDemoState extends State<EmptyViewerDemo> {
  late final Viewer _viewer;

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _viewer.clean(); // Убедимся, что Viewer пустой
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _viewer.buildWidget(),
    );
  }
}

/// Демонстрация Viewer с точками
class PointsViewerDemo extends StatefulWidget {
  const PointsViewerDemo({super.key});

  @override
  State<PointsViewerDemo> createState() => _PointsViewerDemoState();
}

class _PointsViewerDemoState extends State<PointsViewerDemo> {
  late final Viewer _viewer;
  List<Point> _points = [];

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _generatePoints();
  }

  void _generatePoints() {
    _points = [
      const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      const Point(x: 100, y: 200, color: '#FF00FF', thickness: 5),
    ];
    _viewer.draw([], _points);
  }

  void _clearCanvas() {
    setState(() {
      _viewer.clean();
      _points = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _viewer.buildWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generatePoints();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация Viewer с линиями
class LinesViewerDemo extends StatefulWidget {
  const LinesViewerDemo({super.key});

  @override
  State<LinesViewerDemo> createState() => _LinesViewerDemoState();
}

class _LinesViewerDemoState extends State<LinesViewerDemo> {
  late final Viewer _viewer;
  List<Line> _lines = [];

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _generateLines();
  }

  void _generateLines() {
    // Создаем точки для линий
    final points = [
      const Point(x: 50, y: 50),
      const Point(x: 150, y: 50),
      const Point(x: 150, y: 150),
      const Point(x: 50, y: 150),
      const Point(x: 100, y: 200),
    ];

    // Создаем линии
    _lines = [
      Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
      Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
      Line(a: points[2], b: points[3], color: '#0000FF', thickness: 2),
      Line(a: points[3], b: points[0], color: '#FFFF00', thickness: 2),
      Line(a: points[0], b: points[2], color: '#FF00FF', thickness: 2),
      Line(a: points[1], b: points[3], color: '#00FFFF', thickness: 2),
    ];

    _viewer.draw(_lines, []);
  }

  void _clearCanvas() {
    setState(() {
      _viewer.clean();
      _lines = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _viewer.buildWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateLines();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация Viewer с точками и линиями
class PointsAndLinesViewerDemo extends StatefulWidget {
  const PointsAndLinesViewerDemo({super.key});

  @override
  State<PointsAndLinesViewerDemo> createState() =>
      _PointsAndLinesViewerDemoState();
}

class _PointsAndLinesViewerDemoState extends State<PointsAndLinesViewerDemo> {
  late final Viewer _viewer;
  List<Point> _points = [];
  List<Line> _lines = [];

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _generateExample();
  }

  void _generateExample() {
    // Создаем точки
    _points = [
      const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      const Point(x: 100, y: 200, color: '#FF00FF', thickness: 5),
    ];

    // Создаем линии
    _lines = [
      Line(a: _points[0], b: _points[1], color: '#FF0000', thickness: 2),
      Line(a: _points[1], b: _points[2], color: '#00FF00', thickness: 2),
      Line(a: _points[2], b: _points[3], color: '#0000FF', thickness: 2),
      Line(a: _points[3], b: _points[0], color: '#FFFF00', thickness: 2),
      Line(a: _points[0], b: _points[2], color: '#FF00FF', thickness: 2),
      Line(a: _points[1], b: _points[3], color: '#00FFFF', thickness: 2),
      Line(a: _points[3], b: _points[4], color: '#FF0000', thickness: 2),
      Line(a: _points[2], b: _points[4], color: '#00FF00', thickness: 2),
    ];

    // Отрисовываем на холсте
    _viewer.draw(_lines, _points);
  }

  void _clearCanvas() {
    setState(() {
      _viewer.clean();
      _points = [];
      _lines = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _viewer.buildWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateExample();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух пустых Viewer рядом
class TwoViewersDemo extends StatefulWidget {
  const TwoViewersDemo({super.key});

  @override
  State<TwoViewersDemo> createState() => _TwoViewersDemoState();
}

class _TwoViewersDemoState extends State<TwoViewersDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create();
    _viewer2 = CanvasViewerFactory().create();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer2.buildWidget(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Два пустых Viewer рядом',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух Viewer с точками рядом
class TwoViewersWithPointsDemo extends StatefulWidget {
  const TwoViewersWithPointsDemo({super.key});

  @override
  State<TwoViewersWithPointsDemo> createState() =>
      _TwoViewersWithPointsDemoState();
}

class _TwoViewersWithPointsDemoState extends State<TwoViewersWithPointsDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  List<Point> _points1 = [];
  List<Point> _points2 = [];

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create();
    _viewer2 = CanvasViewerFactory().create();
    _generatePoints();
  }

  void _generatePoints() {
    // Точки для первого Viewer
    _points1 = [
      const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
    ];

    // Точки для второго Viewer
    _points2 = [
      const Point(x: 50, y: 50, color: '#FFFF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#FF00FF', thickness: 5),
      const Point(x: 100, y: 200, color: '#00FFFF', thickness: 5),
    ];

    // Отрисовываем на холстах
    _viewer1.draw([], _points1);
    _viewer2.draw([], _points2);
  }

  void _clearCanvas() {
    setState(() {
      _viewer1.clean();
      _viewer2.clean();
      _points1 = [];
      _points2 = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer2.buildWidget(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generatePoints();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух Viewer с линиями рядом
class TwoViewersWithLinesDemo extends StatefulWidget {
  const TwoViewersWithLinesDemo({super.key});

  @override
  State<TwoViewersWithLinesDemo> createState() =>
      _TwoViewersWithLinesDemoState();
}

class _TwoViewersWithLinesDemoState extends State<TwoViewersWithLinesDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  List<Line> _lines1 = [];
  List<Line> _lines2 = [];

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create();
    _viewer2 = CanvasViewerFactory().create();
    _generateLines();
  }

  void _generateLines() {
    // Точки для первого Viewer
    final points1 = [
      const Point(x: 50, y: 50),
      const Point(x: 150, y: 50),
      const Point(x: 150, y: 150),
      const Point(x: 50, y: 150),
    ];

    // Линии для первого Viewer
    _lines1 = [
      Line(a: points1[0], b: points1[1], color: '#FF0000', thickness: 2),
      Line(a: points1[1], b: points1[2], color: '#00FF00', thickness: 2),
      Line(a: points1[2], b: points1[3], color: '#0000FF', thickness: 2),
      Line(a: points1[3], b: points1[0], color: '#FFFF00', thickness: 2),
    ];

    // Точки для второго Viewer
    final points2 = [
      const Point(x: 50, y: 50),
      const Point(x: 150, y: 50),
      const Point(x: 100, y: 150),
    ];

    // Линии для второго Viewer
    _lines2 = [
      Line(a: points2[0], b: points2[1], color: '#FF00FF', thickness: 2),
      Line(a: points2[1], b: points2[2], color: '#00FFFF', thickness: 2),
      Line(a: points2[2], b: points2[0], color: '#FF0000', thickness: 2),
    ];

    // Отрисовываем на холстах
    _viewer1.draw(_lines1, []);
    _viewer2.draw(_lines2, []);
  }

  void _clearCanvas() {
    setState(() {
      _viewer1.clean();
      _viewer2.clean();
      _lines1 = [];
      _lines2 = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer2.buildWidget(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateLines();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух Viewer с точками и линиями рядом
class TwoViewersWithPointsAndLinesDemo extends StatefulWidget {
  const TwoViewersWithPointsAndLinesDemo({super.key});

  @override
  State<TwoViewersWithPointsAndLinesDemo> createState() =>
      _TwoViewersWithPointsAndLinesDemoState();
}

class _TwoViewersWithPointsAndLinesDemoState
    extends State<TwoViewersWithPointsAndLinesDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  List<Point> _points1 = [];
  List<Line> _lines1 = [];
  List<Point> _points2 = [];
  List<Line> _lines2 = [];

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create();
    _viewer2 = CanvasViewerFactory().create();
    _generateExample();
  }

  void _generateExample() {
    // Данные для первого Viewer
    _points1 = [
      const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
    ];

    _lines1 = [
      Line(a: _points1[0], b: _points1[1], color: '#FF0000', thickness: 2),
      Line(a: _points1[1], b: _points1[2], color: '#00FF00', thickness: 2),
      Line(a: _points1[2], b: _points1[3], color: '#0000FF', thickness: 2),
      Line(a: _points1[3], b: _points1[0], color: '#FFFF00', thickness: 2),
    ];

    // Данные для второго Viewer
    _points2 = [
      const Point(x: 50, y: 50, color: '#FF00FF', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FFFF', thickness: 5),
      const Point(x: 100, y: 150, color: '#FF0000', thickness: 5),
    ];

    _lines2 = [
      Line(a: _points2[0], b: _points2[1], color: '#FF00FF', thickness: 2),
      Line(a: _points2[1], b: _points2[2], color: '#00FFFF', thickness: 2),
      Line(a: _points2[2], b: _points2[0], color: '#FF0000', thickness: 2),
    ];

    // Отрисовываем на холстах
    _viewer1.draw(_lines1, _points1);
    _viewer2.draw(_lines2, _points2);
  }

  void _clearCanvas() {
    setState(() {
      _viewer1.clean();
      _viewer2.clean();
      _points1 = [];
      _lines1 = [];
      _points2 = [];
      _lines2 = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer2.buildWidget(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateExample();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация трех Viewer с точками и линиями рядом
class ThreeViewersWithPointsAndLinesDemo extends StatefulWidget {
  const ThreeViewersWithPointsAndLinesDemo({super.key});

  @override
  State<ThreeViewersWithPointsAndLinesDemo> createState() =>
      _ThreeViewersWithPointsAndLinesDemoState();
}

class _ThreeViewersWithPointsAndLinesDemoState
    extends State<ThreeViewersWithPointsAndLinesDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  late final Viewer _viewer3;
  List<Point> _points1 = [];
  List<Line> _lines1 = [];
  List<Point> _points2 = [];
  List<Line> _lines2 = [];
  List<Point> _points3 = [];
  List<Line> _lines3 = [];

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create();
    _viewer2 = CanvasViewerFactory().create();
    _viewer3 = CanvasViewerFactory().create();
    _generateExample();
  }

  void _generateExample() {
    // Данные для первого Viewer - квадрат
    _points1 = [
      const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
    ];

    _lines1 = [
      Line(a: _points1[0], b: _points1[1], color: '#FF0000', thickness: 2),
      Line(a: _points1[1], b: _points1[2], color: '#00FF00', thickness: 2),
      Line(a: _points1[2], b: _points1[3], color: '#0000FF', thickness: 2),
      Line(a: _points1[3], b: _points1[0], color: '#FFFF00', thickness: 2),
    ];

    // Данные для второго Viewer - треугольник
    _points2 = [
      const Point(x: 50, y: 50, color: '#FF00FF', thickness: 5),
      const Point(x: 150, y: 50, color: '#00FFFF', thickness: 5),
      const Point(x: 100, y: 150, color: '#FF0000', thickness: 5),
    ];

    _lines2 = [
      Line(a: _points2[0], b: _points2[1], color: '#FF00FF', thickness: 2),
      Line(a: _points2[1], b: _points2[2], color: '#00FFFF', thickness: 2),
      Line(a: _points2[2], b: _points2[0], color: '#FF0000', thickness: 2),
    ];

    // Данные для третьего Viewer - пятиугольник
    _points3 = [
      const Point(x: 100, y: 50, color: '#FF0000', thickness: 5),
      const Point(x: 150, y: 100, color: '#00FF00', thickness: 5),
      const Point(x: 125, y: 150, color: '#0000FF', thickness: 5),
      const Point(x: 75, y: 150, color: '#FFFF00', thickness: 5),
      const Point(x: 50, y: 100, color: '#FF00FF', thickness: 5),
    ];

    _lines3 = [
      Line(a: _points3[0], b: _points3[1], color: '#FF0000', thickness: 2),
      Line(a: _points3[1], b: _points3[2], color: '#00FF00', thickness: 2),
      Line(a: _points3[2], b: _points3[3], color: '#0000FF', thickness: 2),
      Line(a: _points3[3], b: _points3[4], color: '#FFFF00', thickness: 2),
      Line(a: _points3[4], b: _points3[0], color: '#FF00FF', thickness: 2),
    ];

    // Отрисовываем на холстах
    _viewer1.draw(_lines1, _points1);
    _viewer2.draw(_lines2, _points2);
    _viewer3.draw(_lines3, _points3);
  }

  void _clearCanvas() {
    setState(() {
      _viewer1.clean();
      _viewer2.clean();
      _viewer3.clean();
      _points1 = [];
      _lines1 = [];
      _points2 = [];
      _lines2 = [];
      _points3 = [];
      _lines3 = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer2.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _viewer3.buildWidget(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateExample();
                  });
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
