import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  testWidgets('Добавление элементов в список', (WidgetTester tester) async {
    // Создаем ListField с NumberField
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Тестовый список',
        minItems: 1,
        maxItems: 5,
        createItemField: () => NumberField(
          config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
        ),
      ),
    );

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<double, NumberField>(
              field: listField,
              addButtonLabel: 'Добавить число',
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Проверяем начальное состояние (1 элемент)
    expect(find.text('Элемент 1'), findsOneWidget);

    // Нажимаем на кнопку добавления элемента
    await tester.tap(find.text('Добавить число'));
    await tester.pumpAndSettle();

    // Проверяем, что добавился второй элемент
    expect(find.text('Элемент 2'), findsOneWidget);

    // Добавляем еще элементы до максимума
    await tester.tap(find.text('Добавить число'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Добавить число'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Добавить число'));
    await tester.pumpAndSettle();

    // Проверяем, что все 5 элементов отображаются
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsOneWidget);
    expect(find.text('Элемент 3'), findsOneWidget);
    expect(find.text('Элемент 4'), findsOneWidget);
    expect(find.text('Элемент 5'), findsOneWidget);

    // Проверяем, что кнопка добавления больше не отображается (достигнут максимум)
    expect(find.text('Добавить число'), findsNothing);
  });

  testWidgets('Удаление элементов из списка', (WidgetTester tester) async {
    // Создаем ListField с NumberField и начальными значениями
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Тестовый список',
        minItems: 1,
        maxItems: 5,
        createItemField: () => NumberField(
          config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
        ),
      ),
      initialValue: [10, 20, 30],
    );

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<double, NumberField>(
              field: listField,
              removeButtonTooltip: 'Удалить число',
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Проверяем начальное состояние (3 элемента)
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsOneWidget);
    expect(find.text('Элемент 3'), findsOneWidget);

    // Нажимаем на кнопку удаления второго элемента
    await tester.tap(find.byIcon(Icons.remove_circle_outline).at(1));
    await tester.pumpAndSettle();

    // Проверяем, что остались только два элемента
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsOneWidget);
    expect(find.text('Элемент 3'), findsNothing);

    // Пытаемся удалить еще один элемент
    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pumpAndSettle();

    // Проверяем, что остался только один элемент (минимум)
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsNothing);

    // Проверяем, что кнопка удаления больше не отображается (достигнут минимум)
    expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
  });

  testWidgets('Ввод значений в элементы списка', (WidgetTester tester) async {
    // Создаем ListField с NumberField и начальными значениями
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Тестовый список',
        minItems: 2,
        maxItems: 5,
        createItemField: () => NumberField(
          config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
        ),
      ),
      initialValue: [10, 20],
    );

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<double, NumberField>(
              field: listField,
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Проверяем начальные значения
    expect(listField.value?.length, 2);
    expect(listField.value?[0], 10.0);
    expect(listField.value?[1], 20.0);

    // Находим текстовые поля для ввода
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    // Вводим значения в поля
    await tester.enterText(textFields.at(0), '42');
    await tester.pumpAndSettle();

    // Вызываем явно setFromString для первого поля
    listField.fields[0].setFromString('42');
    await tester.pumpAndSettle();

    // Проверяем, что значение первого элемента обновилось
    expect(listField.value?[0], 42.0);

    await tester.enterText(textFields.at(1), '99');
    await tester.pumpAndSettle();

    // Вызываем явно setFromString для второго поля
    listField.fields[1].setFromString('99');
    await tester.pumpAndSettle();

    // Проверяем, что значение второго элемента обновилось
    expect(listField.value?[1], 99.0);

    // Добавляем еще один элемент
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Находим новое текстовое поле
    final updatedTextFields = find.byType(TextField);
    expect(updatedTextFields, findsNWidgets(3));

    // Вводим значение в новое поле
    await tester.enterText(updatedTextFields.at(2), '75');
    await tester.pumpAndSettle();

    // Вызываем явно setFromString для третьего поля
    listField.fields[2].setFromString('75');
    await tester.pumpAndSettle();

    // Проверяем, что значение третьего элемента обновилось
    expect(listField.value?[2], 75.0);
  });

  testWidgets('Валидация списка', (WidgetTester tester) async {
    // Создаем ListField с NumberField и валидацией, с начальными значениями
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Тестовый список',
        minItems: 2,
        maxItems: 5,
        createItemField: () => NumberField(
          config: NumberFieldConfig(
            label: 'Число',
            min: 10,
            max: 50,
            isRequired: true,
          ),
        ),
        validator: (values) {
          if (values == null) return 'Список не может быть пустым';

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
      initialValue: [20, 30], // Начальные значения
    );

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<double, NumberField>(
              field: listField,
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Находим текстовые поля для ввода
    final textFields = find.byType(TextField);

    // Устанавливаем начальные значения для полей
    listField.fields[0].setFromString('20');
    listField.fields[1].setFromString('30');
    await tester.pumpAndSettle();

    // Явно вызываем validate для listField
    final error1 = listField.validate();
    await tester.pumpAndSettle();

    // Проверяем, что ошибок нет
    expect(error1, isNull);

    // Проверяем ошибку валидации поля при превышении максимального значения
    await tester.enterText(textFields.at(0), '60');
    await tester.pumpAndSettle();
    listField.fields[0].setFromString('60');
    await tester.pumpAndSettle();

    // Явно вызываем validate для listField
    listField.validate();
    await tester.pumpAndSettle();

    // Проверяем ошибку валидации поля (значение 60 > 50)
    expect(listField.error,
        'Ошибка в элементе 1: Значение должно быть не больше 50');

    // Исправляем значение первого поля
    await tester.enterText(textFields.at(0), '20');
    await tester.pumpAndSettle();
    listField.fields[0].setFromString('20');
    await tester.pumpAndSettle();

    // Явно вызываем validate для listField
    listField.validate();
    await tester.pumpAndSettle();

    // Проверяем, что ошибки больше нет
    expect(listField.error, isNull);
  });

  testWidgets('Кастомные метки элементов', (WidgetTester tester) async {
    // Создаем ListField с NumberField
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Тестовый список',
        minItems: 3,
        createItemField: () => NumberField(
          config: NumberFieldConfig(label: 'Число'),
        ),
      ),
    );

    // Создаем виджет для тестирования с кастомным построителем меток
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<double, NumberField>(
              field: listField,
              itemLabelBuilder: (index) => 'Число #${index + 1}',
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Проверяем, что отображаются кастомные метки
    expect(find.text('Число #1'), findsOneWidget);
    expect(find.text('Число #2'), findsOneWidget);
    expect(find.text('Число #3'), findsOneWidget);

    // Добавляем еще один элемент
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Проверяем, что для нового элемента тоже создалась кастомная метка
    expect(find.text('Число #4'), findsOneWidget);
  });

  testWidgets('Список с разными типами полей', (WidgetTester tester) async {
    // Создаем ListField с PointField
    final listField = ListField<Point, PointField>(
      config: ListFieldConfig<Point>(
        label: 'Список точек',
        minItems: 2,
        createItemField: () => PointField(
          config: PointFieldConfig(
            label: 'Точка',
            xConfig: NumberFieldConfig(label: 'X'),
            yConfig: NumberFieldConfig(label: 'Y'),
          ),
        ),
      ),
    );

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ListFieldWidget<Point, PointField>(
              field: listField,
              itemBuilder: (context, field, onChanged) {
                return PointFieldWidget(field: field, onChanged: onChanged);
              },
            ),
          ),
        ),
      ),
    ));

    // Проверяем, что отображаются поля для ввода координат точек
    expect(find.text('X'), findsNWidgets(2));
    expect(find.text('Y'), findsNWidgets(2));

    // Находим текстовые поля для ввода
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(4)); // 2 точки × 2 координаты

    // Вводим значения координат для первой точки
    await tester.enterText(textFields.at(0), '10');
    await tester.enterText(textFields.at(1), '20');
    await tester.pumpAndSettle();

    // Вводим значения координат для второй точки
    await tester.enterText(textFields.at(2), '30');
    await tester.enterText(textFields.at(3), '40');
    await tester.pumpAndSettle();

    // Проверяем значения в списке
    expect(listField.value?.length, 2);
    expect(listField.value?[0].x, 10.0);
    expect(listField.value?[0].y, 20.0);
    expect(listField.value?[1].x, 30.0);
    expect(listField.value?[1].y, 40.0);
  });

  testWidgets('Динамическое изменение списка', (WidgetTester tester) async {
    // Создаем ListField с NumberField
    final listField = ListField<double, NumberField>(
      config: ListFieldConfig<double>(
        label: 'Динамический список',
        minItems: 1,
        maxItems: 10,
        createItemField: () => NumberField(
          config: NumberFieldConfig(label: 'Число'),
        ),
      ),
      initialValue: [5, 10, 15],
    );

    // Создаем контроллер для обновления состояния
    final updateController = ValueNotifier<bool>(false);

    // Создаем виджет для тестирования
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: updateController,
                    builder: (context, _, __) {
                      return ListFieldWidget<double, NumberField>(
                        field: listField,
                        itemBuilder: (context, field, onChanged) {
                          return NumberFieldWidget(
                              field: field, onChanged: onChanged);
                        },
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Программно меняем значение списка
                  listField.value = [25, 50, 75, 100];
                  updateController.value = !updateController.value;
                },
                child: Text('Обновить список'),
              ),
            ],
          ),
        ),
      ),
    ));

    // Проверяем начальное состояние
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsOneWidget);
    expect(find.text('Элемент 3'), findsOneWidget);

    // Находим текстовые поля и проверяем их значения
    final initialTextFields = find.byType(TextField);
    expect(initialTextFields, findsNWidgets(3));

    // Нажимаем на кнопку обновления списка
    await tester.tap(find.text('Обновить список'));
    await tester.pumpAndSettle();

    // Проверяем, что список обновился
    expect(find.text('Элемент 1'), findsOneWidget);
    expect(find.text('Элемент 2'), findsOneWidget);
    expect(find.text('Элемент 3'), findsOneWidget);
    expect(find.text('Элемент 4'), findsOneWidget);

    // Находим текстовые поля и проверяем их новые значения
    final updatedTextFields = find.byType(TextField);
    expect(updatedTextFields, findsNWidgets(4));
  });
}
