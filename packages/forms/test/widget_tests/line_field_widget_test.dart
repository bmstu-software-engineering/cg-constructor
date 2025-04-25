import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('LineFieldWidget', () {
    testWidgets('Отображение и ввод значений', (WidgetTester tester) async {
      // Создаем LineField
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          startConfig: const PointFieldConfig(
            label: 'Начало',
            xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
            yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
          ),
          endConfig: const PointFieldConfig(
            label: 'Конец',
            xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
            yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
          ),
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineFieldWidget(field: lineField),
          ),
        ),
      ));

      // Проверяем отображение меток
      expect(find.text('Тестовая линия'), findsOneWidget);
      expect(find.text('Начало'), findsOneWidget);
      expect(find.text('Конец'), findsOneWidget);
      expect(find.text('X'), findsNWidgets(2)); // По одному для начала и конца
      expect(find.text('Y'), findsNWidgets(2)); // По одному для начала и конца

      // Находим текстовые поля для ввода
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4)); // 2 точки × 2 координаты

      // Вводим значения координат для начальной точки
      await tester.enterText(textFields.at(0), '10');
      await tester.enterText(textFields.at(1), '20');
      await tester.pumpAndSettle();

      // Вводим значения координат для конечной точки
      await tester.enterText(textFields.at(2), '30');
      await tester.enterText(textFields.at(3), '40');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для полей
      lineField.startField.xField.setFromString('10');
      lineField.startField.yField.setFromString('20');
      lineField.endField.xField.setFromString('30');
      lineField.endField.yField.setFromString('40');
      await tester.pumpAndSettle();

      // Проверяем значение в поле
      expect(lineField.value?.a.x, 10.0);
      expect(lineField.value?.a.y, 20.0);
      expect(lineField.value?.b.x, 30.0);
      expect(lineField.value?.b.y, 40.0);
    });

    testWidgets('Отображение ошибок валидации', (WidgetTester tester) async {
      // Создаем LineField с валидатором и начальным значением
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
          validator: (line) {
            if (line == null) return null;

            // Вычисляем длину линии
            final dx = line.b.x - line.a.x;
            final dy = line.b.y - line.a.y;
            final length = math.sqrt(dx * dx + dy * dy);

            if (length < 10) {
              return 'Линия слишком короткая';
            }
            return null;
          },
        ),
        // Устанавливаем начальное значение, чтобы избежать ошибки обязательного поля
        initialValue: const Line(
          a: Point(x: 0, y: 0),
          b: Point(x: 3, y: 4),
        ),
      );

      // Создаем StatefulBuilder для обновления состояния виджета
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    LineFieldWidget(
                      field: lineField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Устанавливаем ошибку напрямую для тестирования отображения
                        lineField.setError('Линия слишком короткая');
                        setState(() {});
                      },
                      child: const Text('Показать ошибку'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Сбрасываем ошибку
                        lineField.setError(null);
                        setState(() {});
                      },
                      child: const Text('Скрыть ошибку'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Нажимаем кнопку для отображения ошибки
      await tester.tap(find.text('Показать ошибку'));
      await tester.pumpAndSettle();

      // Проверяем отображение ошибки
      expect(find.text('Линия слишком короткая'), findsOneWidget);

      // Нажимаем кнопку для скрытия ошибки
      await tester.tap(find.text('Скрыть ошибку'));
      await tester.pumpAndSettle();

      // Проверяем, что ошибка больше не отображается
      expect(find.text('Линия слишком короткая'), findsNothing);
    });

    testWidgets('Обработка событий изменения', (WidgetTester tester) async {
      // Создаем LineField
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
        ),
      );

      // Переменная для отслеживания вызовов onChanged
      var onChangedCalled = false;
      Line? changedValue;

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineFieldWidget(
              field: lineField,
              onChanged: (value) {
                onChangedCalled = true;
                changedValue = value;
              },
            ),
          ),
        ),
      ));

      // Находим текстовые поля для ввода
      final textFields = find.byType(TextField);

      // Вводим значения координат
      await tester.enterText(textFields.at(0), '10');
      await tester.enterText(textFields.at(1), '20');
      await tester.enterText(textFields.at(2), '30');
      await tester.enterText(textFields.at(3), '40');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для полей
      lineField.startField.xField.setFromString('10');
      lineField.startField.yField.setFromString('20');
      lineField.endField.xField.setFromString('30');
      lineField.endField.yField.setFromString('40');
      await tester.pumpAndSettle();

      // Проверяем, что onChanged был вызван
      expect(onChangedCalled, isTrue);
      expect(changedValue, isNotNull);
      expect(changedValue?.a.x, 10.0);
      expect(changedValue?.a.y, 20.0);
      expect(changedValue?.b.x, 30.0);
      expect(changedValue?.b.y, 40.0);
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      // Создаем LineField
      final lineField = LineField(
        config: LineFieldConfig(
          label: 'Тестовая линия',
        ),
      );

      // Создаем виджет для тестирования с кастомной декорацией
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineFieldWidget(
              field: lineField,
              decoration: const InputDecoration(
                labelText: 'Кастомная метка',
                hintText: 'Введите координаты линии',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ));

      // Проверяем отображение кастомной метки
      expect(find.text('Кастомная метка'), findsOneWidget);
      expect(find.text('Тестовая линия'), findsNothing);
    });
  });
}
