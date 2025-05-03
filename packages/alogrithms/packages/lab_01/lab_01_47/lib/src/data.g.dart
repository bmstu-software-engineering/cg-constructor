// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0147DataModel
class AlgorithmLab0147DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0147DataModel> {
  @override
  String get name => 'AlgorithmLab0147DataModel';

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
        FieldConfigEntry(
            id: 'pointB',
            type: FieldType.point,
            config: PointFieldConfig(
              label: 'Точка pB',
            )),
      ];

  @override
  AlgorithmLab0147DataModelFormModel createModel() =>
      AlgorithmLab0147DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0147DataModel
class AlgorithmLab0147DataModelFormModel
    extends TypedFormModel<AlgorithmLab0147DataModel> {
  AlgorithmLab0147DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  /// Поле для pointB
  PointField get pointBField => getField<PointField>('pointB')!;

  @override
  AlgorithmLab0147DataModel get values => AlgorithmLab0147DataModel(
        points: pointsField.value!,
        pointB: pointBField.value!,
      );

  @override
  set values(AlgorithmLab0147DataModel newValues) {
    pointsField.value = newValues.points;
    pointBField.value = newValues.pointB;
  }

  @override
  Map<String, dynamic> toMap() => {
        'points': pointsField.value,
        'pointB': pointBField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('points'))
      pointsField.value = (map['points'] as List<dynamic>).cast<Point>();
    if (map.containsKey('pointB')) pointBField.value = map['pointB'] as Point;
  }
}
