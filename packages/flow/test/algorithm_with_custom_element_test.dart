import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:flow/adapters/calculate_strategies.dart';
import 'package:forms/forms.dart';
import 'package:mocktail/mocktail.dart';

// Мок для алгоритма с пользовательскими элементами
class MockAlgorithmWithCustomElement extends Mock
    implements AlgorithmWithCustomElement {}

// Мок для FormsDataModel
class MockFormsDataModel extends Mock implements FormsDataModel {
  @override
  DynamicFormModel get config =>
      DynamicFormModel(config: FormConfig(fields: [], name: 'test_form'));

  @override
  AlgorithmData get data => MockAlgorithmData();
}

class MockAlgorithmData extends Mock implements AlgorithmData {}

// Мок для ResultModel
class MockResultModel extends Mock implements ResultModel {}

// Мок для стандартного алгоритма
class MockStandardAlgorithm extends Mock implements Algorithm {}

// Мок для FlowDataStrategy
class MockFlowDataStrategy extends Mock implements FlowDataStrategy {}

// Мок для FlowDrawStrategy
class MockFlowDrawStrategy extends Mock
    implements FlowDrawStrategy<FlowDrawData> {}

void main() {
  late MockAlgorithmWithCustomElement mockAlgorithm;
  late MockFormsDataModel mockDataModel;
  late MockFlowDataStrategy mockDataStrategy;
  late MockFlowDrawStrategy mockDrawStrategy;
  late GenericCalculateStrategy<FlowDrawData> calculateStrategy;
  late FlowBuilder<FlowDrawData> flowBuilder;

  setUp(() {
    mockAlgorithm = MockAlgorithmWithCustomElement();
    mockDataModel = MockFormsDataModel();
    mockDataStrategy = MockFlowDataStrategy();
    mockDrawStrategy = MockFlowDrawStrategy();

    // Настраиваем мок алгоритма
    when(() => mockAlgorithm.getDataModel()).thenReturn(mockDataModel);
    when(
      () => mockAlgorithm.buildTopMenuWidget(),
    ).thenReturn(const Text('Верхний пользовательский виджет'));
    when(
      () => mockAlgorithm.buildBottomMenuWidget(),
    ).thenReturn(const Text('Нижний пользовательский виджет'));

    // Создаем стратегию расчетов
    calculateStrategy = GenericCalculateStrategy(mockAlgorithm);

    // Создаем FlowBuilder
    flowBuilder = FlowBuilder<FlowDrawData>(
      name: 'Test Custom Element Flow',
      dataStrategy: mockDataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: mockDrawStrategy,
    );

    // Настраиваем мок стратегии данных
    when(() => mockDataStrategy.buildWidget()).thenReturn(Container());
  });

  group('FlowBuilder с AlgorithmWithCustomElement', () {
    test('должен правильно определять наличие AlgorithmWithCustomElement', () {
      // Act
      final hasCustomElement = flowBuilder.hasCustomElement();

      // Assert
      expect(hasCustomElement, isTrue);
    });

    test('должен получать верхний пользовательский виджет из алгоритма', () {
      // Act
      final topMenuWidget = flowBuilder.buildTopMenuWidget();

      // Assert
      expect(topMenuWidget, isNotNull);
      expect(topMenuWidget, isA<Text>());
      expect((topMenuWidget as Text).data, 'Верхний пользовательский виджет');
      verify(() => mockAlgorithm.buildTopMenuWidget()).called(1);
    });

    test('должен получать нижний пользовательский виджет из алгоритма', () {
      // Act
      final bottomMenuWidget = flowBuilder.buildBottomMenuWidget();

      // Assert
      expect(bottomMenuWidget, isNotNull);
      expect(bottomMenuWidget, isA<Text>());
      expect((bottomMenuWidget as Text).data, 'Нижний пользовательский виджет');
      verify(() => mockAlgorithm.buildBottomMenuWidget()).called(1);
    });

    testWidgets('должен включать пользовательские виджеты в UI', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(body: flowBuilder.buildDataWidget()),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      expect(find.text('Верхний пользовательский виджет'), findsOneWidget);
      expect(find.text('Нижний пользовательский виджет'), findsOneWidget);
    });
  });

  group('FlowBuilder без AlgorithmWithCustomElement', () {
    late MockFormsDataModel mockDataModel;
    late MockFlowDataStrategy mockDataStrategy;
    late MockFlowDrawStrategy mockDrawStrategy;
    late GenericCalculateStrategy<FlowDrawData> calculateStrategy;
    late FlowBuilder<FlowDrawData> flowBuilder;
    late MockStandardAlgorithm mockStandardAlgorithm;

    setUp(() {
      mockStandardAlgorithm = MockStandardAlgorithm();
      mockDataModel = MockFormsDataModel();
      mockDataStrategy = MockFlowDataStrategy();
      mockDrawStrategy = MockFlowDrawStrategy();

      // Настраиваем мок стандартного алгоритма
      when(
        () => mockStandardAlgorithm.getDataModel(),
      ).thenReturn(mockDataModel);

      // Создаем стратегию расчетов
      calculateStrategy = GenericCalculateStrategy(mockStandardAlgorithm);

      // Создаем FlowBuilder
      flowBuilder = FlowBuilder<FlowDrawData>(
        name: 'Test Standard Flow',
        dataStrategy: mockDataStrategy,
        calculateStrategy: calculateStrategy,
        drawStrategy: mockDrawStrategy,
      );

      // Настраиваем мок стратегии данных
      when(() => mockDataStrategy.buildWidget()).thenReturn(Container());
    });

    test('не должен определять наличие AlgorithmWithCustomElement', () {
      // Act
      final hasCustomElement = flowBuilder.hasCustomElement();

      // Assert
      expect(hasCustomElement, isFalse);
    });

    test('должен возвращать null для верхнего пользовательского виджета', () {
      // Act
      final topMenuWidget = flowBuilder.buildTopMenuWidget();

      // Assert
      expect(topMenuWidget, isNull);
    });

    test('должен возвращать null для нижнего пользовательского виджета', () {
      // Act
      final bottomMenuWidget = flowBuilder.buildBottomMenuWidget();

      // Assert
      expect(bottomMenuWidget, isNull);
    });

    testWidgets('не должен включать пользовательские виджеты в UI', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(body: flowBuilder.buildDataWidget()),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      expect(find.text('Верхний пользовательский виджет'), findsNothing);
      expect(find.text('Нижний пользовательский виджет'), findsNothing);
    });
  });

  group('AlgorithmFlowBuilderFactory с AlgorithmWithCustomElement', () {
    test(
      'должен создавать FlowBuilder с поддержкой пользовательских виджетов',
      () {
        // Arrange
        final factory = AlgorithmFlowBuilderFactory(
          mockAlgorithm,
          name: 'Factory Test',
        );

        // Act
        final createdFlowBuilder = factory.create();

        // Assert
        expect(createdFlowBuilder, isNotNull);
        expect(createdFlowBuilder.hasCustomElement(), isTrue);
        expect(createdFlowBuilder.buildTopMenuWidget(), isNotNull);
        expect(createdFlowBuilder.buildBottomMenuWidget(), isNotNull);
      },
    );
  });
}
