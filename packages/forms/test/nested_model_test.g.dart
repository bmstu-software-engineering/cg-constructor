// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_model_test.dart';

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
            config:
                PointFieldConfig(label: 'Центр вращения', isRequired: true)),
        FieldConfigEntry(
            id: 'scale',
            type: FieldType.scale,
            config: ScaleFieldConfig(
                label: 'Коэфициенты масшабирования', isRequired: true)),
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
  FormField<Point> get centerField => getField<FormField<Point>>('center')!;

  /// Поле для scale
  FormField<Scale> get scaleField => getField<FormField<Scale>>('scale')!;

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
    if (map.containsKey('center')) {
      centerField.value = map['center'] as Point;
    }
    if (map.containsKey('scale')) {
      scaleField.value = map['scale'] as Scale;
    }
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
            config: VectorFieldConfig(
                label: 'Вектор перемещения', isRequired: true)),
        FieldConfigEntry(
            id: 'rotate',
            type: FieldType.angle,
            config: AngleFieldConfig(
              label: 'Угол поворота',
            )),
        FieldConfigEntry(
            id: 'scale',
            type: FieldType.form,
            config: FormFieldConfig<AlgorithmLab02DataModelScale>(
                label: 'Параметры масштабирования',
                createFormModel: () => AlgorithmLab02DataModelScaleFormModel(
                    config: AlgorithmLab02DataModelScaleFormConfig()
                        .toFormConfig()),
                isRequired: true)),
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
  FormField<Vector> get moveField => getField<FormField<Vector>>('move')!;

  /// Поле для rotate
  AngleField get rotateField => getField<AngleField>('rotate')!;

  /// Поле для scale
  FormField<AlgorithmLab02DataModelScale> get scaleField =>
      getField<FormField<AlgorithmLab02DataModelScale>>('scale')!;

  @override
  AlgorithmLab02DataModel get values => AlgorithmLab02DataModel(
        move: moveField.value!,
        rotate: rotateField.value!,
        scale: scaleField.value!,
      );

  @override
  set values(AlgorithmLab02DataModel newValues) {
    moveField.value = newValues.move;
    rotateField.value = newValues.rotate;
    scaleField.value = newValues.scale;
  }

  @override
  Map<String, dynamic> toMap() => {
        'move': moveField.value,
        'rotate': rotateField.value,
        'scale': scaleField.value != null
            ? (scaleField as NestedFormField).toMap()
            : null,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('move')) {
      moveField.value = map['move'] as Vector;
    }
    if (map.containsKey('rotate')) rotateField.value = map['rotate'] as Angle;
    if (map.containsKey('scale')) {
      final nestedMap = map['scale'] as Map<String, dynamic>;
      if (scaleField.value == null) {
        // Создаем новую вложенную форму
        final nestedFormModel =
            AlgorithmLab02DataModelScaleFormConfig().createModel();
        nestedFormModel.fromMap(nestedMap);
        scaleField.value = nestedFormModel.values;
      } else {
        // Используем существующую вложенную форму
        (scaleField as NestedFormField).fromMap(nestedMap);
      }
    }
  }
}
