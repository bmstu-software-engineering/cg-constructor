// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab02DataModelScale
class AlgorithmLab02DataModelScaleFormConfig
    extends TypedFormConfig<AlgorithmLab02DataModelScale> {
  @override
  String get name => 'AlgorithmLab02DataModelScale';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'center',
      type: FieldType.point,
      config: PointFieldConfig(label: 'Центр вращения'),
    ),
    FieldConfigEntry(
      id: 'scale',
      type: FieldType.scale,
      config: ScaleFieldConfig(label: 'Коэфициенты масшабирования'),
    ),
  ];

  @override
  AlgorithmLab02DataModelScaleFormModel createModel() =>
      AlgorithmLab02DataModelScaleFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab02DataModelScale
class AlgorithmLab02DataModelScaleFormModel
    extends TypedFormModel<AlgorithmLab02DataModelScale> {
  AlgorithmLab02DataModelScaleFormModel({required super.config});

  /// Поле для center
  PointField get centerField => getField<PointField>('center')!;

  /// Поле для scale
  ScaleField get scaleField => getField<ScaleField>('scale')!;

  @override
  AlgorithmLab02DataModelScale get values => AlgorithmLab02DataModelScale(
    center: centerField.value!,
    scale: scaleField.value!,
  );

  @override
  set values(AlgorithmLab02DataModelScale newValues) {
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
    if (map.containsKey('center')) centerField.value = map['center'] as Point;
    if (map.containsKey('scale')) scaleField.value = map['scale'] as Scale;
  }
}

/// Типизированная конфигурация формы для AlgorithmLab02DataModel
class AlgorithmLab02DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab02DataModel> {
  @override
  String get name => 'AlgorithmLab02DataModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'move',
      type: FieldType.vector,
      config: VectorFieldConfig(label: 'Вектор перемещения'),
    ),
    FieldConfigEntry(
      id: 'rotate',
      type: FieldType.angle,
      config: AngleFieldConfig(label: 'Угол поворота'),
    ),
  ];

  @override
  AlgorithmLab02DataModelFormModel createModel() =>
      AlgorithmLab02DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab02DataModel
class AlgorithmLab02DataModelFormModel
    extends TypedFormModel<AlgorithmLab02DataModel> {
  AlgorithmLab02DataModelFormModel({required super.config});

  /// Поле для move
  VectorField get moveField => getField<VectorField>('move')!;

  /// Поле для rotate
  AngleField get rotateField => getField<AngleField>('rotate')!;

  @override
  AlgorithmLab02DataModel get values => AlgorithmLab02DataModel(
    move: moveField.value!,
    rotate: rotateField.value!,
  );

  @override
  set values(AlgorithmLab02DataModel newValues) {
    moveField.value = newValues.move;
    rotateField.value = newValues.rotate;
  }

  @override
  Map<String, dynamic> toMap() => {
    'move': moveField.value,
    'rotate': rotateField.value,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('move')) moveField.value = map['move'] as Vector;
    if (map.containsKey('rotate')) rotateField.value = map['rotate'] as Angle;
  }
}
