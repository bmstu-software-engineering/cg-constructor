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

/// Типизированная конфигурация формы для RotateTransformationModel
class RotateTransformationModelFormConfig
    extends TypedFormConfig<RotateTransformationModel> {
  @override
  String get name => 'RotateTransformationModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'center',
      type: FieldType.point,
      config: PointFieldConfig(label: 'Центр поворота', isRequired: true),
    ),
    FieldConfigEntry(
      id: 'angle',
      type: FieldType.angle,
      config: AngleFieldConfig(label: 'Угол поворота'),
    ),
  ];

  @override
  RotateTransformationModelFormModel createModel() =>
      RotateTransformationModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для RotateTransformationModel
class RotateTransformationModelFormModel
    extends TypedFormModel<RotateTransformationModel> {
  RotateTransformationModelFormModel({required super.config});

  /// Поле для center
  FormField<Point> get centerField => getField<FormField<Point>>('center')!;

  /// Поле для angle
  AngleField get angleField => getField<AngleField>('angle')!;

  @override
  RotateTransformationModel get values => RotateTransformationModel(
    center: centerField.value!,
    angle: angleField.value!,
  );

  @override
  set values(RotateTransformationModel newValues) {
    centerField.value = newValues.center;
    angleField.value = newValues.angle;
  }

  @override
  Map<String, dynamic> toMap() => {
    'center': centerField.value,
    'angle': angleField.value,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('center')) {
      centerField.value = map['center'] as Point;
    }
    if (map.containsKey('angle')) angleField.value = map['angle'] as Angle;
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
      config: VectorFieldConfig(label: 'Вектор перемещения', isRequired: false),
    ),
    FieldConfigEntry(
      id: 'rotation',
      type: FieldType.form,
      config: FormFieldConfig<RotateTransformationModel?>(
        label: 'Параметры поворота',
        createFormModel:
            () => RotateTransformationModelFormModel(
              config: RotateTransformationModelFormConfig().toFormConfig(),
            ),
        isRequired: false,
      ),
    ),
    FieldConfigEntry(
      id: 'scaling',
      type: FieldType.form,
      config: FormFieldConfig<ScaleTransformationModel?>(
        label: 'Параметры масштабирования',
        createFormModel:
            () => ScaleTransformationModelFormModel(
              config: ScaleTransformationModelFormConfig().toFormConfig(),
            ),
        isRequired: false,
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
  FormField<RotateTransformationModel?> get rotationField =>
      getField<FormField<RotateTransformationModel?>>('rotation')!;

  /// Поле для scaling
  FormField<ScaleTransformationModel?> get scalingField =>
      getField<FormField<ScaleTransformationModel?>>('scaling')!;

  @override
  GeometricTransformationModel get values => GeometricTransformationModel(
    translation: translationField.value,
    rotation: rotationField.value,
    scaling: scalingField.value,
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
    'rotation':
        rotationField.value != null
            ? (rotationField as NestedFormField).toMap()
            : null,
    'scaling':
        scalingField.value != null
            ? (scalingField as NestedFormField).toMap()
            : null,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('translation'))
      translationField.value = map['translation'] as Vector?;
    if (map.containsKey('rotation') && map['rotation'] != null) {
      final nestedMap = map['rotation'] as Map<String, dynamic>;
      if (rotationField.value == null) {
        // Создаем новую вложенную форму
        final nestedFormModel =
            RotateTransformationModelFormConfig().createModel();
        nestedFormModel.fromMap(nestedMap);
        rotationField.value = nestedFormModel.values;
      } else {
        // Используем существующую вложенную форму
        (rotationField as NestedFormField).fromMap(nestedMap);
      }
    } else {
      rotationField.value = null;
    }
    if (map.containsKey('scaling') && map['scaling'] != null) {
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
    } else {
      scalingField.value = null;
    }
  }
}
