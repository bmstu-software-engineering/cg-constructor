import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer', () {
    testWidgets('should render empty canvas', (WidgetTester tester) async {
      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer();

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();
    });

    testWidgets('should render points and lines', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = [Point(x: 0, y: 0), Point(x: 100, y: 100)];

      final lines = [Line(a: points[0], b: points[1])];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
      );

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();
    });

    test('should calculate bounding box correctly', () {
      // Создаем тестовые данные
      final points = [Point(x: 0, y: 0), Point(x: 100, y: 100)];

      final lines = [Line(a: points[0], b: points[1])];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
      );

      // Проверяем ограничивающий прямоугольник
      final boundingBox = viewer.boundingBox;
      expect(boundingBox, isNotNull);
      expect(boundingBox!.left, equals(0));
      expect(boundingBox.top, equals(0));
      expect(boundingBox.right, equals(100));
      expect(boundingBox.bottom, equals(100));
    });

    test('should clean canvas', () {
      // Создаем тестовые данные
      final points = [Point(x: 0, y: 0), Point(x: 100, y: 100)];

      final lines = [Line(a: points[0], b: points[1])];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
      );

      // Проверяем, что данные загружены
      expect(viewer.lines.length, equals(1));
      expect(viewer.points.length, equals(2));

      // Очищаем холст
      viewer.clean();

      // Проверяем, что данные очищены
      expect(viewer.lines.length, equals(0));
      expect(viewer.points.length, equals(0));
      expect(viewer.boundingBox, isNull);
    });

    test('should provide diagnostic information', () {
      // Создаем тестовые данные
      final points = [Point(x: 0, y: 0), Point(x: 100, y: 100)];

      final lines = [Line(a: points[0], b: points[1])];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
      );

      // Проверяем диагностическую информацию
      final diagnostics = viewer.debugDescribeChildren();
      expect(diagnostics, isNotEmpty);

      // Проверяем строковое представление
      final string = viewer.toStringShort();
      expect(string, contains('CanvasViewer'));
      expect(string, contains('lines: 1'));
      expect(string, contains('points: 2'));
    });
  });

  group('CanvasViewerFactory', () {
    test('should create CanvasViewer instance', () {
      final factory = CanvasViewerFactory();
      final viewer = factory.create();

      expect(viewer, isA<CanvasViewer>());
    });
  });
}
