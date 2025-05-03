// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scale_field_codegen_test.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для ScaleTestForm
class ScaleTestFormFormConfig extends TypedFormConfig<ScaleTestForm> {
  @override
  String get name => 'Тестовая форма с масштабом';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'scale',
            type: FieldType.scale,
            config: ScaleFieldConfig(label: 'Масштаб', isRequired: true)),
        FieldConfigEntry(
            id: 'uniformScale',
            type: FieldType.scale,
            config: ScaleFieldConfig(
                label: 'Равномерный масштаб', isRequired: false)),
      ];

  @override
  ScaleTestFormFormModel createModel() =>
      ScaleTestFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для ScaleTestForm
class ScaleTestFormFormModel extends TypedFormModel<ScaleTestForm> {
  ScaleTestFormFormModel({required super.config});

  /// Поле для scale
  FormField<Scale> get scaleField => getField<FormField<Scale>>('scale')!;

  /// Поле для uniformScale
  FormField<Scale?> get uniformScaleField =>
      getField<FormField<Scale?>>('uniformScale')!;

  @override
  ScaleTestForm get values => ScaleTestForm(
        scale: scaleField.value!,
        uniformScale: uniformScaleField.value,
      );

  @override
  set values(ScaleTestForm newValues) {
    scaleField.value = newValues.scale;
    uniformScaleField.value = newValues.uniformScale;
  }

  @override
  Map<String, dynamic> toMap() => {
        'scale': scaleField.value,
        'uniformScale': uniformScaleField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('scale')) {
      scaleField.value = map['scale'] as Scale;
    }
    if (map.containsKey('uniformScale') && map['uniformScale'] != null) {
      uniformScaleField.value = map['uniformScale'] as Scale;
    } else {
      uniformScaleField.value = null;
    }
  }
}
