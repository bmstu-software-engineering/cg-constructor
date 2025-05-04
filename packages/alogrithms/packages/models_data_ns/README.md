# Models Data NS

Библиотека общих моделей данных для алгоритмов. Этот пакет содержит обобщенные модели данных, которые могут быть использованы в различных алгоритмах, что позволяет ускорить кодогенерацию и переиспользовать однотипные модели.

## Модели

### PointSetModel

Модель для алгоритмов, работающих с одним набором точек.

```dart
PointSetModel({required List<Point> points})
```

### PointSetWithReferencePointModel

Модель для алгоритмов, работающих с набором точек и дополнительной контрольной точкой.

```dart
PointSetWithReferencePointModel({
  required List<Point> points,
  required Point referencePoint,
})
```

### DualPointSetModel

Модель для алгоритмов, работающих с двумя наборами точек.

```dart
DualPointSetModel({
  required List<Point> firstPoints,
  required List<Point> secondPoints,
})
```

### GeometricTransformationModel

Модель для алгоритмов геометрических преобразований.

```dart
GeometricTransformationModel({
  required Vector translation,
  required Angle rotation,
  required ScaleTransformationModel scaling,
})
```

## Использование

Для использования моделей в своем алгоритме, импортируйте пакет:

```dart
import 'package:models_data_ns/models_data_ns.dart';
```

Затем вы можете использовать модели в своем коде:

```dart
class MyAlgorithm implements Algorithm<PointSetModel> {
  @override
  AlgorithmResult execute(PointSetModel data) {
    // Реализация алгоритма
  }
}
```

## Преимущества использования общих моделей

1. **Ускорение разработки**: Не нужно создавать новые модели для каждого алгоритма.
2. **Единообразие**: Все алгоритмы используют одинаковые модели данных.
3. **Упрощение кодогенерации**: Генерация кода для форм происходит один раз для каждой модели.
4. **Переиспользование**: Модели могут быть использованы в различных алгоритмах.
