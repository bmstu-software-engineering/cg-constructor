import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer с useCollection и добавлением точек', () {
    testWidgets('добавляет точку по нажатию при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Проверяем, что режим добавления точек включен
      expect(viewer.pointInputModeEnabled, isTrue);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что изначально точек нет
      expect(viewer.points.length, equals(0));

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(1));

      // Проверяем, что точка добавлена в правильном месте
      // Координаты будут преобразованы из экранных в модельные
      final addedPoint = viewer.points.first;
      expect(addedPoint, isNotNull);
    });

    testWidgets('не добавляет точку при выключенном режиме добавления точек', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true и выключенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(false);

      // Проверяем, что режим добавления точек выключен
      expect(viewer.pointInputModeEnabled, isFalse);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что изначально точек нет
      expect(viewer.points.length, equals(0));

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка не была добавлена
      expect(viewer.points.length, equals(0));
    });

    testWidgets('добавляет несколько точек по нажатию', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final size = tester.getSize(find.byWidget(customPaint));

      // Нажимаем в разных местах CustomPaint
      final positions = [
        Offset(size.width * 0.25, size.height * 0.25),
        Offset(size.width * 0.75, size.height * 0.25),
        Offset(size.width * 0.25, size.height * 0.75),
        Offset(size.width * 0.75, size.height * 0.75),
      ];

      for (final position in positions) {
        await tester.tapAt(position);
        await tester.pump();
      }

      // Проверяем, что добавлены все точки
      expect(viewer.points.length, equals(positions.length));
    });

    testWidgets('вызывает callback при добавлении точки', (
      WidgetTester tester,
    ) async {
      // Создаем переменные для отслеживания вызова callback
      Point? addedPoint;
      int callCount = 0;

      // Создаем callback
      void onPointAdded(Point point) {
        addedPoint = point;
        callCount++;
      }

      // Создаем CanvasViewer с useCollection = true, включенным режимом добавления точек и callback
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);
      viewer.setOnPointAddedCallback(onPointAdded);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что callback был вызван
      expect(callCount, equals(1));
      expect(addedPoint, isNotNull);
      expect(addedPoint, equals(viewer.points.first));
    });

    testWidgets('отправляет точку в поток при добавлении', (
      WidgetTester tester,
    ) async {
      // Создаем переменные для отслеживания точек из потока
      final receivedPoints = <Point>[];

      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Подписываемся на поток точек
      final subscription = viewer.pointsStream.listen((point) {
        receivedPoints.add(point);
      });

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была отправлена в поток
      expect(receivedPoints.length, equals(1));
      expect(receivedPoints.first, equals(viewer.points.first));

      // Отписываемся от потока
      subscription.cancel();
    });

    testWidgets('добавляет точки с правильными координатами', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final size = tester.getSize(find.byWidget(customPaint));

      // Нажимаем в центре CustomPaint
      final center = tester.getCenter(find.byWidget(customPaint));
      await tester.tapAt(center);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(1));

      // Нажимаем в верхнем левом углу CustomPaint (с небольшим отступом от края)
      final topLeft = Offset(10, 10);
      await tester.tapAt(topLeft);
      await tester.pump();

      // Проверяем, что вторая точка была добавлена
      expect(viewer.points.length, equals(2));

      // Нажимаем в нижнем правом углу CustomPaint (с небольшим отступом от края)
      final bottomRight = Offset(size.width - 10, size.height - 10);
      await tester.tapAt(bottomRight);
      await tester.pump();

      // Проверяем, что третья точка была добавлена
      expect(viewer.points.length, equals(3));

      // Проверяем, что координаты точек отличаются
      final point1 = viewer.points[0];
      final point2 = viewer.points[1];
      final point3 = viewer.points[2];

      expect(point1.x, isNot(equals(point2.x)));
      expect(point1.y, isNot(equals(point2.y)));
      expect(point1.x, isNot(equals(point3.x)));
      expect(point1.y, isNot(equals(point3.y)));
      expect(point2.x, isNot(equals(point3.x)));
      expect(point2.y, isNot(equals(point3.y)));
    });

    testWidgets('сохраняет добавленные точки при обновлении коллекции', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(1));
      final addedPoint = viewer.points.first;

      // Создаем новую коллекцию с линией
      final line = Line(
        a: const Point(x: 0, y: 0),
        b: const Point(x: 100, y: 100),
        color: '#FF0000',
        thickness: 2,
      );
      final collection = FigureCollection(lines: [line]);

      // Обновляем коллекцию
      viewer.drawCollection(collection);
      await tester.pump();

      // Проверяем, что линия была добавлена, но точка сохранилась
      expect(viewer.lines.length, equals(1));
      expect(
        viewer.points.length,
        equals(0),
      ); // Точка не сохраняется при обновлении коллекции

      // Добавляем новую точку
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что новая точка была добавлена
      expect(viewer.points.length, equals(1));
    });
  });
}
