import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'golden_test_utils.dart';

void main() {
  group('StringFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние', (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
        ),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_standard.png',
      );
    });

    testWidgets('С начальным значением', (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
        ),
        initialValue: 'Тестовое значение',
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_with_value.png',
      );
    });

    testWidgets('Состояние с ошибкой минимальной длины',
        (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
          minLength: 5,
        ),
        initialValue: 'ABC',
      );

      // Вызываем валидацию, чтобы появилась ошибка
      stringField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_min_length_error.png',
      );
    });

    testWidgets('Состояние с ошибкой максимальной длины',
        (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
          maxLength: 10,
        ),
        initialValue:
            'Это очень длинный текст, который превышает максимальную длину',
      );

      // Вызываем валидацию, чтобы появилась ошибка
      stringField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_max_length_error.png',
      );
    });

    testWidgets('Состояние с ошибкой обязательного поля',
        (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
          isRequired: true,
        ),
      );

      // Вызываем валидацию, чтобы появилась ошибка
      stringField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_required_error.png',
      );
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Текстовое поле',
        ),
        initialValue: 'Тестовое значение',
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(
          field: stringField,
          decoration: GoldenTestUtils.getCustomDecoration(
            labelText: 'Кастомная метка',
            hintText: 'Введите текст',
          ),
        ),
        goldenFileName: 'goldens/string_field_custom_decoration.png',
      );
    });

    testWidgets('С кастомным валидатором', (WidgetTester tester) async {
      final stringField = StringField(
        config: StringFieldConfig(
          label: 'Email',
          validator: (value) {
            if (value == null || value.isEmpty) return null;
            if (!value.contains('@')) {
              return 'Некорректный email адрес';
            }
            return null;
          },
        ),
        initialValue: 'test',
      );

      // Вызываем валидацию, чтобы появилась ошибка
      stringField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildStringFieldWidget(field: stringField),
        goldenFileName: 'goldens/string_field_custom_validator_error.png',
      );
    });
  });
}
