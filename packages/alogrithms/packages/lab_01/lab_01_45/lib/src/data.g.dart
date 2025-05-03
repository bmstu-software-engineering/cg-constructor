// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0145DataModel
class AlgorithmLab0145DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0145DataModel> {
  @override
  String get name => 'AlgorithmLab0145DataModel';

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
  AlgorithmLab0145DataModelFormModel createModel() =>
      AlgorithmLab0145DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0145DataModel
class AlgorithmLab0145DataModelFormModel
    extends TypedFormModel<AlgorithmLab0145DataModel> {
  AlgorithmLab0145DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0145DataModel get values =>
      AlgorithmLab0145DataModel(points: pointsField.value!);

  @override
  set values(AlgorithmLab0145DataModel newValues) {
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
