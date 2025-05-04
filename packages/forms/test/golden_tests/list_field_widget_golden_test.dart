import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:forms/src/core/form_field.dart' as forms;
import 'package:models_ns/models_ns.dart';
import 'golden_test_utils.dart';

void main() {
  group('ListFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние с числовыми полями',
        (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список чисел',
          minItems: 2,
          maxItems: 5,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
        ),
        initialValue: [10, 20],
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_standard.png',
      );
    });

    testWidgets('Пустой список с кнопкой добавления',
        (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Пустой список',
          minItems: 0,
          maxItems: 5,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
        ),
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          addButtonLabel: 'Добавить число',
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_empty.png',
      );
    });

    testWidgets('Список с ошибкой валидации', (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список с ошибкой',
          minItems: 2,
          maxItems: 5,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
          validator: (values) {
            if (values == null) return null;
            double sum = 0;
            for (final value in values) {
              sum += value;
            }
            if (sum > 100) {
              return 'Сумма всех чисел не должна превышать 100';
            }
            return null;
          },
        ),
        initialValue: [60, 50],
      );

      // Вызываем валидацию, чтобы появилась ошибка
      listField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_with_error.png',
      );
    });

    testWidgets('Список с ошибкой в элементе', (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список с ошибкой в элементе',
          minItems: 2,
          maxItems: 5,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 10, max: 100),
          ),
        ),
        initialValue: [5, 20],
      );

      // Вызываем валидацию, чтобы появилась ошибка
      listField.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_with_item_error.png',
      );
    });

    testWidgets('Список с кастомными метками элементов',
        (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список с кастомными метками',
          minItems: 3,
          maxItems: 5,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
        ),
        initialValue: [10, 20, 30],
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          itemLabelBuilder: (index) => 'Число #${index + 1}',
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_custom_labels.png',
      );
    });

    testWidgets('Список с векторными полями', (WidgetTester tester) async {
      final listField = ListField<Vector, VectorField>(
        config: ListFieldConfig<Vector>(
          label: 'Список векторов',
          minItems: 2,
          maxItems: 3,
          createItemField: () => VectorField(
            config: VectorFieldConfig(
              label: 'Вектор',
              dxConfig: NumberFieldConfig(label: 'X'),
              dyConfig: NumberFieldConfig(label: 'Y'),
            ),
          ),
        ),
        initialValue: [
          const Vector(dx: 10, dy: 20),
          const Vector(dx: 30, dy: 40),
        ],
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<Vector, VectorField>(
          field: listField,
          addButtonLabel: 'Добавить вектор',
          removeButtonTooltip: 'Удалить вектор',
          itemBuilder: (context, field, onChanged) {
            return VectorFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_vector_items.png',
      );
    });

    testWidgets('Список с максимальным количеством элементов',
        (WidgetTester tester) async {
      final listField = ListField<double, NumberField>(
        config: ListFieldConfig<double>(
          label: 'Список с максимумом элементов',
          minItems: 1,
          maxItems: 3,
          createItemField: () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
        ),
        initialValue: [10, 20, 30],
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildListFieldWidget<double, NumberField>(
          field: listField,
          addButtonLabel: 'Добавить число',
          itemBuilder: (context, field, onChanged) {
            return NumberFieldWidget(field: field, onChanged: onChanged);
          },
        ),
        goldenFileName: 'goldens/list_field_max_items.png',
      );
    });
  });
}
