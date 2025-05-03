import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('ScaleField', () {
    test('Создание поля с начальным значением', () {
      const scale = Scale(x: 1.5, y: 2.0);

      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
          xConfig: const NumberFieldConfig(label: 'Масштаб по X'),
          yConfig: const NumberFieldConfig(label: 'Масштаб по Y'),
        ),
        initialValue: scale,
      );

      expect(scaleField.value, equals(scale));
      expect(scaleField.xField.value, equals(scale.x));
      expect(scaleField.yField.value, equals(scale.y));
      expect(scaleField.error, isNull);
      expect(scaleField.isValid(), isTrue);
    });

    test('Установка и получение значения', () {
      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
        ),
      );

      expect(scaleField.value, isNull);

      const scale = Scale(x: 1.5, y: 2.0);

      scaleField.value = scale;

      expect(scaleField.value, equals(scale));
      expect(scaleField.xField.value, equals(scale.x));
      expect(scaleField.yField.value, equals(scale.y));
    });

    test('Валидация пользовательского валидатора', () {
      // Создаем поле с пользовательским валидатором
      String? customValidator(Scale? scale) {
        if (scale == null) return null;

        // Проверяем, что масштаб не слишком большой
        if (scale.x > 10 || scale.y > 10) {
          return 'Масштаб не должен превышать 10';
        }

        return null;
      }

      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
          validator: customValidator,
        ),
        // Сразу устанавливаем начальное значение, чтобы избежать ошибки обязательного поля
        initialValue: const Scale(x: 5, y: 5),
      );

      // Проверяем, что валидатор установлен

      // Проверяем, что начальное значение валидно
      expect(scaleField.validate(), isNull);
      expect(scaleField.error, isNull);
      expect(scaleField.isValid(), isTrue);

      // Установка невалидного значения
      scaleField.value = const Scale(x: 15, y: 5);

      // Проверяем, что значение действительно установлено

      // Явно вызываем пользовательский валидатор для проверки
      customValidator(scaleField.value);

      // Выводим отладочную информацию

      // Проверяем, что пользовательский валидатор сработал
      final validationResult = scaleField.validate();

      expect(validationResult, equals('Масштаб не должен превышать 10'));
      expect(scaleField.error, equals('Масштаб не должен превышать 10'));
      expect(scaleField.isValid(), isFalse);

      // Установка валидного значения
      scaleField.value = const Scale(x: 5, y: 5);

      // Проверяем, что валидация прошла успешно
      expect(scaleField.validate(), isNull);
      expect(scaleField.error, isNull);
      expect(scaleField.isValid(), isTrue);
    });

    test('Валидация компонентов масштаба', () {
      // Создаем поле с начальным значением, чтобы избежать ошибки обязательного поля
      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
          xConfig:
              const NumberFieldConfig(label: 'Масштаб по X', min: 0.1, max: 10),
          yConfig:
              const NumberFieldConfig(label: 'Масштаб по Y', min: 0.1, max: 10),
        ),
        initialValue: const Scale(x: 1, y: 2),
      );

      // Проверяем, что начальное значение валидно
      expect(scaleField.validate(), isNull);
      expect(scaleField.error, isNull);
      expect(scaleField.isValid(), isTrue);

      // Установка значения с невалидным x
      scaleField.xField.value = 0.05; // Меньше минимума

      expect(scaleField.validate(), contains('не меньше'));
      expect(scaleField.error, contains('не меньше'));
      expect(scaleField.isValid(), isFalse);

      // Исправление x
      scaleField.xField.value = 1;

      expect(scaleField.validate(), isNull);
      expect(scaleField.error, isNull);
      expect(scaleField.isValid(), isTrue);

      // Установка значения с невалидным y
      scaleField.yField.value = 15; // Больше максимума

      expect(scaleField.validate(), contains('не больше'));
      expect(scaleField.error, contains('не больше'));
      expect(scaleField.isValid(), isFalse);
    });

    test('Сброс значения', () {
      const scale = Scale(x: 1.5, y: 2.0);

      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
        ),
        initialValue: scale,
      );

      expect(scaleField.value, equals(scale));

      scaleField.reset();

      expect(scaleField.value, isNull);
      expect(scaleField.xField.value, isNull);
      expect(scaleField.yField.value, isNull);
      expect(scaleField.error, isNull);
    });

    test('Равномерное масштабирование', () {
      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
          uniform: true,
        ),
        initialValue: const Scale(x: 1.5, y: 1.5),
      );

      // Проверяем, что поле использует равномерное масштабирование
      expect(scaleField.isUniform, isTrue);

      // Изменяем значение x и проверяем, что y синхронизировано
      scaleField.xField.value = 2.0;
      scaleField.syncValues(true);

      expect(scaleField.xField.value, equals(2.0));
      expect(scaleField.yField.value, equals(2.0));
      expect(scaleField.value?.x, equals(2.0));
      expect(scaleField.value?.y, equals(2.0));

      // Изменяем значение y и проверяем, что x синхронизировано
      scaleField.yField.value = 3.0;
      scaleField.syncValues(false);

      expect(scaleField.xField.value, equals(3.0));
      expect(scaleField.yField.value, equals(3.0));
      expect(scaleField.value?.x, equals(3.0));
      expect(scaleField.value?.y, equals(3.0));

      // Устанавливаем равномерное значение
      scaleField.setUniformValue(4.0);

      expect(scaleField.xField.value, equals(4.0));
      expect(scaleField.yField.value, equals(4.0));
      expect(scaleField.value?.x, equals(4.0));
      expect(scaleField.value?.y, equals(4.0));
    });

    test('Неравномерное масштабирование', () {
      final scaleField = ScaleField(
        config: ScaleFieldConfig(
          label: 'Тестовый масштаб',
          uniform: false,
        ),
        initialValue: const Scale(x: 1.5, y: 2.0),
      );

      // Проверяем, что поле использует неравномерное масштабирование
      expect(scaleField.isUniform, isFalse);

      // Изменяем значение x и проверяем, что y не изменилось
      scaleField.xField.value = 3.0;
      scaleField.syncValues(true);

      expect(scaleField.xField.value, equals(3.0));
      expect(scaleField.yField.value, equals(2.0));
      expect(scaleField.value?.x, equals(3.0));
      expect(scaleField.value?.y, equals(2.0));

      // Изменяем значение y и проверяем, что x не изменилось
      scaleField.yField.value = 4.0;
      scaleField.syncValues(false);

      expect(scaleField.xField.value, equals(3.0));
      expect(scaleField.yField.value, equals(4.0));
      expect(scaleField.value?.x, equals(3.0));
      expect(scaleField.value?.y, equals(4.0));

      // Пытаемся установить равномерное значение (не должно сработать)
      scaleField.setUniformValue(5.0);

      expect(scaleField.xField.value, equals(3.0));
      expect(scaleField.yField.value, equals(4.0));
      expect(scaleField.value?.x, equals(3.0));
      expect(scaleField.value?.y, equals(4.0));
    });
  });
}
