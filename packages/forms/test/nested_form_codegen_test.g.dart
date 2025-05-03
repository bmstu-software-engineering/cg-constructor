// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_form_codegen_test.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для AddressForm
class AddressFormFormConfig extends TypedFormConfig<AddressForm> {
  @override
  String get name => 'Форма адреса';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'street',
            type: FieldType.string,
            config: StringFieldConfig(
              label: 'Улица',
            )),
        FieldConfigEntry(
            id: 'city',
            type: FieldType.string,
            config: StringFieldConfig(
              label: 'Город',
            )),
        FieldConfigEntry(
            id: 'zipCode',
            type: FieldType.string,
            config: StringFieldConfig(
              label: 'Почтовый индекс',
            )),
      ];

  @override
  AddressFormFormModel createModel() =>
      AddressFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для AddressForm
class AddressFormFormModel extends TypedFormModel<AddressForm> {
  AddressFormFormModel({required super.config});

  /// Поле для street
  StringField get streetField => getField<StringField>('street')!;

  /// Поле для city
  StringField get cityField => getField<StringField>('city')!;

  /// Поле для zipCode
  StringField get zipCodeField => getField<StringField>('zipCode')!;

  @override
  AddressForm get values => AddressForm(
        street: streetField.value!,
        city: cityField.value!,
        zipCode: zipCodeField.value!,
      );

  @override
  set values(AddressForm newValues) {
    streetField.value = newValues.street;
    cityField.value = newValues.city;
    zipCodeField.value = newValues.zipCode;
  }

  @override
  Map<String, dynamic> toMap() => {
        'street': streetField.value,
        'city': cityField.value,
        'zipCode': zipCodeField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('street')) streetField.value = map['street'] as String;
    if (map.containsKey('city')) cityField.value = map['city'] as String;
    if (map.containsKey('zipCode'))
      zipCodeField.value = map['zipCode'] as String;
  }
}

/// Типизированная конфигурация формы для UserForm
class UserFormFormConfig extends TypedFormConfig<UserForm> {
  @override
  String get name => 'Форма пользователя';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'name',
            type: FieldType.string,
            config: StringFieldConfig(
              label: 'Имя',
            )),
        FieldConfigEntry(
            id: 'age',
            type: FieldType.number,
            config: NumberFieldConfig(
              label: 'Возраст',
              min: 0.0,
              max: 120.0,
            )),
        FieldConfigEntry(
            id: 'address',
            type: FieldType.form,
            config: FormFieldConfig<AddressForm>(
                label: 'Адрес',
                createFormModel: () => AddressFormFormModel(
                    config: AddressFormFormConfig().toFormConfig()),
                isRequired: true)),
      ];

  @override
  UserFormFormModel createModel() => UserFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для UserForm
class UserFormFormModel extends TypedFormModel<UserForm> {
  UserFormFormModel({required super.config});

  /// Поле для name
  StringField get nameField => getField<StringField>('name')!;

  /// Поле для age
  NumberField get ageField => getField<NumberField>('age')!;

  /// Поле для address
  FormField<AddressForm> get addressField =>
      getField<FormField<AddressForm>>('address')!;

  @override
  UserForm get values => UserForm(
        name: nameField.value!,
        age: ageField.value!.toInt(),
        address: addressField.value!,
      );

  @override
  set values(UserForm newValues) {
    nameField.value = newValues.name;
    ageField.value = newValues.age.toDouble();
    addressField.value = newValues.address;
  }

  @override
  Map<String, dynamic> toMap() => {
        'name': nameField.value,
        'age': ageField.value,
        'address': addressField.value != null
            ? {
                'street': addressField.value!.street,
                'city': addressField.value!.city,
                'zipCode': addressField.value!.zipCode,
              }
            : null,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) nameField.value = map['name'] as String;
    if (map.containsKey('age')) {
      final value = map['age'];
      ageField.value = (value is int) ? value.toDouble() : (value as double);
    }
    if (map.containsKey('address')) {
      final addressMap = map['address'] as Map<String, dynamic>;
      addressField.value = AddressForm(
        street: addressMap['street'] as String,
        city: addressMap['city'] as String,
        zipCode: addressMap['zipCode'] as String,
      );
    }
  }
}
