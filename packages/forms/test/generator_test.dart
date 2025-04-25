import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'generator_test.g.dart';

/// Тестовая форма для проверки генератора кода
@FormGenAnnotation(name: 'Тестовая форма')
class TestForm {
  /// Числовое поле
  @NumberFieldAnnotation(
    label: 'Число',
    min: 0,
    max: 100,
    isRequired: true,
  )
  final double number;

  /// Поле точки
  @PointFieldAnnotation(
    label: 'Точка',
    xConfig: NumberFieldAnnotation(label: 'X', min: 0, max: 100),
    yConfig: NumberFieldAnnotation(label: 'Y', min: 0, max: 100),
  )
  final Point point;

  /// Создает тестовую форму
  const TestForm({
    required this.number,
    required this.point,
  });
}

/// Тесты для генератора кода форм
///
/// Примечание: Для запуска этих тестов необходимо сначала сгенерировать код:
/// flutter pub run build_runner build
///
/// Затем раскомментировать код ниже и запустить тесты:
/// flutter test test/generator_test.dart
void main() {
  group('FormGenerator', () {
    late TestFormFormConfig formConfig;
    late TestFormFormModel formModel;

    setUp(() {
      formConfig = TestFormFormConfig();
      formModel = formConfig.createModel();
    });

    test('Создание конфигурации формы', () {
      expect(formConfig, isNotNull);
      expect(formConfig.name, equals('Тестовая форма'));
      expect(formConfig.fields.length, equals(2));
    });

    test('Создание модели формы', () {
      expect(formModel, isNotNull);
      expect(formModel.numberField, isNotNull);
      expect(formModel.pointField, isNotNull);
    });

    test('Установка и получение значений', () {
      // Установка значений через типизированный объект
      formModel.values = const TestForm(
        number: 42,
        point: Point(x: 10, y: 20),
      );

      // Проверка значений полей
      expect(formModel.numberField.value, equals(42));
      expect(formModel.pointField.value?.x, equals(10));
      expect(formModel.pointField.value?.y, equals(20));

      // Проверка получения значений через типизированный объект
      final values = formModel.values;
      expect(values.number, equals(42));
      expect(values.point.x, equals(10));
      expect(values.point.y, equals(20));
    });

    // Тест валидации формы временно отключен
    test('Валидация формы', () {
      // Установка валидных значений
      formModel.values = const TestForm(
        number: 42,
        point: Point(x: 10, y: 20),
      );
      expect(formModel.isValid(), isTrue);

      // Установка невалидных значений
      formModel.numberField.value = -10; // Меньше минимального значения
      expect(formModel.isValid(), isFalse);
    });

    test('Преобразование в Map и обратно', () {
      // Установка значений
      formModel.values = const TestForm(
        number: 42,
        point: Point(x: 10, y: 20),
      );

      // Преобразование в Map
      final map = formModel.toMap();
      expect(map['number'], equals(42));
      expect(map['point'], isA<Point>());
      expect((map['point'] as Point).x, equals(10));
      expect((map['point'] as Point).y, equals(20));

      // Сброс значений временно отключен
      formModel.reset();
      expect(formModel.numberField.value, isNull);
      expect(formModel.pointField.value, isNull);

      // Установка значений из Map
      formModel.fromMap(map);
      expect(formModel.numberField.value, equals(42));
      expect(formModel.pointField.value?.x, equals(10));
      expect(formModel.pointField.value?.y, equals(20));
    });

    // Тест совместимости с DynamicFormModel временно отключен
    test('Совместимость с DynamicFormModel', () {
      // Установка значений
      formModel.values = const TestForm(
        number: 42,
        point: Point(x: 10, y: 20),
      );

      // Преобразование в DynamicFormModel
      final dynamicModel = formModel.toDynamicFormModel();
      expect(dynamicModel, isNotNull);
      expect(dynamicModel.getValue('number'), equals(42));
      expect(dynamicModel.getValue('point'), isA<Point>());
      expect((dynamicModel.getValue('point') as Point).x, equals(10));
      expect((dynamicModel.getValue('point') as Point).y, equals(20));

      // Изменение значений через DynamicFormModel
      dynamicModel.setValues({
        'number': 50,
        'point': const Point(x: 15, y: 25),
      });

      // Проверка, что значения изменились и в типизированной модели
      expect(formModel.numberField.value, equals(50));
      expect(formModel.pointField.value?.x, equals(15));
      expect(formModel.pointField.value?.y, equals(25));
    });
  });
}
