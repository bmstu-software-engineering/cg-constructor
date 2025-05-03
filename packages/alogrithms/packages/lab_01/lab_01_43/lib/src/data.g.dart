// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0143DataModel
class AlgorithmLab0143DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0143DataModel> {
  @override
  String get name => 'AlgorithmLab0143DataModel';

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
  AlgorithmLab0143DataModelFormModel createModel() =>
      AlgorithmLab0143DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0143DataModel
class AlgorithmLab0143DataModelFormModel
    extends TypedFormModel<AlgorithmLab0143DataModel> {
  AlgorithmLab0143DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0143DataModel get values =>
      AlgorithmLab0143DataModel(points: pointsField.value!);

  @override
  set values(AlgorithmLab0143DataModel newValues) {
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
