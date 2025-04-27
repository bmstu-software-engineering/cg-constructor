// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_form_example.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для Gender
class GenderFormConfig extends TypedFormConfig<Gender> {
  @override
  String get name => 'Форма выбора пола';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'value',
            type: FieldType.enumSelect,
            config: EnumSelectConfig<Gender>(
                label: 'Значение', values: Gender.values)),
      ];

  @override
  GenderFormModel createModel() => GenderFormModel(config: toFormConfig());
}

/// Типизированная модель формы для Gender
class GenderFormModel extends TypedFormModel<Gender> {
  GenderFormModel({required super.config});

  /// Поле для value
  EnumSelectField<Gender> get valueField =>
      getField<EnumSelectField<Gender>>('value')!;

  @override
  Gender get values => valueField.value!;

  @override
  set values(Gender newValues) {
    valueField.value = newValues;
  }

  @override
  Map<String, dynamic> toMap() => {
        'value': valueField.value?.index,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('value') && map['value'] != null) {
      final index = map['value'] as int;
      valueField.value = Gender.values[index];
    }
  }
}
