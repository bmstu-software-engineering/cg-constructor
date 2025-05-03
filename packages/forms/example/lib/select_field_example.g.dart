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
            type: FieldType.form,
            config: FormFieldConfig<Option>(
                label: 'Выбранный вариант',
                createFormModel: () =>
                    OptionFormModel(config: OptionFormConfig().toFormConfig()),
                isRequired: true)),
      ];

  @override
  SelectFormFormModel createModel() =>
      SelectFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для SelectForm
class SelectFormFormModel extends TypedFormModel<SelectForm> {
  SelectFormFormModel({required super.config});

  /// Поле для selectedOption
  FormField<Option> get selectedOptionField =>
      getField<FormField<Option>>('selectedOption')!;

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
        'selectedOption': selectedOptionField.value != null
            ? (selectedOptionField as NestedFormField).toMap()
            : null,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('selectedOption')) {
      final nestedMap = map['selectedOption'] as Map<String, dynamic>;
      if (selectedOptionField.value == null) {
        // Создаем новую вложенную форму
        final nestedFormModel = OptionFormConfig().createModel();
        nestedFormModel.fromMap(nestedMap);
        selectedOptionField.value = nestedFormModel.values;
      } else {
        // Используем существующую вложенную форму
        (selectedOptionField as NestedFormField).fromMap(nestedMap);
      }
    }
  }
}
