// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab0141DataModel
class AlgorithmLab0141DataModelFormConfig
    extends TypedFormConfig<AlgorithmLab0141DataModel> {
  @override
  String get name => 'AlgorithmLab0141DataModel';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'points',
            type: FieldType.list,
            config: ListFieldConfig<Point>(
              label: 'Множество точек',
              minItems: 6,
              createItemField: () => PointField(
                  config: PointFieldConfig(
                label: 'Точка',
              )),
            )),
      ];

  @override
  AlgorithmLab0141DataModelFormModel createModel() =>
      AlgorithmLab0141DataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab0141DataModel
class AlgorithmLab0141DataModelFormModel
    extends TypedFormModel<AlgorithmLab0141DataModel> {
  AlgorithmLab0141DataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab0141DataModel get values => AlgorithmLab0141DataModel(
        points: pointsField.value!,
      );

  @override
  set values(AlgorithmLab0141DataModel newValues) {
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
