import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_ns/models_ns.dart';

// Моки для стратегий
class MockFlowDataStrategy extends Mock implements FlowDataStrategy {}

class MockFlowCalculateStrategy extends Mock
    implements FlowCalculateStrategy<FlowDrawData> {}

class MockFlowDrawStrategy extends Mock
    implements FlowDrawStrategy<FlowDrawData> {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData(points: [], lines: []));
  });
  late MockFlowDataStrategy mockDataStrategy;
  late MockFlowCalculateStrategy mockCalculateStrategy;
  late MockFlowDrawStrategy mockDrawStrategy;
  late FlowBuilder<FlowDrawData> flowBuilder;

  setUp(() {
    mockDataStrategy = MockFlowDataStrategy();
    mockCalculateStrategy = MockFlowCalculateStrategy();
    mockDrawStrategy = MockFlowDrawStrategy();

    flowBuilder = FlowBuilder<FlowDrawData>(
      name: 'Test Flow',
      dataStrategy: mockDataStrategy,
      calculateStrategy: mockCalculateStrategy,
      drawStrategy: mockDrawStrategy,
    );
  });

  group('FlowBuilder', () {
    test('should initialize with correct values', () {
      expect(flowBuilder.name, equals('Test Flow'));
      expect(flowBuilder.infoStream.value, equals([]));
    });

    test(
      'should call calculate strategy and add success message to infoStream',
      () async {
        // Arrange
        final mockDrawData = FlowDrawData(
          points: [const Point(x: 1, y: 2)],
          lines: [const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))],
        );
        when(
          () => mockCalculateStrategy.calculate(),
        ).thenAnswer((_) async => mockDrawData);

        // Act
        await flowBuilder.calculate();

        // Assert
        verify(() => mockCalculateStrategy.calculate()).called(1);
        expect(flowBuilder.infoStream.value.last, contains('успешно'));
      },
    );

    test(
      'should handle calculate error and add error message to infoStream',
      () async {
        // Arrange
        when(
          () => mockCalculateStrategy.calculate(),
        ).thenThrow(CalculationException('Test error'));

        // Act & Assert
        await expectLater(
          flowBuilder.calculate(),
          throwsA(isA<CalculationException>()),
        );

        // Проверяем, что сообщение об ошибке было добавлено в infoStream
        // Добавляем небольшую задержку, чтобы убедиться, что сообщение было добавлено
        await Future.delayed(const Duration(milliseconds: 10));
        expect(flowBuilder.infoStream.value.isNotEmpty, isTrue);
        expect(flowBuilder.infoStream.value.last, contains('Ошибка'));
      },
    );

    test(
      'should call draw strategy and add success message to infoStream',
      () async {
        // Arrange
        final mockDrawData = FlowDrawData(
          points: [const Point(x: 1, y: 2)],
          lines: [const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))],
        );
        when(
          () => mockCalculateStrategy.calculate(),
        ).thenAnswer((_) async => mockDrawData);
        when(() => mockDrawStrategy.draw(any())).thenAnswer((_) async {});

        // Act
        await flowBuilder.calculate();
        await flowBuilder.draw();

        // Assert
        verify(() => mockDrawStrategy.draw(any())).called(1);
        expect(flowBuilder.infoStream.value.last, contains('успешно'));
      },
    );

    test(
      'should handle draw error and add error message to infoStream',
      () async {
        // Arrange
        final mockDrawData = FlowDrawData(
          points: [const Point(x: 1, y: 2)],
          lines: [const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))],
        );
        when(
          () => mockCalculateStrategy.calculate(),
        ).thenAnswer((_) async => mockDrawData);
        when(
          () => mockDrawStrategy.draw(any()),
        ).thenThrow(Exception('Test error'));

        // Act
        await flowBuilder.calculate();

        // Assert
        await expectLater(flowBuilder.draw(), throwsA(isA<Exception>()));

        // Проверяем, что сообщение об ошибке было добавлено в infoStream
        // Добавляем небольшую задержку, чтобы убедиться, что сообщение было добавлено
        await Future.delayed(const Duration(milliseconds: 10));
        expect(flowBuilder.infoStream.value.length >= 2, isTrue);
        expect(flowBuilder.infoStream.value.last, contains('Ошибка'));
      },
    );

    testWidgets('should build data widget correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testWidget = Container(key: const Key('dataWidget'));
      when(() => mockDataStrategy.buildWidget()).thenReturn(testWidget);

      // Act
      final widget = flowBuilder.buildDataWidget();

      // Assert
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byKey(const Key('dataWidget')), findsOneWidget);
      verify(() => mockDataStrategy.buildWidget()).called(1);
    });

    testWidgets('should build viewer widget correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testWidget = Container(key: const Key('viewerWidget'));
      when(() => mockDrawStrategy.buildWidget()).thenReturn(testWidget);

      // Act
      final widget = flowBuilder.buildViewerWidget();

      // Assert
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byKey(const Key('viewerWidget')), findsOneWidget);
      verify(() => mockDrawStrategy.buildWidget()).called(1);
    });

    test('should close infoStream when dispose is called', () {
      // Act
      flowBuilder.dispose();

      // Assert
      expect(flowBuilder.infoStream.isClosed, isTrue);
    });
  });
}
