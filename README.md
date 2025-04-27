# CG constructor ❤️‍🩹

> Делаем КГ просто

-> [Для чего можем использовать](./FEATURES.md)

Цель:
- набор UI и инфрастуктуры для реализации ЛР

## Пакеты

Проект содержит набор пакетов, которые можно использовать как вместе, так и по отдельности для решения различных задач компьютерной графики.

### models_ns

Пакет геометрических моделей для работы с двумерными объектами в Dart и Flutter.

**Возможности:**
- Набор классов для работы с геометрическими объектами (Point, Line, Vector, Angle, Scale, Polygon, Triangle, Rectangle)
- Сериализация/десериализация JSON
- Удобные методы для работы с объектами

**Подключение:**
```yaml
dependencies:
  models_ns: 
    path: ../models_ns # укажите здесь путь относительно вашего пакета
```

### figure_io

Пакет для чтения и работы с геометрическими фигурами в формате JSON для Flutter.

**Возможности:**
- Чтение файлов JSON с геометрическими фигурами (точки, линии, треугольники)
- Виджет для выбора и чтения файлов
- Stream для получения прочитанных фигур
- Абстракции для удобного добавления новых типов фигур

**Подключение:**
```yaml
dependencies:
  figure_io:
    path: path/to/figure_io # укажите здесь путь к пакету
  models_ns:
    path: path/to/models_ns # укажите здесь путь к пакету models_ns
```

### viewer

Пакет Flutter для отображения точек и линий на холсте с автоматическим масштабированием.

**Возможности:**
- Отображение точек и линий на холсте
- Автоматическое масштабирование для оптимального отображения всех элементов
- Поддержка цветов и толщины для точек и линий
- Отображение координат точек и концов линий
- Ввод точек по нажатию на поверхность
- Получение добавленных точек через поток или обратный вызов

**Подключение:**
```yaml
dependencies:
  viewer: 
    path: path/to/viewer # укажите здесь путь к пакету
  models_ns:
    path: path/to/models_ns # укажите здесь путь к пакету models_ns
```

### forms

Пакет для создания типизированных форм во Flutter с поддержкой валидации, сериализации и кодогенерации.

**Возможности:**
- Типизированные формы с поддержкой различных типов полей
- Валидация полей и форм
- Сериализация и десериализация форм в Map
- Кодогенерация для создания типизированных форм
- Виджеты для отображения полей и форм
- Поддержка списков полей с вложенными элементами

**Подключение:**
```yaml
dependencies:
  forms: 
    path: path/to/forms # укажите здесь путь к пакету

dev_dependencies:
  build_runner: ^2.3.0
  forms_generator: 
    path: path/to/forms/packages/forms_generator # укажите здесь путь к пакету forms_generator
```

### measures

Пакет Flutter для замеров времени работы алгоритма и отображения результатов.

**Возможности:**
- Гибкие замеры времени выполнения алгоритмов
- Многократные запуски для определения более точного времени выполнения
- Комплексные метрики (время в миллисекундах, тики, потребляемая память)
- Опциональное создание отдельного изолята для выполнения замеров
- Разнообразная визуализация результатов (таблица, гистограмма, линейный график)
- Отображение прогресса выполнения замеров в реальном времени

**Подключение:**
```yaml
dependencies:
  measures: 
    path: path/to/measures # укажите здесь путь к пакету
```

### alogrithms

Пакет с алгоритмами для компьютерной графики.

**Подключение:**
```yaml
dependencies:
  alogrithms: 
    path: path/to/alogrithms # укажите здесь путь к пакету
```

### flow

Пакет для управления потоком выполнения алгоритмов.

**Подключение:**
```yaml
dependencies:
  flow: 
    path: path/to/flow # укажите здесь путь к пакету
```

## Примеры использования

### Базовый пример с отображением фигур

```dart
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Пример отображения фигур')),
        body: FigureViewerExample(),
      ),
    );
  }
}

class FigureViewerExample extends StatefulWidget {
  @override
  _FigureViewerExampleState createState() => _FigureViewerExampleState();
}

class _FigureViewerExampleState extends State<FigureViewerExample> {
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
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _viewer.buildWidget(),
    );
  }
}
```

### Пример с чтением фигур из файла

```dart
import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';
import 'package:viewer/viewer.dart';

class FileReaderExample extends StatefulWidget {
  @override
  _FileReaderExampleState createState() => _FileReaderExampleState();
}

class _FileReaderExampleState extends State<FileReaderExample> {
  late final Viewer _viewer;
  
  @override
  void initState() {
    super.initState();
    _viewer = CanvasViewerFactory().create();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FigureReaderWidget(
          buttonText: 'Выбрать файл с фигурами',
          onFiguresLoaded: (figures) {
            // Отображаем загруженные фигуры
            _viewer.draw(figures.lines, figures.points);
          },
        ),
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
      ],
    );
  }
}
```

### Пример с замером производительности алгоритмов

```dart
import 'package:flutter/material.dart';
import 'package:measures/measures.dart';

class MeasureExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Создаем экземпляры MeasureRunner и MeasureStorage
    final runner = SynchronousMeasureRunner();
    final storage = MemoryMeasureStorage();
    final service = MeasureService(runner: runner, storage: storage);

    // Создаем конфигурацию по умолчанию
    const config = MeasureConfig(iterations: 10);

    return MeasureInheritedWidget(
      measureService: service,
      config: config,
      child: MeasureScreen(),
    );
  }
}

class MeasureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Замер производительности')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await service.measure(
                'bubble_sort',
                () => bubbleSort(List.generate(1000, (_) => Random().nextInt(10000))),
                config,
              );
            },
            child: Text('Запустить замер Bubble Sort'),
          ),
          ElevatedButton(
            onPressed: () async {
              await service.measure(
                'quick_sort',
                () {
                  final list = List.generate(1000, (_) => Random().nextInt(10000));
                  quickSort(list, 0, list.length - 1);
                },
                config,
              );
            },
            child: Text('Запустить замер Quick Sort'),
          ),
          Expanded(
            child: MeasureWidget(
              title: 'Результаты замеров',
              keysToCompare: const ['bubble_sort', 'quick_sort'],
              viewType: MeasureViewType.barChart,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Преимущества использования пакетов

1. **Модульность** - каждый пакет решает конкретную задачу и может использоваться независимо от других
2. **Простота подключения** - достаточно указать путь к пакету в pubspec.yaml
3. **Готовые решения** - пакеты предоставляют готовые решения для типичных задач компьютерной графики
4. **Интеграция** - пакеты хорошо интегрируются между собой, образуя единую экосистему
5. **Расширяемость** - пакеты предоставляют абстракции для расширения функциональности

## Лицензия

Все пакеты распространяются под лицензией MIT.
