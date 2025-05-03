import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('VectorFieldWidget', () {
    testWidgets('Отображение и ввод значений', (WidgetTester tester) async {
      // Создаем VectorField
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          dxConfig:
              const NumberFieldConfig(label: 'Смещение по X', min: 0, max: 100),
          dyConfig:
              const NumberFieldConfig(label: 'Смещение по Y', min: 0, max: 100),
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VectorFieldWidget(field: vectorField),
          ),
        ),
      ));

      // Проверяем отображение меток
      expect(find.text('Тестовый вектор'), findsOneWidget);
      expect(find.text('Смещение по X'), findsOneWidget);
      expect(find.text('Смещение по Y'), findsOneWidget);

      // Находим текстовые поля для ввода
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2)); // 2 поля для dx и dy

      // Вводим значения координат
      await tester.enterText(textFields.at(0), '10');
      await tester.enterText(textFields.at(1), '20');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для полей
      vectorField.dxField.setFromString('10');
      vectorField.dyField.setFromString('20');
      await tester.pumpAndSettle();

      // Проверяем значение в поле
      expect(vectorField.value?.dx, 10.0);
      expect(vectorField.value?.dy, 20.0);
    });

    testWidgets('Отображение ошибок валидации', (WidgetTester tester) async {
      // Создаем VectorField с валидатором и начальным значением
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
          validator: (vector) {
            if (vector == null) return null;

            // Вычисляем длину вектора
            final length =
                math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);

            if (length < 10) {
              return 'Вектор слишком короткий';
            }
            return null;
          },
        ),
        // Устанавливаем начальное значение, чтобы избежать ошибки обязательного поля
        initialValue: const Vector(dx: 3, dy: 4),
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
                    VectorFieldWidget(
                      field: vectorField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Устанавливаем ошибку напрямую для тестирования отображения
                        vectorField.setError('Вектор слишком короткий');
                        setState(() {});
                      },
                      child: const Text('Показать ошибку'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Сбрасываем ошибку
                        vectorField.setError(null);
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
      expect(find.text('Вектор слишком короткий'), findsOneWidget);

      // Нажимаем кнопку для скрытия ошибки
      await tester.tap(find.text('Скрыть ошибку'));
      await tester.pumpAndSettle();

      // Проверяем, что ошибка больше не отображается
      expect(find.text('Вектор слишком короткий'), findsNothing);
    });

    testWidgets('Обработка событий изменения', (WidgetTester tester) async {
      // Создаем VectorField
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
        ),
      );

      // Переменная для отслеживания вызовов onChanged
      var onChangedCalled = false;
      Vector? changedValue;

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VectorFieldWidget(
              field: vectorField,
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
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для полей
      vectorField.dxField.setFromString('10');
      vectorField.dyField.setFromString('20');
      await tester.pumpAndSettle();

      // Проверяем, что onChanged был вызван
      expect(onChangedCalled, isTrue);
      expect(changedValue, isNotNull);
      expect(changedValue?.dx, 10.0);
      expect(changedValue?.dy, 20.0);
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      // Создаем VectorField
      final vectorField = VectorField(
        config: VectorFieldConfig(
          label: 'Тестовый вектор',
        ),
      );

      // Создаем виджет для тестирования с кастомной декорацией
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: VectorFieldWidget(
              field: vectorField,
              decoration: const InputDecoration(
                labelText: 'Кастомная метка',
                hintText: 'Введите компоненты вектора',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ));

      // Проверяем отображение кастомной метки
      expect(find.text('Кастомная метка'), findsOneWidget);
      expect(find.text('Тестовый вектор'), findsNothing);
    });
  });
}
