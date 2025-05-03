// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для TestForm
class TestFormFormConfig extends TypedFormConfig<TestForm> {
  @override
  String get name => 'Тестовая форма';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'number',
            type: FieldType.number,
            config: NumberFieldConfig(
              label: 'Число',
              min: 0.0,
              max: 100.0,
            )),
        FieldConfigEntry(
            id: 'point',
            type: FieldType.point,
            config: PointFieldConfig(
              label: 'Точка',
            )),
      ];

  @override
  TestFormFormModel createModel() => TestFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для TestForm
class TestFormFormModel extends TypedFormModel<TestForm> {
  TestFormFormModel({required super.config});

  /// Поле для number
  NumberField get numberField => getField<NumberField>('number')!;

  /// Поле для point
  PointField get pointField => getField<PointField>('point')!;

  @override
  TestForm get values => TestForm(
        number: numberField.value!,
        point: pointField.value!,
      );

  @override
  set values(TestForm newValues) {
    numberField.value = newValues.number.toDouble();
    pointField.value = newValues.point;
  }

  @override
  Map<String, dynamic> toMap() => {
        'number': numberField.value,
        'point': pointField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('number')) {
      final value = map['number'];
      numberField.value = (value is int) ? value.toDouble() : (value as double);
    }
    if (map.containsKey('point')) pointField.value = map['point'] as Point;
  }
}
