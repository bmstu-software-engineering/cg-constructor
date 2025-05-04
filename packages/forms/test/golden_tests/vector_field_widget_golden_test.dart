import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';
import 'golden_test_utils.dart';

void main() {
  group('VectorFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние', (WidgetTester tester) async {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Вектор',
        ),
        initialValue: const Vector(dx: 10, dy: 20),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildVectorFieldWidget(field: vectorField),
        goldenFileName: 'goldens/vector_field_standard.png',
      );
    });

    testWidgets('Состояние с ошибкой', (WidgetTester tester) async {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Вектор',
          validator: (vector) {
            if (vector != null && vector.length > 30) {
              return 'Длина вектора не должна превышать 30';
            }
            return null;
          },
        ),
        initialValue: const Vector(dx: 30, dy: 40),
      );

      // Вызываем валидацию, чтобы появилась ошибка
      vectorField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildVectorFieldWidget(field: vectorField),
        goldenFileName: 'goldens/vector_field_with_error.png',
      );
    });

    testWidgets('Пустое поле', (WidgetTester tester) async {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Вектор',
          isRequired: true,
        ),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildVectorFieldWidget(field: vectorField),
        goldenFileName: 'goldens/vector_field_empty.png',
      );
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Вектор',
        ),
        initialValue: const Vector(dx: 5, dy: 10),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildVectorFieldWidget(
          field: vectorField,
          decoration: GoldenTestUtils.getCustomDecoration(
            labelText: 'Кастомная метка',
            hintText: 'Введите координаты вектора',
          ),
        ),
        goldenFileName: 'goldens/vector_field_custom_decoration.png',
      );
    });

    testWidgets('Ограничения на значения', (WidgetTester tester) async {
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Вектор с ограничениями',
          dxConfig: NumberFieldConfig(
            label: 'X',
            min: -10,
            max: 10,
          ),
          dyConfig: NumberFieldConfig(
            label: 'Y',
            min: -10,
            max: 10,
          ),
        ),
        initialValue: const Vector(dx: 15, dy: 5),
      );

      // Вызываем валидацию, чтобы появилась ошибка
      vectorField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildVectorFieldWidget(field: vectorField),
        goldenFileName: 'goldens/vector_field_with_constraints.png',
      );
    });
  });
}
