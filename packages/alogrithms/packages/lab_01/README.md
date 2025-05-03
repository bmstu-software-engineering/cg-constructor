# Лабораторная работа 01 - Алгоритмы вычислительной геометрии

Этот пакет содержит реализации различных алгоритмов вычислительной геометрии для лабораторной работы 01.

## Структура проекта

- `lab_01_common/` - общие компоненты, используемые всеми алгоритмами
- `lab_01_27/` - алгоритм для варианта 27
- `lab_01_40/` - алгоритм для варианта 40
- `lab_01_41/` - алгоритм для варианта 41 (поиск двух треугольников с максимальным отношением площадей)
- `lab_01_42/` - алгоритм для варианта 42 (поиск двух треугольников с минимальным отношением периметров)
- `lab_01_43/` - алгоритм для варианта 43 (поиск двух треугольников с максимальным углом между прямой через центры вписанных окружностей и осью абсцисс)

## Инструкция по добавлению своего алгоритма

### 1. Создайте новую директорию для вашего алгоритма

Создайте директорию `lab_01_XX`, где XX - номер вашего варианта, в директории `packages/lab_01/`.

```bash
mkdir -p lab_01_XX
```

### 2. Инициализируйте структуру пакета

Скопируйте базовую структуру из существующего алгоритма (например, lab_01_27) и адаптируйте её под свой вариант:

```bash
cp -r lab_01_27/* lab_01_XX/
```

### 3. Обновите файлы пакета

#### 3.1. Обновите pubspec.yaml

Отредактируйте файл `lab_01_XX/pubspec.yaml`, изменив название, описание и зависимости пакета.

```yaml
name: lab_01_XX
description: "Алгоритм для варианта XX лабораторной работы 01."
version: 0.0.1
homepage:
publish_to: 'none'

environment:
  sdk: ^3.7.0
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  lab_01_common:
    path: ../lab_01_common

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
```

#### 3.2. Реализуйте модель данных

Отредактируйте файл `lab_01_XX/lib/src/data.dart`:

```dart
import 'package:lab_01_common/forms_annotations.dart';
import 'package:lab_01_common/lab_01_common.dart';

part 'data.g.dart';

/// Модель данных для вашего алгоритма
@FormGen()
class AlgorithmLab01XXDataModel implements AlgorithmData {
  /// Определите необходимые поля данных с аннотациями для генерации форм
  @ListFieldGen(
    label: 'Множество точек',
    itemConfig: PointFieldGen(),
    minItems: 3, // Укажите минимальное количество точек, необходимое для вашего алгоритма
  )
  final List<Point> points;

  /// Добавьте другие необходимые поля

  /// Конструктор
  const AlgorithmLab01XXDataModel({required this.points});
}

class AlgorithmL01VXXDataModelImpl implements FormsDataModel {
  final _config = AlgorithmLab01XXDataModelFormConfig();
  late final _model = _config.createModel();

  @override
  AlgorithmLab01XXDataModel get data => _model.values;

  @override
  DynamicFormModel get config => _model.toDynamicFormModel();
}
```

#### 3.3. Реализуйте алгоритм

Отредактируйте файл `lab_01_XX/lib/src/algorithm.dart`:

```dart
import 'package:lab_01_common/lab_01_common.dart';
import 'package:flutter/foundation.dart';

import 'data.dart';

/// Реализация вашего алгоритма
class AlgorithmL01VXX implements Algorithm<FormsDataModel, ViewerResultModel> {
  @visibleForTesting
  const AlgorithmL01VXX.fromModel(this._model);

  factory AlgorithmL01VXX() =>
      AlgorithmL01VXX.fromModel(AlgorithmL01VXXDataModelImpl());

  final AlgorithmL01VXXDataModelImpl _model;

  @override
  FormsDataModel getDataModel() => _model;

  // Определите константы для визуализации
  static const String _someColor = '#00FF00'; // Зеленый цвет

  @override
  ViewerResultModel calculate() {
    final points = _model.data.points;
    
    // Проверка на достаточное количество точек
    if (points.length < 3) { // Замените на нужное количество
      throw InsufficientPointsException(
        'Множество точек',
        3, // Минимальное количество точек
        points.length,
      );
    }
    
    // Реализуйте логику вашего алгоритма
    // ...
    
    // Подготовьте данные для визуализации
    final List<Point> resultPoints = [];
    final List<Line> resultLines = [];
    
    // Добавьте точки и линии для визуализации
    // ...
    
    // Подготовьте текстовую информацию в формате Markdown
    final markdownInfo = '''
## Результаты анализа

### Заголовок раздела
- Пункт 1: значение
- Пункт 2: значение

### Визуализация
- Зеленый: описание зеленых элементов
- Красный: описание красных элементов
''';

    // Верните результат для визуализации
    return ViewerResultModel(
      points: resultPoints,
      lines: resultLines,
      markdownInfo: markdownInfo,
    );
  }

  // Добавьте вспомогательные методы
}
```

#### 3.4. Реализуйте фабрику алгоритма

Отредактируйте файл `lab_01_XX/lib/src/factory.dart`:

```dart
import 'package:lab_01_common/lab_01_common.dart';

import 'algorithm.dart';

/// Фабрика для создания вашего алгоритма
class AlgorithmL01VXXFactory implements AlgorithmFactory {
  /// Создает экземпляр алгоритма
  @override
  Algorithm create() => AlgorithmL01VXX();

  /// Название алгоритма
  @override
  String get name => 'lab_01_XX';

  /// Название алгоритма для отображения
  @override
  String get title => 'Лабораторная работа 01, Вариант XX';

  /// Описание алгоритма
  @override
  String get description =>
      'Описание вашего алгоритма...';
}
```

#### 3.5. Обновите основной файл алгоритма

Отредактируйте файл `lab_01_XX/lib/algorithm.dart`:

```dart
library lab_01_XX;

export 'src/factory.dart';
export 'src/algorithm.dart';
export 'src/data.dart';
```

### 4. Сгенерируйте код для модели данных

Запустите генерацию кода для модели данных:

```bash
./codegen.sh
```

Этот скрипт запустит генерацию кода для всех пакетов в проекте.

### 5. Создайте тесты для вашего алгоритма

Создайте файл `lab_01_XX/test/algorithms_lab_01_XX_test.dart` с тестами для вашего алгоритма:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_XX/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01VXXDataModelImpl
class AlgorithmL01VXXDataModelImplMock extends Mock
    implements AlgorithmL01VXXDataModelImpl {}

void main() {
  late AlgorithmL01VXX algorithm;
  late AlgorithmL01VXXDataModelImplMock model;

  setUp(() {
    model = AlgorithmL01VXXDataModelImplMock();
    algorithm = AlgorithmL01VXX.fromModel(model);
  });

  group('AlgorithmL01VXX - Тестирование', () {
    test('базовый тест', () {
      // Устанавливаем тестовые данные
      when(() => model.data).thenReturn(
        AlgorithmLab01XXDataModel(
          points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(x: 0, y: 1),
            // Добавьте другие точки, необходимые для теста
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем результат
      expect(result.points, isNotEmpty);
      expect(result.lines, isNotEmpty);
      expect(result.markdownInfo, isNotEmpty);
      
      // Добавьте другие проверки, специфичные для вашего алгоритма
    });

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          AlgorithmLab01XXDataModel(
            points: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              // Недостаточно точек для алгоритма
            ],
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
        expect(
          () => algorithm.calculate(),
          throwsA(isA<InsufficientPointsException>()),
        );
      },
    );
    
    // Добавьте другие тесты для вашего алгоритма
  });
}
```

### 6. Запустите тесты

Запустите тесты для вашего алгоритма:

```bash
./run_tests.sh
```

Этот скрипт запустит тесты для всех пакетов в проекте.

## Использование общих компонентов

В пакете `lab_01_common` доступны различные утилиты для работы с геометрическими объектами:

- `GeometryCalculator` - утилиты для геометрических вычислений (площадь, периметр, центр вписанной окружности, угол между прямыми и т.д.)
- `TriangleGenerator` - генерация треугольников из множества точек
- `TriangleAnalyzer` - анализ свойств треугольников
- `ObtuseTriangleFinder` - поиск тупоугольных треугольников
- `TriangleMedianCalculator` - вычисление медиан треугольника
- `PointInTriangleChecker` - проверка принадлежности точки треугольнику
- `PointsOnLineChecker` - проверка расположения точек на одной прямой

## Примеры реализованных алгоритмов

### Вариант 41: Поиск двух треугольников с максимальным отношением площадей

Алгоритм находит два треугольника A и B, такие что отношение площадей Sa/Sb максимально, при условии, что никакие две точки обоих треугольников не совпадают.

### Вариант 42: Поиск двух треугольников с минимальным отношением периметров

Алгоритм находит два треугольника A и B, такие что отношение периметров Pa/Pb минимально, при условии, что никакие две точки обоих треугольников не совпадают.

### Вариант 43: Поиск двух треугольников с максимальным углом между прямой через центры вписанных окружностей и осью абсцисс

Алгоритм находит два треугольника A и B, такие что прямая, проходящая через центры вписанных окружностей, образует с осью абсцисс максимальный угол, при условии, что никакие две точки обоих треугольников не совпадают.

## Советы по реализации алгоритмов

1. **Проверка входных данных**: Всегда проверяйте, что входные данные соответствуют требованиям алгоритма (достаточное количество точек, отсутствие вырожденных треугольников и т.д.).

2. **Обработка исключительных ситуаций**: Используйте классы исключений из `lab_01_common` для обработки исключительных ситуаций:
   - `InsufficientPointsException` - недостаточное количество точек
   - `CalculationException` - ошибка в процессе вычислений

3. **Визуализация результатов**: Используйте различные цвета для визуализации различных элементов результата. Добавляйте подробную текстовую информацию в формате Markdown.

4. **Тестирование**: Создавайте тесты для проверки корректности работы алгоритма в различных ситуациях, включая граничные случаи и исключительные ситуации.

## Дополнительная информация

Для более подробной информации о структуре проекта и интерфейсах алгоритмов см. документацию в пакетах `algorithm_interface` и `lab_01_common`.
