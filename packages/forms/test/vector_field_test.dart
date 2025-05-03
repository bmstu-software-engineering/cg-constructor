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
      expect(vectorField.error, isNull);
      expect(vectorField.isValid(), isTrue);
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

    test('Валидация пользовательского валидатора', () {
      // Создаем поле с пользовательским валидатором
      final customValidator = (Vector? vector) {
        if (vector == null) return null;

        // Вычисляем длину вектора
        final length = math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);

        if (length < 10) {
          return 'Длина вектора должна быть не менее 10';
        }
        return null;
      };

      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          validator: customValidator,
        ),
        // Сразу устанавливаем начальное значение, чтобы избежать ошибки обязательного поля
        initialValue: const Vector(dx: 3, dy: 4),
      );

      // Проверяем, что пользовательский валидатор сработал
      expect(vectorField.validate(),
          equals('Длина вектора должна быть не менее 10'));
      expect(
          vectorField.error, equals('Длина вектора должна быть не менее 10'));
      expect(vectorField.isValid(), isFalse);

      // Установка валидного значения
      vectorField.value = const Vector(dx: 30, dy: 40);

      // Вызываем валидацию явно
      final validationResult = vectorField.validate();

      // Выводим отладочную информацию
      print('Валидация вектора (30, 40): $validationResult');
      print('Длина вектора (30, 40): ${math.sqrt(30 * 30 + 40 * 40)}');
      print('Ошибка поля: ${vectorField.error}');

      // Проверяем, что валидация прошла успешно
      expect(validationResult, isNull);
      expect(vectorField.error, isNull);
      expect(vectorField.isValid(), isTrue);
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

      // Проверяем, что начальное значение валидно
      expect(vectorField.validate(), isNull);
      expect(vectorField.error, isNull);
      expect(vectorField.isValid(), isTrue);

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

    test('Валидация вектора с нулевой длиной', () {
      const vector = Vector(dx: 0, dy: 0);

      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          validator: (vector) {
            if (vector == null) return null;
            if (vector.dx == 0 && vector.dy == 0) {
              return 'Вектор не может иметь нулевую длину';
            }
            return null;
          },
        ),
        initialValue: vector,
      );

      expect(vectorField.validate(), contains('нулевую длину'));
      expect(vectorField.error, contains('нулевую длину'));
      expect(vectorField.isValid(), isFalse);
    });
  });
}
