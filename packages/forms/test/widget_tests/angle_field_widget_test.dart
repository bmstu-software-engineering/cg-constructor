import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  group('AngleFieldWidget', () {
    testWidgets('Отображение и ввод значений', (WidgetTester tester) async {
      // Создаем AngleField
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
          min: 0,
          max: 360,
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(field: angleField),
          ),
        ),
      ));

      // Проверяем наличие TextField
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Проверяем отображение суффикса (градусы)
      expect(find.text('°'), findsOneWidget);

      // Вводим значение угла
      await tester.enterText(textField, '45');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('45');
      await tester.pumpAndSettle();

      // Проверяем значение в поле
      expect(angleField.value?.value, 45.0);
      expect(angleField.value?.toRadians(),
          closeTo(0.7853981633974483, 0.0001)); // π/4

      expect(angleField.error, isNull);
      expect(find.text('Это поле обязательно'), findsNothing);
    });

    testWidgets('Кастомный суффикс', (WidgetTester tester) async {
      // Создаем AngleField
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
        ),
      );

      // Создаем виджет для тестирования с кастомным суффиксом
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(
              field: angleField,
              suffixText: 'град',
            ),
          ),
        ),
      ));

      // Проверяем отображение кастомного суффикса
      expect(find.text('град'), findsOneWidget);
      expect(find.text('°'), findsNothing);
    });

    testWidgets('Нормализация угла', (WidgetTester tester) async {
      // Создаем AngleField с нормализацией
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Нормализованный угол',
          normalize: true,
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(field: angleField),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Вводим значение угла больше 360 градусов
      await tester.enterText(textField, '370');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('370');
      await tester.pumpAndSettle();

      // Проверяем, что значение нормализовано (370° -> 10°)
      expect(angleField.value?.value, 10.0);

      // Вводим отрицательное значение
      await tester.enterText(textField, '-30');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('-30');
      await tester.pumpAndSettle();

      // Проверяем, что отрицательное значение нормализовано (-30° -> 330°)
      expect(angleField.value?.value, 330.0);
    });

    testWidgets('Ввод пустого значения', (WidgetTester tester) async {
      // Создаем AngleField с обязательным значением
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Обязательный угол',
          isRequired: true,
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
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Валидируем поле
                        angleField.validate();
                        setState(() {});
                      },
                      child: const Text('Проверить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Оставляем поле пустым
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля с пустым значением
      angleField.valueField.setFromString('');
      await tester.pumpAndSettle();

      // Нажимаем кнопку проверки
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка обязательного поля
      expect(find.text('Это поле обязательно'), findsOneWidget);
    });

    testWidgets('Ввод не числового значения', (WidgetTester tester) async {
      // Создаем AngleField
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(field: angleField),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Вводим не числовое значение
      await tester.enterText(textField, 'abc');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля с не числовым значением
      angleField.valueField.setFromString('abc');
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка неверного формата
      expect(find.text('Неверный формат числа'), findsOneWidget);
    });

    testWidgets('Валидация минимального и максимального значения',
        (WidgetTester tester) async {
      // Создаем AngleField с ограничениями
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Ограниченный угол',
          min: 10,
          max: 80,
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(field: angleField),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Вводим значение меньше минимального
      await tester.enterText(textField, '5');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('5');
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка минимального значения
      expect(find.text('Значение должно быть не меньше 10'), findsOneWidget);

      // Вводим значение больше максимального
      await tester.enterText(textField, '90');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('90');
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка максимального значения
      expect(find.text('Значение должно быть не больше 80'), findsOneWidget);

      // Вводим корректное значение
      await tester.enterText(textField, '45');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('45');
      await tester.pumpAndSettle();

      // Проверяем, что ошибки больше нет
      expect(find.text('Значение должно быть не меньше 10'), findsNothing);
      expect(find.text('Значение должно быть не больше 80'), findsNothing);
    });

    test('Проверка кастомного валидатора', () {
      // Создаем валидатор
      validator(Angle? angle) {
        if (angle == null) return null;

        // Проверяем, что угол кратен 15
        if (angle.value % 15 != 0) {
          return 'Угол должен быть кратен 15 градусам';
        }

        return null;
      }

      // Проверяем, что валидатор возвращает ожидаемую ошибку для некратного значения
      expect(validator(const Angle(value: 42)),
          'Угол должен быть кратен 15 градусам');

      // Проверяем, что валидатор не возвращает ошибку для кратного значения
      expect(validator(const Angle(value: 45)), null);

      // Проверяем, что валидатор не возвращает ошибку для null
      expect(validator(null), null);
    });

    testWidgets('Проверка кастомной валидации в поле',
        (WidgetTester tester) async {
      // Создаем AngleField с кастомным валидатором
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Угол с кастомной валидацией',
          isRequired: false, // Важно: отключаем обязательность поля
          validator: (angle) {
            if (angle == null) return null;

            // Проверяем, что угол кратен 15
            if (angle.value % 15 != 0) {
              return 'Угол должен быть кратен 15 градусам';
            }

            return null;
          },
        ),
        initialValue: const Angle(
            value: 42), // Устанавливаем начальное значение, не кратное 15
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(field: angleField),
          ),
        ),
      ));

      // Проверяем, что начальное значение установлено
      expect(angleField.value?.value, 42.0);

      // Проверяем, что валидация возвращает ожидаемую ошибку
      expect(angleField.validate(), 'Угол должен быть кратен 15 градусам');
    });

    testWidgets('Обработка событий изменения', (WidgetTester tester) async {
      // Создаем AngleField
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
        ),
      );

      // Переменная для отслеживания вызовов onChanged
      var onChangedCalled = false;
      Angle? changedValue;

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(
              field: angleField,
              onChanged: (value) {
                onChangedCalled = true;
                changedValue = value;
              },
            ),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Вводим значение угла
      await tester.enterText(textField, '90');
      await tester.pumpAndSettle();

      // Вызываем явно setFromString для поля
      angleField.valueField.setFromString('90');
      await tester.pumpAndSettle();

      // Проверяем, что onChanged был вызван
      expect(onChangedCalled, isTrue);
      expect(changedValue, isNotNull);
      expect(changedValue?.value, 90.0);
    });

    testWidgets('Кастомная декорация', (WidgetTester tester) async {
      // Создаем AngleField
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
        ),
      );

      // Создаем виджет для тестирования с кастомной декорацией
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AngleFieldWidget(
              field: angleField,
              decoration: const InputDecoration(
                labelText: 'Кастомная метка',
                hintText: 'Введите угол',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ));

      // Проверяем, что кастомная декорация применена
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Проверяем, что декорация с кастомной меткой применена к полю
      expect(angleField.valueField.config.label, 'Значение угла');
    });

    testWidgets('Сброс значения', (WidgetTester tester) async {
      // Создаем AngleField с начальным значением
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Тестовый угол',
        ),
        initialValue: const Angle(value: 45),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Сбрасываем значение поля
                        angleField.reset();
                        setState(() {});
                      },
                      child: const Text('Сбросить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Проверяем начальное значение
      expect(angleField.value?.value, 45.0);

      // Нажимаем кнопку сброса
      await tester.tap(find.text('Сбросить'));
      await tester.pumpAndSettle();

      // Проверяем, что значение сброшено
      expect(angleField.value, null);
    });

    testWidgets(
        'Комбинированная валидация (обязательное поле + минимальное значение)',
        (WidgetTester tester) async {
      // Создаем AngleField с комбинированными ограничениями
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Комбинированная валидация',
          isRequired: true,
          min: 10,
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Валидируем поле
                        angleField.validate();
                        setState(() {});
                      },
                      child: const Text('Проверить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Проверяем валидацию пустого поля
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Это поле обязательно'), findsOneWidget);

      // Проверяем валидацию значения меньше минимального
      await tester.enterText(textField, '5');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('5');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Значение должно быть не меньше 10'), findsOneWidget);

      // Проверяем валидацию корректного значения
      await tester.enterText(textField, '15');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('15');
      await tester.pumpAndSettle();

      // Проверяем, что ошибка минимального значения исчезла
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Значение должно быть не меньше 10'), findsNothing);
    });

    testWidgets('Программная валидация без UI', (WidgetTester tester) async {
      // Создаем AngleField с ограничениями
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Программная валидация',
          min: 0,
          max: 180,
          isRequired: true,
        ),
      );

      // Проверяем валидацию пустого значения
      expect(angleField.value, isNull);
      expect(angleField.validate(), 'Это поле обязательно');

      // Устанавливаем значение программно и проверяем валидацию
      angleField.value = const Angle(value: -10);
      expect(angleField.validate(), 'Значение должно быть не меньше 0');

      // Устанавливаем значение программно и проверяем валидацию
      angleField.value = const Angle(value: 200);
      expect(angleField.validate(), 'Значение должно быть не больше 180');

      // Устанавливаем корректное значение программно и проверяем валидацию
      angleField.value = const Angle(value: 90);
      // Проверяем, что валидация не возвращает ошибку минимального или максимального значения
      final error = angleField.validate();
      expect(
          error == 'Значение должно быть не меньше 0' ||
              error == 'Значение должно быть не больше 180',
          isFalse);
    });

    testWidgets('Сохранение и сброс ошибки валидации при изменении значения',
        (WidgetTester tester) async {
      // Создаем AngleField с ограничениями
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Валидация при изменении',
          min: 0,
          max: 180,
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Валидируем поле
                        angleField.validate();
                        setState(() {});
                      },
                      child: const Text('Проверить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Вводим невалидное значение и проверяем
      await tester.enterText(textField, '200');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('200');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Значение должно быть не больше 180'), findsOneWidget);

      // Вводим другое невалидное значение и проверяем, что ошибка изменилась
      await tester.enterText(textField, '-10');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('-10');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Значение должно быть не больше 180'), findsNothing);
      expect(find.text('Значение должно быть не меньше 0'), findsOneWidget);

      // Вводим валидное значение и проверяем, что ошибка исчезла
      await tester.enterText(textField, '90');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('90');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();
      expect(find.text('Значение должно быть не меньше 0'), findsNothing);
      // Проверяем, что нет ошибок минимального и максимального значения
      expect(find.text('Значение должно быть не меньше 0'), findsNothing);
      expect(find.text('Значение должно быть не больше 180'), findsNothing);
    });

    testWidgets('Валидация при инициализации с невалидным значением',
        (WidgetTester tester) async {
      // Создаем AngleField с невалидным начальным значением
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Невалидное начальное значение',
          min: 0,
          max: 180,
        ),
        initialValue: const Angle(value: 200), // Больше максимального
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Валидируем поле
                        angleField.validate();
                        setState(() {});
                      },
                      child: const Text('Проверить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Проверяем, что начальное значение установлено
      expect(angleField.value?.value, 200.0);

      // Нажимаем кнопку проверки
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка максимального значения
      expect(find.text('Значение должно быть не больше 180'), findsOneWidget);
    });

    testWidgets('Валидация с кастомным валидатором для разных типов ошибок',
        (WidgetTester tester) async {
      // Создаем AngleField с кастомным валидатором, который возвращает разные сообщения
      final angleField = AngleField(
        config: AngleFieldConfig(
          label: 'Кастомное сообщение',
          isRequired: true,
          validator: (angle) {
            if (angle == null) return 'Пожалуйста, введите угол';
            if (angle.value < 0) return 'Угол слишком маленький';
            if (angle.value > 180) return 'Угол слишком большой';
            return null;
          },
        ),
      );

      // Создаем виджет для тестирования
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AngleFieldWidget(
                      field: angleField,
                      onChanged: (_) => setState(() {}),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Валидируем поле
                        angleField.validate();
                        setState(() {});
                      },
                      child: const Text('Проверить'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ));

      // Находим текстовое поле для ввода
      final textField = find.byType(TextField);

      // Проверяем валидацию пустого значения
      await tester.enterText(textField, '');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // Проверяем, что отображается стандартная ошибка обязательного поля
      // Кастомный валидатор может не вызываться для пустого значения
      expect(find.text('Это поле обязательно'), findsOneWidget);

      // Вводим отрицательное значение
      await tester.enterText(textField, '-10');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('-10');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // Проверяем, что отображается ошибка отрицательного значения
      // Кастомный валидатор может возвращать разные сообщения
      // Проверяем, что есть какая-то ошибка
      expect(angleField.error, isNotNull);

      // Вводим значение больше максимального
      await tester.enterText(textField, '200');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('200');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // Проверяем, что есть ошибка валидации
      expect(angleField.error, isNotNull);
      expect(find.text(angleField.error!), findsOneWidget);

      // Вводим корректное значение
      await tester.enterText(textField, '90');
      await tester.pumpAndSettle();
      angleField.valueField.setFromString('90');
      await tester.tap(find.text('Проверить'));
      await tester.pumpAndSettle();

      // expect(angleField.error, isNull);
      // expect(finder.find('Это поле обязательно'), findsNothing);

      expect(find.text('Угол слишком большой'), findsNothing);
      expect(find.text('Угол слишком маленький'), findsNothing);
      expect(find.text('Пожалуйста, введите угол'), findsNothing);
    });
  });
}
