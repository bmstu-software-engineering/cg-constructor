// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector_field_codegen_test.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для VectorTestForm
class VectorTestFormFormConfig extends TypedFormConfig<VectorTestForm> {
  @override
  String get name => 'Тестовая форма с вектором';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'vector',
            type: FieldType.vector,
            config: VectorFieldConfig(label: 'Вектор', isRequired: true)),
      ];

  @override
  VectorTestFormFormModel createModel() =>
      VectorTestFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для VectorTestForm
class VectorTestFormFormModel extends TypedFormModel<VectorTestForm> {
  VectorTestFormFormModel({required super.config});

  /// Поле для vector
  FormField<Vector> get vectorField => getField<FormField<Vector>>('vector')!;

  @override
  VectorTestForm get values => VectorTestForm(
        vector: vectorField.value!,
      );

  @override
  set values(VectorTestForm newValues) {
    vectorField.value = newValues.vector;
  }

  @override
  Map<String, dynamic> toMap() => {
        'vector': vectorField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('vector')) {
      vectorField.value = map['vector'] as Vector;
    }
  }
}
