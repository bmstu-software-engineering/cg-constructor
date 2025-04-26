# Forms

Пакет для создания типизированных форм во Flutter с поддержкой валидации, сериализации и кодогенерации.

## Возможности

- Типизированные формы с поддержкой различных типов полей
- Валидация полей и форм
- Сериализация и десериализация форм в Map
- Кодогенерация для создания типизированных форм
- Виджеты для отображения полей и форм
- Поддержка списков полей с вложенными элементами

## Установка

Добавьте пакет в зависимости вашего проекта:

```yaml
dependencies:
  forms: ^1.0.0

dev_dependencies:
  build_runner: ^2.3.0
  forms_generator: ^1.0.0
```

## Использование

### Создание типизированной формы

1. Создайте класс с аннотациями для генерации формы:

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

  @ListField(
    label: 'Телефоны',
    minItems: 1,
    maxItems: 5,
    itemConfig: NumberField(
      label: 'Телефон',
    ),
  )
  final List<double> phones;

  UserForm({
    required this.age,
    required this.phones,
  });
}
```

2. Запустите генерацию кода:

```bash
flutter pub run build_runner build
```

3. Используйте сгенерированные классы:

```dart
// Создание конфигурации формы
final formConfig = UserFormFormConfig();

// Создание модели формы
final formModel = formConfig.createModel();

// Установка значений
formModel.values = UserForm(
  age: 25,
  phones: [79001234567, 79009876543],
);

// Валидация формы
if (formModel.isValid()) {
  print('Форма валидна');
} else {
  print('Форма невалидна');
}

// Получение значений
final values = formModel.values;
print('Возраст: ${values.age}');
print('Телефоны: ${values.phones}');

// Преобразование в Map
final map = formModel.toMap();
print('Map: $map');

// Установка значений из Map
formModel.fromMap({
  'age': 30,
  'phones': [79001234567],
});
```

### Использование виджетов

```dart
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';

class UserFormWidget extends StatelessWidget {
  final UserFormFormModel formModel;

  const UserFormWidget({
    Key? key,
    required this.formModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberFieldWidget(
          field: formModel.ageField,
          decoration: const InputDecoration(
            labelText: 'Возраст',
          ),
        ),
        ListFieldWidget(
          field: formModel.phonesField,
          itemBuilder: (context, field, index) {
            return NumberFieldWidget(
              field: field,
              decoration: InputDecoration(
                labelText: 'Телефон ${index + 1}',
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (formModel.isValid()) {
              final values = formModel.values;
              print('Форма отправлена: $values');
            } else {
              formModel.validate();
              print('Форма невалидна');
            }
          },
          child: const Text('Отправить'),
        ),
      ],
    );
  }
}
```

## Типы полей

Пакет поддерживает следующие типы полей:

- `NumberField` - поле для ввода чисел
- `PointField` - поле для ввода точек (x, y)
- `AngleField` - поле для ввода углов
- `VectorField` - поле для ввода векторов
- `ScaleField` - поле для ввода масштаба
- `PolygonField` - поле для ввода многоугольников
- `TriangleField` - поле для ввода треугольников
- `RectangleField` - поле для ввода прямоугольников
- `LineField` - поле для ввода линий
- `ListField` - поле для ввода списков

## Валидация

Каждое поле может иметь свои правила валидации:

```dart
@NumberField(
  label: 'Возраст',
  min: 18,
  max: 100,
  validator: (value) => value < 21 ? 'Возраст должен быть не менее 21 года' : null,
)
final double age;
```

Также можно добавить валидацию для всей формы:

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

## Динамические формы

Пакет также поддерживает создание динамических форм без кодогенерации:

```dart
// Создание конфигурации формы
final formConfig = FormConfig(
  name: 'Динамическая форма',
  fields: [
    FieldConfigEntry(
      id: 'name',
      type: FieldType.text,
      config: TextFieldConfig(
        label: 'Имя',
        isRequired: true,
      ),
    ),
    FieldConfigEntry(
      id: 'age',
      type: FieldType.number,
      config: NumberFieldConfig(
        label: 'Возраст',
        min: 18,
        max: 100,
      ),
    ),
  ],
);

// Создание модели формы
final formModel = DynamicFormModel(config: formConfig);

// Установка значений
formModel.setValues({
  'name': 'Иван',
  'age': 25,
});

// Валидация формы
if (formModel.isValid()) {
  print('Форма валидна');
} else {
  print('Форма невалидна');
}

// Получение значений
final values = formModel.getValues();
print('Имя: ${values['name']}');
print('Возраст: ${values['age']}');
```

## Дополнительная информация

Для более подробной информации о возможностях пакета и примерах использования смотрите:

- [Документация по кодогенерации](CODEGEN.md) - подробное руководство по использованию кодогенерации в пакете
- [Документация API](https://pub.dev/documentation/forms/latest/) - полная документация API пакета
- [Примеры](https://github.com/example/forms/tree/main/example) - примеры использования пакета

## Лицензия

Пакет распространяется под лицензией MIT.
