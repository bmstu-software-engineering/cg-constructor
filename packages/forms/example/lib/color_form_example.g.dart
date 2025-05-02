// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_form_example.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для ColorForm
class ColorFormFormConfig extends TypedFormConfig<ColorForm> {
  @override
  String get name => 'Форма с выбором цвета';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'coloredPoint',
            type: FieldType.point,
            config: PointFieldConfig(
              label: 'Точка с цветом',
              xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
              yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
              canSetColor: true,
              defaultColor: '#FF0000',
            )),
        FieldConfigEntry(
            id: 'coloredLine',
            type: FieldType.line,
            config: LineFieldConfig(
              label: 'Линия с цветом',
              startConfig: PointFieldConfig(label: 'Начало'),
              endConfig: PointFieldConfig(label: 'Конец'),
              canSetColor: true,
              defaultColor: '#0000FF',
              canSetThickness: true,
              defaultThickness: 2.0,
            )),
      ];

  @override
  ColorFormFormModel createModel() =>
      ColorFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для ColorForm
class ColorFormFormModel extends TypedFormModel<ColorForm> {
  ColorFormFormModel({required super.config});

  /// Поле для coloredPoint
  PointField get coloredPointField => getField<PointField>('coloredPoint')!;

  /// Поле для coloredLine
  LineField get coloredLineField => getField<LineField>('coloredLine')!;

  @override
  ColorForm get values => ColorForm(
        coloredPoint: coloredPointField.value!,
        coloredLine: coloredLineField.value!,
      );

  @override
  set values(ColorForm newValues) {
    coloredPointField.value = newValues.coloredPoint;
    coloredLineField.value = newValues.coloredLine;
  }

  @override
  Map<String, dynamic> toMap() => {
        'coloredPoint': coloredPointField.value,
        'coloredLine': coloredLineField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('coloredPoint')) {
      coloredPointField.value = map['coloredPoint'] as Point;
    }
    if (map.containsKey('coloredLine')) {
      coloredLineField.value = map['coloredLine'] as Line;
    }
  }
}
