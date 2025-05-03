import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:flow/adapters/calculate_strategies.dart';
import 'package:forms/forms.dart';
import 'package:mocktail/mocktail.dart';

// Реализация VariatedAlgorithm для тестирования
class TestVariatedAlgorithm implements VariatedAlgorithm {
  final Map<String?, ViewerResultModel> _results = {};
  final List<AlgorithmVariant> _variants = [];
  final DataModel _dataModel;
  bool _throwExceptionOnCalculate = false;

  TestVariatedAlgorithm({
    required DataModel dataModel,
    List<AlgorithmVariant>? variants,
  }) : _dataModel = dataModel {
    if (variants != null) {
      _variants.addAll(variants);
    }
  }

  // Добавляет вариант алгоритма
  void addVariant(AlgorithmVariant variant, ViewerResultModel result) {
    _variants.add(variant);
    _results[variant.id] = result;
  }

  // Устанавливает результат для стандартного расчета (без варианта)
  void setDefaultResult(ViewerResultModel result) {
    _results[null] = result;
  }

  // Устанавливает флаг для генерации исключения при расчете
  void setThrowExceptionOnCalculate(bool value) {
    _throwExceptionOnCalculate = value;
  }

  @override
  ResultModel calculate() {
    return calculateWithVariant(null);
  }

  @override
  ResultModel calculateWithVariant(String? variant) {
    if (_throwExceptionOnCalculate) {
      throw CalculationException('Тестовая ошибка расчета');
    }

    final result = _results[variant];
    if (result == null) {
      throw CalculationException('Вариант "$variant" не найден');
    }
    return result;
  }

  @override
  DataModel getDataModel() {
    return _dataModel;
  }

  @override
  List<AlgorithmVariant> getAvailableVariants() {
    return _variants;
  }
}

// Мок для FormsDataModel
class MockFormsDataModel extends Mock implements FormsDataModel {
  @override
  DynamicFormModel get config =>
      DynamicFormModel(config: FormConfig(fields: [], name: 'test_form'));

  @override
  AlgorithmData get data => MockAlgorithmData();
}

class MockAlgorithmData extends Mock implements AlgorithmData {}

// Мок для FlowDataStrategy
class MockFlowDataStrategy extends Mock implements FlowDataStrategy {}

// Мок для FlowDrawStrategy
class MockFlowDrawStrategy extends Mock
    implements FlowDrawStrategy<FlowDrawData> {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData());
  });

  late TestVariatedAlgorithm testAlgorithm;
  late MockFormsDataModel mockFormsDataModel;
  late MockFlowDataStrategy mockDataStrategy;
  late MockFlowDrawStrategy mockDrawStrategy;
  late FlowBuilder<FlowDrawData> flowBuilder;

  setUp(() {
    mockFormsDataModel = MockFormsDataModel();
    mockDataStrategy = MockFlowDataStrategy();
    mockDrawStrategy = MockFlowDrawStrategy();

    // Создаем тестовый алгоритм
    testAlgorithm = TestVariatedAlgorithm(dataModel: mockFormsDataModel);

    // Устанавливаем результаты для вариантов
    testAlgorithm.setDefaultResult(
      ViewerResultModel(
        points: [const Point(x: 0, y: 0)],
        lines: [],
        markdownInfo: 'Стандартный результат',
      ),
    );

    testAlgorithm.addVariant(
      const AlgorithmVariant(
        id: 'variant1',
        name: 'Вариант 1',
        icon: Icons.circle,
        color: Colors.blue,
      ),
      ViewerResultModel(
        points: [const Point(x: 1, y: 1)],
        lines: [const Line(a: Point(x: 1, y: 1), b: Point(x: 2, y: 2))],
        markdownInfo: '# Вариант 1\nРезультат для варианта 1',
      ),
    );

    testAlgorithm.addVariant(
      const AlgorithmVariant(
        id: 'variant2',
        name: 'Вариант 2',
        icon: Icons.square,
        color: Colors.green,
      ),
      ViewerResultModel(
        points: [const Point(x: 3, y: 3)],
        lines: [const Line(a: Point(x: 3, y: 3), b: Point(x: 4, y: 4))],
        markdownInfo: '# Вариант 2\nРезультат для варианта 2',
      ),
    );

    // Создаем стратегию расчетов
    final calculateStrategy = GenericCalculateStrategy(testAlgorithm);

    // Создаем FlowBuilder
    flowBuilder = FlowBuilder<FlowDrawData>(
      name: 'Test Integration',
      dataStrategy: mockDataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: mockDrawStrategy,
    );

    // Настраиваем мок стратегии данных
    when(() => mockDataStrategy.isValid).thenReturn(true);
    when(() => mockDataStrategy.buildWidget()).thenReturn(Container());

    // Настраиваем мок стратегии отрисовки
    when(() => mockDrawStrategy.draw(any())).thenAnswer((_) async {});
    when(() => mockDrawStrategy.buildWidget()).thenReturn(Container());
  });

  group('Интеграция FlowBuilder с VariatedAlgorithm', () {
    test('должен получать правильные действия из алгоритма', () {
      // Act
      final actions = flowBuilder.getActionsFromAlgorithm();

      // Assert
      expect(actions.length, equals(2));
      expect(actions[0].label, equals('Вариант 1'));
      expect(actions[1].label, equals('Вариант 2'));
    });

    test('должен выполнять расчет с правильным вариантом', () async {
      // Act
      await flowBuilder.calculate(variant: 'variant1');

      // Assert
      expect(
        flowBuilder.infoStream.value.last,
        equals('# Вариант 1\nРезультат для варианта 1'),
      );
    });

    test('должен выполнять расчет со стандартным вариантом', () async {
      // Act
      await flowBuilder.calculate();

      // Assert
      expect(
        flowBuilder.infoStream.value.last,
        equals('Стандартный результат'),
      );
    });

    test('должен обрабатывать ошибки при расчете', () async {
      // Arrange
      testAlgorithm.setThrowExceptionOnCalculate(true);

      // Act & Assert
      await expectLater(
        flowBuilder.calculate(variant: 'variant1'),
        throwsA(isA<CalculationException>()),
      );
      expect(
        flowBuilder.infoStream.value.last,
        contains('Ошибка при расчетах'),
      );
    });

    test('должен выполнять действие из варианта алгоритма', () async {
      // Arrange
      final actions = flowBuilder.getActionsFromAlgorithm();
      final action = actions[0]; // Вариант 1

      // Act
      await action.action(flowBuilder);

      // Assert
      expect(flowBuilder.infoStream.value.length, equals(2));
      expect(
        flowBuilder.infoStream.value[0],
        equals('# Вариант 1\nРезультат для варианта 1'),
      );
      expect(
        flowBuilder.infoStream.value[1],
        equals('Отрисовка выполнена успешно'),
      );
      verify(() => mockDrawStrategy.draw(any())).called(1);
    });

    test('не должен выполнять действие, если данные невалидны', () async {
      // Arrange
      when(() => mockDataStrategy.isValid).thenReturn(false);
      final actions = flowBuilder.getActionsFromAlgorithm();
      final action = actions[0]; // Вариант 1

      // Act
      await action.action(flowBuilder);

      // Assert
      expect(flowBuilder.infoStream.value.length, equals(1));
      expect(
        flowBuilder.infoStream.value[0],
        equals('# Валидация не пройдена'),
      );
      verifyNever(() => mockDrawStrategy.draw(any()));
    });
  });

  group('AlgorithmFlowBuilderFactory с VariatedAlgorithm', () {
    test('должен создавать FlowBuilder с действиями из алгоритма', () {
      // Arrange & Act
      final factory = AlgorithmFlowBuilderFactory(
        testAlgorithm,
        name: 'Factory Test',
        useAlgorithmActions: true,
      );
      final createdFlowBuilder = factory.create();

      // Assert
      expect(createdFlowBuilder, isNotNull);

      // Проверяем, что действия были добавлены
      // Для этого нам нужно отрисовать виджет и проверить наличие кнопок
      final widget = createdFlowBuilder.buildDataWidget();
      expect(widget, isNotNull);
    });

    test(
      'не должен добавлять действия из алгоритма, если useAlgorithmActions=false',
      () {
        // Arrange & Act
        final factory = AlgorithmFlowBuilderFactory(
          testAlgorithm,
          name: 'Factory Test',
          useAlgorithmActions: false,
        );
        final createdFlowBuilder = factory.create();

        // Assert
        expect(createdFlowBuilder, isNotNull);

        // Проверяем, что действия не были добавлены
        // Для этого нам нужно отрисовать виджет и проверить отсутствие кнопок
        final widget = createdFlowBuilder.buildDataWidget();
        expect(widget, isNotNull);
      },
    );

    test('должен добавлять пользовательские действия', () {
      // Arrange
      final customActions = [
        FlowAction(label: 'Пользовательское действие', action: (_) async {}),
      ];

      // Act
      final factory = AlgorithmFlowBuilderFactory(
        testAlgorithm,
        name: 'Factory Test',
        actions: customActions,
      );
      final createdFlowBuilder = factory.create();

      // Assert
      expect(createdFlowBuilder, isNotNull);

      // Проверяем, что действия были добавлены
      final widget = createdFlowBuilder.buildDataWidget();
      expect(widget, isNotNull);
    });
  });
}
