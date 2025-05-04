import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

/// Демонстрация использования FigureCollection с Viewer
class FigureCollectionDemo extends StatefulWidget {
  const FigureCollectionDemo({super.key});

  @override
  State<FigureCollectionDemo> createState() => _FigureCollectionDemoState();
}

class _FigureCollectionDemoState extends State<FigureCollectionDemo> {
  late final Viewer _viewer;
  late FigureCollection _collection;
  String _currentFigureType = 'Все фигуры';

  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create(showCoordinates: true);
    _generateAllFigures();
  }

  void _generateAllFigures() {
    // Создаем точки
    final points = [
      const Point(x: 20, y: 20, color: '#FF0000', thickness: 5),
      const Point(x: 40, y: 20, color: '#00FF00', thickness: 5),
    ];

    // Создаем линии
    final lines = [
      Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
    ];

    // Создаем треугольник
    final triangle = Triangle(
      a: const Point(x: 60, y: 20),
      b: const Point(x: 100, y: 20),
      c: const Point(x: 80, y: 60),
      color: '#0000FF',
      thickness: 2,
    );

    // Создаем прямоугольник
    final rectangle = Rectangle.fromCorners(
      topLeft: const Point(x: 120, y: 20),
      bottomRight: const Point(x: 170, y: 60),
      color: '#FFFF00',
      thickness: 2,
    );

    // Создаем квадрат
    final square = Square(
      center: const Point(x: 210, y: 40),
      sideLength: 40,
      color: '#FF00FF',
      thickness: 2,
    );

    // Создаем круг
    final circle = Circle(
      center: const Point(x: 40, y: 120),
      radius: 30,
      color: '#00FFFF',
      thickness: 2,
    );

    // Создаем эллипс
    final ellipse = Ellipse(
      center: const Point(x: 120, y: 120),
      semiMajorAxis: 40,
      semiMinorAxis: 20,
      color: '#800080',
      thickness: 2,
    );

    // Создаем дугу
    final arc = Arc(
      center: const Point(x: 200, y: 120),
      radius: 30,
      startAngle: 0,
      endAngle: 3.14159, // полукруг (π радиан = 180 градусов)
      color: '#008000',
      thickness: 2,
    );

    // Создаем коллекцию со всеми типами фигур
    _collection = FigureCollection(
      points: points,
      lines: lines,
      triangles: [triangle],
      rectangles: [rectangle],
      squares: [square],
      circles: [circle],
      ellipses: [ellipse],
      arcs: [arc],
    );

    // Отображаем коллекцию
    _viewer.drawCollection(_collection);
    setState(() {
      _currentFigureType = 'Все фигуры';
    });
  }

  void _showOnlyPoints() {
    final pointsCollection = FigureCollection(
      points: [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      ],
    );
    _viewer.drawCollection(pointsCollection);
    setState(() {
      _collection = pointsCollection;
      _currentFigureType = 'Точки';
    });
  }

  void _showOnlyLines() {
    final points = [
      const Point(x: 50, y: 50),
      const Point(x: 150, y: 50),
      const Point(x: 150, y: 150),
      const Point(x: 50, y: 150),
    ];

    final linesCollection = FigureCollection(
      lines: [
        Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
        Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
        Line(a: points[2], b: points[3], color: '#0000FF', thickness: 2),
        Line(a: points[3], b: points[0], color: '#FFFF00', thickness: 2),
      ],
    );
    _viewer.drawCollection(linesCollection);
    setState(() {
      _collection = linesCollection;
      _currentFigureType = 'Линии';
    });
  }

  void _showOnlyTriangles() {
    final trianglesCollection = FigureCollection(
      triangles: [
        Triangle(
          a: const Point(x: 50, y: 50),
          b: const Point(x: 150, y: 50),
          c: const Point(x: 100, y: 150),
          color: '#FF0000',
          thickness: 2,
        ),
        Triangle(
          a: const Point(x: 70, y: 70),
          b: const Point(x: 130, y: 70),
          c: const Point(x: 100, y: 130),
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(trianglesCollection);
    setState(() {
      _collection = trianglesCollection;
      _currentFigureType = 'Треугольники';
    });
  }

  void _showOnlyRectangles() {
    final rectanglesCollection = FigureCollection(
      rectangles: [
        Rectangle.fromCorners(
          topLeft: const Point(x: 30, y: 30),
          bottomRight: const Point(x: 120, y: 80),
          color: '#FF0000',
          thickness: 2,
        ),
        Rectangle.fromCorners(
          topLeft: const Point(x: 50, y: 100),
          bottomRight: const Point(x: 150, y: 170),
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(rectanglesCollection);
    setState(() {
      _collection = rectanglesCollection;
      _currentFigureType = 'Прямоугольники';
    });
  }

  void _showOnlySquares() {
    final squaresCollection = FigureCollection(
      squares: [
        Square(
          center: const Point(x: 75, y: 75),
          sideLength: 50,
          color: '#FF0000',
          thickness: 2,
        ),
        Square(
          center: const Point(x: 145, y: 95),
          sideLength: 50,
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(squaresCollection);
    setState(() {
      _collection = squaresCollection;
      _currentFigureType = 'Квадраты';
    });
  }

  void _showOnlyCircles() {
    final circlesCollection = FigureCollection(
      circles: [
        Circle(
          center: const Point(x: 80, y: 80),
          radius: 40,
          color: '#FF0000',
          thickness: 2,
        ),
        Circle(
          center: const Point(x: 150, y: 120),
          radius: 30,
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(circlesCollection);
    setState(() {
      _collection = circlesCollection;
      _currentFigureType = 'Круги';
    });
  }

  void _showOnlyEllipses() {
    final ellipsesCollection = FigureCollection(
      ellipses: [
        Ellipse(
          center: const Point(x: 80, y: 80),
          semiMajorAxis: 50,
          semiMinorAxis: 30,
          color: '#FF0000',
          thickness: 2,
        ),
        Ellipse(
          center: const Point(x: 150, y: 150),
          semiMajorAxis: 40,
          semiMinorAxis: 20,
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(ellipsesCollection);
    setState(() {
      _collection = ellipsesCollection;
      _currentFigureType = 'Эллипсы';
    });
  }

  void _showOnlyArcs() {
    final arcsCollection = FigureCollection(
      arcs: [
        Arc(
          center: const Point(x: 100, y: 100),
          radius: 50,
          startAngle: 0,
          endAngle: 3.14159, // полукруг (π радиан = 180 градусов)
          color: '#FF0000',
          thickness: 2,
        ),
        Arc(
          center: const Point(x: 150, y: 150),
          radius: 40,
          startAngle: 1.57079, // π/2 радиан = 90 градусов
          endAngle: 4.71238, // 3π/2 радиан = 270 градусов
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );
    _viewer.drawCollection(arcsCollection);
    setState(() {
      _collection = arcsCollection;
      _currentFigureType = 'Дуги';
    });
  }

  void _clearCanvas() {
    _viewer.clean();
    setState(() {
      _collection = FigureCollection();
      _currentFigureType = 'Пусто';
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
          padding: const EdgeInsets.all(8),
          child: Text(
            'Текущий тип фигур: $_currentFigureType',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text('Очистить'),
              ),
              ElevatedButton(
                onPressed: _generateAllFigures,
                child: const Text('Все фигуры'),
              ),
              ElevatedButton(
                onPressed: _showOnlyPoints,
                child: const Text('Точки'),
              ),
              ElevatedButton(
                onPressed: _showOnlyLines,
                child: const Text('Линии'),
              ),
              ElevatedButton(
                onPressed: _showOnlyTriangles,
                child: const Text('Треугольники'),
              ),
              ElevatedButton(
                onPressed: _showOnlyRectangles,
                child: const Text('Прямоугольники'),
              ),
              ElevatedButton(
                onPressed: _showOnlySquares,
                child: const Text('Квадраты'),
              ),
              ElevatedButton(
                onPressed: _showOnlyCircles,
                child: const Text('Круги'),
              ),
              ElevatedButton(
                onPressed: _showOnlyEllipses,
                child: const Text('Эллипсы'),
              ),
              ElevatedButton(
                onPressed: _showOnlyArcs,
                child: const Text('Дуги'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Демонстрация двух Viewer с разными коллекциями фигур
class TwoViewersWithFigureCollectionsDemo extends StatefulWidget {
  const TwoViewersWithFigureCollectionsDemo({super.key});

  @override
  State<TwoViewersWithFigureCollectionsDemo> createState() =>
      _TwoViewersWithFigureCollectionsDemoState();
}

class _TwoViewersWithFigureCollectionsDemoState
    extends State<TwoViewersWithFigureCollectionsDemo> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  late FigureCollection _collection1;
  late FigureCollection _collection2;

  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create(showCoordinates: true);
    _viewer2 = CanvasViewerFactory().create(showCoordinates: true);
    _generateCollections();
  }

  void _generateCollections() {
    // Коллекция 1: Точки, линии и прямоугольники
    _collection1 = FigureCollection(
      points: [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      ],
      lines: [
        Line(
          a: const Point(x: 50, y: 50),
          b: const Point(x: 150, y: 50),
          color: '#FF0000',
          thickness: 2,
        ),
        Line(
          a: const Point(x: 150, y: 50),
          b: const Point(x: 150, y: 150),
          color: '#00FF00',
          thickness: 2,
        ),
      ],
      rectangles: [
        Rectangle.fromCorners(
          topLeft: const Point(x: 50, y: 50),
          bottomRight: const Point(x: 150, y: 150),
          color: '#0000FF',
          thickness: 2,
        ),
      ],
    );

    // Коллекция 2: Треугольники и круги
    _collection2 = FigureCollection(
      triangles: [
        Triangle(
          a: const Point(x: 50, y: 50),
          b: const Point(x: 150, y: 50),
          c: const Point(x: 100, y: 150),
          color: '#FF0000',
          thickness: 2,
        ),
      ],
      circles: [
        Circle(
          center: const Point(x: 100, y: 100),
          radius: 40,
          color: '#00FF00',
          thickness: 2,
        ),
      ],
    );

    // Отображаем коллекции
    _viewer1.drawCollection(_collection1);
    _viewer2.drawCollection(_collection2);
  }

  void _clearCanvas() {
    _viewer1.clean();
    _viewer2.clean();
    setState(() {
      _collection1 = FigureCollection();
      _collection2 = FigureCollection();
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
          padding: const EdgeInsets.all(8),
          child: Text(
            'Два Viewer с разными коллекциями фигур',
            style: Theme.of(context).textTheme.titleMedium,
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
                onPressed: _generateCollections,
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
