import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';

void main() {
  group('EnumSelectFieldWidget', () {
    testWidgets('Отображение поля с пустым списком значений',
        (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: [],
      );
      final field = EnumSelectField<String>(config: config);
      final widget = EnumSelectFieldWidget<String>(field: field);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text('Выбор'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.byType(DropdownMenuItem<String>), findsNothing);
    });

    testWidgets('Отображение поля со списком значений',
        (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);
      final widget = EnumSelectFieldWidget<String>(field: field);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text('Выбор'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Открываем выпадающий список
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Проверяем, что все элементы отображаются
      expect(find.text('Один'), findsOneWidget);
      expect(find.text('Два'), findsOneWidget);
      expect(find.text('Три'), findsOneWidget);
    });

    testWidgets('Выбор значения из списка', (WidgetTester tester) async {
      String? selectedValue;

      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(config: config);
      final widget = EnumSelectFieldWidget<String>(
        field: field,
        onChanged: (value) {
          selectedValue = value;
        },
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Открываем выпадающий список
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Выбираем значение "Два"
      await tester.tap(find.text('Два').last);
      await tester.pumpAndSettle();

      expect(field.value, equals('Два'));
      expect(selectedValue, equals('Два'));
    });

    testWidgets('Отображение поля с начальным значением',
        (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
      );
      final field = EnumSelectField<String>(
        config: config,
        initialValue: 'Два',
      );
      final widget = EnumSelectFieldWidget<String>(field: field);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text('Выбор'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Проверяем, что выбрано значение "Два"
      expect(field.value, equals('Два'));
    });

    testWidgets('Отображение поля с использованием titleBuilder',
        (WidgetTester tester) async {
      final config = EnumSelectConfig<int>(
        label: 'Выбор',
        values: [1, 2, 3],
        titleBuilder: (value) => 'Число $value',
      );
      final field = EnumSelectField<int>(config: config);
      final widget = EnumSelectFieldWidget<int>(field: field);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Открываем выпадающий список
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();

      // Проверяем, что отображаются правильные названия
      expect(find.text('Число 1'), findsOneWidget);
      expect(find.text('Число 2'), findsOneWidget);
      expect(find.text('Число 3'), findsOneWidget);
    });

    testWidgets('Отображение ошибки валидации', (WidgetTester tester) async {
      final config = EnumSelectConfig<String>(
        label: 'Выбор',
        values: ['Один', 'Два', 'Три'],
        isRequired: true,
      );
      final field = EnumSelectField<String>(config: config);
      final widget = EnumSelectFieldWidget<String>(field: field);

      // Валидируем поле (должна быть ошибка, т.к. значение не выбрано)
      field.validate();

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Проверяем, что отображается ошибка
      expect(find.text('Это поле обязательно'), findsOneWidget);
    });
  });
}
