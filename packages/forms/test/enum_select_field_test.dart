import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';

void main() {
  group('EnumSelectField', () {
    test('Создание поля с пустым списком значений', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: [],
      );
      final field = EnumSelectField<String>(config: config);

      expect(field.value, isNull);
      expect(field.config.label, equals('Выбор'));
      expect(field.config.values, isEmpty);
    });

    test('Создание поля с начальным значением', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(
        config: config,
        initialValue: 'Два',
      );

      expect(field.value, equals('Два'));
      expect(field.config.values, hasLength(3));
      expect(field.config.values, contains('Два'));
    });

    test('Установка значения', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);

      field.value = 'Три';
      expect(field.value, equals('Три'));

      field.value = null;
      expect(field.value, isNull);
    });

    test('Валидация обязательного поля', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
        isRequired: true,
      );
      final field = EnumSelectField<String>(config: config);

      // Валидация возвращает сообщение об ошибке или null
      field.validate();
      expect(field.error, isNotNull);
      expect(field.isValid(), isFalse);

      field.value = 'Один';
      field.validate();
      expect(field.error, isNull);
      expect(field.isValid(), isTrue);
    });

    test('Валидация необязательного поля', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
        isRequired: false,
      );
      final field = EnumSelectField<String>(config: config);

      // Валидация возвращает сообщение об ошибке или null
      field.validate();
      expect(field.error, isNull);
      expect(field.isValid(), isTrue);
    });

    test('Использование titleBuilder', () {
      final config = EnumSelectConfig<int>(
        label: 'Выбор',
        values: [1, 2, 3],
        titleBuilder: (value) => 'Число $value',
      );
      final field = EnumSelectField<int>(
        config: config,
        initialValue: 2,
      );

      expect(field.getTitle(1), equals('Число 1'));
      expect(field.getTitle(2), equals('Число 2'));
      expect(field.getTitle(3), equals('Число 3'));
    });

    test('Значение по умолчанию для titleBuilder', () {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(
        config: config,
        initialValue: 'Два',
      );

      expect(field.getTitle('Один'), equals('Один'));
      expect(field.getTitle('Два'), equals('Два'));
      expect(field.getTitle('Три'), equals('Три'));
    });
  });
}
