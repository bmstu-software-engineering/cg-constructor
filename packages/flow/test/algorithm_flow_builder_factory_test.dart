import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:flow/algorithm_flow_builder_factory.dart';
import 'package:mocktail/mocktail.dart';
import 'package:viewer/viewer.dart';

// Моки для тестирования
class MockVariatedAlgorithm extends Mock implements VariatedAlgorithm {}

class MockAlgorithm extends Mock implements Algorithm {}

class MockFormsDataModel extends Mock implements FormsDataModel {
  @override
  DynamicFormModel get config =>
      DynamicFormModel(config: FormConfig(fields: [], name: 'test_form'));

  @override
  AlgorithmData get data => MockAlgorithmData();
}

class MockAlgorithmData extends Mock implements AlgorithmData {}

class MockViewerFactory extends Mock implements ViewerFactory {}

class MockViewer extends Mock implements Viewer {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData());
  });

  late MockVariatedAlgorithm mockVariatedAlgorithm;
  late MockAlgorithm mockStandardAlgorithm;
  late MockFormsDataModel mockFormsDataModel;
  late MockViewerFactory mockViewerFactory;
  late MockViewer mockViewer;

  setUp(() {
    mockVariatedAlgorithm = MockVariatedAlgorithm();
    mockStandardAlgorithm = MockAlgorithm();
    mockFormsDataModel = MockFormsDataModel();
    mockViewerFactory = MockViewerFactory();
    mockViewer = MockViewer();

    // Настраиваем моки
    when(
      () => mockVariatedAlgorithm.getDataModel(),
    ).thenReturn(mockFormsDataModel);
    when(
      () => mockStandardAlgorithm.getDataModel(),
    ).thenReturn(mockFormsDataModel);
    when(
      () => mockViewerFactory.create(showCoordinates: true),
    ).thenReturn(mockViewer);
    when(() => mockViewer.buildWidget()).thenReturn(Container());

    // Настраиваем варианты для VariatedAlgorithm
    when(() => mockVariatedAlgorithm.getAvailableVariants()).thenReturn([
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
    ]);
  });

  group('AlgorithmFlowBuilderFactory с VariatedAlgorithm', () {
    test('должен создавать FlowBuilder с правильным именем', () {
      // Arrange & Act
      final factory = AlgorithmFlowBuilderFactory(
        mockVariatedAlgorithm,
        name: 'Тестовый Flow',
      );
      final flowBuilder = factory.create();

      // Assert
      expect(flowBuilder.name, equals('Тестовый Flow'));
    });

    test('должен использовать имя алгоритма, если имя не указано', () {
      // Arrange & Act
      final factory = AlgorithmFlowBuilderFactory(mockVariatedAlgorithm);
      final flowBuilder = factory.create();

      // Assert
      expect(flowBuilder.name, equals('MockVariatedAlgorithm'));
    });

    test(
      'должен добавлять действия из VariatedAlgorithm, если useAlgorithmActions=true',
      () {
        // Arrange
        final factory = AlgorithmFlowBuilderFactory(
          mockVariatedAlgorithm,
          useAlgorithmActions: true,
        );

        // Act
        final flowBuilder = factory.create();

        // Проверяем, что действия были добавлены, создав виджет
        final widget = flowBuilder.buildDataWidget();

        // Assert
        expect(widget, isNotNull);
        verify(() => mockVariatedAlgorithm.getAvailableVariants()).called(1);
      },
    );

    test(
      'не должен добавлять действия из VariatedAlgorithm, если useAlgorithmActions=false',
      () {
        // Arrange
        final factory = AlgorithmFlowBuilderFactory(
          mockVariatedAlgorithm,
          useAlgorithmActions: false,
        );

        // Act
        final flowBuilder = factory.create();

        // Проверяем, что действия не были добавлены, создав виджет
        final widget = flowBuilder.buildDataWidget();

        // Assert
        expect(widget, isNotNull);
        verifyNever(() => mockVariatedAlgorithm.getAvailableVariants());
      },
    );

    test('должен добавлять пользовательские действия', () {
      // Arrange
      final customActions = [
        FlowAction(label: 'Пользовательское действие', action: (_) async {}),
      ];

      final factory = AlgorithmFlowBuilderFactory(
        mockVariatedAlgorithm,
        actions: customActions,
      );

      // Act
      final flowBuilder = factory.create();

      // Проверяем, что действия были добавлены, создав виджет
      final widget = flowBuilder.buildDataWidget();

      // Assert
      expect(widget, isNotNull);
    });

    test('должен использовать указанную ViewerFactory', () {
      // Arrange
      final factory = AlgorithmFlowBuilderFactory(
        mockVariatedAlgorithm,
        viewerFactory: mockViewerFactory,
      );

      // Act
      final flowBuilder = factory.create();

      // Проверяем, что Viewer был создан с помощью фабрики
      final viewerWidget = flowBuilder.buildViewerWidget();

      // Assert
      expect(viewerWidget, isNotNull);
      verify(() => mockViewerFactory.create(showCoordinates: true)).called(1);
    });
  });

  group('AlgorithmFlowBuilderFactory со стандартным Algorithm', () {
    test('должен создавать FlowBuilder со стандартным алгоритмом', () {
      // Arrange
      final factory = AlgorithmFlowBuilderFactory(mockStandardAlgorithm);

      // Act
      final flowBuilder = factory.create();

      // Assert
      expect(flowBuilder, isNotNull);
      expect(flowBuilder.name, equals('MockAlgorithm'));
    });

    test('должен добавлять стандартное действие для обычного алгоритма', () {
      // Arrange
      final factory = AlgorithmFlowBuilderFactory(
        mockStandardAlgorithm,
        useAlgorithmActions: true,
      );

      // Act
      final flowBuilder = factory.create();

      // Проверяем, что действие было добавлено, создав виджет
      final widget = flowBuilder.buildDataWidget();

      // Assert
      expect(widget, isNotNull);
    });
  });
}
