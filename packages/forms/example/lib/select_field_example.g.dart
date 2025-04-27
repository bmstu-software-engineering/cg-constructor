// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_field_example.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для SelectForm
class SelectFormFormConfig extends TypedFormConfig<SelectForm> {
  @override
  String get name => 'Форма с выбором из списка';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'selectedOption',
            type: FieldType.enumSelect,
            config: EnumSelectConfig<Option>(
              label: 'Выбранный вариант',
              values: [],
              titleBuilder: (value) => value.toString(),
            )),
      ];

  @override
  SelectFormFormModel createModel() =>
      SelectFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для SelectForm
class SelectFormFormModel extends TypedFormModel<SelectForm> {
  SelectFormFormModel({required super.config});

  /// Поле для selectedOption
  EnumSelectField get selectedOptionField =>
      getField<EnumSelectField>('selectedOption')!;

  @override
  SelectForm get values => SelectForm(
        selectedOption: selectedOptionField.value!,
      );

  @override
  set values(SelectForm newValues) {
    selectedOptionField.value = newValues.selectedOption;
  }

  @override
  Map<String, dynamic> toMap() => {
        'selectedOption': selectedOptionField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('selectedOption'))
      selectedOptionField.value = map['selectedOption'] as Option;
  }
}
