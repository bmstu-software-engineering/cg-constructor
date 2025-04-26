# Figure IO

Пакет для чтения и работы с геометрическими фигурами в формате JSON для Flutter.

## Возможности

- Чтение файлов JSON с геометрическими фигурами (точки, линии, треугольники)
- Виджет для выбора и чтения файлов
- Stream для получения прочитанных фигур
- Абстракции для удобного добавления новых типов фигур

## Начало работы

Добавьте пакет в зависимости вашего проекта:

```yaml
dependencies:
  figure_io:
    path: path/to/figure_io # укажите здесь путь к пакету
  models_ns:
    path: path/to/models_ns # укажите здесь путь к пакету models_ns
```

## Использование

### Виджет для чтения файла

```dart
import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FigureReaderWidget(
      buttonText: 'Выбрать файл с фигурами',
      onFiguresLoaded: (figures) {
        // Обработка загруженных фигур
        print('Загружено точек: ${figures.points.length}');
        print('Загружено линий: ${figures.lines.length}');
        print('Загружено треугольников: ${figures.triangles.length}');
      },
    );
  }
}
```

### Получение Stream с фигурами

```dart
import 'package:flutter/material.dart';
import 'package:figure_io/figure_io.dart';

class MyStreamWidget extends StatefulWidget {
  @override
  _MyStreamWidgetState createState() => _MyStreamWidgetState();
}

class _MyStreamWidgetState extends State<MyStreamWidget> {
  final _figureReaderKey = GlobalKey<_FigureReaderWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FigureReaderWidget(
          key: _figureReaderKey,
        ),
        StreamBuilder<FigureCollection>(
          stream: _figureReaderKey.currentState?.figuresStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final figures = snapshot.data!;
              return Text('Получены фигуры: ${figures.allFigures.length}');
            }
            return Text('Ожидание данных...');
          },
        ),
      ],
    );
  }
}
```

### Чтение файла программно

```dart
import 'dart:io';
import 'package:figure_io/figure_io.dart';

Future<void> readFiguresFromFile(String path) async {
  final reader = FigureReader();
  
  // Подписка на Stream
  reader.figuresStream.listen((figures) {
    print('Получены фигуры: ${figures.allFigures.length}');
  });
  
  // Чтение из файла
  final file = File(path);
  await reader.readFromFile(file);
  
  // Не забудьте закрыть reader, когда он больше не нужен
  reader.dispose();
}
```

### Формат JSON

Пакет поддерживает следующий формат JSON:

```json
{
  "points": [
    {
      "x": 10,
      "y": 20
    },
    {
      "x": 30,
      "y": 40
    }
  ],
  "lines": [
    {
      "a": {
        "x": 0,
        "y": 0
      },
      "b": {
        "x": 100,
        "y": 100
      }
    }
  ],
  "triangles": [
    {
      "a": {
        "x": 0,
        "y": 0
      },
      "b": {
        "x": 100,
        "y": 0
      },
      "c": {
        "x": 50,
        "y": 86.6
      }
    }
  ]
}
```

## Поддержка веб-платформы

Пакет полностью поддерживает работу на веб-платформе. При использовании на веб-платформе, файлы читаются с использованием байтов вместо путей к файлам, так как на веб-платформе доступ к файловой системе ограничен.

### Чтение файла из байтов

```dart
import 'dart:typed_data';
import 'package:figure_io/figure_io.dart';

Future<void> readFiguresFromBytes(Uint8List bytes) async {
  final reader = FigureReader();
  
  // Подписка на Stream
  reader.figuresStream.listen((figures) {
    print('Получены фигуры: ${figures.allFigures.length}');
  });
  
  // Чтение из байтов
  await reader.readFromBytes(bytes);
  
  // Не забудьте закрыть reader, когда он больше не нужен
  reader.dispose();
}
```

## Дополнительная информация

Пакет использует модели из пакета `models_ns` для работы с геометрическими объектами. Для добавления новых типов фигур, реализуйте интерфейс `Figure` и добавьте соответствующую обработку в `FigureCollection`.
