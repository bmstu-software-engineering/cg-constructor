import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:flow/adapters/calculate_strategies.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_ns/models_ns.dart';
import 'package:alogrithms/alogrithms.dart';

// Моки для тестирования
class MockAlgorithm extends Mock implements Algorithm {}

class MockViewerResultModel extends Mock implements ViewerResultModel {}

// Мок для ResultModel, который не является ViewerResultModel
class MockResultModel extends Mock implements ResultModel {}

void main() {
  late MockAlgorithm mockAlgorithm;
  late GenericCalculateStrategy<FlowDrawData> calculateStrategy;

  setUp(() {
    mockAlgorithm = MockAlgorithm();
    calculateStrategy = GenericCalculateStrategy(mockAlgorithm);
  });

  group('GenericCalculateStrategy', () {
    test('should call algorithm calculate method', () async {
      // Arrange
      final mockResult = MockViewerResultModel();
      when(() => mockResult.points).thenReturn([const Point(x: 1, y: 2)]);
      when(
        () => mockResult.lines,
      ).thenReturn([const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))]);
      when(() => mockAlgorithm.calculate()).thenReturn(mockResult);

      // Act
      final result = await calculateStrategy.calculate();

      // Assert
      verify(() => mockAlgorithm.calculate()).called(1);
      expect(result, isA<FlowDrawData>());
      expect(result.points, equals([const Point(x: 1, y: 2)]));
      expect(
        result.lines,
        equals([const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))]),
      );
    });

    test(
      'should throw exception when algorithm returns invalid result type',
      () async {
        // Arrange
        final invalidResult = MockResultModel();
        when(() => mockAlgorithm.calculate()).thenReturn(invalidResult);

        // Act & Assert
        expect(
          () => calculateStrategy.calculate(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('ViewerResultModel'),
            ),
          ),
        );
        verify(() => mockAlgorithm.calculate()).called(1);
      },
    );

    test('should propagate exceptions from algorithm', () async {
      // Arrange
      when(
        () => mockAlgorithm.calculate(),
      ).thenThrow(Exception('Algorithm error'));

      // Act & Assert
      expect(
        () => calculateStrategy.calculate(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Algorithm error'),
          ),
        ),
      );
      verify(() => mockAlgorithm.calculate()).called(1);
    });
  });
}
