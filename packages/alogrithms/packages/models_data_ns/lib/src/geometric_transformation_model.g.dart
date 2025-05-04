// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geometric_transformation_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для ScaleTransformationModel
class ScaleTransformationModelFormConfig
    extends TypedFormConfig<ScaleTransformationModel> {
  @override
  String get name => 'ScaleTransformationModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'center',
      type: FieldType.point,
      config: PointFieldConfig(
        label: 'Центр масштабирования',
        isRequired: true,
      ),
    ),
    FieldConfigEntry(
      id: 'scale',
      type: FieldType.scale,
      config: ScaleFieldConfig(
        label: 'Коэффициенты масштабирования',
        isRequired: true,
      ),
    ),
  ];

  @override
  ScaleTransformationModelFormModel createModel() =>
      ScaleTransformationModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для ScaleTransformationModel
class ScaleTransformationModelFormModel
    extends TypedFormModel<ScaleTransformationModel> {
  ScaleTransformationModelFormModel({required super.config});

  /// Поле для center
  FormField<Point> get centerField => getField<FormField<Point>>('center')!;

  /// Поле для scale
  FormField<Scale> get scaleField => getField<FormField<Scale>>('scale')!;

  @override
  ScaleTransformationModel get values => ScaleTransformationModel(
    center: centerField.value!,
    scale: scaleField.value!,
  );

  @override
  set values(ScaleTransformationModel newValues) {
    centerField.value = newValues.center;
    scaleField.value = newValues.scale;
  }

  @override
  Map<String, dynamic> toMap() => {
    'center': centerField.value,
    'scale': scaleField.value,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('center')) {
      centerField.value = map['center'] as Point;
    }
    if (map.containsKey('scale')) {
      scaleField.value = map['scale'] as Scale;
    }
  }
}

/// Типизированная конфигурация формы для GeometricTransformationModel
class GeometricTransformationModelFormConfig
    extends TypedFormConfig<GeometricTransformationModel> {
  @override
  String get name => 'GeometricTransformationModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'translation',
      type: FieldType.vector,
      config: VectorFieldConfig(label: 'Вектор перемещения'),
    ),
    FieldConfigEntry(
      id: 'rotation',
      type: FieldType.angle,
      config: AngleFieldConfig(label: 'Угол поворота'),
    ),
    FieldConfigEntry(
      id: 'scaling',
      type: FieldType.form,
      config: FormFieldConfig<ScaleTransformationModel>(
        label: 'Параметры масштабирования',
        createFormModel:
            () => ScaleTransformationModelFormModel(
              config: ScaleTransformationModelFormConfig().toFormConfig(),
            ),
        isRequired: true,
      ),
    ),
  ];

  @override
  GeometricTransformationModelFormModel createModel() =>
      GeometricTransformationModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для GeometricTransformationModel
class GeometricTransformationModelFormModel
    extends TypedFormModel<GeometricTransformationModel> {
  GeometricTransformationModelFormModel({required super.config});

  /// Поле для translation
  VectorField get translationField => getField<VectorField>('translation')!;

  /// Поле для rotation
  AngleField get rotationField => getField<AngleField>('rotation')!;

  /// Поле для scaling
  FormField<ScaleTransformationModel> get scalingField =>
      getField<FormField<ScaleTransformationModel>>('scaling')!;

  @override
  GeometricTransformationModel get values => GeometricTransformationModel(
    translation: translationField.value!,
    rotation: rotationField.value!,
    scaling: scalingField.value!,
  );

  @override
  set values(GeometricTransformationModel newValues) {
    translationField.value = newValues.translation;
    rotationField.value = newValues.rotation;
    scalingField.value = newValues.scaling;
  }

  @override
  Map<String, dynamic> toMap() => {
    'translation': translationField.value,
    'rotation': rotationField.value,
    'scaling':
        scalingField.value != null
            ? (scalingField as NestedFormField).toMap()
            : null,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('translation'))
      translationField.value = map['translation'] as Vector;
    if (map.containsKey('rotation'))
      rotationField.value = map['rotation'] as Angle;
    if (map.containsKey('scaling')) {
      final nestedMap = map['scaling'] as Map<String, dynamic>;
      if (scalingField.value == null) {
        // Создаем новую вложенную форму
        final nestedFormModel =
            ScaleTransformationModelFormConfig().createModel();
        nestedFormModel.fromMap(nestedMap);
        scalingField.value = nestedFormModel.values;
      } else {
        // Используем существующую вложенную форму
        (scalingField as NestedFormField).fromMap(nestedMap);
      }
    }
  }
}
