import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('Coordinates Display Tests', () {
    test('should toggle coordinates display', () {
      // Создаем тестовые данные
      final points = [const Point(x: 10, y: 20), const Point(x: 100, y: 150)];

      final lines = [
        Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
      ];

      // Создаем виджет для тестирования с выключенными координатами
      final factory = CanvasViewerFactory();
      final viewer = factory.create() as CanvasViewer;
      viewer.draw(lines, points);

      // По умолчанию координаты не отображаются
      expect(viewer.showCoordinates, isFalse);

      // Включаем отображение координат
      viewer.setShowCoordinates(true);
      expect(viewer.showCoordinates, isTrue);

      // Выключаем отображение координат
      viewer.setShowCoordinates(false);
      expect(viewer.showCoordinates, isFalse);

      // Создаем виджет с включенными координатами через фабрику
      final viewerWithCoords =
          factory.create(showCoordinates: true) as CanvasViewer;
      expect(viewerWithCoords.showCoordinates, isTrue);
    });

    test('should include coordinates state in diagnostic information', () {
      // Создаем тестовые данные
      final points = [const Point(x: 10, y: 20)];
      final viewer = ViewerTestUtils.createTestViewer(points: points);

      // Проверяем диагностическую информацию по умолчанию
      expect(viewer.toStringShort(), contains('showCoordinates: false'));

      // Включаем отображение координат
      viewer.setShowCoordinates(true);

      // Проверяем обновленную диагностическую информацию
      expect(viewer.toStringShort(), contains('showCoordinates: true'));

      // Проверяем, что информация о координатах есть в детальной диагностике
      final diagnostics = viewer.debugDescribeChildren();
      final coordsProperty = diagnostics.firstWhere(
        (node) => node.name == 'showCoordinates',
        orElse: () => throw Exception('showCoordinates property not found'),
      );
      expect(coordsProperty.value, isTrue);
    });

    test('should include coordinates state in scaling state', () {
      final viewer = ViewerTestUtils.createTestViewer();

      // Проверяем состояние масштабирования по умолчанию
      final defaultState = viewer.getScalingState();
      expect(defaultState.containsKey('showCoordinates'), isTrue);
      expect(defaultState['showCoordinates'], isFalse);

      // Включаем отображение координат
      viewer.setShowCoordinates(true);

      // Проверяем обновленное состояние масштабирования
      final updatedState = viewer.getScalingState();
      expect(updatedState['showCoordinates'], isTrue);
    });

    testWidgets('should render with coordinates visible', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 150, color: '#00FF00', thickness: 5),
      ];

      final lines = [
        Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
      ];

      // Создаем виджет для тестирования с включенными координатами
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
        showCoordinates: true,
      );

      // Рендерим виджет
      await tester.pumpWidget(
        ViewerTestUtils.createTestWidget(
          viewer: viewer,
          size: const Size(300, 300),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что ключ содержит информацию о координатах
      final customPaint = await tester.findCanvasViewerPaint();
      final key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('with_coords'));
    });
  });

  // Golden тесты требуют наличия эталонных изображений
  // Для их создания нужно запустить тесты с флагом --update-goldens
  // Например: flutter test --update-goldens test/coordinates_display_test.dart
}
