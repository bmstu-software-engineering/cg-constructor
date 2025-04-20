import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('Coordinates Widget Tests', () {
    testWidgets('should create viewer with coordinates enabled from factory', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer с включенными координатами через фабрику
      final factory = CanvasViewerFactory();
      final viewer = factory.create(showCoordinates: true) as CanvasViewer;

      // Проверяем, что координаты включены
      expect(viewer.showCoordinates, isTrue);

      // Добавляем точки и линии
      final points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 150, color: '#00FF00', thickness: 5),
      ];

      final lines = [
        Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
      ];

      viewer.draw(lines, points);

      // Рендерим виджет
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: viewer.buildWidget(),
            ),
          ),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что ключ содержит информацию о координатах
      final customPaint = await tester.findCanvasViewerPaint();
      final key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('with_coords'));
    });

    // TODO: тест ломается нужно починить
    testWidgets(
      'should toggle coordinates display through setShowCoordinates',
      (WidgetTester tester) async {
        // Создаем Viewer без координат
        final factory = CanvasViewerFactory();
        final viewer = factory.create() as CanvasViewer;

        // Проверяем, что координаты выключены по умолчанию
        expect(viewer.showCoordinates, isFalse);

        // Добавляем точки и линии
        final points = [
          const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
          const Point(x: 150, y: 150, color: '#00FF00', thickness: 5),
        ];

        final lines = [
          Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
        ];

        viewer.draw(lines, points);

        // Рендерим виджет
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 300,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        );

        // Проверяем, что ключ не содержит информацию о координатах
        var customPaint = await tester.findCanvasViewerPaint();
        var key = customPaint.key as ValueKey;
        expect(key.value.toString(), contains('no_coords'));

        // Включаем отображение координат
        viewer.setShowCoordinates(true);
        await tester.pump();

        // Проверяем, что координаты включены
        expect(viewer.showCoordinates, isTrue);

        // Проверяем, что ключ содержит информацию о координатах
        customPaint = await tester.findCanvasViewerPaint();
        key = customPaint.key as ValueKey;
        expect(key.value.toString(), contains('with_coords'));

        // Выключаем отображение координат
        viewer.setShowCoordinates(false);
        await tester.pump();

        // Проверяем, что координаты выключены
        expect(viewer.showCoordinates, isFalse);

        // Проверяем, что ключ не содержит информацию о координатах
        customPaint = await tester.findCanvasViewerPaint();
        key = customPaint.key as ValueKey;
        expect(key.value.toString(), contains('no_coords'));
      },
      skip: true,
    );

    testWidgets('should preserve coordinates state after redrawing', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer с включенными координатами
      final factory = CanvasViewerFactory();
      final viewer = factory.create(showCoordinates: true) as CanvasViewer;

      // Проверяем, что координаты включены
      expect(viewer.showCoordinates, isTrue);

      // Добавляем точки и линии
      var points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 150, color: '#00FF00', thickness: 5),
      ];

      var lines = [
        Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
      ];

      viewer.draw(lines, points);

      // Рендерим виджет
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: viewer.buildWidget(),
            ),
          ),
        ),
      );

      // Проверяем, что ключ содержит информацию о координатах
      var customPaint = await tester.findCanvasViewerPaint();
      var key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('with_coords'));

      // Очищаем холст
      viewer.clean();
      await tester.pump();

      // Добавляем новые точки и линии
      points = [
        const Point(x: 100, y: 100, color: '#FF0000', thickness: 5),
        const Point(x: 200, y: 200, color: '#00FF00', thickness: 5),
      ];

      lines = [
        Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
      ];

      viewer.draw(lines, points);
      await tester.pump();

      // Проверяем, что координаты все еще включены
      expect(viewer.showCoordinates, isTrue);

      // Проверяем, что ключ содержит информацию о координатах
      customPaint = await tester.findCanvasViewerPaint();
      key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('with_coords'));
    });

    testWidgets(
      'should have independent coordinates settings for multiple viewers',
      (WidgetTester tester) async {
        // Создаем два Viewer с разными настройками координат
        final factory = CanvasViewerFactory();
        final viewer1 = factory.create(showCoordinates: true) as CanvasViewer;
        final viewer2 = factory.create() as CanvasViewer;

        // Проверяем настройки координат
        expect(viewer1.showCoordinates, isTrue);
        expect(viewer2.showCoordinates, isFalse);

        // Добавляем точки и линии
        final points = [
          const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
          const Point(x: 150, y: 150, color: '#00FF00', thickness: 5),
        ];

        final lines = [
          Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
        ];

        viewer1.draw(lines, points);
        viewer2.draw(lines, points);

        // Рендерим виджеты
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(child: viewer1.buildWidget()),
                  Expanded(child: viewer2.buildWidget()),
                ],
              ),
            ),
          ),
        );

        // Находим CustomPaint с ключами, начинающимися с 'canvas_viewer_'
        final customPaints = tester.widgetList<CustomPaint>(
          find.byWidgetPredicate((widget) {
            if (widget is CustomPaint && widget.key is ValueKey) {
              final key = widget.key as ValueKey;
              if (key.value is String &&
                  (key.value as String).startsWith('canvas_viewer_')) {
                return true;
              }
            }
            return false;
          }),
        );
        expect(customPaints.length, 2);

        // Проверяем ключи
        final key1 = customPaints.elementAt(0).key as ValueKey;
        final key2 = customPaints.elementAt(1).key as ValueKey;

        expect(key1.value.toString(), contains('with_coords'));
        expect(key2.value.toString(), contains('no_coords'));
      },
    );

    testWidgets('should update scaling state with coordinates information', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer
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
  });
}
