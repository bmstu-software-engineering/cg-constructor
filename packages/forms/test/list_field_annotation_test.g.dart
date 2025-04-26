// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_field_annotation_test.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

/// Типизированная конфигурация формы для NumberListForm
class NumberListFormFormConfig extends TypedFormConfig<NumberListForm> {
  @override
  String get name => 'Форма со списком чисел';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'numbers',
            type: FieldType.list,
            config: ListFieldConfig<double>(
              label: 'Список чисел',
              minItems: 1,
              maxItems: 5,
              createItemField: () => NumberField(
                  config: NumberFieldConfig(
                label: 'Число',
                min: 0.0,
                max: 100.0,
              )),
            )),
      ];

  @override
  NumberListFormFormModel createModel() =>
      NumberListFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для NumberListForm
class NumberListFormFormModel extends TypedFormModel<NumberListForm> {
  NumberListFormFormModel({required super.config});

  /// Поле для numbers
  ListField get numbersField => getField<ListField>('numbers')!;

  @override
  NumberListForm get values => NumberListForm(
        numbers: (numbersField.value as List<dynamic>?)?.cast<double>() ?? [],
      );

  @override
  set values(NumberListForm newValues) {
    numbersField.value = newValues.numbers;
  }

  @override
  Map<String, dynamic> toMap() => {
        'numbers': numbersField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('numbers'))
      numbersField.value = (map['numbers'] as List<dynamic>).cast<double>();
  }
}

/// Типизированная конфигурация формы для PointListForm
class PointListFormFormConfig extends TypedFormConfig<PointListForm> {
  @override
  String get name => 'Форма со списком точек';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'points',
            type: FieldType.list,
            config: ListFieldConfig<Point>(
              label: 'Список точек',
              minItems: 2,
              maxItems: 10,
              createItemField: () => PointField(
                  config: PointFieldConfig(
                label: 'Точка',
              )),
            )),
      ];

  @override
  PointListFormFormModel createModel() =>
      PointListFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для PointListForm
class PointListFormFormModel extends TypedFormModel<PointListForm> {
  PointListFormFormModel({required super.config});

  /// Поле для points
  ListField get pointsField => getField<ListField>('points')!;

  @override
  PointListForm get values => PointListForm(
        points: (pointsField.value as List<dynamic>?)?.cast<Point>() ?? [],
      );

  @override
  set values(PointListForm newValues) {
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

/// Типизированная конфигурация формы для SimpleListForm
class SimpleListFormFormConfig extends TypedFormConfig<SimpleListForm> {
  @override
  String get name => 'Форма с простым списком';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'simpleList',
            type: FieldType.list,
            config: ListFieldConfig<double>(
              label: 'Простой список',
              createItemField: () => NumberField(
                  config: NumberFieldConfig(
                label: 'Элемент',
              )),
            )),
      ];

  @override
  SimpleListFormFormModel createModel() =>
      SimpleListFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для SimpleListForm
class SimpleListFormFormModel extends TypedFormModel<SimpleListForm> {
  SimpleListFormFormModel({required super.config});

  /// Поле для simpleList
  ListField get simpleListField => getField<ListField>('simpleList')!;

  @override
  SimpleListForm get values => SimpleListForm(
        simpleList:
            (simpleListField.value as List<dynamic>?)?.cast<double>() ?? [],
      );

  @override
  set values(SimpleListForm newValues) {
    simpleListField.value = newValues.simpleList;
  }

  @override
  Map<String, dynamic> toMap() => {
        'simpleList': simpleListField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('simpleList'))
      simpleListField.value =
          (map['simpleList'] as List<dynamic>).cast<double>();
  }
}

/// Типизированная конфигурация формы для OptionalListForm
class OptionalListFormFormConfig extends TypedFormConfig<OptionalListForm> {
  @override
  String get name => 'Форма с необязательным списком';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'optionalList',
            type: FieldType.list,
            config: ListFieldConfig<double>(
              label: 'Необязательный список',
              createItemField: () => NumberField(
                  config: NumberFieldConfig(
                label: 'Число',
                min: 0.0,
                max: 100.0,
              )),
              isRequired: false,
            )),
      ];

  @override
  OptionalListFormFormModel createModel() =>
      OptionalListFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для OptionalListForm
class OptionalListFormFormModel extends TypedFormModel<OptionalListForm> {
  OptionalListFormFormModel({required super.config});

  /// Поле для optionalList
  ListField get optionalListField => getField<ListField>('optionalList')!;

  @override
  OptionalListForm get values => OptionalListForm(
        optionalList:
            (optionalListField.value as List<dynamic>?)?.cast<double>(),
      );

  @override
  set values(OptionalListForm newValues) {
    optionalListField.value = newValues.optionalList;
  }

  @override
  Map<String, dynamic> toMap() => {
        'optionalList': optionalListField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('optionalList'))
      optionalListField.value =
          (map['optionalList'] as List<dynamic>?)?.cast<double>();
  }
}

/// Типизированная конфигурация формы для NestedListForm
class NestedListFormFormConfig extends TypedFormConfig<NestedListForm> {
  @override
  String get name => 'Форма с вложенными списками';

  @override
  List<FieldConfigEntry> get fields => [
        FieldConfigEntry(
            id: 'nestedList',
            type: FieldType.list,
            config: ListFieldConfig<List<double>>(
              label: 'Вложенный список',
              minItems: 1,
              maxItems: 3,
              createItemField: () => ListField<double, NumberField>(
                  config: ListFieldConfig<double>(
                label: 'Внутренний список',
                minItems: 2,
                maxItems: 4,
                createItemField: () => NumberField(
                    config: NumberFieldConfig(
                  label: 'Число',
                  min: 0.0,
                  max: 100.0,
                )),
              )),
            )),
      ];

  @override
  NestedListFormFormModel createModel() =>
      NestedListFormFormModel(config: toFormConfig());
}

/// Типизированная модель формы для NestedListForm
class NestedListFormFormModel extends TypedFormModel<NestedListForm> {
  NestedListFormFormModel({required super.config});

  /// Поле для nestedList
  ListField get nestedListField => getField<ListField>('nestedList')!;

  @override
  NestedListForm get values => NestedListForm(
        nestedList: (nestedListField.value as List<dynamic>?)
                ?.map((item) => (item as List<dynamic>).cast<double>())
                .toList() ??
            [],
      );

  @override
  set values(NestedListForm newValues) {
    nestedListField.value = newValues.nestedList;
  }

  @override
  Map<String, dynamic> toMap() => {
        'nestedList': nestedListField.value,
      };

  @override
  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nestedList'))
      nestedListField.value = (map['nestedList'] as List<dynamic>)
          .map((item) => (item as List<dynamic>).cast<double>())
          .toList();
  }
}
