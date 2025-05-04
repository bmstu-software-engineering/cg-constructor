// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_set_with_reference_point_model.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для PointSetWithReferencePointModel
class PointSetWithReferencePointModelFormConfig
    extends TypedFormConfig<PointSetWithReferencePointModel> {
  @override
  String get name => 'PointSetWithReferencePointModel';

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
    FieldConfigEntry(
      id: 'referencePoint',
      type: FieldType.point,
      config: PointFieldConfig(label: 'Контрольная точка', isRequired: true),
    ),
  ];

  @override
  PointSetWithReferencePointModelFormModel createModel() =>
      PointSetWithReferencePointModelFormModel(config: toFormConfig());
}

/// Типизированная модель формы для PointSetWithReferencePointModel
class PointSetWithReferencePointModelFormModel
    extends TypedFormModel<PointSetWithReferencePointModel> {
  PointSetWithReferencePointModelFormModel({required super.config});

  /// Поле для points
  ListField<Point, FormField<Point>> get pointsField =>
      getField<ListField<Point, FormField<Point>>>('points')!;

  /// Поле для referencePoint
  FormField<Point> get referencePointField =>
      getField<FormField<Point>>('referencePoint')!;

  @override
  PointSetWithReferencePointModel get values => PointSetWithReferencePointModel(
    points: pointsField.value!,
    referencePoint: referencePointField.value!,
  );

  @override
  set values(PointSetWithReferencePointModel newValues) {
    pointsField.value = newValues.points;
    referencePointField.value = newValues.referencePoint;
  }

  @override
  Map<String, dynamic> toMap() => {
    'points': pointsField.value,
    'referencePoint': referencePointField.value,
  };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('points'))
      pointsField.value = (map['points'] as List<dynamic>).cast<Point>();
    if (map.containsKey('referencePoint')) {
      referencePointField.value = map['referencePoint'] as Point;
    }
  }
}
