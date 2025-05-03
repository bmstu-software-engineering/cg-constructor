// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_example.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для UserForm
class UserFormFormConfig extends TypedFormConfig<UserForm> {
  @override
  String get name => 'Пользовательская форма';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'age',
            type: FieldType.number,
            config: NumberFieldConfig(
              label: 'Возраст',
              min: 18.0,
              max: 100.0,
            )),
        FieldConfigEntry(
            id: 'location',
            type: FieldType.point,
            config: PointFieldConfig(
              label: 'Координаты',
            )),
        FieldConfigEntry(
            id: 'rotation',
            type: FieldType.angle,
            config: AngleFieldConfig(
              label: 'Угол поворота',
              min: 0.0,
              max: 360.0,
              normalize: true,
              isRequired: false,
            )),
      ];

  @override
  UserFormFormModel createModel() => UserFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для UserForm
class UserFormFormModel extends TypedFormModel<UserForm> {
  UserFormFormModel({required super.config});

  /// Поле для age
  NumberField get ageField => getField<NumberField>('age')!;

  /// Поле для location
  PointField get locationField => getField<PointField>('location')!;

  /// Поле для rotation
  AngleField get rotationField => getField<AngleField>('rotation')!;

  @override
  UserForm get values => UserForm(
        age: ageField.value!,
        location: locationField.value!,
        rotation: rotationField.value,
      );

  @override
  set values(UserForm newValues) {
    ageField.value = newValues.age.toDouble();
    locationField.value = newValues.location;
    rotationField.value = newValues.rotation;
  }

  @override
  Map<String, dynamic> toMap() => {
        'age': ageField.value,
        'location': locationField.value,
        'rotation': rotationField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('age')) {
      final value = map['age'];
      ageField.value = (value is int) ? value.toDouble() : (value as double);
    }
    if (map.containsKey('location'))
      locationField.value = map['location'] as Point;
    if (map.containsKey('rotation'))
      rotationField.value = map['rotation'] as Angle?;
  }
}
