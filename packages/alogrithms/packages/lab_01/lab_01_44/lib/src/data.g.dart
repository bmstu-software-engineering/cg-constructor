// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0144DataModel
class AlgorithmLab0144DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0144DataModel> {
  @override
  String get name => 'AlgorithmLab0144DataModel';

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
  AlgorithmLab0144DataModelFormModel createModel() =>
      AlgorithmLab0144DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0144DataModel
class AlgorithmLab0144DataModelFormModel
    extends TypedFormModel<AlgorithmLab0144DataModel> {
  AlgorithmLab0144DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0144DataModel get values =>
      AlgorithmLab0144DataModel(points: pointsField.value!);

  @override
  set values(AlgorithmLab0144DataModel newValues) {
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
