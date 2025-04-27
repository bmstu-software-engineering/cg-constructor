# Measures


Пакет Flutter для замеров времени работы алгоритма и отображения результатов. Позволяет легко измерять и сравнивать производительность различных алгоритмов и функций в вашем приложении.


## 📋 Содержание

- [Возможности](#возможности)
- [Установка](#установка)
- [Быстрый старт](#быстрый-старт)
- [Подробное руководство](#подробное-руководство)
  - [Конфигурация](#конфигурация)
  - [Измерение производительности](#измерение-производительности)
  - [Отображение результатов](#отображение-результатов)
  - [Работа с изолятами](#работа-с-изолятами)
  - [Управление результатами](#управление-результатами)
- [Архитектура](#архитектура)
- [API Reference](#api-reference)
- [Примеры](#примеры)
- [Советы по использованию](#советы-по-использованию)
- [Вклад в проект](#вклад-в-проект)
- [Лицензия](#лицензия)

## ✨ Возможности

- **Гибкие замеры**: измерение времени выполнения алгоритмов с возможностью нескольких замеров по разным ключам
- **Многократные запуски**: опциональный запуск расчётов энное количество раз для определения более точного времени выполнения
- **Комплексные метрики**: измерение времени выполнения в миллисекундах, тиках, потребляемой памяти
- **Изоляты**: опциональное создание отдельного изолята для выполнения замеров без блокировки UI
- **Разнообразная визуализация**: отображение результатов замеров в различных форматах (таблица, гистограмма, линейный график)
- **Прогресс выполнения**: отображение прогресса выполнения замеров в реальном времени
- **Интеграция с Flutter**: использование InheritedWidget для передачи настроек через дерево виджетов

## 🚀 Установка

Добавьте пакет в зависимости вашего проекта:

```yaml
dependencies:
  measures: ^0.0.1
```

Затем выполните:

```bash
flutter pub get
```

## 🏁 Быстрый старт

### 1. Импортируйте пакет

```dart
import 'package:measures/measures.dart';
```

### 2. Настройте сервис измерений

```dart
// В корне вашего приложения
void main() {
  // Создаем экземпляры MeasureRunner и MeasureStorage
  final runner = SynchronousMeasureRunner();
  final storage = MemoryMeasureStorage();
  final service = MeasureService(runner: runner, storage: storage);

  // Создаем конфигурацию по умолчанию
  const config = MeasureConfig(iterations: 10);

  runApp(
    MaterialApp(
      home: MeasureInheritedWidget(
        measureService: service,
        config: config,
        child: const MyApp(),
      ),
    ),
  );
}
```

### 3. Измерьте производительность функции

```dart
// В вашем виджете
ElevatedButton(
  onPressed: () async {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(context);
    
    await service.measure(
      'bubble_sort',
      () => bubbleSort(List.generate(1000, (_) => Random().nextInt(10000))),
      config,
    );
  },
  child: const Text('Запустить замер'),
),
```

### 4. Отобразите результаты

```dart
MeasureWidget(
  title: 'Результаты замеров',
  keysToCompare: const ['bubble_sort', 'quick_sort'],
  viewType: MeasureViewType.barChart,
),
```

## 📚 Подробное руководство

### Конфигурация

Класс `MeasureConfig` позволяет настроить параметры замеров:

```dart
final config = MeasureConfig(
  iterations: 10,           // Количество повторений для каждого замера
  useIsolate: true,         // Использовать отдельный изолят для замеров
  measureMemory: true,      // Измерять использование памяти
  measureTicks: true,       // Измерять количество тиков процессора
);
```

Вы можете создать базовую конфигурацию и затем модифицировать её для конкретных замеров:

```dart
final baseConfig = MeasureConfig(iterations: 5);
final extendedConfig = baseConfig.copyWith(iterations: 20, useIsolate: true);
```

### Измерение производительности

#### Синхронные функции

```dart
await service.measure(
  'algorithm_name',         // Уникальный ключ для идентификации замера
  () {
    // Ваш алгоритм или функция
    return result;          // Возвращаемое значение (опционально)
  },
  config,                   // Конфигурация замера
);
```

#### Асинхронные функции

```dart
await service.measureAsync(
  'async_operation',
  () async {
    // Ваша асинхронная операция
    final result = await fetchData();
    return result;          // Возвращаемое значение (опционально)
  },
  config,
);
```

### Отображение результатов

Пакет предоставляет три типа отображения результатов:

#### Табличное представление

```dart
MeasureWidget(
  title: 'Результаты в таблице',
  keysToCompare: const ['algorithm1', 'algorithm2'],
  viewType: MeasureViewType.table,
),
```

<p align="center">
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/table_view.png" alt="Table View" width="600"/>
</p>

#### Гистограмма

```dart
MeasureWidget(
  title: 'Сравнение алгоритмов',
  keysToCompare: const ['algorithm1', 'algorithm2', 'algorithm3'],
  viewType: MeasureViewType.barChart,
),
```

<p align="center">
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/bar_chart.png" alt="Bar Chart" width="600"/>
</p>

#### Линейный график

Особенно полезен для отображения результатов по итерациям:

```dart
MeasureWidget(
  title: 'Динамика выполнения',
  keysToCompare: const ['algorithm1', 'algorithm2'],
  viewType: MeasureViewType.lineChart,
),
```

<p align="center">
  <img src="https://raw.githubusercontent.com/username/measures/main/doc/assets/line_chart.png" alt="Line Chart" width="600"/>
</p>

### Работа с изолятами

Для тяжелых вычислений рекомендуется использовать изоляты, чтобы не блокировать UI:

```dart
// Создаем runner с поддержкой изолятов
final runner = IsolateMeasureRunner();
final service = MeasureService(runner: runner, storage: storage);

// Включаем использование изолятов в конфигурации
final config = MeasureConfig(useIsolate: true);

// Запускаем замер в изоляте
await service.measure('heavy_computation', () => heavyComputation(), config);
```

### Управление результатами

#### Получение результатов

```dart
// Получение всех результатов
final results = await service.getResults();

// Получение конкретного результата по ключу
final result = await service.getResult('algorithm_name');
```

#### Удаление результатов

```dart
// Удаление конкретного результата
await service.removeResult('algorithm_name');

// Очистка всех результатов
await service.clearResults();
```

#### Отслеживание прогресса

```dart
// Подписка на обновления прогресса
service.progressStream.listen((progress) {
  print('Прогресс: ${progress.progress * 100}%');
  print('Текущая итерация: ${progress.currentIteration}/${progress.totalIterations}');
});
```

## 🏗️ Архитектура

Пакет построен на основе следующих абстракций:

### Основные классы

- **MeasureConfig** - конфигурация замеров (количество повторений, использование изолятов и т.д.)
- **MeasureResult** - результаты замеров (время, память, тики)
- **MeasureProgress** - информация о прогрессе выполнения замеров
- **MeasureRunner** - абстрактный класс для запуска замеров
- **MeasureStorage** - хранение результатов замеров
- **MeasureService** - основной класс для работы с замерами

### UI компоненты

- **MeasureInheritedWidget** - для передачи настроек через дерево виджетов
- **MeasureWidget** - основной виджет для отображения результатов
- **MeasureTableView** - табличное представление результатов
- **MeasureBarChartView** - отображение результатов в виде гистограммы
- **MeasureLineChartView** - отображение результатов в виде линейного графика

### Реализации

- **SynchronousMeasureRunner** - запуск замеров в основном потоке
- **IsolateMeasureRunner** - запуск замеров в отдельном изоляте
- **MemoryMeasureStorage** - хранение результатов в памяти

## 📖 API Reference

### MeasureService

```dart
// Основные методы
Future<MeasureResult> measure<T>(String key, T Function() function, MeasureConfig config);
Future<MeasureResult> measureAsync<T>(String key, Future<T> Function() function, MeasureConfig config);
Future<void> cancel();
Future<List<MeasureResult>> getResults();
Future<MeasureResult?> getResult(String key);
Future<bool> removeResult(String key);
Future<void> clearResults();

// Стримы для отслеживания изменений
Stream<MeasureProgress> get progressStream;
Stream<List<MeasureResult>> get resultsStream;
```

### MeasureConfig

```dart
MeasureConfig({
  int iterations = 1,
  bool useIsolate = false,
  bool measureMemory = true,
  bool measureTicks = false,
});

MeasureConfig copyWith({
  int? iterations,
  bool? useIsolate,
  bool? measureMemory,
  bool? measureTicks,
});
```

### MeasureResult

```dart
MeasureResult({
  required String key,
  required List<int> executionTimeMs,
  List<int> memoryUsage = const [],
  List<int> ticks = const [],
});

// Статистические показатели
double get averageExecutionTimeMs;
double get medianExecutionTimeMs;
int get minExecutionTimeMs;
int get maxExecutionTimeMs;
double get stdDevExecutionTimeMs;
double get averageMemoryUsage;
double get averageTicks;
```

### MeasureWidget

```dart
MeasureWidget({
  Key? key,
  required String title,
  required List<String> keysToCompare,
  MeasureViewType viewType = MeasureViewType.table,
  double height = 300,
});
```

## 📋 Примеры

Полный пример использования пакета можно найти в директории [example](example).

### Сравнение алгоритмов сортировки

```dart
// Измерение времени выполнения различных алгоритмов сортировки
await service.measure(
  'bubble_sort',
  () => bubbleSort(List.generate(5000, (_) => Random().nextInt(10000))),
  config,
);

await service.measure(
  'quick_sort',
  () {
    final list = List.generate(10000, (_) => Random().nextInt(10000));
    quickSort(list, 0, list.length - 1);
  },
  config,
);

await service.measure(
  'dart_sort',
  () {
    final list = List.generate(10000, (_) => Random().nextInt(10000));
    list.sort();
  },
  config,
);

// Отображение результатов
MeasureWidget(
  title: 'Сравнение алгоритмов сортировки',
  keysToCompare: const ['bubble_sort', 'quick_sort', 'dart_sort'],
  viewType: MeasureViewType.barChart,
),
```

### Измерение производительности асинхронных операций

```dart
await service.measureAsync(
  'fetch_data',
  () async => await httpClient.get('https://api.example.com/data'),
  config,
);

await service.measureAsync(
  'process_data',
  () async {
    final data = await loadData();
    return processData(data);
  },
  config,
);

MeasureWidget(
  title: 'Производительность API',
  keysToCompare: const ['fetch_data', 'process_data'],
  viewType: MeasureViewType.table,
),
```

## 💡 Советы по использованию

- **Используйте изоляты** для тяжелых вычислений, чтобы не блокировать UI
- **Увеличивайте количество итераций** для получения более точных результатов
- **Сравнивайте алгоритмы** на одинаковых входных данных для корректного сравнения
- **Используйте разные типы отображения** для разных сценариев:
  - Таблицы для детальной информации
  - Гистограммы для быстрого визуального сравнения
  - Линейные графики для анализа производительности по итерациям
- **Отслеживайте прогресс** для длительных операций, чтобы информировать пользователя

## 🤝 Вклад в проект

Мы приветствуем вклад в развитие пакета! Если у вас есть идеи по улучшению или вы нашли ошибку, пожалуйста, создайте issue или pull request на GitHub.

1. Fork репозитория
2. Создайте ветку для вашей функциональности (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add some amazing feature'`)
4. Push в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.
