import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

// Моки для тестирования
class MockViewer extends Mock implements Viewer {}

class MockFigureCollection extends Mock implements FigureCollection {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивные значения для FlowDrawData
    registerFallbackValue(const FlowDrawData(points: [], lines: []));
    registerFallbackValue(MockFigureCollection());
  });

  late MockViewer mockViewer;
  late ViewerFlowDrawStrategy drawStrategy;
  late MockFigureCollection mockFigureCollection;

  setUp(() {
    mockViewer = MockViewer();
    drawStrategy = ViewerFlowDrawStrategy(mockViewer);
    mockFigureCollection = MockFigureCollection();
  });

  group('ViewerFlowDrawStrategy с ViewerResultModelV2', () {
    test(
      'должен вызывать метод drawCollection, когда figureCollection не null',
      () async {
        // Arrange
        final drawData = FlowDrawData(figureCollection: mockFigureCollection);
        when(() => mockViewer.drawCollection(any())).thenAnswer((_) async {});

        // Act
        await drawStrategy.draw(drawData);

        // Assert
        verify(() => mockViewer.drawCollection(mockFigureCollection)).called(1);
        verifyNever(() => mockViewer.draw(any(), any()));
      },
    );

    test('должен вызывать метод draw, когда figureCollection null', () async {
      // Arrange
      final testPoints = [const Point(x: 1, y: 2)];
      final testLines = [
        const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4)),
      ];
      final drawData = FlowDrawData(points: testPoints, lines: testLines);
      when(() => mockViewer.draw(any(), any())).thenAnswer((_) async {});

      // Act
      await drawStrategy.draw(drawData);

      // Assert
      verify(() => mockViewer.draw(testLines, testPoints)).called(1);
      verifyNever(() => mockViewer.drawCollection(any()));
    });

    test('должен обрабатывать исключения из метода drawCollection', () async {
      // Arrange
      final drawData = FlowDrawData(figureCollection: mockFigureCollection);
      when(
        () => mockViewer.drawCollection(any()),
      ).thenThrow(Exception('Ошибка при отрисовке коллекции'));

      // Act & Assert
      expect(
        () => drawStrategy.draw(drawData),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Ошибка при отрисовке коллекции'),
          ),
        ),
      );
      verify(() => mockViewer.drawCollection(mockFigureCollection)).called(1);
    });

    test(
      'должен корректно обрабатывать смешанные данные (и figureCollection, и points/lines)',
      () async {
        // Arrange
        final testPoints = [const Point(x: 1, y: 2)];
        final testLines = [
          const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4)),
        ];
        final drawData = FlowDrawData(
          points: testPoints,
          lines: testLines,
          figureCollection: mockFigureCollection,
        );
        when(() => mockViewer.drawCollection(any())).thenAnswer((_) async {});

        // Act
        await drawStrategy.draw(drawData);

        // Assert
        // Должен использовать drawCollection, даже если points и lines тоже присутствуют
        verify(() => mockViewer.drawCollection(mockFigureCollection)).called(1);
        verifyNever(() => mockViewer.draw(any(), any()));
      },
    );
  });
}
