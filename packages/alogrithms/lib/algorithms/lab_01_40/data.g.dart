// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab01V40DataModel
class AlgorithmLab01V40DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab01V40DataModel> {
  @override
  String get name => 'AlgorithmLab01V40DataModel';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'pointsFirst',
            type: FieldType.list,
            config: ListFieldConfig<Point>(
              label: 'Первое множество точек',
              minItems: 3,
              createItemField: () => PointField(
                  config: PointFieldConfig(
                label: 'Точка',
              )),
            )),
        FieldConfigEntry(
            id: 'pointsSecond',
            type: FieldType.list,
            config: ListFieldConfig<Point>(
              label: 'Второе множество точек',
              minItems: 3,
              createItemField: () => PointField(
                  config: PointFieldConfig(
                label: 'Точка',
              )),
            )),
      ];

  @override
  AlgorithmLab01V40DataModelFormModel createModel() =>
      AlgorithmLab01V40DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab01V40DataModel
class AlgorithmLab01V40DataModelFormModel
    extends TypedFormModel<AlgorithmLab01V40DataModel> {
  AlgorithmLab01V40DataModelFormModel({required super.config});

  /// Поле для pointsFirst
  ListField<Point, FormField<Point>> get pointsFirstField =>
      getField<ListField<Point, FormField<Point>>>('pointsFirst')!;

  /// Поле для pointsSecond
  ListField<Point, FormField<Point>> get pointsSecondField =>
      getField<ListField<Point, FormField<Point>>>('pointsSecond')!;

  @override
  AlgorithmLab01V40DataModel get values => AlgorithmLab01V40DataModel(
        pointsFirst: pointsFirstField.value!,
        pointsSecond: pointsSecondField.value!,
      );

  @override
  set values(AlgorithmLab01V40DataModel newValues) {
    pointsFirstField.value = newValues.pointsFirst;
    pointsSecondField.value = newValues.pointsSecond;
  }

  @override
  Map<String, dynamic> toMap() => {
        'pointsFirst': pointsFirstField.value,
        'pointsSecond': pointsSecondField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('pointsFirst'))
      pointsFirstField.value =
          (map['pointsFirst'] as List<dynamic>).cast<Point>();
    if (map.containsKey('pointsSecond'))
      pointsSecondField.value =
          (map['pointsSecond'] as List<dynamic>).cast<Point>();
  }
}
