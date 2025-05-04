import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';
import 'golden_test_utils.dart';

void main() {
  group('AngleFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние', (WidgetTester tester) async {
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол',
          min: 0,
          max: 360,
        ),
        initialValue: const Angle(value: 45),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildAngleFieldWidget(field: angleField),
        goldenFileName: 'goldens/angle_field_standard.png',
      );
    });

    testWidgets('Состояние с ошибкой', (WidgetTester tester) async {
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол',
          min: 0,
          max: 90,
        ),
        initialValue: const Angle(value: 120),
      );

      // Вызываем валидацию, чтобы появилась ошибка
      angleField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildAngleFieldWidget(field: angleField),
        goldenFileName: 'goldens/angle_field_with_error.png',
      );
    });

    testWidgets('Пустое поле', (WidgetTester tester) async {
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол',
          isRequired: true,
        ),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildAngleFieldWidget(field: angleField),
        goldenFileName: 'goldens/angle_field_empty.png',
      );
    });

    testWidgets('Кастомный суффикс', (WidgetTester tester) async {
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол',
        ),
        initialValue: const Angle(value: 90),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildAngleFieldWidget(
          field: angleField,
          suffixText: 'град',
        ),
        goldenFileName: 'goldens/angle_field_custom_suffix.png',
      );
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол',
        ),
        initialValue: const Angle(value: 180),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildAngleFieldWidget(
          field: angleField,
          decoration: GoldenTestUtils.getCustomDecoration(
            labelText: 'Кастомная метка',
            hintText: 'Введите угол',
          ),
        ),
        goldenFileName: 'goldens/angle_field_custom_decoration.png',
      );
    });
  });
}
