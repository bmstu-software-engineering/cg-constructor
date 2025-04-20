# Forms

Модульный пакет для Flutter, предоставляющий компоненты для ввода и валидации различных типов данных, таких как точки, векторы, углы, масштабы и геометрические фигуры.

## Возможности

- Ввод и валидация различных типов данных:
  - Числа
  - Точки (x, y)
  - Углы поворота
  - Векторы перемещения
  - Коэффициенты масштабирования
  - Многоугольники
  - Треугольники
  - Прямоугольники
  - Списки полей одного типа
- Гибкая система конфигурации полей ввода
- Встроенные валидаторы для различных типов данных
- Поддержка пользовательских валидаторов
- Готовые виджеты для всех типов полей
- Интеграция с библиотекой models_ns
- Поддержка DiagnosticableTreeMixin для улучшения диагностики

## Начало работы

### Зависимости

Добавьте пакет в ваш `pubspec.yaml`:

```yaml
dependencies:
  forms:
    path: path/to/forms
  models_ns:
    path: path/to/models_ns
```

### Импорт

```dart
import 'package:forms/forms.dart';
```

## Использование

### Поля ввода

#### Числовое поле

```dart
// Создание конфигурации
final numberConfig = NumberFieldConfig(
  label: 'Число',
  min: 0,
  max: 100,
  isRequired: true,
);

// Создание поля
final numberField = NumberField(config: numberConfig);

// Установка значения
numberField.value = 42;

// Получение значения
final value = numberField.value; // 42

// Валидация
final error = numberField.validate(); // null, если значение валидно
```

#### Поле для ввода точки

```dart
// Создание конфигурации
final pointConfig = PointFieldConfig(
  label: 'Точка',
  xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
  yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
);

// Создание поля
final pointField = PointField(config: pointConfig);

// Установка значения
pointField.value = Point(x: 10, y: 20);

// Получение значения
final point = pointField.value; // Point(x: 10, y: 20)

// Доступ к отдельным полям
final xField = pointField.xField;
final yField = pointField.yField;
```

### Виджеты

Пакет предоставляет готовые виджеты для всех типов полей:

```dart
// Числовое поле
NumberFieldWidget(
  field: numberField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле точки
PointFieldWidget(
  field: pointField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле угла
AngleFieldWidget(
  field: angleField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле вектора
VectorFieldWidget(
  field: vectorField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле масштабирования
ScaleFieldWidget(
  field: scaleField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле треугольника
TriangleFieldWidget(
  field: triangleField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле прямоугольника
RectangleFieldWidget(
  field: rectangleField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле многоугольника
PolygonFieldWidget(
  field: polygonField,
  onChanged: (value) {
    // Обработка изменения значения
  },
)

// Поле списка
ListFieldWidget<double, NumberField>(
  field: numberListField,
  onChanged: (values) {
    // Обработка изменения значения
  },
  itemBuilder: (context, field, onChanged) {
    return NumberFieldWidget(
      field: field,
      onChanged: onChanged,
    );
  },
)
```

### Геометрические фигуры

#### Треугольник

```dart
// Создание конфигурации
final triangleConfig = TriangleFieldConfig(
  label: 'Треугольник',
  aConfig: PointFieldConfig(label: 'Точка A'),
  bConfig: PointFieldConfig(label: 'Точка B'),
  cConfig: PointFieldConfig(label: 'Точка C'),
);

// Создание поля
final triangleField = TriangleField(config: triangleConfig);

// Установка значения
triangleField.value = Triangle(
  a: Point(x: 0, y: 0),
  b: Point(x: 10, y: 0),
  c: Point(x: 5, y: 10),
);

// Получение значения
final triangle = triangleField.value;

// Доступ к отдельным полям
final aField = triangleField.aField;
final bField = triangleField.bField;
final cField = triangleField.cField;
```

#### Многоугольник

```dart
// Создание конфигурации
final polygonConfig = PolygonFieldConfig(
  label: 'Многоугольник',
  minPoints: 3,
  maxPoints: 10,
);

// Создание поля
final polygonField = PolygonField(config: polygonConfig);

// Добавление точки
polygonField.addPoint();

// Удаление точки
polygonField.removePoint(0);

// Получение списка полей точек
final pointFields = polygonField.pointFields;
```

#### Список полей одного типа

```dart
// Создание конфигурации
final listConfig = ListFieldConfig<double>(
  label: 'Список чисел',
  minItems: 1,
  maxItems: 5,
  isRequired: true,
  createField: () => NumberField(
    config: NumberFieldConfig(
      label: 'Число',
      min: 0,
      max: 100,
    ),
  ),
);

// Создание поля
final listField = ListField<double, NumberField>(
  config: listConfig,
  initialValue: [10, 20, 30],
);

// Добавление нового поля
listField.addField();

// Удаление поля
listField.removeField(0);

// Получение списка полей
final fields = listField.fields;

// Получение значения
final values = listField.value; // [10, 20, 30]
```

## Дополнительная информация

Этот пакет разработан для использования в проектах компьютерной графики и геометрических приложениях. Он тесно интегрирован с библиотекой models_ns, которая предоставляет базовые модели для работы с геометрическими объектами.

### Модели

Пакет включает следующие модели:

- `Angle` - угол поворота
- `Vector` - вектор перемещения
- `Scale` - коэффициенты масштабирования
- `Polygon` - многоугольник
- `Triangle` - треугольник
- `Rectangle` - прямоугольник

Все модели реализуют интерфейс `Validatable` и используют миксин `DiagnosticableTreeMixin` для улучшения диагностики в Flutter DevTools.

### Классы с поддержкой диагностики

#### DiagnosticableFormField

Пакет предоставляет базовый класс `DiagnosticableFormField`, который реализует интерфейсы `FormField` и `Validatable`, а также использует миксин `DiagnosticableTreeMixin` для улучшения диагностики в Flutter DevTools. Этот класс можно использовать в качестве базового для создания собственных полей форм с поддержкой диагностики.

```dart
// Пример создания поля формы с поддержкой диагностики
class MyFormField extends DiagnosticableFormField<String> {
  // Реализация методов интерфейса FormField
  @override
  String? get value => _value;

  @override
  set value(String? newValue) {
    _value = newValue;
  }

  @override
  String? get error => _error;

  @override
  String? validate() {
    // Реализация валидации
    return null;
  }

  @override
  void reset() {
    _value = null;
    _error = null;
  }

  // Приватные поля
  String? _value;
  String? _error;
}
```

#### DiagnosticsNodeWidget

Пакет также предоставляет виджет `DiagnosticsNodeWidget`, который позволяет отображать диагностическую информацию в пользовательском интерфейсе. Этот виджет может быть полезен для отладки и демонстрации возможностей DiagnosticableTreeMixin.

```dart
// Пример использования DiagnosticsNodeWidget
DiagnosticsNodeWidget(
  diagnosticsNode: angleField.value!,
  title: 'Диагностика угла',
)
```

Виджет отображает:
- Заголовок
- Результат вызова toString() для диагностического узла
- Список всех диагностических свойств узла с их значениями

Пример использования можно найти в файле `example/lib/diagnostics_demo.dart`.

#### DiagnosticableFormModel

Пакет также предоставляет базовый класс `DiagnosticableFormModel`, который реализует интерфейс `FormModel` и использует миксин `DiagnosticableTreeMixin` для улучшения диагностики в Flutter DevTools. Этот класс можно использовать в качестве базового для создания собственных моделей форм с поддержкой диагностики.

```dart
// Пример создания модели формы с поддержкой диагностики
class MyFormModel extends DiagnosticableFormModel {
  // Поля формы
  final nameField = MyFormField();
  final emailField = MyFormField();
  
  @override
  bool isValid() {
    return nameField.isValid() && emailField.isValid();
  }
  
  @override
  void validate() {
    nameField.validate();
    emailField.validate();
  }
  
  @override
  void reset() {
    nameField.reset();
    emailField.reset();
  }
  
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MyFormField>('nameField', nameField));
    properties.add(DiagnosticsProperty<MyFormField>('emailField', emailField));
  }
}
```

### Валидаторы

Пакет включает следующие встроенные валидаторы:

- `Validators.required` - проверка на обязательное поле
- `Validators.range` - проверка числа на вхождение в диапазон
- `Validators.colorHex` - проверка строки на соответствие формату цвета #RRGGBB
