import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';

void main() {
  group('Diagnostics Tests', () {
    test('Angle diagnostics', () {
      final angle = Angle(value: 45);

      // Создаем DiagnosticPropertiesBuilder для проверки свойств
      final builder = DiagnosticPropertiesBuilder();
      angle.debugFillProperties(builder);

      // Получаем список свойств
      final properties = builder.properties;

      // Проверяем, что свойства содержат ожидаемые значения
      expect(properties.any((p) => p.name == 'value' && p.value == 45), isTrue);
      expect(properties.any((p) => p.name == 'radians'), isTrue);
      expect(properties.any((p) => p.name == 'normalized'), isTrue);

      // Проверяем, что toString возвращает ожидаемое значение
      expect(angle.toString(), 'Angle(value: 45.0°)');
    });

    test('Vector diagnostics', () {
      final vector = Vector(dx: 3, dy: 4);

      final builder = DiagnosticPropertiesBuilder();
      vector.debugFillProperties(builder);

      final properties = builder.properties;

      expect(properties.any((p) => p.name == 'dx' && p.value == 3), isTrue);
      expect(properties.any((p) => p.name == 'dy' && p.value == 4), isTrue);
      expect(properties.any((p) => p.name == 'length' && p.value == 5), isTrue);

      expect(vector.toString(), 'Vector(dx: 3.0, dy: 4.0)');
    });

    test('Scale diagnostics', () {
      final scale = Scale(x: 2, y: 3);

      final builder = DiagnosticPropertiesBuilder();
      scale.debugFillProperties(builder);

      final properties = builder.properties;

      expect(properties.any((p) => p.name == 'x' && p.value == 2), isTrue);
      expect(properties.any((p) => p.name == 'y' && p.value == 3), isTrue);
      expect(
        properties.any((p) => p.name == 'isUniform' && p.value == false),
        isTrue,
      );

      expect(scale.toString(), 'Scale(x: 2.0, y: 3.0)');
    });

    test('DiagnosticableFormField diagnostics', () {
      // Создаем тестовое поле, наследующееся от DiagnosticableFormField
      final field = NumberField(
        config: NumberFieldConfig(label: 'Test', min: 0, max: 100),
      );

      field.value = 42;

      final builder = DiagnosticPropertiesBuilder();
      field.debugFillProperties(builder);

      final properties = builder.properties;

      expect(properties.any((p) => p.name == 'value' && p.value == 42), isTrue);
      expect(
        properties.any((p) => p.name == 'error' && p.value == null),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );
      expect(
        properties.any((p) => p.name == 'hasValue' && p.value == true),
        isTrue,
      );
    });

    test('DiagnosticableFormModel diagnostics', () {
      // Создаем тестовую модель формы
      final model = TestFormModel();

      final builder = DiagnosticPropertiesBuilder();
      model.debugFillProperties(builder);

      final properties = builder.properties;

      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );
      expect(properties.any((p) => p.name == 'field1'), isTrue);
      expect(properties.any((p) => p.name == 'field2'), isTrue);
    });

    test('Widget diagnostics integration', () {
      // Создаем тестовое поле
      final field = NumberField(
        config: NumberFieldConfig(label: 'Test', min: 0, max: 100),
      );

      field.value = 42;

      // Создаем виджет
      final widget = NumberFieldWidget(field: field);

      // Проверяем, что виджет корректно отображает значение поля
      expect(widget.field.value, 42);

      // Проверяем, что поле в виджете имеет корректные диагностические свойства
      final builder = DiagnosticPropertiesBuilder();
      widget.field.debugFillProperties(builder);

      final properties = builder.properties;

      expect(properties.any((p) => p.name == 'value' && p.value == 42), isTrue);
      expect(
        properties.any((p) => p.name == 'isValid' && p.value == true),
        isTrue,
      );
    });
  });
}

// Тестовая модель формы для проверки DiagnosticableFormModel
class TestFormModel extends DiagnosticableFormModel {
  final field1 = NumberField(
    config: NumberFieldConfig(
        label: 'Field 1', min: 0, max: 100, isRequired: false),
  );

  final field2 = NumberField(
    config: NumberFieldConfig(
        label: 'Field 2', min: 0, max: 100, isRequired: false),
  );

  @override
  bool isValid() {
    return field1.isValid() && field2.isValid();
  }

  @override
  void validate() {
    field1.validate();
    field2.validate();
  }

  @override
  void reset() {
    field1.reset();
    field2.reset();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NumberField>('field1', field1));
    properties.add(DiagnosticsProperty<NumberField>('field2', field2));
  }
}
