// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0127DataModel
class AlgorithmLab0127DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0127DataModel> {
  @override
  String get name => 'AlgorithmLab0127DataModel';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'points',
            type: FieldType.list,
            config: ListFieldConfig<Point>(
              label: 'Множество точек',
              minItems: 3,
              createItemField: () => PointField(
                  config: PointFieldConfig(
                label: 'Точка',
              )),
            )),
      ];

  @override
  AlgorithmLab0127DataModelFormModel createModel() =>
      AlgorithmLab0127DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0127DataModel
class AlgorithmLab0127DataModelFormModel
    extends TypedFormModel<AlgorithmLab0127DataModel> {
  AlgorithmLab0127DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0127DataModel get values => AlgorithmLab0127DataModel(
        points: pointsField.value!,
      );

  @override
  set values(AlgorithmLab0127DataModel newValues) {
    pointsField.value = newValues.points;
  }

  @override
  Map<String, dynamic> toMap() => {
        'points': pointsField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('points'))
      pointsField.value = (map['points'] as List<dynamic>).cast<Point>();
  }
}
