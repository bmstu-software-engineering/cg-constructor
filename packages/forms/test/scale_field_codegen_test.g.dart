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
            config: ScaleFieldConfig(
              label: 'Масштаб',
            )),
        FieldConfigEntry(
            id: 'uniformScale',
            type: FieldType.scale,
            config: ScaleFieldConfig(
              label: 'Равномерный масштаб',
              uniform: true,
              isRequired: false,
            )),
      ];

  @override
  ScaleTestFormFormModel createModel() =>
      ScaleTestFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для ScaleTestForm
class ScaleTestFormFormModel extends TypedFormModel<ScaleTestForm> {
  ScaleTestFormFormModel({required super.config});

  /// Поле для scale
  ScaleField get scaleField => getField<ScaleField>('scale')!;

  /// Поле для uniformScale
  ScaleField get uniformScaleField => getField<ScaleField>('uniformScale')!;

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
    if (map.containsKey('scale')) scaleField.value = map['scale'] as Scale;
    if (map.containsKey('uniformScale'))
      uniformScaleField.value = map['uniformScale'] as Scale?;
  }
}
