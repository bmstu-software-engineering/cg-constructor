# Models NS

Пакет геометрических моделей для работы с двумерными объектами в Dart и Flutter.

## Возможности

Пакет предоставляет набор классов для работы с различными геометрическими объектами:

- **Point** - точка в двумерном пространстве
- **Line** - линия, определенная двумя точками
- **Vector** - вектор перемещения
- **Angle** - угол поворота
- **Scale** - коэффициенты масштабирования
- **Polygon** - многоугольник
- **Triangle** - треугольник
- **Rectangle** - прямоугольник

Все модели поддерживают сериализацию/десериализацию JSON и имеют удобные методы для работы с ними.

## Начало работы

Добавьте пакет в зависимости вашего проекта:

```yaml
dependencies:
  models_ns: 
    path: ../models_ns # укажите здесь путь относительно вашего пакета
```

Затем импортируйте пакет в вашем коде:

```dart
import 'package:models_ns/models_ns.dart';
```

## Использование

### Point (Точка)

```dart
// Создание точки
final point = Point(x: 10, y: 20);

// Точки считаются равными, если их координаты совпадают
final point2 = Point(x: 10, y: 20);
print(point == point2); // true
```

### Line (Линия)

```dart
// Создание линии
final line = Line(
  a: Point(x: 0, y: 0),
  b: Point(x: 10, y: 10),
);

// Линии считаются равными, если их точки совпадают
final line2 = Line(
  a: Point(x: 0, y: 0),
  b: Point(x: 10, y: 10),
);
print(line == line2); // true
```

### Vector (Вектор)

```dart
// Создание вектора
final vector = Vector(dx: 3, dy: 4);

// Получение длины вектора
print(vector.length); // 5.0

// Получение угла вектора в радианах
print(vector.angle); // 0.9272952180016122

// Нормализация вектора (единичный вектор)
final normalized = vector.normalized;
print(normalized); // Vector(dx: 0.6, dy: 0.8)

// Операции с векторами
final v1 = Vector(dx: 1, dy: 2);
final v2 = Vector(dx: 3, dy: 4);

print(v1 + v2); // Vector(dx: 4, dy: 6)
print(v1 - v2); // Vector(dx: -2, dy: -2)
print(v1 * 2); // Vector(dx: 2, dy: 4)
print(v1 / 2); // Vector(dx: 0.5, dy: 1.0)
```

### Angle (Угол)

```dart
// Создание угла
final angle = Angle(value: 45);

// Нормализация угла в диапазон [0, 360)
final angle2 = Angle(value: 370);
print(angle2.normalize()); // Angle(value: 10°)

// Конвертация в радианы
print(angle.toRadians()); // 0.7853981633974483

// Создание угла из радиан
final angleFromRadians = Angle.fromRadians(Math.pi / 4);
print(angleFromRadians.value); // 45.0
```

### Scale (Масштаб)

```dart
// Создание масштаба
final scale = Scale(x: 2, y: 3);

// Создание равномерного масштаба
final uniformScale = Scale.uniform(2);
print(uniformScale); // Scale(x: 2, y: 2)

// Проверка равномерности масштаба
print(scale.isUniform); // false
print(uniformScale.isUniform); // true

// Операции с масштабами
final s1 = Scale(x: 2, y: 3);
final s2 = Scale(x: 4, y: 2);

print(s1 * s2); // Scale(x: 8, y: 6)
print(s1 / s2); // Scale(x: 0.5, y: 1.5)

// Инвертирование масштаба
print(s1.inverted); // Scale(x: 0.5, y: 0.3333333333333333)
```

### Polygon (Многоугольник)

```dart
// Создание многоугольника
final polygon = Polygon(points: [
  Point(x: 0, y: 0),
  Point(x: 10, y: 0),
  Point(x: 10, y: 10),
  Point(x: 0, y: 10),
]);

// Вычисление периметра
print(polygon.perimeter); // 40.0

// Вычисление площади
print(polygon.area); // 100.0

// Вычисление центра
print(polygon.center); // Point(x: 5.0, y: 5.0)

// Валидация
print(polygon.isValid()); // true

final invalidPolygon = Polygon(points: [
  Point(x: 0, y: 0),
  Point(x: 10, y: 0),
]);
print(invalidPolygon.isValid()); // false
print(invalidPolygon.validate()); // Многоугольник должен иметь не менее 3 точек
```

### Triangle (Треугольник)

```dart
// Создание треугольника
final triangle = Triangle(
  a: Point(x: 0, y: 0),
  b: Point(x: 10, y: 0),
  c: Point(x: 5, y: 8.66),
);

// Получение списка точек
print(triangle.points); // [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 5, y: 8.66)]

// Вычисление длин сторон
print(triangle.sideAB); // 10.0
print(triangle.sideBC); // 10.0
print(triangle.sideCA); // 10.0

// Вычисление периметра
print(triangle.perimeter); // 30.0

// Вычисление площади
print(triangle.area); // 43.3

// Вычисление центра
print(triangle.center); // Point(x: 5.0, y: 2.89)

// Проверка типа треугольника
print(triangle.isEquilateral); // true (равносторонний)
print(triangle.isIsosceles); // true (равнобедренный)
print(triangle.isRightAngled); // false (не прямоугольный)
```

### Rectangle (Прямоугольник)

```dart
// Создание прямоугольника
final rectangle = Rectangle(
  topLeft: Point(x: 0, y: 0),
  topRight: Point(x: 10, y: 0),
  bottomRight: Point(x: 10, y: 5),
  bottomLeft: Point(x: 0, y: 5),
);

// Создание прямоугольника из двух углов
final rectangle2 = Rectangle.fromCorners(
  topLeft: Point(x: 0, y: 0),
  bottomRight: Point(x: 10, y: 5),
);

// Получение списка точек
print(rectangle.points); // [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 10, y: 5), Point(x: 0, y: 5)]

// Вычисление ширины и высоты
print(rectangle.width); // 10.0
print(rectangle.height); // 5.0

// Вычисление периметра
print(rectangle.perimeter); // 30.0

// Вычисление площади
print(rectangle.area); // 50.0

// Вычисление центра
print(rectangle.center); // Point(x: 5.0, y: 2.5)

// Проверка, является ли прямоугольник квадратом
print(rectangle.isSquare); // false

final square = Rectangle.fromCorners(
  topLeft: Point(x: 0, y: 0),
  bottomRight: Point(x: 10, y: 10),
);
print(square.isSquare); // true
```

## Дополнительная информация

Все модели в пакете используют библиотеку [freezed](https://pub.dev/packages/freezed) для генерации кода и поддерживают сериализацию/десериализацию JSON.

Большинство моделей реализуют интерфейс `Validatable`, который предоставляет методы для валидации данных:
- `validate()` - возвращает null, если данные валидны, или сообщение об ошибке
- `isValid()` - возвращает true, если данные валидны

Модели также поддерживают отладку с помощью `DiagnosticableTreeMixin`, что делает их удобными для использования в Flutter.
