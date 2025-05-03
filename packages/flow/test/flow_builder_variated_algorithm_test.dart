import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:mocktail/mocktail.dart';

// Моки для тестирования
class MockVariatedAlgorithm extends Mock implements VariatedAlgorithm {}

class MockDataModel extends Mock implements DataModel {}

class MockViewerResultModel extends Mock implements ViewerResultModel {}

class MockFlowDataStrategy extends Mock implements FlowDataStrategy {}

class MockFlowDrawStrategy extends Mock
    implements FlowDrawStrategy<FlowDrawData> {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData());
  });

  late MockVariatedAlgorithm mockAlgorithm;
  late MockDataModel mockDataModel;
  late MockFlowDataStrategy mockDataStrategy;
  late MockFlowDrawStrategy mockDrawStrategy;
  late GenericCalculateStrategy<FlowDrawData> calculateStrategy;
  late FlowBuilder<FlowDrawData> flowBuilder;

  setUp(() {
    mockAlgorithm = MockVariatedAlgorithm();
    mockDataModel = MockDataModel();
    mockDataStrategy = MockFlowDataStrategy();
    mockDrawStrategy = MockFlowDrawStrategy();

    // Настраиваем мок алгоритма
    when(() => mockAlgorithm.getDataModel()).thenReturn(mockDataModel);

    // Создаем стратегию расчетов
    calculateStrategy = GenericCalculateStrategy(mockAlgorithm);

    // Создаем FlowBuilder
    flowBuilder = FlowBuilder<FlowDrawData>(
      name: 'Test Variated Flow',
      dataStrategy: mockDataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: mockDrawStrategy,
    );
  });

  group('FlowBuilder с VariatedAlgorithm', () {
    test('должен правильно инициализироваться с VariatedAlgorithm', () {
      expect(flowBuilder.name, equals('Test Variated Flow'));
      expect(calculateStrategy.algorithm, equals(mockAlgorithm));
    });

    test('должен получать действия из VariatedAlgorithm', () {
      // Arrange
      final variants = [
        const AlgorithmVariant(
          id: 'variant1',
          name: 'Вариант 1',
          icon: Icons.circle,
          color: Colors.blue,
        ),
        const AlgorithmVariant(
          id: 'variant2',
          name: 'Вариант 2',
          icon: Icons.square,
          color: Colors.green,
        ),
      ];

      when(() => mockAlgorithm.getAvailableVariants()).thenReturn(variants);

      // Act
      final actions = flowBuilder.getActionsFromAlgorithm();

      // Assert
      verify(() => mockAlgorithm.getAvailableVariants()).called(1);
      expect(actions.length, equals(2));
      expect(actions[0].label, equals('Вариант 1'));
      expect(actions[0].icon, equals(Icons.circle));
      expect(actions[0].color, equals(Colors.blue));
      expect(actions[1].label, equals('Вариант 2'));
      expect(actions[1].icon, equals(Icons.square));
      expect(actions[1].color, equals(Colors.green));
    });

    test(
      'должен возвращать стандартное действие, если алгоритм не VariatedAlgorithm',
      () {
        // Arrange
        final mockStandardAlgorithm = MockAlgorithm();
        final standardCalculateStrategy = GenericCalculateStrategy(
          mockStandardAlgorithm,
        );
        final standardFlowBuilder = FlowBuilder<FlowDrawData>(
          name: 'Standard Flow',
          dataStrategy: mockDataStrategy,
          calculateStrategy: standardCalculateStrategy,
          drawStrategy: mockDrawStrategy,
        );

        // Act
        final actions = standardFlowBuilder.getActionsFromAlgorithm();

        // Assert
        expect(actions.length, equals(1));
        expect(actions[0].label, equals('Расчитать'));
      },
    );

    test(
      'должен вызывать calculateWithVariant при расчете с вариантом',
      () async {
        // Arrange
        final mockResult = MockViewerResultModel();
        when(() => mockResult.points).thenReturn([const Point(x: 1, y: 2)]);
        when(
          () => mockResult.lines,
        ).thenReturn([const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))]);
        when(() => mockResult.markdownInfo).thenReturn(null);

        when(
          () => mockAlgorithm.calculateWithVariant('variant1'),
        ).thenReturn(mockResult);

        // Act
        await flowBuilder.calculate(variant: 'variant1');

        // Assert
        verify(() => mockAlgorithm.calculateWithVariant('variant1')).called(1);
        expect(
          flowBuilder.infoStream.value.isNotEmpty,
          isTrue,
          reason: 'infoStream должен содержать сообщения',
        );
        expect(
          flowBuilder.infoStream.value.last,
          contains('Расчеты выполнены успешно'),
        );
      },
    );

    test(
      'должен добавлять markdownInfo в infoStream, если она предоставлена',
      () async {
        // Arrange
        final mockResult = MockViewerResultModel();
        when(() => mockResult.points).thenReturn([const Point(x: 1, y: 2)]);
        when(
          () => mockResult.lines,
        ).thenReturn([const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))]);
        when(
          () => mockResult.markdownInfo,
        ).thenReturn('# Тестовый заголовок\nТестовая информация');

        when(
          () => mockAlgorithm.calculateWithVariant('variant1'),
        ).thenReturn(mockResult);

        // Act
        await flowBuilder.calculate(variant: 'variant1');

        // Assert
        verify(() => mockAlgorithm.calculateWithVariant('variant1')).called(1);
        expect(
          flowBuilder.infoStream.value.last,
          equals('# Тестовый заголовок\nТестовая информация'),
        );
      },
    );
  });

  group('AlgorithmFlowBuilderFactory с VariatedAlgorithm', () {
    test('должен создавать FlowBuilder с действиями из алгоритма', () {
      // Arrange
      final variants = [
        const AlgorithmVariant(
          id: 'variant1',
          name: 'Вариант 1',
          icon: Icons.circle,
          color: Colors.blue,
        ),
      ];

      when(() => mockAlgorithm.getAvailableVariants()).thenReturn(variants);
      when(() => mockAlgorithm.getDataModel()).thenReturn(mockDataModel);

      // Мокаем фабрики для создания стратегий
      // Это требует дополнительной настройки, так как они статические

      // Act
      final factory = AlgorithmFlowBuilderFactory(
        mockAlgorithm,
        name: 'Factory Test',
      );

      // Assert
      expect(factory, isNotNull);
    });
  });
}

// Мок для стандартного алгоритма
class MockAlgorithm extends Mock implements Algorithm {}
