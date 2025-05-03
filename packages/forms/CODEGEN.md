# Руководство по кодогенерации в пакете Forms

Этот документ содержит подробную информацию о том, как использовать кодогенерацию в пакете Forms для создания типизированных форм.

## Содержание

1. [Введение](#введение)
2. [Настройка проекта](#настройка-проекта)
3. [Аннотации](#аннотации)
   - [FormGen](#formgen)
   - [Аннотации полей](#аннотации-полей)
4. [Генерация кода](#генерация-кода)
5. [Сгенерированные классы](#сгенерированные-классы)
   - [FormConfig](#formconfig)
   - [FormModel](#formmodel)
6. [Примеры использования](#примеры-использования)
   - [Простая форма](#простая-форма)
   - [Форма со списками](#форма-со-списками)
   - [Вложенные списки](#вложенные-списки)
   - [Необязательные поля](#необязательные-поля)
7. [Расширенные возможности](#расширенные-возможности)
   - [Валидация](#валидация)
   - [Кастомные типы](#кастомные-типы)
8. [Решение проблем](#решение-проблем)

## Введение

Кодогенерация в пакете Forms позволяет автоматически создавать типизированные формы на основе аннотированных классов. Это упрощает работу с формами и обеспечивает типобезопасность при работе с данными.

## Настройка проекта

1. Добавьте необходимые зависимости в `pubspec.yaml`:

```yaml
dependencies:
  forms: ^1.0.0
  forms_annotations: ^1.0.0

dev_dependencies:
  build_runner: ^2.3.0
  forms_generator: ^1.0.0
```

2. Запустите `flutter pub get` для установки зависимостей.

3. Создайте файл `build.yaml` в корне проекта (если его еще нет):

```yaml
targets:
  $default:
    builders:
      forms_generator|form_generator:
        enabled: true
```

## Аннотации

### FormGen

Аннотация `@FormGen` применяется к классам и указывает, что для этого класса нужно сгенерировать код формы.

Параметры:
- `name` (String): Название формы (опционально)
- `validator` (Function): Функция валидации всей формы (опционально)

Пример:

```dart
@FormGen(
  name: 'Форма пользователя',
  validator: (values) {
    if (values['age'] < 21 && values['isDriver']) {
      return 'Водитель должен быть не моложе 21 года';
    }
    return null;
  },
)
class UserForm {
  // ...
}
```

### Аннотации полей

Для каждого типа поля существует своя аннотация:

#### EnumSelectField

```dart
@EnumSelectFieldGen(
  label: 'Пол',
  titleBuilder: (value) => value.toString(),
)
final Gender gender;
```

Параметры:
- `label` (String): Метка поля
- `titleBuilder` (Function): Функция для получения названия значения
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

Для перечислений (enum) можно реализовать интерфейс `EnumSelectEnum`:

```dart
enum Gender implements EnumSelectEnum {
  male,
  female,
  other;

  @override
  String get title {
    switch (this) {
      case Gender.male:
        return 'Мужской';
      case Gender.female:
        return 'Женский';
      case Gender.other:
        return 'Другой';
    }
  }
}
```

#### NumberField

```dart
@NumberField(
  label: 'Возраст',
  min: 18,
  max: 100,
  isRequired: true,
  validator: (value) => value < 21 ? 'Возраст должен быть не менее 21 года' : null,
)
final double age;
```

Параметры:
- `label` (String): Метка поля
- `min` (double): Минимальное значение
- `max` (double): Максимальное значение
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

#### PointField

```dart
@PointField(
  label: 'Координаты',
  isRequired: true,
)
final Point point;
```

Параметры:
- `label` (String): Метка поля
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

#### AngleField

```dart
@AngleField(
  label: 'Угол',
  min: 0,
  max: 360,
  normalize: true,
  isRequired: true,
)
final double angle;
```

Параметры:
- `label` (String): Метка поля
- `min` (double): Минимальное значение угла
- `max` (double): Максимальное значение угла
- `normalize` (bool): Нормализовать ли угол (по умолчанию false)
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

#### VectorField

```dart
@VectorField(
  label: 'Вектор',
  dxConfig: NumberField(
    label: 'Смещение по X',
    min: -100,
    max: 100,
  ),
  dyConfig: NumberField(
    label: 'Смещение по Y',
    min: -100,
    max: 100,
  ),
  isRequired: true,
)
final Vector vector;
```

Параметры:
- `label` (String): Метка поля
- `dxConfig` (NumberFieldAnnotation): Конфигурация для компонента X вектора
- `dyConfig` (NumberFieldAnnotation): Конфигурация для компонента Y вектора
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

#### ListField

```dart
@ListField(
  label: 'Телефоны',
  minItems: 1,
  maxItems: 5,
  itemConfig: NumberField(
    label: 'Телефон',
  ),
  isRequired: true,
)
final List<double> phones;
```

Параметры:
- `label` (String): Метка поля
- `minItems` (int): Минимальное количество элементов
- `maxItems` (int): Максимальное количество элементов
- `itemConfig` (FieldAnnotation): Конфигурация для элементов списка
- `isRequired` (bool): Обязательное ли поле (по умолчанию true)
- `validator` (Function): Функция валидации

## Генерация кода

После создания аннотированных классов, запустите генерацию кода:

```bash
flutter pub run build_runner build
```

Для автоматической генерации кода при изменении файлов:

```bash
flutter pub run build_runner watch
```

Также можно использовать скрипт `codegen.sh` из пакета:

```bash
./codegen.sh
```

## Сгенерированные классы

Для каждого аннотированного класса генерируются два класса:

### FormConfig

Класс `<ClassName>FormConfig` содержит конфигурацию формы:

```dart
class UserFormFormConfig extends TypedFormConfig<UserForm> {
  @override
  String get name => 'Форма пользователя';

  @override
  List<FieldConfigEntry> get fields => [
        // Конфигурации полей
      ];

  @override
  UserFormFormModel createModel() =>
      UserFormFormModel(config: toFormConfig());
}
```

### FormModel

Класс `<ClassName>FormModel` содержит модель формы:

```dart
class UserFormFormModel extends TypedFormModel<UserForm> {
  UserFormFormModel({required super.config});

  // Геттеры для полей
  NumberField get ageField =>
      getField<NumberField>('age')!;

  // Геттер и сеттер для values
  @override
  UserForm get values => UserForm(
        age: ageField.value!,
      );

  @override
  set values(UserForm newValues) {
    ageField.value = newValues.age;
  }

  // Методы для сериализации
  @override
  Map<String, dynamic> toMap() => {
        'age': ageField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('age'))
      ageField.value = map['age'] as double;
  }
}
```

## Примеры использования

### Простая форма

```dart
import 'package:forms_annotations/forms_annotations.dart';

part 'user_form.g.dart';

@FormGen(name: 'Форма пользователя')
class UserForm {
  @NumberField(
    label: 'Возраст',
    min: 18,
    max: 100,
  )
  final double age;

  @PointField(
    label: 'Местоположение',
  )
  final Point location;

  UserForm({
    required this.age,
    required this.location,
  });
}
```

### Форма со списками

```dart
import 'package:forms_annotations/forms_annotations.dart';

part 'contact_form.g.dart';

@FormGen(name: 'Контактная форма')
class ContactForm {
  @NumberField(
    label: 'Возраст',
    min: 18,
    max: 100,
  )
  final double age;

  @ListField(
    label: 'Телефоны',
    minItems: 1,
    maxItems: 5,
    itemConfig: NumberField(
      label: 'Телефон',
    ),
  )
  final List<double> phones;

  ContactForm({
    required this.age,
    required this.phones,
  });
}
```

### Вложенные списки

```dart
import 'package:forms_annotations/forms_annotations.dart';

part 'nested_form.g.dart';

@FormGen(name: 'Форма с вложенными списками')
class NestedForm {
  @ListField(
    label: 'Матрица',
    minItems: 1,
    maxItems: 3,
    itemConfig: ListField(
      label: 'Строка',
      minItems: 2,
      maxItems: 4,
      itemConfig: NumberField(
        label: 'Значение',
        min: 0,
        max: 100,
      ),
    ),
  )
  final List<List<double>> matrix;

  NestedForm({
    required this.matrix,
  });
}
```

### Необязательные поля

```dart
import 'package:forms_annotations/forms_annotations.dart';

part 'optional_form.g.dart';

@FormGen(name: 'Форма с необязательными полями')
class OptionalForm {
  @NumberField(
    label: 'Возраст',
    min: 18,
    max: 100,
    isRequired: true,
  )
  final double age;

  @ListField(
    label: 'Телефоны',
    minItems: 1,
    maxItems: 5,
    itemConfig: NumberField(
      label: 'Телефон',
    ),
    isRequired: false,
  )
  final List<double>? phones;

  OptionalForm({
    required this.age,
    this.phones,
  });
}
```

## Расширенные возможности

### Валидация

Валидация может быть добавлена на уровне поля и на уровне формы:

```dart
@FormGen(
  name: 'Форма пользователя',
  validator: (values) {
    if (values['age'] < 21 && values['isDriver']) {
      return 'Водитель должен быть не моложе 21 года';
    }
    return null;
  },
)
class UserForm {
  @NumberField(
    label: 'Возраст',
    min: 18,
    max: 100,
    validator: (value) => value < 21 ? 'Возраст должен быть не менее 21 года' : null,
  )
  final double age;

  @NumberField(
    label: 'Является водителем',
  )
  final bool isDriver;

  UserForm({
    required this.age,
    required this.isDriver,
  });
}
```

### Кастомные типы

Для использования кастомных типов в формах, необходимо реализовать соответствующие поля и конфигурации:

```dart
class CustomField extends FormField<CustomType> {
  CustomField({
    required CustomFieldConfig config,
    CustomType? initialValue,
  }) : super(
          config: config,
          initialValue: initialValue,
        );

  @override
  String? validate() {
    // Реализация валидации
  }
}

class CustomFieldConfig extends FieldConfig {
  // Параметры конфигурации
  
  CustomFieldConfig({
    required String label,
    bool isRequired = true,
    String? Function(CustomType?)? validator,
  }) : super(
          label: label,
          isRequired: isRequired,
          validator: validator,
        );

  @override
  CustomField createField() {
    return CustomField(config: this);
  }
}
```

## Решение проблем

### Проблема: Ошибка типов при работе с ListField

Если вы получаете ошибку типа:

```
type 'ListField<double, FormField<double>>' is not a subtype of type 'ListField<double, NumberField>?'
```

Убедитесь, что в генераторе кода используется базовый тип `FormField<T>` для всех типов элементов списка:

```dart
itemFieldType = 'FormField<$elementType>';
```

### Проблема: Ошибка при генерации кода

Если вы получаете ошибку при генерации кода, попробуйте очистить кэш:

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Проблема: Изменения не отражаются в сгенерированном коде

Если изменения в аннотациях не отражаются в сгенерированном коде, попробуйте:

1. Остановить `build_runner watch`, если он запущен
2. Очистить кэш: `flutter pub run build_runner clean`
3. Запустить генерацию заново: `flutter pub run build_runner build --delete-conflicting-outputs`
