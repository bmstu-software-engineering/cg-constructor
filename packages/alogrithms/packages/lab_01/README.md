# Лабораторная работа 01 - Алгоритмы вычислительной геометрии

Этот пакет содержит реализации различных алгоритмов вычислительной геометрии для лабораторной работы 01.

## Структура проекта

- `lab_01_common/` - общие компоненты, используемые всеми алгоритмами

## Инструкция по добавлению своего алгоритма

### 1. Создайте новую директорию для вашего алгоритма

Создайте директорию `lab_01_XX`, где XX - номер вашего варианта, в директории `packages/lab_01/`.

```bash
mkdir -p packages/lab_01/lab_01_XX
```

### 2. Инициализируйте структуру пакета

Скопируйте базовую структуру из существующего алгоритма (например, lab_01_27) и адаптируйте её под свой вариант:

```bash
cp -r packages/lab_01/lab_01_27/* packages/lab_01/lab_01_XX/
```

### 3. Обновите файлы пакета

#### 3.1. Обновите pubspec.yaml

Отредактируйте файл `packages/lab_01/lab_01_XX/pubspec.yaml`, изменив название, описание и зависимости пакета.

```yaml
name: lab_01_XX
description: Алгоритм для варианта XX лабораторной работы 01
version: 1.0.0

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  algorithm_interface:
    path: ../../algorithm_interface
  lab_01_common:
    path: ../lab_01_common
  # Добавьте другие необходимые зависимости
```

#### 3.2. Реализуйте модель данных

Отредактируйте файл `packages/lab_01/lab_01_XX/lib/src/data.dart`:

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
    minItems: 3,
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

Отредактируйте файл `packages/lab_01/lab_01_XX/lib/src/algorithm.dart`:

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

  @override
  ViewerResultModel calculate() {
    // Реализуйте логику вашего алгоритма
    // ...

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

Отредактируйте файл `packages/lab_01/lab_01_XX/lib/src/factory.dart`:

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

Отредактируйте файл `packages/lab_01/lab_01_XX/lib/algorithm.dart`:

```dart
import 'package:flutter/foundation.dart';

export 'src/factory.dart';

@visibleForTesting
export 'src/data.dart';

@visibleForTesting
export 'src/algorithm.dart';
```

### 4. Сгенерируйте код для модели данных

Запустите генерацию кода для модели данных:

```bash
cd packages/lab_01/lab_01_XX
dart run build_runner build --delete-conflicting-outputs
```

### 5. Создайте тесты для вашего алгоритма

Создайте файл `packages/lab_01/lab_01_XX/test/algorithms_lab_01_XX_test.dart` с тестами для вашего алгоритма.

### 6. Интеграция с основным проектом

Для интеграции вашего алгоритма с основным проектом, вам нужно зарегистрировать фабрику вашего алгоритма в провайдере алгоритмов.

## Использование общих компонентов

В пакете `lab_01_common` доступны различные утилиты для работы с геометрическими объектами:

- `GeometryCalculator` - утилиты для геометрических вычислений
- `TriangleGenerator` - генерация треугольников из множества точек
- `TriangleAnalyzer` - анализ свойств треугольников
- `ObtuseTriangleFinder` - поиск тупоугольных треугольников
- `TriangleMedianCalculator` - вычисление медиан треугольника
- `PointInTriangleChecker` - проверка принадлежности точки треугольнику
- `PointsOnLineChecker` - проверка расположения точек на одной прямой

## Пример использования

```dart
import 'package:lab_01_common/lab_01_common.dart';

// Создание экземпляра алгоритма
final algorithm = AlgorithmL01VXX();

// Получение модели данных
final dataModel = algorithm.getDataModel();

// Выполнение расчета
final result = algorithm.calculate();

// Использование результата
final points = result.points;
final lines = result.lines;
final markdownInfo = result.markdownInfo;
```

## Дополнительная информация

Для более подробной информации о структуре проекта и интерфейсах алгоритмов см. документацию в пакетах `algorithm_interface` и `lab_01_common`.
