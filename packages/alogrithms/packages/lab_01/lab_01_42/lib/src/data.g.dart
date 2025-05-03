// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0142DataModel
class AlgorithmLab0142DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0142DataModel> {
  @override
  String get name => 'AlgorithmLab0142DataModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'points',
      type: FieldType.list,
      config: ListFieldConfig<Point>(
        label: 'Множество точек',
        minItems: 6,
        createItemField:
            () => PointField(config: PointFieldConfig(label: 'Точка')),
      ),
    ),
  ];

  @override
  AlgorithmLab0142DataModelFormModel createModel() =>
      AlgorithmLab0142DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0142DataModel
class AlgorithmLab0142DataModelFormModel
    extends TypedFormModel<AlgorithmLab0142DataModel> {
  AlgorithmLab0142DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0142DataModel get values =>
      AlgorithmLab0142DataModel(points: pointsField.value!);

  @override
  set values(AlgorithmLab0142DataModel newValues) {
    pointsField.value = newValues.points;
  }

  @override
  Map<String, dynamic> toMap() => {'points': pointsField.value};

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('points'))
      pointsField.value = (map['points'] as List<dynamic>).cast<Point>();
  }
}
