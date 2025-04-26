# Measures

Пакет Flutter для замеров времени работы алгоритма и отображения результатов.

## Возможности

- Измерение времени выполнения алгоритмов с возможностью нескольких замеров по разным ключам
- Опциональный запуск расчётов энное количество раз для определения более точного времени выполнения
- Измерение времени выполнения в миллисекундах, тиках, потребляемой памяти
- Опциональное создание отдельного изолята для выполнения замеров
- Отображение результатов замеров в различных форматах (таблица, гистограмма, линейный график)
- Отображение прогресса выполнения замеров
- Использование InheritedWidget для передачи настроек через дерево виджетов

## Начало работы

### Установка

Добавьте пакет в зависимости вашего проекта:

```yaml
dependencies:
  measures: ^0.0.1
```

### Импорт

```dart
import 'package:measures/measures.dart';
```

## Использование

### Базовая настройка

```dart
// Создаем экземпляры MeasureRunner и MeasureStorage
final runner = SynchronousMeasureRunner();
final storage = MemoryMeasureStorage();
final service = MeasureService(runner: runner, storage: storage);

// Создаем конфигурацию по умолчанию
const config = MeasureConfig(iterations: 10);

// Оборачиваем приложение в MeasureInheritedWidget
return MaterialApp(
  home: MeasureInheritedWidget(
    measureService: service,
    config: config,
    child: const HomePage(),
  ),
);
```

### Измерение времени выполнения

```dart
// Получаем сервис из контекста
final service = MeasureInheritedWidget.getService(context);
final config = MeasureInheritedWidget.getConfig(context);

// Измеряем время выполнения функции
await service.measure(
  'bubble_sort',
  () => bubbleSort(List.generate(1000, (_) => Random().nextInt(10000))),
  config,
);

// Измеряем время выполнения асинхронной функции
await service.measureAsync(
  'async_operation',
  () async => await fetchData(),
  config,
);
```

### Отображение результатов

```dart
// Отображаем результаты замеров
MeasureWidget(
  title: 'Результаты сортировки',
  keysToCompare: const [
    'bubble_sort',
    'insertion_sort',
    'quick_sort',
  ],
  viewType: MeasureViewType.table, // или barChart, lineChart
),
```

## Архитектура

Пакет построен на основе следующих абстракций:

- `MeasureConfig` - конфигурация замеров (количество повторений, использование изолятов и т.д.)
- `MeasureResult` - результаты замеров (время, память, тики)
- `MeasureRunner` - абстрактный класс для запуска замеров
- `MeasureStorage` - хранение результатов замеров
- `MeasureService` - основной класс для работы с замерами
- `MeasureInheritedWidget` - для передачи настроек через дерево виджетов
- `MeasureWidget` - основной виджет для отображения результатов

## Пример

Полный пример использования пакета можно найти в директории [example](example).

## Дополнительная информация

### Реализации MeasureRunner

- `SynchronousMeasureRunner` - запуск замеров в основном потоке
- `IsolateMeasureRunner` - запуск замеров в отдельном изоляте

### Реализации MeasureStorage

- `MemoryMeasureStorage` - хранение результатов в памяти

### Типы отображения результатов

- `MeasureViewType.table` - табличное представление
- `MeasureViewType.barChart` - гистограмма
- `MeasureViewType.lineChart` - линейный график
