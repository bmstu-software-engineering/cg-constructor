import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Генератор кода для типизированных форм
class FormGenerator extends GeneratorForAnnotation<FormGenAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement && element is! EnumElement) {
      throw InvalidGenerationSourceError(
        'Аннотация @FormGen может быть применена только к классам или enum.',
        element: element,
      );
    }

    final className = element.name;
    final formName = annotation.peek('name')?.stringValue ?? className;
    final fields = _getFormFields(element);

    if (fields.isEmpty && element is! EnumElement) {
      throw InvalidGenerationSourceError(
        'Класс $className не содержит полей с аннотациями FieldGen.',
        element: element,
      );
    }

    return _generateFormCode(className, formName, fields);
  }

  /// Получает поля формы из класса или enum
  List<_FormField> _getFormFields(Element element) {
    final fields = <_FormField>[];

    if (element is ClassElement) {
      for (final field in element.fields) {
        if (field.isStatic) continue;

        final fieldGen = _getFieldGenAnnotation(field);
        if (fieldGen == null) continue;

        fields.add(_FormField(
          name: field.name,
          type: field.type.getDisplayString(withNullability: true),
          annotation: fieldGen,
        ));
      }
    } else if (element is EnumElement) {
      // Для enum добавляем специальное поле для выбора значения
      fields.add(_FormField(
        name: 'value',
        type: element.name,
        annotation: ConstantReader(null), // Пустая аннотация для enum
      ));
    }

    return fields;
  }

  /// Получает аннотацию FieldGen из поля
  ConstantReader? _getFieldGenAnnotation(FieldElement field) {
    for (final metadata in field.metadata) {
      try {
        final annotation = ConstantReader(metadata.computeConstantValue());
        final objectValue = annotation.objectValue;
        if (objectValue == null) continue;

        final annotationType = objectValue.type;
        if (annotationType == null) continue;

        final annotationTypeName =
            annotationType.getDisplayString(withNullability: false);

        // Проверяем, является ли аннотация FieldGen
        if (_isFieldGenAnnotation(annotationTypeName)) {
          return annotation;
        }

        // Проверяем, является ли аннотация FieldGen с префиксом
        final lastDotIndex = annotationTypeName.lastIndexOf('.');
        if (lastDotIndex != -1) {
          final shortName = annotationTypeName.substring(lastDotIndex + 1);
          if (_isFieldGenAnnotation(shortName)) {
            return annotation;
          }
        }
      } catch (e) {
        // Игнорируем ошибки при обработке аннотаций
        continue;
      }
    }

    return null;
  }

  /// Проверяет, является ли тип аннотацией FieldGen
  bool _isFieldGenAnnotation(String typeName) {
    // Проверяем, содержит ли тип префикс
    final lastDotIndex = typeName.lastIndexOf('.');
    final shortName =
        lastDotIndex != -1 ? typeName.substring(lastDotIndex + 1) : typeName;

    return shortName == 'NumberFieldAnnotation' ||
        shortName == 'PointFieldAnnotation' ||
        shortName == 'AngleFieldAnnotation' ||
        shortName == 'VectorFieldAnnotation' ||
        shortName == 'ScaleFieldAnnotation' ||
        shortName == 'PolygonFieldAnnotation' ||
        shortName == 'TriangleFieldAnnotation' ||
        shortName == 'RectangleFieldAnnotation' ||
        shortName == 'LineFieldAnnotation' ||
        shortName == 'ListFieldAnnotation' ||
        shortName == 'EnumSelectFieldAnnotation' ||
        // Для обратной совместимости
        shortName == 'NumberField' ||
        shortName == 'PointField' ||
        shortName == 'AngleField' ||
        shortName == 'VectorField' ||
        shortName == 'ScaleField' ||
        shortName == 'PolygonField' ||
        shortName == 'TriangleField' ||
        shortName == 'RectangleField' ||
        shortName == 'LineField' ||
        shortName == 'ListField' ||
        shortName == 'EnumSelectField';
  }

  /// Генерирует код для формы
  String _generateFormCode(
    String? className,
    String? formName,
    List<_FormField> fields,
  ) {
    // Убедимся, что className и formName не null
    final safeClassName = className ?? 'UnknownClass';
    final safeFormName = formName ?? 'Форма';
    // Проверяем, является ли класс enum
    final isEnum = fields.length == 1 && fields[0].name == 'value';
    final buffer = StringBuffer();

    // Генерируем код для конфигурации формы
    buffer.writeln('/// Типизированная конфигурация формы для $safeClassName');
    buffer.writeln(
        'class ${safeClassName}FormConfig extends TypedFormConfig<$safeClassName> {');
    buffer.writeln('  @override');
    buffer.writeln('  String get name => \'$safeFormName\';');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  List<FieldConfigEntry> get fields => [');

    // Генерируем код для полей формы
    for (final field in fields) {
      buffer.writeln('    ${_generateFieldConfigEntry(field)},');
    }

    buffer.writeln('  ];');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln(
        '  ${safeClassName}FormModel createModel() => ${safeClassName}FormModel(config: toFormConfig());');
    buffer.writeln('}');
    buffer.writeln();

    // Генерируем код для модели формы
    buffer.writeln('/// Типизированная модель формы для $safeClassName');
    buffer.writeln(
        'class ${safeClassName}FormModel extends TypedFormModel<$safeClassName> {');
    buffer.writeln('  ${safeClassName}FormModel({required super.config});');
    buffer.writeln();

    // Генерируем геттеры для полей формы
    for (final field in fields) {
      buffer.writeln('  /// Поле для ${field.name}');
      buffer.writeln(
          '  ${_getFieldType(field)} get ${field.name}Field => getField<${_getFieldType(field)}>(\'${field.name}\')!;');
    }
    buffer.writeln();

    // Генерируем геттер и сеттер для values
    buffer.writeln('  @override');
    if (isEnum) {
      // Для enum просто возвращаем значение поля value
      buffer.writeln('  $safeClassName get values => valueField.value!;');
    } else {
      // Для обычных классов создаем экземпляр класса с полями
      buffer.writeln('  $safeClassName get values => $safeClassName(');
      for (final field in fields) {
        buffer.writeln(
            '    ${field.name}: ${field.name}Field.value${field.type.endsWith('?') ? '' : '!'},');
      }
      buffer.writeln('  );');
    }
    buffer.writeln();

    buffer.writeln('  @override');
    if (isEnum) {
      // Для enum просто устанавливаем значение поля value
      buffer.writeln('  set values($safeClassName newValues) {');
      buffer.writeln('    valueField.value = newValues;');
      buffer.writeln('  }');
    } else {
      // Для обычных классов устанавливаем значения всех полей
      buffer.writeln('  set values($safeClassName newValues) {');
      for (final field in fields) {
        buffer
            .writeln('    ${field.name}Field.value = newValues.${field.name};');
      }
      buffer.writeln('  }');
    }
    buffer.writeln();

    // Генерируем методы toMap и fromMap
    buffer.writeln('  @override');
    if (isEnum) {
      // Для enum просто возвращаем значение поля value как строку
      buffer.writeln('  Map<String, dynamic> toMap() => {');
      buffer.writeln('    \'value\': valueField.value?.index,');
      buffer.writeln('  };');
    } else {
      // Для обычных классов возвращаем значения всех полей
      buffer.writeln('  Map<String, dynamic> toMap() => {');
      for (final field in fields) {
        buffer.writeln('    \'${field.name}\': ${field.name}Field.value,');
      }
      buffer.writeln('  };');
    }
    buffer.writeln();

    buffer.writeln('  @override');
    if (isEnum) {
      // Для enum устанавливаем значение поля value из индекса
      buffer.writeln('  void fromMap(Map<String, dynamic> map) {');
      buffer.writeln(
          '    if (map.containsKey(\'value\') && map[\'value\'] != null) {');
      buffer.writeln('      final index = map[\'value\'] as int;');
      buffer.writeln('      valueField.value = $safeClassName.values[index];');
      buffer.writeln('    }');
      buffer.writeln('  }');
    } else {
      // Для обычных классов устанавливаем значения всех полей
      buffer.writeln('  void fromMap(Map<String, dynamic> map) {');
      for (final field in fields) {
        final annotationType = field.annotation.objectValue?.type
            ?.getDisplayString(withNullability: false);

        if (annotationType == 'ListField' ||
            annotationType == 'ListFieldAnnotation') {
          // Для списков используем cast для безопасного приведения типов
          final elementType = _getListElementType(field.type);
          // Получаем тип элемента списка без учета nullable
          String elementTypeNonNull = elementType;
          if (elementTypeNonNull.endsWith('?')) {
            elementTypeNonNull =
                elementTypeNonNull.substring(0, elementTypeNonNull.length - 1);
          }

          // Получаем тип элемента списка без учета nullable для поля
          String elementTypeForField = elementType;
          if (field.type.startsWith('List<') && field.type.endsWith('>?')) {
            elementTypeForField =
                field.type.substring(5, field.type.length - 2);
          }

          if (field.type.endsWith('?')) {
            // Для необязательных списков
            buffer.writeln(
                '    if (map.containsKey(\'${field.name}\')) ${field.name}Field.value = (map[\'${field.name}\'] as List<dynamic>?)?.cast<$elementTypeForField>();');
          } else {
            // Для обязательных списков
            buffer.writeln(
                '    if (map.containsKey(\'${field.name}\')) ${field.name}Field.value = (map[\'${field.name}\'] as List<dynamic>).cast<$elementTypeForField>();');
          }
        } else {
          // Для остальных типов используем стандартную обработку
          buffer.writeln(
              '    if (map.containsKey(\'${field.name}\')) ${field.name}Field.value = map[\'${field.name}\'] as ${field.type};');
        }
      }
      buffer.writeln('  }');
    }
    buffer.writeln('}');

    return buffer.toString();
  }

  /// Генерирует код для конфигурации поля
  String _generateFieldConfigEntry(_FormField field) {
    // Для enum создаем специальную конфигурацию
    if (field.name == 'value') {
      return 'FieldConfigEntry(id: \'value\', type: FieldType.enumSelect, config: EnumSelectConfig<${field.type}>(label: \'Значение\', values: ${field.type}.values))';
    }

    // Проверяем, что objectValue не null
    if (field.annotation.objectValue == null) {
      return 'FieldConfigEntry(id: \'${field.name}\', type: FieldType.enumSelect, config: EnumSelectConfig<${field.type}>(label: \'${field.name.substring(0, 1).toUpperCase() + field.name.substring(1)}\', values: []))';
    }

    // Проверяем, что type не null
    if (field.annotation.objectValue!.type == null) {
      return 'FieldConfigEntry(id: \'${field.name}\', type: FieldType.enumSelect, config: EnumSelectConfig<${field.type}>(label: \'${_getLabel(field)}\', values: []))';
    }

    final annotationType = field.annotation.objectValue!.type!
        .getDisplayString(withNullability: false);
    final fieldType = _getFieldType(field);
    final fieldTypeEnum = _getFieldTypeEnum(annotationType);

    // Определяем тип конфигурации
    String configType;
    if (annotationType == 'ListField' ||
        annotationType == 'ListFieldAnnotation') {
      // Для списков используем ListFieldConfig<ElementType>
      String elementType = _getListElementType(field.type);

      // Если тип поля - List<double>?, то тип элемента - double
      if (field.type.startsWith('List<') && field.type.endsWith('>?')) {
        elementType = field.type.substring(5, field.type.length - 2);
      }

      configType = 'ListFieldConfig<$elementType>';
    } else if (annotationType == 'EnumSelectField' ||
        annotationType == 'EnumSelectFieldAnnotation') {
      // Для EnumSelectField используем EnumSelectConfig
      configType = 'EnumSelectConfig<${field.type}>';
    } else {
      // Для остальных типов используем соответствующий тип конфигурации
      configType = '${fieldType}Config';
    }

    final configParams = StringBuffer();
    configParams.write('label: \'${_getLabel(field)}\', ');

    // Добавляем специфичные параметры для разных типов полей
    switch (annotationType) {
      case 'NumberField':
      case 'NumberFieldAnnotation':
        final min = field.annotation.peek('min')?.doubleValue;
        final max = field.annotation.peek('max')?.doubleValue;
        if (min != null) configParams.write('min: $min, ');
        if (max != null) configParams.write('max: $max, ');
        break;
      case 'AngleField':
      case 'AngleFieldAnnotation':
        final min = field.annotation.peek('min')?.doubleValue;
        final max = field.annotation.peek('max')?.doubleValue;
        final normalize =
            field.annotation.peek('normalize')?.boolValue ?? false;
        if (min != null) configParams.write('min: $min, ');
        if (max != null) configParams.write('max: $max, ');
        if (normalize) configParams.write('normalize: true, ');
        break;
      case 'ScaleField':
      case 'ScaleFieldAnnotation':
        final uniform = field.annotation.peek('uniform')?.boolValue ?? false;
        if (uniform) configParams.write('uniform: true, ');
        break;
      case 'EnumSelectField':
      case 'EnumSelectFieldAnnotation':
        // Получаем список значений из аннотации или используем пустой список
        final values = field.annotation.peek('values');
        if (values != null) {
          // Если values указан в аннотации, используем его
          configParams.write('values: ${field.name}Values, ');
        } else {
          // Иначе используем пустой список
          configParams.write('values: [], ');
        }

        // Добавляем titleBuilder, если он указан
        final titleBuilder = field.annotation.peek('titleBuilder');
        if (titleBuilder != null) {
          configParams.write('titleBuilder: (value) => value.toString(), ');
        }
        break;
      case 'ListField':
      case 'ListFieldAnnotation':
        final minItems = field.annotation.peek('minItems')?.intValue;
        final maxItems = field.annotation.peek('maxItems')?.intValue;
        if (minItems != null) configParams.write('minItems: $minItems, ');
        if (maxItems != null) configParams.write('maxItems: $maxItems, ');

        // Добавляем обработку itemConfig
        final itemConfig = field.annotation.peek('itemConfig');
        if (itemConfig != null) {
          final itemConfigType = itemConfig.objectValue.type!
              .getDisplayString(withNullability: false);

          // Получаем тип элемента списка из типа поля
          final elementType = _getListElementType(field.type);

          // Генерируем функцию createItemField
          configParams.write('createItemField: () => ');

          switch (itemConfigType) {
            case 'NumberFieldAnnotation':
            case 'NumberField':
              final min = itemConfig.peek('min')?.doubleValue;
              final max = itemConfig.peek('max')?.doubleValue;
              final itemLabel =
                  itemConfig.peek('label')?.stringValue ?? 'Элемент';

              configParams.write('NumberField(');
              configParams.write('config: NumberFieldConfig(');
              configParams.write('label: \'$itemLabel\', ');
              if (min != null) configParams.write('min: $min, ');
              if (max != null) configParams.write('max: $max, ');
              configParams.write(')), ');
              break;
            case 'PointFieldAnnotation':
            case 'PointField':
              final itemLabel =
                  itemConfig.peek('label')?.stringValue ?? 'Точка';

              configParams.write('PointField(');
              configParams.write('config: PointFieldConfig(');
              configParams.write('label: \'$itemLabel\', ');
              configParams.write(')), ');
              break;
            case 'ListFieldAnnotation':
            case 'ListField':
              // Обработка вложенных списков
              final nestedMinItems = itemConfig.peek('minItems')?.intValue;
              final nestedMaxItems = itemConfig.peek('maxItems')?.intValue;
              final itemLabel =
                  itemConfig.peek('label')?.stringValue ?? 'Список';

              configParams.write(
                  'ListField<${_getListElementType(elementType)}, FormField<${_getListElementType(elementType)}>>(');
              configParams.write(
                  'config: ListFieldConfig<${_getListElementType(elementType)}>(');
              configParams.write('label: \'$itemLabel\', ');
              if (nestedMinItems != null)
                configParams.write('minItems: $nestedMinItems, ');
              if (nestedMaxItems != null)
                configParams.write('maxItems: $nestedMaxItems, ');

              // Рекурсивная обработка вложенных itemConfig
              final nestedItemConfig = itemConfig.peek('itemConfig');
              if (nestedItemConfig != null) {
                final nestedItemConfigType = nestedItemConfig.objectValue.type!
                    .getDisplayString(withNullability: false);

                configParams.write('createItemField: () => ');

                switch (nestedItemConfigType) {
                  case 'NumberFieldAnnotation':
                  case 'NumberField':
                    final min = nestedItemConfig.peek('min')?.doubleValue;
                    final max = nestedItemConfig.peek('max')?.doubleValue;
                    final nestedItemLabel =
                        nestedItemConfig.peek('label')?.stringValue ??
                            'Элемент';

                    configParams.write('NumberField(');
                    configParams.write('config: NumberFieldConfig(');
                    configParams.write('label: \'$nestedItemLabel\', ');
                    if (min != null) configParams.write('min: $min, ');
                    if (max != null) configParams.write('max: $max, ');
                    configParams.write(')), ');
                    break;
                  default:
                    configParams.write(
                        'NumberField(config: NumberFieldConfig(label: \'Элемент\')), ');
                }
              } else {
                configParams.write(
                    'createItemField: () => NumberField(config: NumberFieldConfig(label: \'Элемент\')), ');
              }

              configParams.write(')), ');
              break;
            default:
              configParams.write(
                  'NumberField(config: NumberFieldConfig(label: \'Элемент\')), ');
          }
        } else {
          // Если itemConfig не указан, создаем базовое поле
          final elementType = _getListElementType(field.type);
          // Если тип элемента - double, используем NumberField
          if (elementType == 'double') {
            configParams.write(
                'createItemField: () => NumberField(config: NumberFieldConfig(label: \'Элемент\')), ');
          } else if (elementType == 'Point') {
            configParams.write(
                'createItemField: () => PointField(config: PointFieldConfig(label: \'Точка\')), ');
          } else {
            // Для других типов используем NumberField с преобразованием
            configParams.write(
                'createItemField: () => NumberField(config: NumberFieldConfig(label: \'Элемент\')), ');
          }
        }
        break;
      // Другие типы полей можно добавить по аналогии
    }

    final isRequired = field.annotation.peek('isRequired')?.boolValue ?? true;
    if (!isRequired) configParams.write('isRequired: false, ');

    return 'FieldConfigEntry(id: \'${field.name}\', type: FieldType.$fieldTypeEnum, config: $configType($configParams))';
  }

  /// Получает метку поля
  String _getLabel(_FormField field) {
    // Если аннотация null, возвращаем имя поля с большой буквы
    if (field.annotation.objectValue == null) {
      return field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
    }

    final label = field.annotation.peek('label')?.stringValue;
    if (label != null) return label;

    // Преобразуем имя поля в метку (например, userName -> User Name)
    final name = field.name;
    final result = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      if (i == 0) {
        result.write(name[i].toUpperCase());
      } else if (name[i].toUpperCase() == name[i]) {
        result.write(' ${name[i]}');
      } else {
        result.write(name[i]);
      }
    }
    return result.toString();
  }

  /// Получает тип элемента списка из типа поля
  String _getListElementType(String listType) {
    // Извлекаем тип элемента из List<ElementType>
    if (listType.startsWith('List<') && listType.endsWith('>')) {
      return listType.substring(5, listType.length - 1);
    }
    return 'dynamic';
  }

  /// Получает тип элемента списка для приведения типов в fromMap
  String _getListElementTypeForCast(String listType) {
    final elementType = _getListElementType(listType);
    if (elementType.endsWith('?')) {
      return elementType;
    }
    return elementType;
  }

  /// Получает тип поля формы
  String _getFieldType(_FormField field) {
    // Для enum возвращаем EnumSelectField
    if (field.name == 'value') {
      return 'EnumSelectField<${field.type}>';
    }

    final annotationType = field.annotation.objectValue?.type
        ?.getDisplayString(withNullability: false);
    if (annotationType == null) {
      return 'EnumSelectField<${field.type}>';
    }
    switch (annotationType) {
      case 'NumberField':
      case 'NumberFieldAnnotation':
        return 'NumberField';
      case 'PointField':
      case 'PointFieldAnnotation':
        return 'PointField';
      case 'AngleField':
      case 'AngleFieldAnnotation':
        return 'AngleField';
      case 'VectorField':
      case 'VectorFieldAnnotation':
        return 'VectorField';
      case 'ScaleField':
      case 'ScaleFieldAnnotation':
        return 'ScaleField';
      case 'PolygonField':
      case 'PolygonFieldAnnotation':
        return 'PolygonField';
      case 'TriangleField':
      case 'TriangleFieldAnnotation':
        return 'TriangleField';
      case 'RectangleField':
      case 'RectangleFieldAnnotation':
        return 'RectangleField';
      case 'LineField':
      case 'LineFieldAnnotation':
        return 'LineField';
      case 'EnumSelectField':
      case 'EnumSelectFieldAnnotation':
        return 'EnumSelectField';
      case 'ListField':
      case 'ListFieldAnnotation':
        // Получаем тип элемента списка
        String elementType = _getListElementType(field.type);

        // Если тип поля - List<double>?, то тип элемента - double
        if (field.type.startsWith('List<') && field.type.endsWith('>?')) {
          elementType = field.type.substring(5, field.type.length - 2);
        }

        // Определяем тип поля для элемента списка
        String itemFieldType;
        final itemConfig = field.annotation.peek('itemConfig');
        if (itemConfig != null) {
          final itemConfigType = itemConfig.objectValue.type!
              .getDisplayString(withNullability: false);

          // Для всех типов используем FormField<T>
          itemFieldType = 'FormField<$elementType>';
        } else {
          // Для всех типов используем FormField<T>
          itemFieldType = 'FormField<$elementType>';
        }

        return 'ListField<$elementType, $itemFieldType>';
      default:
        throw InvalidGenerationSourceError(
          'Неподдерживаемый тип аннотации: $annotationType',
        );
    }
  }

  /// Получает тип поля для перечисления FieldType
  String _getFieldTypeEnum(String annotationType) {
    if (annotationType.isEmpty) {
      return 'enumSelect';
    }
    switch (annotationType) {
      case 'NumberField':
      case 'NumberFieldAnnotation':
        return 'number';
      case 'PointField':
      case 'PointFieldAnnotation':
        return 'point';
      case 'AngleField':
      case 'AngleFieldAnnotation':
        return 'angle';
      case 'VectorField':
      case 'VectorFieldAnnotation':
        return 'vector';
      case 'ScaleField':
      case 'ScaleFieldAnnotation':
        return 'scale';
      case 'PolygonField':
      case 'PolygonFieldAnnotation':
        return 'polygon';
      case 'TriangleField':
      case 'TriangleFieldAnnotation':
        return 'triangle';
      case 'RectangleField':
      case 'RectangleFieldAnnotation':
        return 'rectangle';
      case 'LineField':
      case 'LineFieldAnnotation':
        return 'line';
      case 'EnumSelectField':
      case 'EnumSelectFieldAnnotation':
        return 'enumSelect';
      case 'ListField':
      case 'ListFieldAnnotation':
        return 'list';
      default:
        throw InvalidGenerationSourceError(
          'Неподдерживаемый тип аннотации: $annotationType',
        );
    }
  }
}

/// Вспомогательный класс для хранения информации о поле формы
class _FormField {
  final String name;
  final String type;
  final ConstantReader annotation;

  _FormField({
    required this.name,
    required this.type,
    required this.annotation,
  });
}
