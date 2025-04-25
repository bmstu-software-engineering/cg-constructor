import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:forms/typed_form_base.dart';
import 'package:models_ns/models_ns.dart';

/// Тесты для базовых классов типизированных форм
void main() {
  group('TypedFormConfig', () {
    test('Преобразование в FormConfig', () {
      // Создаем тестовую конфигурацию формы
      final config = _TestFormConfig();

      // Преобразуем в FormConfig
      final formConfig = config.toFormConfig();

      // Проверяем результат
      expect(formConfig, isNotNull);
      expect(formConfig.name, equals('Тестовая форма'));
      expect(formConfig.fields.length, equals(2));
      expect(formConfig.fields[0].id, equals('number'));
      expect(formConfig.fields[0].type, equals(FieldType.number));
      expect(formConfig.fields[1].id, equals('point'));
      expect(formConfig.fields[1].type, equals(FieldType.point));
    });
  });

  group('TypedFormModel', () {
    late _TestFormModel formModel;

    setUp(() {
      // Создаем тестовую конфигурацию формы
      final config = _TestFormConfig();

      // Создаем тестовую модель формы
      formModel = _TestFormModel(config: config.toFormConfig());

      // Устанавливаем начальные значения
      formModel.numberField.value = 42;
      formModel.pointField.value = const Point(x: 10, y: 20);
    });

    test('Получение полей по ID', () {
      expect(formModel.getField<NumberField>('number'), isNotNull);
      expect(formModel.getField<PointField>('point'), isNotNull);
      expect(formModel.getField<NumberField>('nonexistent'), isNull);
    });

    test('Получение значений по ID', () {
      expect(formModel.getValue('number'), equals(42));
      expect(formModel.getValue('point'), isA<Point>());
      expect((formModel.getValue('point') as Point).x, equals(10));
      expect((formModel.getValue('point') as Point).y, equals(20));
      expect(formModel.getValue('nonexistent'), isNull);
    });

    test('Получение всех значений в виде Map', () {
      final values = formModel.getValues();
      expect(values, isA<Map<String, dynamic>>());
      expect(values.length, equals(2));
      expect(values['number'], equals(42));
      expect(values['point'], isA<Point>());
      expect((values['point'] as Point).x, equals(10));
      expect((values['point'] as Point).y, equals(20));
    });

    test('Установка значений из Map', () {
      // Сбрасываем значения
      formModel.reset();
      expect(formModel.numberField.value, isNull);
      expect(formModel.pointField.value, isNull);

      // Устанавливаем значения из Map
      formModel.setValues({
        'number': 50,
        'point': const Point(x: 15, y: 25),
      });

      // Проверяем результат
      expect(formModel.numberField.value, equals(50));
      expect(formModel.pointField.value, isA<Point>());
      expect(formModel.pointField.value?.x, equals(15));
      expect(formModel.pointField.value?.y, equals(25));
    });

    test('Валидация формы', () {
      // Проверяем, что форма валидна
      expect(formModel.isValid(), isTrue);

      // Устанавливаем невалидное значение
      formModel.numberField.value = -10; // Меньше минимального значения

      // Проверяем, что форма невалидна
      expect(formModel.isValid(), isFalse);
    });

    test('Сброс формы', () {
      // Проверяем, что значения установлены
      expect(formModel.numberField.value, equals(42));
      expect(formModel.pointField.value, isNotNull);

      // Сбрасываем форму
      formModel.reset();

      // Проверяем, что значения сброшены
      expect(formModel.numberField.value, isNull);
      expect(formModel.pointField.value, isNull);
    });

    test('Преобразование в DynamicFormModel', () {
      // Преобразуем в DynamicFormModel
      final dynamicModel = formModel.toDynamicFormModel();

      // Проверяем результат
      expect(dynamicModel, isNotNull);
      expect(dynamicModel.getValue('number'), equals(42));
      expect(dynamicModel.getValue('point'), isA<Point>());
      expect((dynamicModel.getValue('point') as Point).x, equals(10));
      expect((dynamicModel.getValue('point') as Point).y, equals(20));
    });
  });
}

/// Тестовая реализация TypedFormConfig
class _TestFormConfig extends TypedFormConfig<_TestFormValues> {
  @override
  String get name => 'Тестовая форма';

  @override
  List<FieldConfigEntry> get fields => [
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
      ];

  @override
  _TestFormModel createModel() => _TestFormModel(config: toFormConfig());
}

/// Тестовая реализация TypedFormModel
class _TestFormModel extends TypedFormModel<_TestFormValues> {
  _TestFormModel({required super.config});

  /// Поле для числа
  NumberField get numberField => getField<NumberField>('number')!;

  /// Поле для точки
  PointField get pointField => getField<PointField>('point')!;

  @override
  _TestFormValues get values => _TestFormValues(
        number: numberField.value ?? 0,
        point: pointField.value ?? const Point(x: 0, y: 0),
      );

  @override
  set values(_TestFormValues newValues) {
    numberField.value = newValues.number;
    pointField.value = newValues.point;
  }

  @override
  Map<String, dynamic> toMap() => {
        'number': numberField.value,
        'point': pointField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('number')) numberField.value = map['number'] as double?;
    if (map.containsKey('point')) pointField.value = map['point'] as Point?;
  }
}

/// Тестовый класс для значений формы
class _TestFormValues {
  final double number;
  final Point point;

  const _TestFormValues({
    required this.number,
    required this.point,
  });
}
