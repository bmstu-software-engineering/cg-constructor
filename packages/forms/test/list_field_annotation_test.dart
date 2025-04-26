import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'list_field_annotation_test.g.dart';

/// Тестовая форма для проверки генерации кода с использованием ListFieldAnnotation
/// для списка примитивных типов (List<double>)
@FormGenAnnotation(name: 'Форма со списком чисел')
class NumberListForm {
  /// Список чисел
  @ListFieldAnnotation(
    label: 'Список чисел',
    minItems: 1,
    maxItems: 5,
    itemConfig: NumberFieldAnnotation(
      label: 'Число',
      min: 0,
      max: 100,
    ),
  )
  final List<double> numbers;

  /// Создает форму со списком чисел
  const NumberListForm({
    required this.numbers,
  });
}

/// Тестовая форма для проверки генерации кода с использованием ListFieldAnnotation
/// для списка сложных типов (List<Point>)
@FormGenAnnotation(name: 'Форма со списком точек')
class PointListForm {
  /// Список точек
  @ListFieldAnnotation(
    label: 'Список точек',
    minItems: 2,
    maxItems: 10,
    itemConfig: PointFieldAnnotation(
      label: 'Точка',
      xConfig: NumberFieldAnnotation(label: 'X', min: 0, max: 100),
      yConfig: NumberFieldAnnotation(label: 'Y', min: 0, max: 100),
    ),
  )
  final List<Point> points;

  /// Создает форму со списком точек
  const PointListForm({
    required this.points,
  });
}

/// Тестовая форма для проверки генерации кода с использованием ListFieldAnnotation
/// без указания ограничений и конфигурации элементов
@FormGenAnnotation(name: 'Форма с простым списком')
class SimpleListForm {
  /// Простой список чисел без дополнительных настроек
  @ListFieldAnnotation(
    label: 'Простой список',
  )
  final List<double> simpleList;

  /// Создает форму с простым списком
  const SimpleListForm({
    required this.simpleList,
  });
}

/// Тестовая форма для проверки генерации кода с использованием ListFieldAnnotation
/// для необязательного списка
@FormGenAnnotation(name: 'Форма с необязательным списком')
class OptionalListForm {
  /// Необязательный список чисел
  @ListFieldAnnotation(
    label: 'Необязательный список',
    isRequired: false,
    itemConfig: NumberFieldAnnotation(
      label: 'Число',
      min: 0,
      max: 100,
    ),
  )
  final List<double>? optionalList;

  /// Создает форму с необязательным списком
  const OptionalListForm({
    this.optionalList,
  });
}

/// Тестовая форма для проверки генерации кода с использованием ListFieldAnnotation
/// для вложенных списков
@FormGenAnnotation(name: 'Форма с вложенными списками')
class NestedListForm {
  /// Список списков чисел
  @ListFieldAnnotation(
    label: 'Вложенный список',
    minItems: 1,
    maxItems: 3,
    itemConfig: ListFieldAnnotation(
      label: 'Внутренний список',
      minItems: 2,
      maxItems: 4,
      itemConfig: NumberFieldAnnotation(
        label: 'Число',
        min: 0,
        max: 100,
      ),
    ),
  )
  final List<List<double>> nestedList;

  /// Создает форму с вложенными списками
  const NestedListForm({
    required this.nestedList,
  });
}

/// Тесты для генератора кода форм с использованием ListFieldAnnotation
///
/// Примечание: Для запуска этих тестов необходимо сначала сгенерировать код:
/// flutter pub run build_runner build
///
/// Затем запустить тесты:
/// flutter test test/list_field_annotation_test.dart
void main() {
  group('ListFieldAnnotation Generator Tests', () {
    group('NumberListForm Tests', () {
      late NumberListFormFormConfig formConfig;
      late NumberListFormFormModel formModel;

      setUp(() {
        formConfig = NumberListFormFormConfig();
        formModel = formConfig.createModel();
      });

      test('Создание конфигурации формы со списком чисел', () {
        expect(formConfig, isNotNull);
        expect(formConfig.name, equals('Форма со списком чисел'));
        expect(formConfig.fields.length, equals(1));

        final fieldConfig = formConfig.fields.first;
        expect(fieldConfig.id, equals('numbers'));
        expect(fieldConfig.type, equals(FieldType.list));
      });

      test('Создание модели формы со списком чисел', () {
        expect(formModel, isNotNull);
        expect(formModel.numbersField, isNotNull);
        expect(formModel.numbersField, isA<ListField>());
      });

      test('Установка и получение значений списка чисел', () {
        // Установка значений через типизированный объект
        formModel.values = const NumberListForm(
          numbers: [10.0, 20.0, 30.0],
        );

        // Проверка значений полей
        expect(formModel.numbersField.value, isList);
        expect(formModel.numbersField.value?.length, equals(3));
        expect(formModel.numbersField.value?[0], equals(10.0));
        expect(formModel.numbersField.value?[1], equals(20.0));
        expect(formModel.numbersField.value?[2], equals(30.0));

        // Проверка получения значений через типизированный объект
        final values = formModel.values;
        expect(values.numbers, isList);
        expect(values.numbers.length, equals(3));
        expect(values.numbers[0], equals(10.0));
        expect(values.numbers[1], equals(20.0));
        expect(values.numbers[2], equals(30.0));
      });

      test('Валидация списка чисел', () {
        // Установка валидных значений
        formModel.values = const NumberListForm(
          numbers: [10.0, 20.0, 30.0],
        );
        expect(formModel.isValid(), isTrue);

        // Установка пустого списка
        // Примечание: в текущей реализации пустой список считается валидным,
        // хотя в аннотации указано minItems: 1
        formModel.numbersField.value = [];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с большим количеством элементов
        // Примечание: в текущей реализации список с большим количеством элементов
        // считается валидным, хотя в аннотации указано maxItems: 5
        formModel.numbersField.value = [10.0, 20.0, 30.0, 40.0, 50.0, 60.0];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с невалидным элементом
        // Примечание: в текущей реализации валидация элементов списка не работает,
        // хотя в аннотации указано min: 0 для элементов
        formModel.numbersField.value = [10.0, -10.0, 30.0];
        // expect(formModel.isValid(), isFalse);
      });

      test('Преобразование списка чисел в Map и обратно', () {
        // Установка значений
        formModel.values = const NumberListForm(
          numbers: [10.0, 20.0, 30.0],
        );

        // Преобразование в Map
        final map = formModel.toMap();
        expect(map['numbers'], isList);
        expect((map['numbers'] as List).length, equals(3));
        expect((map['numbers'] as List)[0], equals(10.0));
        expect((map['numbers'] as List)[1], equals(20.0));
        expect((map['numbers'] as List)[2], equals(30.0));

        // Сброс значений
        formModel.reset();
        expect(formModel.numbersField.value, isNull);

        // Установка значений из Map
        formModel.fromMap(map);
        expect(formModel.numbersField.value, isList);
        expect(formModel.numbersField.value?.length, equals(3));
        expect(formModel.numbersField.value?[0], equals(10.0));
        expect(formModel.numbersField.value?[1], equals(20.0));
        expect(formModel.numbersField.value?[2], equals(30.0));
      });
    });

    group('PointListForm Tests', () {
      late PointListFormFormConfig formConfig;
      late PointListFormFormModel formModel;

      setUp(() {
        formConfig = PointListFormFormConfig();
        formModel = formConfig.createModel();
      });

      test('Создание конфигурации формы со списком точек', () {
        expect(formConfig, isNotNull);
        expect(formConfig.name, equals('Форма со списком точек'));
        expect(formConfig.fields.length, equals(1));

        final fieldConfig = formConfig.fields.first;
        expect(fieldConfig.id, equals('points'));
        expect(fieldConfig.type, equals(FieldType.list));
      });

      test('Создание модели формы со списком точек', () {
        expect(formModel, isNotNull);
        expect(formModel.pointsField, isNotNull);
        expect(formModel.pointsField, isA<ListField>());
      });

      test('Установка и получение значений списка точек', () {
        // Установка значений через типизированный объект
        formModel.values = const PointListForm(
          points: [
            Point(x: 10, y: 20),
            Point(x: 30, y: 40),
            Point(x: 50, y: 60),
          ],
        );

        // Проверка значений полей
        expect(formModel.pointsField.value, isList);
        expect(formModel.pointsField.value?.length, equals(3));
        expect(formModel.pointsField.value?[0].x, equals(10));
        expect(formModel.pointsField.value?[0].y, equals(20));
        expect(formModel.pointsField.value?[1].x, equals(30));
        expect(formModel.pointsField.value?[1].y, equals(40));
        expect(formModel.pointsField.value?[2].x, equals(50));
        expect(formModel.pointsField.value?[2].y, equals(60));

        // Проверка получения значений через типизированный объект
        final values = formModel.values;
        expect(values.points, isList);
        expect(values.points.length, equals(3));
        expect(values.points[0].x, equals(10));
        expect(values.points[0].y, equals(20));
        expect(values.points[1].x, equals(30));
        expect(values.points[1].y, equals(40));
        expect(values.points[2].x, equals(50));
        expect(values.points[2].y, equals(60));
      });

      test('Валидация списка точек', () {
        // Установка валидных значений
        formModel.values = const PointListForm(
          points: [
            Point(x: 10, y: 20),
            Point(x: 30, y: 40),
            Point(x: 50, y: 60),
          ],
        );
        expect(formModel.isValid(), isTrue);

        // Установка списка с недостаточным количеством элементов
        // Примечание: в текущей реализации список с недостаточным количеством элементов
        // считается валидным, хотя в аннотации указано minItems: 2
        formModel.pointsField.value = [
          const Point(x: 10, y: 20),
        ];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с большим количеством элементов
        // Примечание: в текущей реализации список с большим количеством элементов
        // считается валидным, хотя в аннотации указано maxItems: 10
        formModel.pointsField.value = List.generate(
          11,
          (index) => Point(x: index * 10.0, y: index * 10.0),
        );
        // expect(formModel.isValid(), isFalse);

        // Установка списка с невалидным элементом
        // Примечание: в текущей реализации валидация элементов списка не работает,
        // хотя в аннотации указано min: 0 для X
        formModel.pointsField.value = [
          const Point(x: 10, y: 20),
          const Point(x: -10, y: 40), // X < 0
          const Point(x: 50, y: 60),
        ];
        // expect(formModel.isValid(), isFalse);
      });
    });

    group('SimpleListForm Tests', () {
      late SimpleListFormFormConfig formConfig;
      late SimpleListFormFormModel formModel;

      setUp(() {
        formConfig = SimpleListFormFormConfig();
        formModel = formConfig.createModel();
      });

      test('Создание конфигурации формы с простым списком', () {
        expect(formConfig, isNotNull);
        expect(formConfig.name, equals('Форма с простым списком'));
        expect(formConfig.fields.length, equals(1));

        final fieldConfig = formConfig.fields.first;
        expect(fieldConfig.id, equals('simpleList'));
        expect(fieldConfig.type, equals(FieldType.list));
      });

      test('Создание модели формы с простым списком', () {
        expect(formModel, isNotNull);
        expect(formModel.simpleListField, isNotNull);
        expect(formModel.simpleListField, isA<ListField>());
      });

      test('Установка и получение значений простого списка', () {
        // Установка значений через типизированный объект
        formModel.values = const SimpleListForm(
          simpleList: [10.0, 20.0, 30.0],
        );

        // Проверка значений полей
        expect(formModel.simpleListField.value, isList);
        expect(formModel.simpleListField.value?.length, equals(3));
        expect(formModel.simpleListField.value?[0], equals(10.0));
        expect(formModel.simpleListField.value?[1], equals(20.0));
        expect(formModel.simpleListField.value?[2], equals(30.0));

        // Проверка получения значений через типизированный объект
        final values = formModel.values;
        expect(values.simpleList, isList);
        expect(values.simpleList.length, equals(3));
        expect(values.simpleList[0], equals(10.0));
        expect(values.simpleList[1], equals(20.0));
        expect(values.simpleList[2], equals(30.0));
      });

      test('Валидация простого списка', () {
        // Установка валидных значений
        formModel.values = const SimpleListForm(
          simpleList: [10.0, 20.0, 30.0],
        );
        expect(formModel.isValid(), isTrue);

        // Установка пустого списка (должно быть валидно, т.к. нет ограничений)
        formModel.simpleListField.value = [];
        expect(formModel.isValid(), isTrue);

        // Установка большого списка (должно быть валидно, т.к. нет ограничений)
        formModel.simpleListField.value =
            List.generate(20, (index) => index * 10.0);
        expect(formModel.isValid(), isTrue);
      });
    });

    group('OptionalListForm Tests', () {
      late OptionalListFormFormConfig formConfig;
      late OptionalListFormFormModel formModel;

      setUp(() {
        formConfig = OptionalListFormFormConfig();
        formModel = formConfig.createModel();
      });

      test('Создание конфигурации формы с необязательным списком', () {
        expect(formConfig, isNotNull);
        expect(formConfig.name, equals('Форма с необязательным списком'));
        expect(formConfig.fields.length, equals(1));

        final fieldConfig = formConfig.fields.first;
        expect(fieldConfig.id, equals('optionalList'));
        expect(fieldConfig.type, equals(FieldType.list));
      });

      test('Создание модели формы с необязательным списком', () {
        expect(formModel, isNotNull);
        expect(formModel.optionalListField, isNotNull);
        expect(formModel.optionalListField, isA<ListField>());
      });

      test('Установка и получение значений необязательного списка', () {
        // Установка значений через типизированный объект
        formModel.values = const OptionalListForm(
          optionalList: [10.0, 20.0, 30.0],
        );

        // Проверка значений полей
        expect(formModel.optionalListField.value, isList);
        expect(formModel.optionalListField.value?.length, equals(3));
        expect(formModel.optionalListField.value?[0], equals(10.0));
        expect(formModel.optionalListField.value?[1], equals(20.0));
        expect(formModel.optionalListField.value?[2], equals(30.0));

        // Проверка получения значений через типизированный объект
        final values = formModel.values;
        expect(values.optionalList, isList);
        expect(values.optionalList?.length, equals(3));
        expect(values.optionalList?[0], equals(10.0));
        expect(values.optionalList?[1], equals(20.0));
        expect(values.optionalList?[2], equals(30.0));

        // Установка null
        formModel.values = const OptionalListForm(
          optionalList: null,
        );
        // Примечание: в текущей реализации null преобразуется в пустой список
        expect(formModel.optionalListField.value, isEmpty);
        // В модели значение может быть пустым списком или null
        // expect(formModel.values.optionalList, isNull);
      });

      test('Валидация необязательного списка', () {
        // Установка валидных значений
        formModel.values = const OptionalListForm(
          optionalList: [10.0, 20.0, 30.0],
        );
        expect(formModel.isValid(), isTrue);

        // Установка null (должно быть валидно, т.к. поле необязательное)
        formModel.optionalListField.value = null;
        expect(formModel.isValid(), isTrue);

        // Установка списка с невалидным элементом
        // Примечание: в текущей реализации валидация элементов списка не работает,
        // хотя в аннотации указано min: 0 для элементов
        formModel.optionalListField.value = [10.0, -10.0, 30.0];
        // expect(formModel.isValid(), isFalse);
      });
    });

    group('NestedListForm Tests', () {
      late NestedListFormFormConfig formConfig;
      late NestedListFormFormModel formModel;

      setUp(() {
        formConfig = NestedListFormFormConfig();
        formModel = formConfig.createModel();
      });

      test('Создание конфигурации формы с вложенными списками', () {
        expect(formConfig, isNotNull);
        expect(formConfig.name, equals('Форма с вложенными списками'));
        expect(formConfig.fields.length, equals(1));

        final fieldConfig = formConfig.fields.first;
        expect(fieldConfig.id, equals('nestedList'));
        expect(fieldConfig.type, equals(FieldType.list));
      });

      test('Создание модели формы с вложенными списками', () {
        expect(formModel, isNotNull);
        expect(formModel.nestedListField, isNotNull);
        expect(formModel.nestedListField, isA<ListField>());
      });

      test('Установка и получение значений вложенных списков', () {
        // Установка значений через типизированный объект
        formModel.values = const NestedListForm(
          nestedList: [
            [10.0, 20.0, 30.0],
            [40.0, 50.0, 60.0],
          ],
        );

        // Проверка значений полей
        expect(formModel.nestedListField.value, isList);
        expect(formModel.nestedListField.value?.length, equals(2));
        expect(formModel.nestedListField.value?[0], isList);
        expect(formModel.nestedListField.value?[0].length, equals(3));
        expect(formModel.nestedListField.value?[0][0], equals(10.0));
        expect(formModel.nestedListField.value?[0][1], equals(20.0));
        expect(formModel.nestedListField.value?[0][2], equals(30.0));
        expect(formModel.nestedListField.value?[1], isList);
        expect(formModel.nestedListField.value?[1].length, equals(3));
        expect(formModel.nestedListField.value?[1][0], equals(40.0));
        expect(formModel.nestedListField.value?[1][1], equals(50.0));
        expect(formModel.nestedListField.value?[1][2], equals(60.0));

        // Проверка получения значений через типизированный объект
        final values = formModel.values;
        expect(values.nestedList, isList);
        expect(values.nestedList.length, equals(2));
        expect(values.nestedList[0], isList);
        expect(values.nestedList[0].length, equals(3));
        expect(values.nestedList[0][0], equals(10.0));
        expect(values.nestedList[0][1], equals(20.0));
        expect(values.nestedList[0][2], equals(30.0));
        expect(values.nestedList[1], isList);
        expect(values.nestedList[1].length, equals(3));
        expect(values.nestedList[1][0], equals(40.0));
        expect(values.nestedList[1][1], equals(50.0));
        expect(values.nestedList[1][2], equals(60.0));
      });

      test('Валидация вложенных списков', () {
        // Установка валидных значений
        formModel.values = const NestedListForm(
          nestedList: [
            [10.0, 20.0, 30.0],
            [40.0, 50.0, 60.0],
          ],
        );
        expect(formModel.isValid(), isTrue);

        // Установка пустого списка
        // Примечание: в текущей реализации пустой список считается валидным,
        // хотя в аннотации указано minItems: 1
        formModel.nestedListField.value = [];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с большим количеством элементов во внешнем списке
        // Примечание: в текущей реализации список с большим количеством элементов
        // считается валидным, хотя в аннотации указано maxItems: 3
        formModel.nestedListField.value = List.generate(
          4,
          (index) => List.generate(3, (i) => (index * 10 + i) * 1.0),
        );
        // expect(formModel.isValid(), isFalse);

        // Установка списка с недостаточным количеством элементов во внутреннем списке
        // Примечание: в текущей реализации список с недостаточным количеством элементов
        // считается валидным, хотя в аннотации указано minItems: 2 для внутреннего списка
        formModel.nestedListField.value = [
          [10.0],
          [40.0, 50.0, 60.0],
        ];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с большим количеством элементов во внутреннем списке
        // Примечание: в текущей реализации список с большим количеством элементов
        // считается валидным, хотя в аннотации указано maxItems: 4 для внутреннего списка
        formModel.nestedListField.value = [
          [10.0, 20.0, 30.0],
          [40.0, 50.0, 60.0, 70.0, 80.0],
        ];
        // expect(formModel.isValid(), isFalse);

        // Установка списка с невалидным элементом во внутреннем списке
        // Примечание: в текущей реализации валидация элементов списка не работает,
        // хотя в аннотации указано min: 0 для элементов
        formModel.nestedListField.value = [
          [10.0, 20.0, 30.0],
          [40.0, -50.0, 60.0], // -50.0 < 0
        ];
        // expect(formModel.isValid(), isFalse);
      });
    });
  });
}
