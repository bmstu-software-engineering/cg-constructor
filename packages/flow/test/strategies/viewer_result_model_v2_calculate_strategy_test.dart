import 'package:alogrithms/alogrithms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_ns/models_ns.dart';

// Моки для тестирования
class MockAlgorithm extends Mock implements Algorithm {}

class MockViewerResultModelV2 extends Mock implements ViewerResultModelV2 {}

class MockFigureCollection extends Mock implements FigureCollection {}

void main() {
  late MockAlgorithm mockAlgorithm;
  late GenericCalculateStrategy<FlowDrawData> calculateStrategy;
  late MockFigureCollection mockFigureCollection;

  setUp(() {
    mockAlgorithm = MockAlgorithm();
    calculateStrategy = GenericCalculateStrategy(mockAlgorithm);
    mockFigureCollection = MockFigureCollection();
  });

  group('GenericCalculateStrategy с ViewerResultModelV2', () {
    test(
      'должен корректно обрабатывать результат типа ViewerResultModelV2',
      () async {
        // Arrange
        final mockResult = MockViewerResultModelV2();
        when(
          () => mockResult.figureCollection,
        ).thenReturn(mockFigureCollection);
        when(() => mockResult.markdownInfo).thenReturn('Тестовая информация');
        when(() => mockAlgorithm.calculate()).thenReturn(mockResult);

        // Act
        final result = await calculateStrategy.calculate();

        // Assert
        verify(() => mockAlgorithm.calculate()).called(1);
        expect(result, isA<FlowDrawData>());
        expect(result.figureCollection, equals(mockFigureCollection));
        expect(result.markdownInfo, equals('Тестовая информация'));
      },
    );

    test(
      'должен корректно обрабатывать результат типа ViewerResultModelV2 без markdownInfo',
      () async {
        // Arrange
        final mockResult = MockViewerResultModelV2();
        when(
          () => mockResult.figureCollection,
        ).thenReturn(mockFigureCollection);
        when(() => mockResult.markdownInfo).thenReturn(null);
        when(() => mockAlgorithm.calculate()).thenReturn(mockResult);

        // Act
        final result = await calculateStrategy.calculate();

        // Assert
        verify(() => mockAlgorithm.calculate()).called(1);
        expect(result, isA<FlowDrawData>());
        expect(result.figureCollection, equals(mockFigureCollection));
        expect(result.markdownInfo, isNull);
      },
    );

    test(
      'должен корректно обрабатывать результат типа ViewerResultModel после добавления поддержки ViewerResultModelV2',
      () async {
        // Arrange
        final mockViewerResultModel = MockViewerResultModel();
        final testPoints = [const Point(x: 1, y: 2)];
        final testLines = [
          const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4)),
        ];

        when(() => mockViewerResultModel.points).thenReturn(testPoints);
        when(() => mockViewerResultModel.lines).thenReturn(testLines);
        when(
          () => mockViewerResultModel.markdownInfo,
        ).thenReturn('Тестовая информация для ViewerResultModel');
        when(() => mockAlgorithm.calculate()).thenReturn(mockViewerResultModel);

        // Act
        final result = await calculateStrategy.calculate();

        // Assert
        verify(() => mockAlgorithm.calculate()).called(1);
        expect(result, isA<FlowDrawData>());
        expect(result.points, equals(testPoints));
        expect(result.lines, equals(testLines));
        expect(
          result.markdownInfo,
          equals('Тестовая информация для ViewerResultModel'),
        );
        expect(result.figureCollection, isNull);
      },
    );
  });
}

// Мок для ViewerResultModel, необходимый для тестирования обратной совместимости
class MockViewerResultModel extends Mock implements ViewerResultModel {}
