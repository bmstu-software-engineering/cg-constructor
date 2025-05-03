import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/flow.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

// Моки для тестирования
class MockViewer extends Mock implements Viewer {}

void main() {
  setUpAll(() {
    // Регистрируем фиктивное значение для FlowDrawData
    registerFallbackValue(const FlowDrawData(points: [], lines: []));
  });

  late MockViewer mockViewer;
  late ViewerFlowDrawStrategy drawStrategy;

  setUp(() {
    mockViewer = MockViewer();
    drawStrategy = ViewerFlowDrawStrategy(mockViewer);
  });

  group('ViewerFlowDrawStrategy', () {
    test('should call viewer draw method with correct parameters', () async {
      // Arrange
      final drawData = FlowDrawData(
        points: [const Point(x: 1, y: 2)],
        lines: [const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))],
      );
      when(() => mockViewer.draw(any(), any())).thenAnswer((_) async {});

      // Act
      await drawStrategy.draw(drawData);

      // Assert
      verify(() => mockViewer.draw(drawData.lines, drawData.points)).called(1);
    });

    test('should propagate exceptions from viewer', () async {
      // Arrange
      final drawData = FlowDrawData(
        points: [const Point(x: 1, y: 2)],
        lines: [const Line(a: Point(x: 1, y: 2), b: Point(x: 3, y: 4))],
      );
      when(
        () => mockViewer.draw(any(), any()),
      ).thenThrow(Exception('Viewer error'));

      // Act & Assert
      expect(
        () => drawStrategy.draw(drawData),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Viewer error'),
          ),
        ),
      );
      verify(() => mockViewer.draw(drawData.lines, drawData.points)).called(1);
    });

    testWidgets('should build viewer widget correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testWidget = Container(key: const Key('viewerWidget'));
      when(() => mockViewer.buildWidget()).thenReturn(testWidget);

      // Act
      final widget = drawStrategy.buildWidget();

      // Assert
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      expect(find.byKey(const Key('viewerWidget')), findsOneWidget);
      verify(() => mockViewer.buildWidget()).called(1);
    });
  });
}
