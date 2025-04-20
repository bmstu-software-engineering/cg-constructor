import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

import 'package:forms/forms.dart';

void main() {
  group('Validators', () {
    test('required validator', () {
      expect(Validators.required(null), 'Это поле обязательно');
      expect(Validators.required(''), 'Это поле обязательно');
      expect(Validators.required('value'), null);
      expect(Validators.required(0), null);
    });

    test('range validator', () {
      final rangeValidator = Validators.range(0, 10);
      expect(rangeValidator(null), null);
      expect(rangeValidator(-1), 'Значение должно быть не меньше 0');
      expect(rangeValidator(11), 'Значение должно быть не больше 10');
      expect(rangeValidator(5), null);
    });

    test('colorHex validator', () {
      expect(Validators.colorHex(null), null);
      expect(
        Validators.colorHex('#12345'),
        'Неверный формат цвета (должен быть #RRGGBB)',
      );
      expect(
        Validators.colorHex('12345'),
        'Неверный формат цвета (должен быть #RRGGBB)',
      );
      expect(
        Validators.colorHex('#1234567'),
        'Неверный формат цвета (должен быть #RRGGBB)',
      );
      expect(
        Validators.colorHex('#GGHHII'),
        'Неверный формат цвета (должен быть #RRGGBB)',
      );
      expect(Validators.colorHex('#123456'), null);
      expect(Validators.colorHex('#abcdef'), null);
    });
  });

  group('BaseFormField', () {
    test('initialization', () {
      final field = BaseFormField<String>();
      expect(field.value, null);
      expect(field.error, null);
    });

    test('validation', () {
      final field = BaseFormField<String>(
        isRequired: true,
        validator: (value) => value == 'invalid' ? 'Invalid value' : null,
      );

      expect(field.validate(), 'Это поле обязательно');

      field.value = 'invalid';
      expect(field.validate(), 'Invalid value');

      field.value = 'valid';
      expect(field.validate(), null);
    });

    test('reset', () {
      final field = BaseFormField<String>(initialValue: 'initial');
      expect(field.value, 'initial');

      field.value = 'changed';
      expect(field.value, 'changed');

      field.reset();
      expect(field.value, null);
    });
  });

  group('NumberField', () {
    test('initialization', () {
      final config = NumberFieldConfig(label: 'Number', min: 0, max: 10);
      final field = NumberField(config: config, initialValue: 5);

      expect(field.value, 5);
      expect(field.error, null);
    });

    test('validation', () {
      final config = NumberFieldConfig(label: 'Number', min: 0, max: 10);
      final field = NumberField(config: config);

      field.value = -1;
      expect(field.validate(), 'Значение должно быть не меньше 0');

      field.value = 11;
      expect(field.validate(), 'Значение должно быть не больше 10');

      field.value = 5;
      expect(field.validate(), null);
    });

    test('setFromString', () {
      final config = NumberFieldConfig(label: 'Number');
      final field = NumberField(config: config);

      field.setFromString('123.45');
      expect(field.value, 123.45);

      field.setFromString('invalid');
      expect(field.value, null);
      expect(field.error, 'Неверный формат числа');
    });
  });

  group('Angle', () {
    test('initialization', () {
      final angle = Angle(value: 45);
      expect(angle.value, 45);
    });

    test('normalize', () {
      expect(Angle(value: 370).normalize().value, 10);
      expect(Angle(value: -30).normalize().value, 330);
    });

    test('toRadians', () {
      final angle = Angle(value: 180);
      expect(angle.toRadians(), closeTo(3.14159, 0.00001));
    });

    test('fromRadians', () {
      final angle = Angle.fromRadians(3.14159);
      expect(
        angle.value,
        closeTo(180, 0.01),
      ); // Увеличиваем допустимую погрешность
    });
  });

  group('Vector', () {
    test('initialization', () {
      final vector = Vector(dx: 3, dy: 4);
      expect(vector.dx, 3);
      expect(vector.dy, 4);
    });

    test('length', () {
      final vector = Vector(dx: 3, dy: 4);
      expect(vector.length, 5);
    });

    test('normalized', () {
      final vector = Vector(dx: 3, dy: 4);
      final normalized = vector.normalized;
      expect(normalized.dx, closeTo(0.6, 0.00001));
      expect(normalized.dy, closeTo(0.8, 0.00001));
    });

    test('operators', () {
      final v1 = Vector(dx: 1, dy: 2);
      final v2 = Vector(dx: 3, dy: 4);

      final sum = v1 + v2;
      expect(sum.dx, 4);
      expect(sum.dy, 6);

      final diff = v2 - v1;
      expect(diff.dx, 2);
      expect(diff.dy, 2);

      final scaled = v1 * 2;
      expect(scaled.dx, 2);
      expect(scaled.dy, 4);

      final divided = v2 / 2;
      expect(divided.dx, 1.5);
      expect(divided.dy, 2);
    });
  });

  group('Scale', () {
    test('initialization', () {
      final scale = Scale(x: 2, y: 3);
      expect(scale.x, 2);
      expect(scale.y, 3);
    });

    test('uniform', () {
      final scale = Scale.uniform(2);
      expect(scale.x, 2);
      expect(scale.y, 2);
      expect(scale.isUniform, true);
    });

    test('validation', () {
      expect(
        Scale(x: 0, y: 1).validate(),
        'Коэффициент масштабирования по X не может быть равен 0',
      );
      expect(
        Scale(x: 1, y: 0).validate(),
        'Коэффициент масштабирования по Y не может быть равен 0',
      );
      expect(Scale(x: 1, y: 1).validate(), null);
    });

    test('operators', () {
      final s1 = Scale(x: 2, y: 3);
      final s2 = Scale(x: 4, y: 5);

      final product = s1 * s2;
      expect(product.x, 8);
      expect(product.y, 15);

      final quotient = s2 / s1;
      expect(quotient.x, 2);
      expect(quotient.y, closeTo(1.6667, 0.0001));

      final inverted = s1.inverted;
      expect(inverted.x, 0.5);
      expect(inverted.y, closeTo(0.3333, 0.0001));
    });
  });
}
