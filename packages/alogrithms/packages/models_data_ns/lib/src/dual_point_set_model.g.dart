// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dual_point_set_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для DualPointSetModel
class DualPointSetModelFormConfig extends TypedFormConfig<DualPointSetModel> {
  @override
  String get name => 'DualPointSetModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'firstPoints',
      type: FieldType.list,
      config: ListFieldConfig<Point>(
        label: 'Первое множество точек',
        minItems: 3,
        createItemField:
            () => PointField(config: PointFieldConfig(label: 'Точка')),
      ),
    ),
    FieldConfigEntry(
      id: 'secondPoints',
      type: FieldType.list,
      config: ListFieldConfig<Point>(
        label: 'Второе множество точек',
        minItems: 3,
        createItemField:
            () => PointField(config: PointFieldConfig(label: 'Точка')),
      ),
    ),
  ];

  @override
  DualPointSetModelFormModel createModel() =>
      DualPointSetModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для DualPointSetModel
class DualPointSetModelFormModel extends TypedFormModel<DualPointSetModel> {
  DualPointSetModelFormModel({required super.config});

  /// Поле для firstPoints
  ListField<Point, FormField<Point>> get firstPointsField =>
      getField<ListField<Point, FormField<Point>>>('firstPoints')!;

  /// Поле для secondPoints
  ListField<Point, FormField<Point>> get secondPointsField =>
      getField<ListField<Point, FormField<Point>>>('secondPoints')!;

  @override
  DualPointSetModel get values => DualPointSetModel(
    firstPoints: firstPointsField.value!,
    secondPoints: secondPointsField.value!,
  );

  @override
  set values(DualPointSetModel newValues) {
    firstPointsField.value = newValues.firstPoints;
    secondPointsField.value = newValues.secondPoints;
  }

  @override
  Map<String, dynamic> toMap() => {
    'firstPoints': firstPointsField.value,
    'secondPoints': secondPointsField.value,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('firstPoints'))
      firstPointsField.value =
          (map['firstPoints'] as List<dynamic>).cast<Point>();
    if (map.containsKey('secondPoints'))
      secondPointsField.value =
          (map['secondPoints'] as List<dynamic>).cast<Point>();
  }
}
