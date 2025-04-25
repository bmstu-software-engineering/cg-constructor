# Forms

Модульный пакет для Flutter, предоставляющий компоненты для ввода и валидации различных типов данных, а также генератор типизированных форм.

## Возможности

- Готовые компоненты для ввода различных типов данных (числа, точки, углы, векторы и т.д.)
- Валидация данных
- Динамические формы на основе конфигурации
- Генератор типизированных форм для борьбы с передачей значений в виде `Map<String, Object?>`

## Установка

```yaml
dependencies:
  forms:
    path: path/to/forms
```

## Использование

### Базовые компоненты

```dart
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

// Создание полей формы
final numberField = NumberField(
  config: NumberFieldConfig(
    label: 'Число',
    min: 0,
    max: 100,
    isRequired: true,
  ),
);

final pointField = PointField(
  config: PointFieldConfig(
    label: 'Точка',
    xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
    yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
  ),
);

// Установка значений
numberField.value = 42;
pointField.value = const Point(x: 10, y: 20);

// Валидация
final numberError = numberField.validate();
final pointError = pointField.validate();

// Проверка валидности
final isNumberValid = numberField.isValid();
final isPointValid = pointField.isValid();
```

### Динамические формы

```dart
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

// Создание конфигурации формы
final formConfig = FormConfig(
  name: 'Моя форма',
  fields: [
    FieldConfigEntry(
      id: 'number',
      type: FieldType.number,
      config: NumberFieldConfig(
        label: 'Число',
        min: 0,
        max: 100,
        isRequired: true,
      ),
    ),
    FieldConfigEntry(
      id: 'point',
      type: FieldType.point,
      config: PointFieldConfig(
        label: 'Точка',
        xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
        yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
      ),
    ),
  ],
);

// Создание модели формы
final formModel = DynamicFormModel(config: formConfig);

// Установка значений
formModel.setValues({
  'number': 42,
  'point': const Point(x: 10, y: 20),
});

// Получение значений
final values = formModel.getValues();
final number = values['number'] as double?;
final point = values['point'] as Point?;

// Валидация
formModel.validate();
final isValid = formModel.isValid();
```

## Генератор типизированных форм

Генератор типизированных форм позволяет создавать типобезопасные формы на основе аннотаций.

### Настройка

1. Добавьте зависимость `build_runner` в `dev_dependencies`:

```yaml
dev_dependencies:
  build_runner: ^2.4.7
```

2. Создайте класс формы с аннотациями:

```dart
import 'package:forms/forms_generator.dart';
import 'package:models_ns/models_ns.dart';

// Аннотация для генерации формы
@FormGen(name: 'Пользовательская форма')
class UserForm {
  // Аннотации для полей
  @NumberField(
    label: 'Возраст',
    min: 18,
    max: 100,
    isRequired: true,
  )
  final double age;

  @PointField(
    label: 'Координаты',
    xConfig: NumberField(label: 'X', min: 0, max: 100),
    yConfig: NumberField(label: 'Y', min: 0, max: 100),
  )
  final Point location;

  const UserForm({
    required this.age,
    required this.location,
  });
}

// Подключение сгенерированного кода
part 'my_file.g.dart';
```

3. Запустите генератор кода:

```bash
flutter pub run build_runner build
```

### Использование сгенерированного кода

```dart
// Создание конфигурации формы
final formConfig = UserFormConfig();

// Создание модели формы
final formModel = formConfig.createModel();

// Установка значений
formModel.values = UserForm(
  age: 25,
  location: const Point(x: 10, y: 20),
);

// Получение значений
final values = formModel.values;
print('Возраст: ${values.age}');
print('Координаты: ${values.location}');

// Валидация
formModel.validate();
print('Форма валидна: ${formModel.isValid()}');

// Совместимость с DynamicFormModel
final dynamicModel = formModel.toDynamicFormModel();
```

## Преимущества генератора типизированных форм

1. **Типобезопасность**: ошибки будут обнаруживаться на этапе компиляции
2. **Автодополнение в IDE**: разработчики получат подсказки при работе с формами
3. **Меньше ошибок**: нет необходимости помнить строковые идентификаторы полей
4. **Совместимость**: сохраняется совместимость с текущей реализацией
5. **Удобство использования**: более чистый и понятный API

## Поддерживаемые типы полей

- `NumberField` - числовое поле
- `PointField` - поле точки (x, y)
- `AngleField` - поле угла
- `VectorField` - поле вектора
- `ScaleField` - поле масштаба
- `PolygonField` - поле многоугольника
- `TriangleField` - поле треугольника
- `RectangleField` - поле прямоугольника
- `LineField` - поле линии
- `ListField` - поле списка
