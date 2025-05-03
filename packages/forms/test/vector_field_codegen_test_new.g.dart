// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector_field_codegen_test_new.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для VectorTestFormNew
class VectorTestFormNewFormConfig extends TypedFormConfig<VectorTestFormNew> {
  @override
  String get name => 'Тестовая форма с вектором';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'vector',
            type: FieldType.vector,
            config: VectorFieldConfig(
              label: 'Вектор',
            )),
      ];

  @override
  VectorTestFormNewFormModel createModel() =>
      VectorTestFormNewFormModel(config: toFormConfig());
}

/// Типизированная модель формы для VectorTestFormNew
class VectorTestFormNewFormModel extends TypedFormModel<VectorTestFormNew> {
  VectorTestFormNewFormModel({required super.config});

  /// Поле для vector
  VectorField get vectorField => getField<VectorField>('vector')!;

  @override
  VectorTestFormNew get values => VectorTestFormNew(
        vector: vectorField.value!,
      );

  @override
  set values(VectorTestFormNew newValues) {
    vectorField.value = newValues.vector;
  }

  @override
  Map<String, dynamic> toMap() => {
        'vector': vectorField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('vector')) vectorField.value = map['vector'] as Vector;
  }
}
