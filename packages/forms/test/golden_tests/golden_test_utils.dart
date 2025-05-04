import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';
import 'package:forms/src/core/form_field.dart' as forms;

/// Утилиты для golden тестов
class GoldenTestUtils {
  /// Создает виджет для тестирования с заданной темой и размерами
  static Widget buildTestableWidget({
    required Widget child,
    ThemeData? theme,
    Size size = const Size(400, 600),
  }) {
    return MaterialApp(
      theme: theme ??
          ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
      home: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Создает стандартную декорацию для тестирования кастомной декорации
  static InputDecoration getCustomDecoration({
    required String labelText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: const Color(0xFFE0F7FA),
    );
  }

  /// Запускает golden тест для виджета
  static Future<void> runGoldenTest({
    required WidgetTester tester,
    required Widget widget,
    required String goldenFileName,
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(goldenFileName),
    );
  }

  /// Создает виджет для тестирования AngleFieldWidget
  static Widget buildAngleFieldWidget({
    required AngleField field,
    String suffixText = '°',
    InputDecoration? decoration,
    ValueChanged<Angle?>? onChanged,
  }) {
    return buildTestableWidget(
      child: AngleFieldWidget(
        field: field,
        suffixText: suffixText,
        decoration: decoration,
        onChanged: onChanged,
      ),
    );
  }

  /// Создает виджет для тестирования VectorFieldWidget
  static Widget buildVectorFieldWidget({
    required VectorField field,
    InputDecoration? decoration,
    ValueChanged<Vector?>? onChanged,
  }) {
    return buildTestableWidget(
      child: VectorFieldWidget(
        field: field,
        decoration: decoration,
        onChanged: onChanged,
      ),
    );
  }

  /// Создает виджет для тестирования StringFieldWidget
  static Widget buildStringFieldWidget({
    required StringField field,
    InputDecoration? decoration,
    ValueChanged<String?>? onChanged,
  }) {
    return buildTestableWidget(
      child: StringFieldWidget(
        field: field,
        decoration: decoration,
        onChanged: onChanged,
      ),
    );
  }

  /// Создает виджет для тестирования NumberFieldWidget
  static Widget buildNumberFieldWidget({
    required NumberField field,
    InputDecoration? decoration,
    ValueChanged<double?>? onChanged,
  }) {
    return buildTestableWidget(
      child: NumberFieldWidget(
        field: field,
        decoration: decoration,
        onChanged: onChanged,
      ),
    );
  }

  /// Создает виджет для тестирования EnumSelectFieldWidget
  static Widget buildEnumSelectFieldWidget<T>({
    required EnumSelectField<T> field,
    InputDecoration? decoration,
    ValueChanged<T?>? onChanged,
  }) {
    return buildTestableWidget(
      child: EnumSelectFieldWidget<T>(
        field: field,
        decoration: decoration,
        onChanged: onChanged,
      ),
    );
  }

  /// Создает виджет для тестирования ListFieldWidget
  static Widget buildListFieldWidget<T, F extends forms.FormField<T>>({
    required ListField<T, F> field,
    required Widget Function(BuildContext, F, ValueChanged<T?>) itemBuilder,
    String addButtonLabel = 'Добавить элемент',
    String removeButtonTooltip = 'Удалить элемент',
    String Function(int)? itemLabelBuilder,
  }) {
    return buildTestableWidget(
      child: SingleChildScrollView(
        child: ListFieldWidget<T, F>(
          field: field,
          itemBuilder: itemBuilder,
          addButtonLabel: addButtonLabel,
          removeButtonTooltip: removeButtonTooltip,
          itemLabelBuilder: itemLabelBuilder,
        ),
      ),
    );
  }
}
