import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('VectorField', () {
    test('Создание поля с начальным значением', () {
      const vector = Vector(dx: 10, dy: 20);

      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          dxConfig: const NumberFieldConfig(label: 'Смещение по X'),
          dyConfig: const NumberFieldConfig(label: 'Смещение по Y'),
        ),
        initialValue: vector,
      );

      expect(vectorField.value, equals(vector));
      expect(vectorField.dxField.value, equals(vector.dx));
      expect(vectorField.dyField.value, equals(vector.dy));
    });

    test('Установка и получение значения', () {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
        ),
      );

      expect(vectorField.value, isNull);

      const vector = Vector(dx: 10, dy: 20);

      vectorField.value = vector;

      expect(vectorField.value, equals(vector));
      expect(vectorField.dxField.value, equals(vector.dx));
      expect(vectorField.dyField.value, equals(vector.dy));
    });

    test('Валидация компонентов вектора', () {
      // Создаем поле с начальным значением, чтобы избежать ошибки обязательного поля
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          dxConfig:
              const NumberFieldConfig(label: 'Смещение по X', min: 0, max: 100),
          dyConfig:
              const NumberFieldConfig(label: 'Смещение по Y', min: 0, max: 100),
        ),
        initialValue: const Vector(dx: 10, dy: 20),
      );

      // Установка значения с невалидным dx
      vectorField.dxField.value = -10; // Меньше минимума

      expect(vectorField.validate(), contains('не меньше'));
      expect(vectorField.error, contains('не меньше'));
      expect(vectorField.isValid(), isFalse);

      // Исправление dx
      vectorField.dxField.value = 10;

      expect(vectorField.validate(), isNull);
      expect(vectorField.error, isNull);
      expect(vectorField.isValid(), isTrue);

      // Установка значения с невалидным dy
      vectorField.dyField.value = 150; // Больше максимума

      expect(vectorField.validate(), contains('не больше'));
      expect(vectorField.error, contains('не больше'));
      expect(vectorField.isValid(), isFalse);
    });

    test('Сброс значения', () {
      const vector = Vector(dx: 10, dy: 20);

      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
        ),
        initialValue: vector,
      );

      expect(vectorField.value, equals(vector));

      vectorField.reset();

      expect(vectorField.value, isNull);
      expect(vectorField.dxField.value, isNull);
      expect(vectorField.dyField.value, isNull);
      expect(vectorField.error, isNull);
    });
  });
}
