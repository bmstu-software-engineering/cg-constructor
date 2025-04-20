import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('ListField Diagnostics Tests', () {
    test('ListField<double, NumberField> diagnostics', () {
      // Создаем поле для списка чисел
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список чисел',
          minItems: 1,
          maxItems: 5,
          isRequired: true,
          createItemField: () => NumberField(
            config: NumberFieldConfig(
              label: 'Число',
              min: 0,
              max: 100,
              isRequired: false,
            ),
          ),
        ),
        initialValue: [10, 20, 30],
      );

      // Создаем DiagnosticPropertiesBuilder для проверки свойств
      final builder = DiagnosticPropertiesBuilder();
      listField.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения
      expect(
        properties.any(
          (p) =>
              p.name == 'value' && p.value.toString() == '[10.0, 20.0, 30.0]',
        ),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'error' && p.value == null),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'hasValue' && p.value == true),
        isTrue,
      );

      // Проверяем, что toString возвращает ожидаемое значение
      expect(listField.toString(), contains('ListField<double>'));
      expect(listField.toString(), contains('value: [10.0, 20.0, 30.0]'));
    });

    test('ListField<Point, PointField> diagnostics', () {
      // Создаем поле для списка точек
      final listField = ListField<Point, PointField>(
        config: ListFieldConfig<Point>(
          label: 'Список точек',
          minItems: 2,
          maxItems: 4,
          isRequired: true,
          createItemField: () => PointField(
            config: PointFieldConfig(
              label: 'Точка',
              isRequired: false,
              xConfig: NumberFieldConfig(
                label: 'X',
                min: 0,
                max: 100,
                isRequired: false,
              ),
              yConfig: NumberFieldConfig(
                label: 'Y',
                min: 0,
                max: 100,
                isRequired: false,
              ),
            ),
          ),
        ),
        initialValue: [const Point(x: 10, y: 20), const Point(x: 30, y: 40)],
      );

      // Создаем DiagnosticPropertiesBuilder для проверки свойств
      final builder = DiagnosticPropertiesBuilder();
      listField.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения
      expect(properties.any((p) => p.name == 'value'), isTrue);
      expect(
        properties.any((p) => p.name == 'error' && p.value == null),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'hasValue' && p.value == true),
        isTrue,
      );

      // Проверяем, что toString возвращает ожидаемое значение
      expect(listField.toString(), contains('ListField<Point>'));
    });

    test('ListField validation diagnostics', () {
      // Создаем поле для списка чисел с ошибкой валидации
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список чисел',
          minItems: 3,
          maxItems: 5,
          isRequired: true,
          createItemField: () => NumberField(
            config: NumberFieldConfig(
              label: 'Число',
              min: 0,
              max: 100,
              isRequired: false,
            ),
          ),
        ),
        initialValue: [
          10,
          20,
        ], // Соответствует минимальному количеству элементов
      );

      // Валидируем поле
      final error = listField.validate();

      // Создаем DiagnosticPropertiesBuilder для проверки свойств
      final builder = DiagnosticPropertiesBuilder();
      listField.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения
      expect(error, isNotNull);
      expect(error, contains('не менее 3 элементов'));
      expect(
        properties.any((p) => p.name == 'error' && p.value != null),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == false),
        isTrue,
      );
    });

    test('ListField with nested diagnostics', () {
      // Создаем поле для списка точек
      final listField = ListField<Point, PointField>(
        config: ListFieldConfig<Point>(
          label: 'Список точек',
          minItems: 1,
          maxItems: 3,
          isRequired: true,
          createItemField: () => PointField(
            config: PointFieldConfig(
              label: 'Точка',
              xConfig: NumberFieldConfig(
                  label: 'X', min: 0, max: 100, isRequired: false),
              yConfig: NumberFieldConfig(
                  label: 'Y', min: 0, max: 100, isRequired: false),
              isRequired: false,
            ),
          ),
        ),
        initialValue: [const Point(x: 10, y: 20), const Point(x: 30, y: 40)],
      );

      // Получаем вложенное поле
      final pointField = listField.fields.first;

      // Создаем DiagnosticPropertiesBuilder для проверки свойств вложенного поля
      final builder = DiagnosticPropertiesBuilder();
      pointField.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения
      expect(properties.any((p) => p.name == 'value'), isTrue);
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );

      // Проверяем, что toString возвращает ожидаемое значение
      expect(pointField.toString(), contains('Point'));
    });

    test('ListField dynamic operations diagnostics', () {
      // Создаем поле для списка чисел
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список чисел',
          minItems: 1,
          maxItems: 5,
          isRequired: true,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
        ),
        initialValue: [10, 20],
      );

      // Добавляем новое поле
      listField.addField();
      listField.fields.last.value = 30;

      // Создаем DiagnosticPropertiesBuilder для проверки свойств
      final builder = DiagnosticPropertiesBuilder();
      listField.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения после добавления
      expect(
        properties.any(
          (p) =>
              p.name == 'value' && p.value.toString() == '[10.0, 20.0, 30.0]',
        ),
        isTrue,
      );

      // Удаляем поле
      listField.removeField(1);

      // Обновляем свойства
      final builder2 = DiagnosticPropertiesBuilder();
      listField.debugFillProperties(builder2);
      final properties2 = builder2.properties;

      // Проверяем, что свойства содержат ожидаемые значения после удаления
      expect(
        properties2.any(
          (p) => p.name == 'value' && p.value.toString() == '[10.0, 30.0]',
        ),
        isTrue,
      );
    });
  });
}
