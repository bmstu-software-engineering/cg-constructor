import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'golden_test_utils.dart';

void main() {
  group('EnumSelectFieldWidget Golden Tests', () {
    testWidgets('Стандартное состояние', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildEnumSelectFieldWidget(field: field),
        goldenFileName: 'goldens/enum_select_field_standard.png',
      );
    });

    testWidgets('С выбранным значением', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(
        config: config,
        initialValue: 'Два',
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildEnumSelectFieldWidget(field: field),
        goldenFileName: 'goldens/enum_select_field_with_value.png',
      );
    });

    testWidgets('Состояние с ошибкой', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
        isRequired: true,
      );
      final field = EnumSelectField<String>(config: config);

      // Вызываем валидацию, чтобы появилась ошибка
      field.validate();

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildEnumSelectFieldWidget(field: field),
        goldenFileName: 'goldens/enum_select_field_with_error.png',
      );
    });

    testWidgets('С кастомным titleBuilder', (WidgetTester tester) async {
      final config = EnumSelectConfig<int>(
        label: 'Выбор числа',
        values: [1, 2, 3],
        titleBuilder: (value) => 'Число $value',
      );
      final field = EnumSelectField<int>(
        config: config,
        initialValue: 2,
      );

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildEnumSelectFieldWidget(field: field),
        goldenFileName: 'goldens/enum_select_field_with_title_builder.png',
      );
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);

      await GoldenTestUtils.runGoldenTest(
        tester: tester,
        widget: GoldenTestUtils.buildEnumSelectFieldWidget(
          field: field,
          decoration: GoldenTestUtils.getCustomDecoration(
            labelText: 'Кастомная метка',
            hintText: 'Выберите значение',
          ),
        ),
        goldenFileName: 'goldens/enum_select_field_custom_decoration.png',
      );
    });

    testWidgets('Открытый выпадающий список', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);

      // Создаем виджет
      final widget = GoldenTestUtils.buildEnumSelectFieldWidget(field: field);

      // Отображаем виджет
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Открываем выпадающий список
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Проверяем соответствие golden файлу
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('enum_select_field_dropdown_open.png'),
      );
    });
  });
}
