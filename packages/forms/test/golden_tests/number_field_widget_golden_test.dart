import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'golden_test_utils.dart';

void main() {
  group('NumberFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние', (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
        ),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_standard.png',
      );
    });

    testWidgets('С начальным значением', (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
        ),
        initialValue: 42.5,
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_with_value.png',
      );
    });

    testWidgets('Состояние с ошибкой минимального значения',
        (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
          min: 10,
        ),
        initialValue: 5,
      );

      // Вызываем валидацию, чтобы появилась ошибка
      numberField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_min_value_error.png',
      );
    });

    testWidgets('Состояние с ошибкой максимального значения',
        (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
          max: 100,
        ),
        initialValue: 150,
      );

      // Вызываем валидацию, чтобы появилась ошибка
      numberField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_max_value_error.png',
      );
    });

    testWidgets('Состояние с ошибкой обязательного поля',
        (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
          isRequired: true,
        ),
      );

      // Вызываем валидацию, чтобы появилась ошибка
      numberField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_required_error.png',
      );
    });

    testWidgets('Состояние с ошибкой неверного формата',
        (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
        ),
      );

      // Устанавливаем неверное значение
      numberField.setFromString('abc');

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_format_error.png',
      );
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Числовое поле',
        ),
        initialValue: 42,
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(
          field: numberField,
          decoration: GoldenTestUtils.getCustomDecoration(
            labelText: 'Кастомная метка',
            hintText: 'Введите число',
          ),
        ),
        goldenFileName: 'goldens/number_field_custom_decoration.png',
      );
    });

    testWidgets('С кастомным валидатором', (WidgetTester tester) async {
      final numberField = NumberField(
        config: NumberFieldConfig(
          label: 'Оценка',
          validator: (value) {
            if (value == null) return null;
            if (value % 1 != 0) {
              return 'Оценка должна быть целым числом';
            }
            return null;
          },
        ),
        initialValue: 4.5,
      );

      // Вызываем валидацию, чтобы появилась ошибка
      numberField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildNumberFieldWidget(field: numberField),
        goldenFileName: 'goldens/number_field_custom_validator_error.png',
      );
    });
  });
}
