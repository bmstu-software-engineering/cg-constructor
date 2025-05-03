import 'package:alogrithms/alogrithms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:mocktail/mocktail.dart';

// Моки для тестирования
class MockVariatedAlgorithm extends Mock implements VariatedAlgorithm {}

class MockViewerResultModel extends Mock implements ViewerResultModel {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData());
  });

  late MockVariatedAlgorithm mockAlgorithm;
  late GenericCalculateStrategy<FlowDrawData> calculateStrategy;
  late MockViewerResultModel mockDefaultResult;
  late MockViewerResultModel mockVariant1Result;
  late MockViewerResultModel mockVariant2Result;

  setUp(() {
    mockAlgorithm = MockVariatedAlgorithm();
    calculateStrategy = GenericCalculateStrategy(mockAlgorithm);

    // Создаем мок-результаты для разных вариантов
    mockDefaultResult = MockViewerResultModel();
    mockVariant1Result = MockViewerResultModel();
    mockVariant2Result = MockViewerResultModel();

    // Настраиваем мок-результаты
    when(() => mockDefaultResult.points).thenReturn([const Point(x: 0, y: 0)]);
    when(() => mockDefaultResult.lines).thenReturn([]);
    when(
      () => mockDefaultResult.markdownInfo,
    ).thenReturn('Стандартный результат');

    when(() => mockVariant1Result.points).thenReturn([const Point(x: 1, y: 1)]);
    when(
      () => mockVariant1Result.lines,
    ).thenReturn([const Line(a: Point(x: 1, y: 1), b: Point(x: 2, y: 2))]);
    when(
      () => mockVariant1Result.markdownInfo,
    ).thenReturn('Результат варианта 1');

    when(() => mockVariant2Result.points).thenReturn([const Point(x: 3, y: 3)]);
    when(
      () => mockVariant2Result.lines,
    ).thenReturn([const Line(a: Point(x: 3, y: 3), b: Point(x: 4, y: 4))]);
    when(
      () => mockVariant2Result.markdownInfo,
    ).thenReturn('Результат варианта 2');

    // Настраиваем мок алгоритма
    when(() => mockAlgorithm.calculate()).thenReturn(mockDefaultResult);
    when(
      () => mockAlgorithm.calculateWithVariant('variant1'),
    ).thenReturn(mockVariant1Result);
    when(
      () => mockAlgorithm.calculateWithVariant('variant2'),
    ).thenReturn(mockVariant2Result);
  });

  group('GenericCalculateStrategy с VariatedAlgorithm', () {
    test('должен вызывать calculate() для стандартного расчета', () async {
      // Arrange
      when(
        () => mockAlgorithm.calculateWithVariant(any()),
      ).thenReturn(mockDefaultResult);

      // Act
      final result = await calculateStrategy.calculate();

      // Assert
      // В реализации GenericCalculateStrategy для VariatedAlgorithm
      // вызывается calculateWithVariant(null) вместо calculate()
      verify(() => mockAlgorithm.calculateWithVariant(null)).called(1);
      expect(result, isA<FlowDrawData>());
      expect(result.points, equals([const Point(x: 0, y: 0)]));
      expect(result.lines, equals([]));
      expect(result.markdownInfo, equals('Стандартный результат'));
    });

    test(
      'должен вызывать calculateWithVariant() для расчета с вариантом',
      () async {
        // Act
        final result = await calculateStrategy.calculate(variant: 'variant1');

        // Assert
        verify(() => mockAlgorithm.calculateWithVariant('variant1')).called(1);
        verifyNever(() => mockAlgorithm.calculate());
        expect(result, isA<FlowDrawData>());
        expect(result.points, equals([const Point(x: 1, y: 1)]));
        expect(
          result.lines,
          equals([const Line(a: Point(x: 1, y: 1), b: Point(x: 2, y: 2))]),
        );
        expect(result.markdownInfo, equals('Результат варианта 1'));
      },
    );

    test('должен корректно обрабатывать разные варианты', () async {
      // Act - Вариант 1
      final result1 = await calculateStrategy.calculate(variant: 'variant1');

      // Assert - Вариант 1
      verify(() => mockAlgorithm.calculateWithVariant('variant1')).called(1);
      expect(result1.markdownInfo, equals('Результат варианта 1'));

      // Act - Вариант 2
      final result2 = await calculateStrategy.calculate(variant: 'variant2');

      // Assert - Вариант 2
      verify(() => mockAlgorithm.calculateWithVariant('variant2')).called(1);
      expect(result2.markdownInfo, equals('Результат варианта 2'));
    });

    test('должен пробрасывать исключения от алгоритма', () async {
      // Arrange
      when(
        () => mockAlgorithm.calculateWithVariant('error'),
      ).thenThrow(CalculationException('Тестовая ошибка'));

      // Act & Assert
      expect(
        () => calculateStrategy.calculate(variant: 'error'),
        throwsA(isA<CalculationException>()),
      );
    });

    test('должен возвращать алгоритм через геттер', () {
      // Act & Assert
      expect(calculateStrategy.algorithm, equals(mockAlgorithm));
    });
  });

  group('CalculateStrategyFactory', () {
    test('должен создавать GenericCalculateStrategy', () {
      // Act
      final strategy = CalculateStrategyFactory.createCalculateStrategy(
        mockAlgorithm,
      );

      // Assert
      expect(strategy, isA<GenericCalculateStrategy>());
      expect(
        (strategy as GenericCalculateStrategy).algorithm,
        equals(mockAlgorithm),
      );
    });
  });
}
