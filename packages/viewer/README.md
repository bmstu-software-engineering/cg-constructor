# Viewer

Пакет Flutter для отображения точек и линий на холсте с автоматическим масштабированием, отображением координат и вводом точек.

## Возможности

- Отображение точек и линий на холсте
- Автоматическое масштабирование для оптимального отображения всех элементов
- Поддержка цветов и толщины для точек и линий
- Отображение координат точек и концов линий
- Ввод точек по нажатию на поверхность
- Получение добавленных точек через поток или обратный вызов
- Динамическое изменение размера в зависимости от контейнера
- Поддержка диагностики для упрощения тестирования

## Установка

Добавьте зависимость в ваш `pubspec.yaml`:

```yaml
dependencies:
  viewer: ^0.0.1
  models_ns: # Требуется для моделей Point и Line
    path: ../models_ns # Укажите правильный путь или версию
```

## Импорт

```dart
import 'package:viewer/viewer.dart';
import 'package:models_ns/models_ns.dart';
```

## Основное использование

### Создание Viewer

```dart
// Создаем фабрику
final ViewerFactory factory = CanvasViewerFactory();

// Создаем экземпляр Viewer
final Viewer viewer = factory.create();
```

### Отрисовка точек и линий

```dart
// Создаем точки
final points = [
  Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
  Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
  Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
];

// Создаем линии
final lines = [
  Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
  Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
  Line(a: points[0], b: points[2], color: '#0000FF', thickness: 2),
];

// Отрисовываем на холсте
viewer.draw(lines, points);
```

### Добавление виджета в дерево

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Canvas Viewer Example')),
    body: Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: viewer.buildWidget(),
    ),
  );
}
```

### Очистка холста

```dart
viewer.clean();
```

## Расширенные возможности

### Отображение координат

Вы можете включить отображение координат точек и концов линий:

```dart
// При создании Viewer
final Viewer viewer = factory.create(showCoordinates: true);

// Или позже
viewer.setShowCoordinates(true);

// Проверка текущего состояния
bool isShowingCoordinates = viewer.showCoordinates;
```

Когда отображение координат включено, рядом с каждой точкой и концом линии будет отображаться текст с координатами в формате (x, y).

### Ввод точек по нажатию

Вы можете включить режим ввода точек, который позволяет добавлять точки по нажатию на поверхность:

```dart
// При создании Viewer
final Viewer viewer = factory.create(pointInputModeEnabled: true);

// Или позже
viewer.setPointInputMode(true);

// Проверка текущего состояния
bool isInputModeEnabled = viewer.pointInputModeEnabled;
```

### Обработка добавленных точек

Есть два способа получить добавленные точки:

#### 1. Через обратный вызов

```dart
// При создании Viewer
final Viewer viewer = factory.create(
  pointInputModeEnabled: true,
  onPointAdded: (Point point) {
    print('Добавлена точка: (${point.x}, ${point.y})');
    // Обработка добавленной точки
  },
);

// Или позже
viewer.setOnPointAddedCallback((Point point) {
  print('Добавлена точка: (${point.x}, ${point.y})');
  // Обработка добавленной точки
});
```

#### 2. Через поток

```dart
// Подписываемся на поток добавленных точек
final subscription = viewer.pointsStream.listen((Point point) {
  print('Получена точка из потока: (${point.x}, ${point.y})');
  // Обработка добавленной точки
});

// Не забудьте отписаться, когда поток больше не нужен
@override
void dispose() {
  subscription.cancel();
  super.dispose();
}
```

## Примеры использования

### Простой пример с отображением фигуры

```dart
class SimpleViewerExample extends StatefulWidget {
  @override
  _SimpleViewerExampleState createState() => _SimpleViewerExampleState();
}

class _SimpleViewerExampleState extends State<SimpleViewerExample> {
  late final Viewer _viewer;
  
  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _drawTriangle();
  }
  
  void _drawTriangle() {
    final points = [
      Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      Point(x: 100, y: 150, color: '#0000FF', thickness: 5),
    ];
    
    final lines = [
      Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
      Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
      Line(a: points[2], b: points[0], color: '#0000FF', thickness: 2),
    ];
    
    _viewer.draw(lines, points);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Простой пример')),
      body: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _viewer.buildWidget(),
      ),
    );
  }
}
```

### Пример с отображением координат

```dart
class CoordinatesViewerExample extends StatefulWidget {
  @override
  _CoordinatesViewerExampleState createState() => _CoordinatesViewerExampleState();
}

class _CoordinatesViewerExampleState extends State<CoordinatesViewerExample> {
  late final Viewer _viewer;
  bool _showCoordinates = false;
  
  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
    _drawSquare();
  }
  
  void _drawSquare() {
    final points = [
      Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
      Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
    ];
    
    final lines = [
      Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
      Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
      Line(a: points[2], b: points[3], color: '#0000FF', thickness: 2),
      Line(a: points[3], b: points[0], color: '#FFFF00', thickness: 2),
    ];
    
    _viewer.draw(lines, points);
  }
  
  void _toggleCoordinates() {
    setState(() {
      _showCoordinates = !_showCoordinates;
      _viewer.setShowCoordinates(_showCoordinates);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Пример с координатами')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _viewer.buildWidget(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Отображать координаты:'),
                SizedBox(width: 16),
                Switch(
                  value: _showCoordinates,
                  onChanged: (value) => _toggleCoordinates(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Пример с вводом точек

```dart
class PointInputViewerExample extends StatefulWidget {
  @override
  _PointInputViewerExampleState createState() => _PointInputViewerExampleState();
}

class _PointInputViewerExampleState extends State<PointInputViewerExample> {
  late final Viewer _viewer;
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
        
        // Отрисовываем все точки и новую линию
        _viewer.draw([line], _addedPoints);
      } else {
        // Отрисовываем только точку
        _viewer.draw([], _addedPoints);
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
      _addedPoints.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Пример с вводом точек')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _viewer.buildWidget(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Режим ввода точек:'),
                    SizedBox(width: 16),
                    Switch(
                      value: _pointInputModeEnabled,
                      onChanged: (value) => _togglePointInputMode(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Добавлено точек: ${_addedPoints.length}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _clearCanvas,
                  child: Text('Очистить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Несколько Viewer на одном экране

Вы можете разместить несколько Viewer на одном экране, каждый со своими настройками:

```dart
class MultipleViewersExample extends StatefulWidget {
  @override
  _MultipleViewersExampleState createState() => _MultipleViewersExampleState();
}

class _MultipleViewersExampleState extends State<MultipleViewersExample> {
  late final Viewer _viewer1;
  late final Viewer _viewer2;
  
  @override
  void initState() {
    super.initState();
    _viewer1 = CanvasViewerFactory().create(showCoordinates: true);
    _viewer2 = CanvasViewerFactory().create(pointInputModeEnabled: true);
    
    _drawSquare(_viewer1);
    _drawTriangle(_viewer2);
  }
  
  void _drawSquare(Viewer viewer) {
    // ... код для отрисовки квадрата
  }
  
  void _drawTriangle(Viewer viewer) {
    // ... код для отрисовки треугольника
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Несколько Viewer')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _viewer1.buildWidget(),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
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
        ],
      ),
    );
  }
}
```

## Часто задаваемые вопросы

### Как изменить цвет и толщину точек и линий?

Цвет и толщина задаются при создании объектов `Point` и `Line`:

```dart
final point = Point(
  x: 100,
  y: 100,
  color: '#FF0000', // Цвет в формате HEX
  thickness: 5.0,    // Толщина в пикселях
);

final line = Line(
  a: point1,
  b: point2,
  color: '#00FF00', // Цвет в формате HEX
  thickness: 2.0,    // Толщина в пикселях
);
```

### Как изменить отступы от краев?

Отступы можно задать при создании фабрики:

```dart
final factory = CanvasViewerFactory(padding: 20.0);
final viewer = factory.create();
```

### Как обновить отображение после изменения данных?

Просто вызовите метод `draw` с новыми данными:

```dart
// Обновляем данные
points.add(newPoint);
lines.add(newLine);

// Перерисовываем
viewer.draw(lines, points);
```

### Как получить текущий масштаб и смещение?

Для отладки и тестирования можно получить текущее состояние масштабирования:

```dart
if (viewer is CanvasViewer) {
  final scale = viewer.currentScale;
  final offset = viewer.currentOffset;
  final boundingBox = viewer.boundingBox;
  
  print('Scale: $scale, Offset: $offset, BoundingBox: $boundingBox');
}
```

## Дополнительная информация

### Особенности реализации

- Использует `CustomPaint` и `CustomPainter` для отрисовки на холсте
- Автоматически рассчитывает масштаб для оптимального отображения всех элементов
- Использует `LayoutBuilder` для получения размеров контейнера
- Реализует `DiagnosticableTreeMixin` для улучшения отладки и тестирования

### Расширение функциональности

Вы можете создать собственную реализацию интерфейса `Viewer` для использования других методов отрисовки, например, с использованием SVG или WebGL.

## Примеры

Полные примеры использования можно найти в директории `/example`.

## Тестирование

Пакет включает утилиты для тестирования, которые упрощают написание тестов для виджетов, использующих Viewer.

```dart
testWidgets('should render points and lines', (WidgetTester tester) async {
  // Создаем тестовые данные
  final points = [Point(x: 0, y: 0), Point(x: 100, y: 100)];
  final lines = [Line(a: points[0], b: points[1])];
  
  // Создаем виджет для тестирования
  final viewer = ViewerTestUtils.createTestViewer(
    points: points,
    lines: lines,
  );
  
  // Рендерим виджет
  await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));
  
  // Проверяем, что виджет отрендерился
  await tester.expectCanvasViewerRendered();
});
