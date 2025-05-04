// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_set_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для PointSetModel
class PointSetModelFormConfig extends TypedFormConfig<PointSetModel> {
  @override
  String get name => 'PointSetModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'points',
      type: FieldType.list,
      config: ListFieldConfig<Point>(
        label: 'Множество точек',
        minItems: 3,
        createItemField:
            () => PointField(config: PointFieldConfig(label: 'Точка')),
      ),
    ),
  ];

  @override
  PointSetModelFormModel createModel() =>
      PointSetModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для PointSetModel
class PointSetModelFormModel extends TypedFormModel<PointSetModel> {
  PointSetModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  PointSetModel get values => PointSetModel(points: pointsField.value!);

  @override
  set values(PointSetModel newValues) {
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
