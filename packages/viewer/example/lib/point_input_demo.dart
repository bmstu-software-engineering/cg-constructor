import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

/// Демонстрация ввода точек по нажатию на поверхность Viewer
class PointInputDemo extends StatefulWidget {
  const PointInputDemo({super.key});

  @override
  State<PointInputDemo> createState() => _PointInputDemoState();
}

class _PointInputDemoState extends State<PointInputDemo> {
  late final Viewer _viewer;
  List<Point> _points = [];
  List<Line> _lines = [];
  bool _pointInputModeEnabled = false;
  final List<Point> _addedPoints = [];

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();

    // Подписываемся на поток добавленных точек
    _viewer.pointsStream.listen(_onPointAdded);
  }

  void _onPointAdded(Point point) {
    setState(() {
      _addedPoints.add(point);

      // Если есть хотя бы две точки, создаем линию между последними двумя точками
      if (_addedPoints.length >= 2) {
        final lastPoint = _addedPoints[_addedPoints.length - 1];
        final prevPoint = _addedPoints[_addedPoints.length - 2];

        final line = Line(
          a: prevPoint,
          b: lastPoint,
          color: '#0000FF',
          thickness: 2,
        );

        _lines = [..._lines, line];
        _viewer.draw(_lines, _points);
      }
    });
  }

  void _togglePointInputMode() {
    setState(() {
      _pointInputModeEnabled = !_pointInputModeEnabled;
      _viewer.setPointInputMode(_pointInputModeEnabled);
    });
  }

  void _clearCanvas() {
    setState(() {
      _viewer.clean();
      _points = [];
      _lines = [];
      _addedPoints.clear();
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Режим ввода точек:'),
                  const SizedBox(width: 16),
                  Switch(
                    value: _pointInputModeEnabled,
                    onChanged: (value) {
                      _togglePointInputMode();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Режим ввода точек: ${_pointInputModeEnabled ? 'Включен' : 'Выключен'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _pointInputModeEnabled ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Добавлено точек: ${_addedPoints.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_addedPoints.isNotEmpty)
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _addedPoints.length,
                    itemBuilder: (context, index) {
                      final point = _addedPoints[index];
                      return Text(
                        'Точка ${index + 1}: (${point.x.toStringAsFixed(2)}, ${point.y.toStringAsFixed(2)})',
                        style: TextStyle(
                          color: Color(
                            int.parse(point.color.substring(1), radix: 16) |
                                0xFF000000,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Нажмите на поверхность для добавления точек',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const Text(
                'Между последовательно добавленными точками будут созданы линии',
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

/// Демонстрация двух Viewer с разными настройками режима ввода точек
class TwoViewersWithPointInputDemo extends StatefulWidget {
  const TwoViewersWithPointInputDemo({super.key});

  @override
  State<TwoViewersWithPointInputDemo> createState() =>
      _TwoViewersWithPointInputDemoState();
}

class _TwoViewersWithPointInputDemoState
    extends State<TwoViewersWithPointInputDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  final List<Point> _addedPoints1 = [];
  final List<Point> _addedPoints2 = [];
  bool _pointInputModeEnabled1 = true;
  bool _pointInputModeEnabled2 = false;

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create(
      pointInputModeEnabled: _pointInputModeEnabled1,
    );
    _viewer2 = CanvasViewerFactory().create(
      pointInputModeEnabled: _pointInputModeEnabled2,
    );

    // Подписываемся на потоки добавленных точек
    _viewer1.pointsStream.listen((point) {
      setState(() {
        _addedPoints1.add(point);
      });
    });

    _viewer2.pointsStream.listen((point) {
      setState(() {
        _addedPoints2.add(point);
      });
    });
  }

  void _togglePointInputMode1() {
    setState(() {
      _pointInputModeEnabled1 = !_pointInputModeEnabled1;
      _viewer1.setPointInputMode(_pointInputModeEnabled1);
    });
  }

  void _togglePointInputMode2() {
    setState(() {
      _pointInputModeEnabled2 = !_pointInputModeEnabled2;
      _viewer2.setPointInputMode(_pointInputModeEnabled2);
    });
  }

  void _clearCanvas() {
    setState(() {
      _viewer1.clean();
      _viewer2.clean();
      _addedPoints1.clear();
      _addedPoints2.clear();
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
                          const Text('Ввод точек:'),
                          const SizedBox(width: 8),
                          Switch(
                            value: _pointInputModeEnabled1,
                            onChanged: (value) {
                              _togglePointInputMode1();
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Добавлено точек: ${_addedPoints1.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          const Text('Ввод точек:'),
                          const SizedBox(width: 8),
                          Switch(
                            value: _pointInputModeEnabled2,
                            onChanged: (value) {
                              _togglePointInputMode2();
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Добавлено точек: ${_addedPoints2.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ],
    );
  }
}
