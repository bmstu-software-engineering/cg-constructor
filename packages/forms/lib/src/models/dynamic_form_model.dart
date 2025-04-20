import 'package:flutter/foundation.dart';

import '../config/field_config_entry.dart';
import '../config/field_type.dart';
import '../config/form_config.dart';
import '../config/number_config.dart';
import '../config/point_config.dart';
import '../config/angle_config.dart';
import '../config/vector_config.dart';
import '../config/scale_config.dart';
import '../config/polygon_config.dart';
import '../config/triangle_config.dart';
import '../config/rectangle_config.dart';
import '../config/list_field_config.dart';
import '../core/diagnosticable_form_model.dart';
import '../core/form_field.dart';
import '../fields/number_field.dart';
import '../fields/point_field.dart';
import '../fields/angle_field.dart';
import '../fields/vector_field.dart';
import '../fields/scale_field.dart';
import '../fields/polygon_field.dart';
import '../fields/triangle_field.dart';
import '../fields/rectangle_field.dart';
import '../fields/list_field.dart';

/// Динамическая модель формы, создаваемая на основе конфига
class DynamicFormModel extends DiagnosticableFormModel {
  /// Конфигурация формы
  final FormConfig config;

  /// Карта полей по их ID
  final Map<String, FormField> _fields = {};

  /// Создает динамическую модель формы
  ///
  /// [config] - конфигурация формы
  DynamicFormModel({required this.config}) {
    _initializeFields();
  }

  /// Инициализация полей на основе конфига
  void _initializeFields() {
    for (final fieldEntry in config.fields) {
      final field = _createField(fieldEntry);
      _fields[fieldEntry.id] = field;
    }
  }

  /// Создание поля на основе конфигурации
  FormField _createField(FieldConfigEntry entry) {
    switch (entry.type) {
      case FieldType.number:
        return NumberField(config: entry.config as NumberFieldConfig);
      case FieldType.point:
        return PointField(config: entry.config as PointFieldConfig);
      case FieldType.angle:
        return AngleField(config: entry.config as AngleFieldConfig);
      case FieldType.vector:
        return VectorField(config: entry.config as VectorFieldConfig);
      case FieldType.scale:
        return ScaleField(config: entry.config as ScaleFieldConfig);
      case FieldType.polygon:
        return PolygonField(config: entry.config as PolygonFieldConfig);
      case FieldType.triangle:
        return TriangleField(config: entry.config as TriangleFieldConfig);
      case FieldType.rectangle:
        return RectangleField(config: entry.config as RectangleFieldConfig);
      case FieldType.list:
        final listConfig = entry.config as ListFieldConfig;
        // Для списка нужно создать поле с правильным типом
        // Это упрощенная реализация, которая поддерживает только списки чисел
        return ListField<double, NumberField>(
            config: listConfig as ListFieldConfig<double>);
      default:
        throw ArgumentError('Неподдерживаемый тип поля: ${entry.type}');
    }
  }

  /// Получение поля по ID
  T? getField<T extends FormField>(String id) {
    return _fields[id] as T?;
  }

  /// Получение значения поля по ID
  dynamic getValue(String id) {
    return _fields[id]?.value;
  }

  /// Получение всех значений формы в виде Map
  Map<String, dynamic> getValues() {
    final result = <String, dynamic>{};
    for (final entry in _fields.entries) {
      result[entry.key] = entry.value.value;
    }
    return result;
  }

  /// Установка значений полей из Map
  void setValues(Map<String, dynamic> values) {
    for (final entry in values.entries) {
      final field = _fields[entry.key];
      if (field != null) {
        // Обработка списков с преобразованием типов
        if (field is ListField && entry.value is List) {
          final listField = field as ListField;
          if (listField.config is ListFieldConfig<double>) {
            // Преобразуем элементы списка в double
            final doubleList = (entry.value as List)
                .map<double>((e) => e is int ? e.toDouble() : e as double)
                .toList();
            field.value = doubleList;
          } else {
            field.value = entry.value;
          }
        } else if (field is NumberField && entry.value is int) {
          // Преобразуем int в double для NumberField
          field.value = (entry.value as int).toDouble();
        } else {
          field.value = entry.value;
        }
      }
    }
  }

  @override
  bool isValid() {
    for (final field in _fields.values) {
      if (field.validate() != null) {
        return false;
      }
    }

    // Проверка валидации всей формы
    if (config.validator != null) {
      final values = getValues();
      return config.validator!(values) == null;
    }

    return true;
  }

  @override
  void validate() {
    for (final field in _fields.values) {
      field.validate();
    }
  }

  @override
  void reset() {
    for (final field in _fields.values) {
      field.reset();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', config.name));
    properties.add(IntProperty('fieldsCount', _fields.length));

    // Добавляем свойства для каждого поля
    for (final entry in _fields.entries) {
      properties.add(DiagnosticsProperty(entry.key, entry.value));
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DynamicFormModel(name: ${config.name}, fields: ${_fields.length}, isValid: ${isValid()})';
  }
}
