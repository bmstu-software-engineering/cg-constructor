import 'package:forms/forms.dart';

/// Базовый класс для типизированной конфигурации формы
abstract class TypedFormConfig<T> {
  /// Название формы
  String get name;

  /// Список конфигураций полей
  List<FieldConfigEntry> get fields;

  /// Функция валидации всей формы
  String? Function(Map<String, dynamic>)? get validator => null;

  /// Преобразует типизированную конфигурацию в стандартную конфигурацию формы
  FormConfig toFormConfig() {
    return FormConfig(
      name: name,
      fields: fields,
      validator: validator,
    );
  }

  /// Создает типизированную модель формы
  TypedFormModel<T> createModel();
}

/// Базовый класс для типизированной модели формы
abstract class TypedFormModel<T> implements FormModel {
  /// Конфигурация формы
  final FormConfig config;

  /// Динамическая модель формы
  final DynamicFormModel _dynamicModel;

  /// Создает типизированную модель формы
  ///
  /// [config] - конфигурация формы
  TypedFormModel({required this.config})
      : _dynamicModel = DynamicFormModel(config: config);

  /// Получает значения формы в типизированном виде
  T get values;

  /// Устанавливает значения формы из типизированного объекта
  set values(T newValues);

  /// Преобразует значения формы в Map
  Map<String, dynamic> toMap();

  /// Устанавливает значения формы из Map
  void fromMap(Map<String, dynamic> map);

  /// Получает поле формы по ID
  V? getField<V extends FormField>(String id) {
    return _dynamicModel.getField<V>(id);
  }

  /// Получает значение поля по ID
  dynamic getValue(String id) {
    return _dynamicModel.getValue(id);
  }

  /// Получает все значения формы в виде Map
  Map<String, dynamic> getValues() {
    return _dynamicModel.getValues();
  }

  /// Устанавливает значения полей из Map
  void setValues(Map<String, dynamic> values) {
    _dynamicModel.setValues(values);
  }

  @override
  bool isValid() {
    return _dynamicModel.isValid();
  }

  @override
  void validate() {
    _dynamicModel.validate();
  }

  @override
  void reset() {
    _dynamicModel.reset();
  }

  /// Преобразует типизированную модель в динамическую модель формы
  DynamicFormModel toDynamicFormModel() {
    return _dynamicModel;
  }
}
