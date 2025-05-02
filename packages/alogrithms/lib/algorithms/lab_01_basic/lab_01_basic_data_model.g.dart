// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_01_basic_data_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AlgorithmLab01BasicDataModel
class AlgorithmLab01BasicDataModelFormConfig
    extends TypedFormConfig<AlgorithmLab01BasicDataModel> {
  @override
  String get name => 'AlgorithmLab01BasicDataModel';

  @override
  List<FieldConfigEntry> get fields => [
    FieldConfigEntry(
      id: 'points',
      type: FieldType.list,
      config: ListFieldConfig<Point>(
        label: 'Список точек',
        createItemField:
            () => PointField(config: PointFieldConfig(label: 'Точка')),
      ),
    ),
  ];

  @override
  AlgorithmLab01BasicDataModelFormModel createModel() =>
      AlgorithmLab01BasicDataModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AlgorithmLab01BasicDataModel
class AlgorithmLab01BasicDataModelFormModel
    extends TypedFormModel<AlgorithmLab01BasicDataModel> {
  AlgorithmLab01BasicDataModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  @override
  AlgorithmLab01BasicDataModel get values =>
      AlgorithmLab01BasicDataModel(points: pointsField.value!);

  @override
  set values(AlgorithmLab01BasicDataModel newValues) {
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
