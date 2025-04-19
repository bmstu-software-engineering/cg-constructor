# Canvas Viewer

Пакет для отображения точек и линий на холсте с автоматическим масштабированием.

## Возможности

- Отображение точек и линий на холсте
- Автоматическое масштабирование для оптимального отображения всех элементов
- Поддержка цветов и толщины для точек и линий
- Динамическое изменение размера в зависимости от контейнера
- Поддержка диагностики для упрощения тестирования

## Начало работы

### Установка

Добавьте зависимость в ваш `pubspec.yaml`:

```yaml
dependencies:
  viewer: ^0.0.1
```

### Импорт

```dart
import 'package:viewer/viewer.dart';
```

## Использование

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

## Пример

Полный пример использования можно найти в директории `/example`.

## Тестирование

Пакет включает утилиты для тестирования, которые упрощают написание тестов для виджетов, использующих Canvas Viewer.

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
```

## Дополнительная информация

### Особенности реализации

- Использует `CustomPaint` и `CustomPainter` для отрисовки на холсте
- Автоматически рассчитывает масштаб для оптимального отображения всех элементов
- Использует `LayoutBuilder` для получения размеров контейнера
- Реализует `DiagnosticableTreeMixin` для улучшения отладки и тестирования

### Расширение функциональности

Вы можете создать собственную реализацию интерфейса `Viewer` для использования других методов отрисовки, например, с использованием SVG или WebGL.
