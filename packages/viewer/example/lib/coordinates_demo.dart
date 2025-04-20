import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

/// Демонстрация Viewer с отображением координат точек и линий
class CoordinatesViewerDemo extends StatefulWidget {
  const CoordinatesViewerDemo({super.key});

  @override
  State<CoordinatesViewerDemo> createState() => _CoordinatesViewerDemoState();
}

class _CoordinatesViewerDemoState extends State<CoordinatesViewerDemo> {
  late final Viewer _viewer;
  List<Point> _points = [];
  List<Line> _lines = [];
  bool _showCoordinates = false;

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create(showCoordinates: _showCoordinates);
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

  void _toggleCoordinates() {
    setState(() {
      _showCoordinates = !_showCoordinates;
      _viewer.setShowCoordinates(_showCoordinates);
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
          child: Column(
            children: [
              Row(
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Отображать координаты:'),
                  const SizedBox(width: 16),
                  Switch(
                    value: _showCoordinates,
                    onChanged: (value) {
                      _toggleCoordinates();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Координаты: ${_showCoordinates ? 'Включены' : 'Выключены'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _showCoordinates ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'При масштабировании координаты адаптируются автоматически',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух Viewer с разными настройками отображения координат
class TwoViewersWithCoordinatesDemo extends StatefulWidget {
  const TwoViewersWithCoordinatesDemo({super.key});

  @override
  State<TwoViewersWithCoordinatesDemo> createState() =>
      _TwoViewersWithCoordinatesDemoState();
}

class _TwoViewersWithCoordinatesDemoState
    extends State<TwoViewersWithCoordinatesDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  List<Point> _points1 = [];
  List<Line> _lines1 = [];
  List<Point> _points2 = [];
  List<Line> _lines2 = [];
  bool _showCoordinates1 = false;
  bool _showCoordinates2 = true;

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create(showCoordinates: _showCoordinates1);
    _viewer2 = CanvasViewerFactory().create(showCoordinates: _showCoordinates2);
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

  void _toggleCoordinates1() {
    setState(() {
      _showCoordinates1 = !_showCoordinates1;
      _viewer1.setShowCoordinates(_showCoordinates1);
    });
  }

  void _toggleCoordinates2() {
    setState(() {
      _showCoordinates2 = !_showCoordinates2;
      _viewer2.setShowCoordinates(_showCoordinates2);
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
                child: Column(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Координаты:'),
                          const SizedBox(width: 8),
                          Switch(
                            value: _showCoordinates1,
                            onChanged: (value) {
                              _toggleCoordinates1();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Координаты:'),
                          const SizedBox(width: 8),
                          Switch(
                            value: _showCoordinates2,
                            onChanged: (value) {
                              _toggleCoordinates2();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
