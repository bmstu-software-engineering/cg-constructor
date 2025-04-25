import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('LineField', () {
    test('Создание поля с начальным значением', () {
      const line = Line(
        a: Point(x: 10, y: 20),
        b: Point(x: 30, y: 40),
      );

      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          startConfig: const PointFieldConfig(
            label: 'Начало',
            xConfig: NumberFieldConfig(label: 'X'),
            yConfig: NumberFieldConfig(label: 'Y'),
          ),
          endConfig: const PointFieldConfig(
            label: 'Конец',
            xConfig: NumberFieldConfig(label: 'X'),
            yConfig: NumberFieldConfig(label: 'Y'),
          ),
        ),
        initialValue: line,
      );

      expect(lineField.value, equals(line));
      expect(lineField.startField.value, equals(line.a));
      expect(lineField.endField.value, equals(line.b));
      expect(lineField.error, isNull);
      expect(lineField.isValid(), isTrue);
    });

    test('Установка и получение значения', () {
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
        ),
      );

      expect(lineField.value, isNull);

      const line = Line(
        a: Point(x: 10, y: 20),
        b: Point(x: 30, y: 40),
      );

      lineField.value = line;

      expect(lineField.value, equals(line));
      expect(lineField.startField.value, equals(line.a));
      expect(lineField.endField.value, equals(line.b));
    });

    test('Валидация пользовательского валидатора', () {
      // Создаем поле с пользовательским валидатором
      final customValidator = (Line? line) {
        if (line == null) return null;

        // Вычисляем длину линии
        final dx = line.b.x - line.a.x;
        final dy = line.b.y - line.a.y;
        final length = math.sqrt(dx * dx + dy * dy);

        if (length < 10) {
          return 'Длина линии должна быть не менее 10';
        }
        return null;
      };

      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          validator: customValidator,
        ),
        // Сразу устанавливаем начальное значение, чтобы избежать ошибки обязательного поля
        initialValue: const Line(
          a: Point(x: 0, y: 0),
          b: Point(x: 3, y: 4),
        ),
      );

      // Проверяем, что пользовательский валидатор сработал
      expect(
          lineField.validate(), equals('Длина линии должна быть не менее 10'));
      expect(lineField.error, equals('Длина линии должна быть не менее 10'));
      expect(lineField.isValid(), isFalse);

      // Установка валидного значения
      lineField.value = const Line(
        a: Point(x: 0, y: 0),
        b: Point(x: 30, y: 40),
      );

      expect(lineField.validate(), isNull);
      expect(lineField.error, isNull);
      expect(lineField.isValid(), isTrue);
    });

    test('Валидация начальной и конечной точек', () {
      // Создаем поле с начальным значением, чтобы избежать ошибки обязательного поля
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          startConfig: const PointFieldConfig(
            label: 'Начало',
            xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
            yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
          ),
          endConfig: const PointFieldConfig(
            label: 'Конец',
            xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
            yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
          ),
        ),
        initialValue: const Line(
          a: Point(x: 10, y: 20),
          b: Point(x: 30, y: 40),
        ),
      );

      // Проверяем, что начальное значение валидно
      expect(lineField.validate(), isNull);
      expect(lineField.error, isNull);
      expect(lineField.isValid(), isTrue);

      // Установка значения с невалидной начальной точкой
      lineField.startField.xField.value = -10; // Меньше минимума

      expect(lineField.validate(), contains('не меньше'));
      expect(lineField.error, contains('не меньше'));
      expect(lineField.isValid(), isFalse);

      // Исправление начальной точки
      lineField.startField.xField.value = 10;

      expect(lineField.validate(), isNull);
      expect(lineField.error, isNull);
      expect(lineField.isValid(), isTrue);

      // Установка значения с невалидной конечной точкой
      lineField.endField.yField.value = 150; // Больше максимума

      expect(lineField.validate(), contains('не больше'));
      expect(lineField.error, contains('не больше'));
      expect(lineField.isValid(), isFalse);
    });

    test('Сброс значения', () {
      const line = Line(
        a: Point(x: 10, y: 20),
        b: Point(x: 30, y: 40),
      );

      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
        ),
        initialValue: line,
      );

      expect(lineField.value, equals(line));

      lineField.reset();

      expect(lineField.value, isNull);
      expect(lineField.startField.value, isNull);
      expect(lineField.endField.value, isNull);
      expect(lineField.error, isNull);
    });

    test('Валидация линии с совпадающими точками', () {
      const line = Line(
        a: Point(x: 10, y: 20),
        b: Point(x: 10, y: 20),
      );

      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          validator: (line) {
            if (line == null) return null;
            if (line.a.x == line.b.x && line.a.y == line.b.y) {
              return 'Начальная и конечная точки не могут совпадать';
            }
            return null;
          },
        ),
        initialValue: line,
      );

      expect(lineField.validate(), contains('не могут совпадать'));
      expect(lineField.error, contains('не могут совпадать'));
      expect(lineField.isValid(), isFalse);
    });
  });
}
