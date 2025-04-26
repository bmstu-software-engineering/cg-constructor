# Руководство для разработчиков пакета Viewer

Данный документ предназначен для разработчиков, которые будут поддерживать и расширять функциональность пакета Viewer.

## Архитектура пакета

Пакет Viewer построен на основе интерфейсного подхода, что обеспечивает гибкость и возможность создания различных реализаций.

### Основные компоненты

```
viewer/
├── lib/
│   ├── viewer.dart (основной экспортный файл)
│   └── src/
│       ├── viewer_interface.dart (интерфейсы Viewer и ViewerFactory)
│       └── canvas_viewer.dart (реализация на основе Canvas)
├── test/ (тесты)
└── example/ (примеры использования)
```

### Диаграмма классов

```
┌───────────────────┐      ┌───────────────────┐
│  <<interface>>    │      │  <<interface>>    │
│     Viewer        │      │   ViewerFactory   │
└───────────────────┘      └───────────────────┘
         ▲                          ▲
         │                          │
         │                          │
┌───────────────────┐      ┌───────────────────┐
│   CanvasViewer    │◄─────│CanvasViewerFactory│
└───────────────────┘      └───────────────────┘
         │
         │ использует
         ▼
┌───────────────────┐
│  _CanvasPainter   │
└───────────────────┘
```

## Интерфейсы и их реализации

### Интерфейс Viewer

Интерфейс `Viewer` определяет основные методы для работы с визуализацией точек и линий:

```dart
abstract interface class Viewer {
  void draw(List<Line> lines, List<Point> points);
  void clean();
  Widget buildWidget();
  void setShowCoordinates(bool show);
  bool get showCoordinates;
  void setPointInputMode(bool enabled);
  bool get pointInputModeEnabled;
  void setOnPointAddedCallback(void Function(Point point)? onPointAdded);
  Stream<Point> get pointsStream;
}
```

### Интерфейс ViewerFactory

Интерфейс `ViewerFactory` определяет метод для создания экземпляров `Viewer`:

```dart
abstract interface class ViewerFactory {
  Viewer create({
    bool showCoordinates = false,
    bool pointInputModeEnabled = false,
    void Function(Point point)? onPointAdded,
  });
}
```

### Реализация CanvasViewer

Класс `CanvasViewer` реализует интерфейс `Viewer` с использованием Flutter `CustomPaint` для отрисовки на холсте:

- Хранит списки точек и линий для отрисовки
- Управляет масштабированием и смещением для оптимального отображения
- Поддерживает режим отображения координат
- Поддерживает режим ввода точек по нажатию
- Предоставляет поток для получения добавленных точек

### Реализация CanvasViewerFactory

Класс `CanvasViewerFactory` реализует интерфейс `ViewerFactory` для создания экземпляров `CanvasViewer` с заданными параметрами.

## Ключевые механизмы и алгоритмы

### Масштабирование и центрирование

Алгоритм масштабирования в `_CanvasPainter` выполняет следующие шаги:

1. Находит минимальные и максимальные координаты всех точек и линий
2. Рассчитывает ограничивающий прямоугольник (bounding box)
3. Вычисляет масштаб для оптимального отображения с учетом отступов
4. Рассчитывает смещение для центрирования содержимого
5. Применяет масштаб и смещение при отрисовке

```dart
void _calculateScaleAndOffset(Size size) {
  // Находим минимальные и максимальные координаты
  // ...
  
  // Рассчитываем масштаб с учетом отступов
  final width = maxX - minX;
  final height = maxY - minY;
  
  final scaleX = (size.width - 2 * _padding) / width;
  final scaleY = (size.height - 2 * _padding) / height;
  
  // Выбираем минимальный масштаб, чтобы все поместилось
  _scale = min(scaleX, scaleY);
  
  // Рассчитываем смещение для центрирования
  _offsetX = (size.width - width * _scale) / 2 - minX * _scale;
  _offsetY = (size.height - height * _scale) / 2 - minY * _scale;
}
```

### Преобразование координат

Для режима ввода точек реализовано преобразование координат экрана в координаты модели:

```dart
Offset _convertToModelCoordinates(double screenX, double screenY) {
  // Обратное преобразование с учетом масштаба и смещения
  final modelX = (screenX - _currentOffset.dx) / _currentScale;
  final modelY = (screenY - _currentOffset.dy) / _currentScale;
  return Offset(modelX, modelY);
}
```

### Отображение координат

Механизм отображения координат включает:

1. Отрисовку текста с координатами рядом с точками
2. Добавление фона для улучшения читаемости
3. Адаптацию размера текста в зависимости от масштаба
4. Предотвращение дублирования координат для точек с одинаковыми координатами

### Ввод точек

Механизм ввода точек включает:

1. Обработку нажатий на холст через `GestureDetector`
2. Преобразование координат экрана в координаты модели
3. Создание новой точки и добавление ее к существующим
4. Вызов обработчика `onPointAdded` и отправку точки в поток `pointsStream`

## Тестирование

### Структура тестов

Тесты организованы по функциональным областям:

- `canvas_viewer_test.dart` - тесты основной функциональности CanvasViewer
- `coordinates_display_test.dart` - тесты отображения координат
- `coordinates_widget_test.dart` - тесты виджетов с отображением координат
- `point_input_test.dart` - тесты режима ввода точек
- `viewer_golden_test.dart` - golden-тесты для визуальной проверки

### Утилиты для тестирования

Класс `ViewerTestUtils` предоставляет вспомогательные методы для тестирования:

```dart
static CanvasViewer createTestViewer({
  List<Line> lines = const [],
  List<Point> points = const [],
  bool showCoordinates = false,
  bool pointInputModeEnabled = false,
  void Function(Point point)? onPointAdded,
  double padding = 40.0,
}) {
  // ...
}

static Widget createTestWidget({
  required CanvasViewer viewer,
  Size size = const Size(300, 300),
}) {
  // ...
}
```

Расширение `ViewerTestExtensions` добавляет методы для проверки виджетов:

```dart
extension ViewerTestExtensions on WidgetTester {
  Future<CustomPaint> findCanvasViewerPaint() async {
    // ...
  }
  
  Future<void> expectCanvasViewerRendered() async {
    // ...
  }
}
```

### Golden-тесты

Golden-тесты используются для визуальной проверки отрисовки. Они создают эталонные изображения и сравнивают их с результатами отрисовки при последующих запусках тестов.

## Расширение функциональности

### Создание новых реализаций Viewer

Для создания новой реализации Viewer необходимо:

1. Реализовать интерфейс `Viewer`
2. Реализовать интерфейс `ViewerFactory` для создания экземпляров
3. Обеспечить поддержку всех требуемых функций (отрисовка, масштабирование, координаты, ввод точек)

Пример скелета новой реализации:

```dart
class MyCustomViewer implements Viewer {
  @override
  void draw(List<Line> lines, List<Point> points) {
    // Реализация отрисовки
  }
  
  @override
  void clean() {
    // Реализация очистки
  }
  
  @override
  Widget buildWidget() {
    // Создание виджета
  }
  
  // Реализация остальных методов...
}

class MyCustomViewerFactory implements ViewerFactory {
  @override
  Viewer create({
    bool showCoordinates = false,
    bool pointInputModeEnabled = false,
    void Function(Point point)? onPointAdded,
  }) {
    // Создание и настройка экземпляра MyCustomViewer
  }
}
```

### Добавление новых функций

При добавлении новых функций следует:

1. Обновить интерфейс `Viewer` с новыми методами
2. Реализовать эти методы в `CanvasViewer`
3. Обновить фабрику для поддержки новых параметров
4. Добавить тесты для новой функциональности
5. Обновить документацию и примеры

## Оптимизация и производительность

### Текущие оптимизации

- Использование `StreamBuilder` для эффективного обновления виджета
- Использование `ValueKey` для оптимизации перерисовки
- Кэширование результатов масштабирования
- Предотвращение ненужных перерисовок через `shouldRepaint`

### Потенциальные улучшения

- Реализация виртуализации для больших наборов данных
- Оптимизация алгоритма масштабирования для больших наборов данных
- Добавление поддержки жестов для масштабирования и панорамирования
- Оптимизация отрисовки координат для большого количества точек

## Интеграция с моделями

Пакет зависит от `models_ns`, который предоставляет модели `Point` и `Line`. Эти модели используются для представления данных для отрисовки.

### Модель Point

```dart
class Point {
  final double x;
  final double y;
  final String color;
  final double thickness;
  
  // ...
}
```

### Модель Line

```dart
class Line {
  final Point a;
  final Point b;
  final String color;
  final double thickness;
  
  // ...
}
```

## Валидация изменений

Перед отправкой изменений в репозиторий необходимо убедиться в их корректности. Для этого используйте следующие команды:

### Запуск тестов

```bash
fvm flutter test
```

Эта команда запускает все тесты в директории `test/` и проверяет, что все они проходят успешно. Обязательно запускайте тесты после внесения любых изменений в код.

### Статический анализ кода

```bash
fvm flutter analyze .
```

Эта команда выполняет статический анализ кода и выявляет потенциальные проблемы, такие как:
- Неиспользуемые импорты
- Неиспользуемые переменные
- Несоответствие типов
- Нарушения стиля кодирования
- Другие потенциальные ошибки

Убедитесь, что код проходит статический анализ без ошибок и предупреждений перед отправкой изменений.

## Рекомендации по разработке

1. Следуйте принципам SOLID при расширении функциональности
2. Добавляйте тесты для новой функциональности
3. Обновляйте документацию при внесении изменений
4. Используйте интерфейсы для обеспечения гибкости
5. Следите за производительностью при работе с большими наборами данных
6. Всегда запускайте тесты и статический анализ перед отправкой изменений
