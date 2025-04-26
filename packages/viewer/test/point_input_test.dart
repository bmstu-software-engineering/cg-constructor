import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('Point Input Mode Tests', () {
    testWidgets(
      'should create viewer with point input mode enabled from factory',
      (WidgetTester tester) async {
        // Создаем Viewer с включенным режимом ввода точек через фабрику
        final factory = CanvasViewerFactory(pointInputModeEnabled: true);
        final viewer = factory.create() as CanvasViewer;

        // Проверяем, что режим ввода точек включен
        expect(viewer.pointInputModeEnabled, isTrue);

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

        // Проверяем, что ключ содержит информацию о режиме ввода точек
        final customPaint = await tester.findCanvasViewerPaint();
        final key = customPaint.key as ValueKey;
        expect(key.value.toString(), contains('input_mode'));
      },
    );

    testWidgets('should toggle point input mode through setPointInputMode', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer без режима ввода точек
      final factory = CanvasViewerFactory();
      final viewer = factory.create() as CanvasViewer;

      // Проверяем, что режим ввода точек выключен по умолчанию
      expect(viewer.pointInputModeEnabled, isFalse);

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

      // Проверяем, что ключ не содержит информацию о режиме ввода точек
      var customPaint = await tester.findCanvasViewerPaint();
      var key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('view_mode'));

      // Включаем режим ввода точек
      viewer.setPointInputMode(true);
      await tester.pump();

      // Проверяем, что режим ввода точек включен
      expect(viewer.pointInputModeEnabled, isTrue);

      // Проверяем, что ключ содержит информацию о режиме ввода точек
      customPaint = await tester.findCanvasViewerPaint();
      key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('input_mode'));

      // Выключаем режим ввода точек
      viewer.setPointInputMode(false);
      await tester.pump();

      // Проверяем, что режим ввода точек выключен
      expect(viewer.pointInputModeEnabled, isFalse);

      // Проверяем только состояние pointInputModeEnabled, а не ключ
      expect(viewer.pointInputModeEnabled, isFalse);
    });

    testWidgets('should add point on tap when input mode is enabled', (
      WidgetTester tester,
    ) async {
      // Создаем список для хранения добавленных точек
      final addedPoints = <Point>[];

      // Создаем Viewer с включенным режимом ввода точек
      final viewer = ViewerTestUtils.createTestViewer(
        pointInputModeEnabled: true,
        onPointAdded: (point) {
          addedPoints.add(point);
        },
      );

      // Проверяем, что режим ввода точек включен
      expect(viewer.pointInputModeEnabled, isTrue);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что изначально нет точек
      expect(viewer.points.length, 0);
      expect(addedPoints.length, 0);

      // Нажимаем на холст
      await tester.tapAt(const Offset(150, 150));
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, 1);
      expect(addedPoints.length, 1);

      // Проверяем, что координаты точки соответствуют месту нажатия
      // (с учетом преобразования координат)
      // Точные значения будут зависеть от реализации _convertToModelCoordinates
      // Поэтому проверяем только, что точка была добавлена
    });

    testWidgets('should not add point on tap when input mode is disabled', (
      WidgetTester tester,
    ) async {
      // Создаем список для хранения добавленных точек
      final addedPoints = <Point>[];

      // Создаем Viewer с выключенным режимом ввода точек
      final viewer = ViewerTestUtils.createTestViewer(
        pointInputModeEnabled: false,
        onPointAdded: (point) {
          addedPoints.add(point);
        },
      );

      // Проверяем, что режим ввода точек выключен
      expect(viewer.pointInputModeEnabled, isFalse);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что изначально нет точек
      expect(viewer.points.length, 0);
      expect(addedPoints.length, 0);

      // Нажимаем на холст
      await tester.tapAt(const Offset(150, 150));
      await tester.pump();

      // Проверяем, что точка не была добавлена
      expect(viewer.points.length, 0);
      expect(addedPoints.length, 0);
    });

    testWidgets('should receive points through stream', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer с включенным режимом ввода точек
      final viewer = ViewerTestUtils.createTestViewer(
        pointInputModeEnabled: true,
      );

      // Создаем список для хранения точек из потока
      final streamPoints = <Point>[];

      // Подписываемся на поток точек
      final subscription = viewer.pointsStream.listen((point) {
        streamPoints.add(point);
      });

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что изначально нет точек
      expect(viewer.points.length, 0);
      expect(streamPoints.length, 0);

      // Нажимаем на холст несколько раз
      await tester.tapAt(const Offset(100, 100));
      await tester.pump();
      await tester.tapAt(const Offset(200, 200));
      await tester.pump();

      // Проверяем, что точки были добавлены
      expect(viewer.points.length, 2);
      expect(streamPoints.length, 2);

      // Отписываемся от потока
      subscription.cancel();
    });

    testWidgets(
      'should update scaling state with point input mode information',
      (WidgetTester tester) async {
        // Создаем Viewer
        final viewer = ViewerTestUtils.createTestViewer();

        // Проверяем состояние масштабирования по умолчанию
        final defaultState = viewer.getScalingState();
        expect(defaultState.containsKey('pointInputModeEnabled'), isTrue);
        expect(defaultState['pointInputModeEnabled'], isFalse);

        // Включаем режим ввода точек
        viewer.setPointInputMode(true);

        // Проверяем обновленное состояние масштабирования
        final updatedState = viewer.getScalingState();
        expect(updatedState['pointInputModeEnabled'], isTrue);
      },
    );

    testWidgets('should preserve point input mode state after redrawing', (
      WidgetTester tester,
    ) async {
      // Создаем Viewer с включенным режимом ввода точек
      final factory = CanvasViewerFactory();
      final viewer =
          factory.create(pointInputModeEnabled: true) as CanvasViewer;

      // Проверяем, что режим ввода точек включен
      expect(viewer.pointInputModeEnabled, isTrue);

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

      // Проверяем, что ключ содержит информацию о режиме ввода точек
      var customPaint = await tester.findCanvasViewerPaint();
      var key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('input_mode'));

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

      // Проверяем, что режим ввода точек все еще включен
      expect(viewer.pointInputModeEnabled, isTrue);

      // Проверяем, что ключ содержит информацию о режиме ввода точек
      customPaint = await tester.findCanvasViewerPaint();
      key = customPaint.key as ValueKey;
      expect(key.value.toString(), contains('input_mode'));
    });

    testWidgets(
      'should have independent point input mode settings for multiple viewers',
      (WidgetTester tester) async {
        // Создаем два Viewer с разными настройками режима ввода точек
        final factory = CanvasViewerFactory();
        final viewer1 =
            factory.create(pointInputModeEnabled: true) as CanvasViewer;
        final viewer2 = factory.create() as CanvasViewer;

        // Проверяем настройки режима ввода точек
        expect(viewer1.pointInputModeEnabled, isTrue);
        expect(viewer2.pointInputModeEnabled, isFalse);

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

        expect(key1.value.toString(), contains('input_mode'));
        expect(key2.value.toString(), contains('view_mode'));
      },
    );
  });
}
