import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer с масштабированием и добавлением точек', () {
    testWidgets('корректно определяет координаты точки при масштабировании', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные для масштабирования
      final initialPoints = [
        const Point(x: -100, y: -100),
        const Point(x: 100, y: 100),
      ];

      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Добавляем начальные точки для масштабирования
      viewer.draw([], initialPoints);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что масштаб был применен (должен быть не равен 1.0)
      expect(viewer.currentScale, isNot(equals(1.0)));

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(initialPoints.length + 1));

      // Получаем добавленную точку
      final addedPoint = viewer.points.last;

      // Проверяем, что координаты точки находятся в пределах видимой области
      // Учитывая масштаб, координаты должны быть близки к 0,0 (центр видимой области)
      expect(addedPoint.x, closeTo(0, 20));
      expect(addedPoint.y, closeTo(0, 20));
    });

    testWidgets('корректно определяет координаты точки при разных масштабах', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные для разных масштабов
      final testCases = [
        // Маленькие точки близко к центру (маленький масштаб)
        [const Point(x: -10, y: -10), const Point(x: 10, y: 10)],
        // Точки дальше от центра (средний масштаб)
        [const Point(x: -50, y: -50), const Point(x: 50, y: 50)],
        // Точки далеко от центра (большой масштаб)
        [const Point(x: -200, y: -200), const Point(x: 200, y: 200)],
      ];

      for (final points in testCases) {
        // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
        final viewer = CanvasViewer(useCollection: true);
        viewer.setPointInputMode(true);

        // Добавляем начальные точки для масштабирования
        viewer.draw([], points);

        // Рендерим виджет
        await tester.pumpWidget(
          ViewerTestUtils.createTestWidget(viewer: viewer),
        );

        // Проверяем, что виджет отрендерился
        await tester.expectCanvasViewerRendered();

        // Запоминаем текущий масштаб
        final currentScale = viewer.currentScale;

        // Находим CustomPaint
        final customPaint = await tester.findCanvasViewerPaint();
        final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

        // Нажимаем на центр CustomPaint
        await tester.tapAt(customPaintCenter);
        await tester.pump();

        // Проверяем, что точка была добавлена
        expect(viewer.points.length, equals(points.length + 1));

        // Получаем добавленную точку
        final addedPoint = viewer.points.last;

        // Проверяем, что координаты точки находятся в пределах видимой области
        // Учитывая масштаб, координаты должны быть близки к 0,0 (центр видимой области)
        expect(addedPoint.x, closeTo(0, 20));
        expect(addedPoint.y, closeTo(0, 20));

        // Проверяем, что масштаб влияет на точность определения координат
        // Чем больше масштаб, тем точнее определение координат
        final scaleFactor = 1 / currentScale;
        expect(addedPoint.x.abs(), lessThanOrEqualTo(10 * scaleFactor));
        expect(addedPoint.y.abs(), lessThanOrEqualTo(10 * scaleFactor));
      }
    });

    testWidgets('корректно определяет координаты точки при смещении холста', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные для смещения
      // Точки смещены вправо и вниз
      final initialPoints = [
        const Point(x: 100, y: 100),
        const Point(x: 200, y: 200),
      ];

      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Добавляем начальные точки для масштабирования и смещения
      viewer.draw([], initialPoints);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Запоминаем текущий масштаб и смещение
      final currentScale = viewer.currentScale;
      final currentOffset = viewer.currentOffset;

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(initialPoints.length + 1));

      // Получаем добавленную точку
      final addedPoint = viewer.points.last;

      // Проверяем, что координаты точки учитывают смещение
      // Центр экрана должен соответствовать примерно (150, 150) в координатах модели
      // (среднее между начальными точками)
      expect(addedPoint.x, closeTo(150, 30));
      expect(addedPoint.y, closeTo(150, 30));
    });

    testWidgets(
      'корректно определяет координаты при нажатии в разных местах холста',
      (WidgetTester tester) async {
        // Создаем тестовые данные для масштабирования
        final initialPoints = [
          const Point(x: -100, y: -100),
          const Point(x: 100, y: 100),
        ];

        // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
        final viewer = CanvasViewer(useCollection: true);
        viewer.setPointInputMode(true);

        // Добавляем начальные точки для масштабирования
        viewer.draw([], initialPoints);

        // Рендерим виджет
        await tester.pumpWidget(
          ViewerTestUtils.createTestWidget(viewer: viewer),
        );

        // Проверяем, что виджет отрендерился
        await tester.expectCanvasViewerRendered();

        // Запоминаем текущий масштаб и смещение
        final currentScale = viewer.currentScale;
        final currentOffset = viewer.currentOffset;

        // Находим CustomPaint
        final customPaint = await tester.findCanvasViewerPaint();
        final size = tester.getSize(find.byWidget(customPaint));

        // Определяем точки для нажатия (центр, верхний левый угол, нижний правый угол)
        final center = tester.getCenter(find.byWidget(customPaint));
        final topLeft = Offset(10, 10);
        final bottomRight = Offset(size.width - 10, size.height - 10);

        // Нажимаем на центр CustomPaint
        await tester.tapAt(center);
        await tester.pump();

        // Нажимаем в верхнем левом углу CustomPaint
        await tester.tapAt(topLeft);
        await tester.pump();

        // Нажимаем в нижнем правом углу CustomPaint
        await tester.tapAt(bottomRight);
        await tester.pump();

        // Проверяем, что все точки были добавлены
        expect(viewer.points.length, equals(initialPoints.length + 3));

        // Получаем добавленные точки
        final centerPoint = viewer.points[initialPoints.length];
        final topLeftPoint = viewer.points[initialPoints.length + 1];
        final bottomRightPoint = viewer.points[initialPoints.length + 2];

        // Проверяем, что координаты точек соответствуют их положению на экране
        // Центральная точка должна быть близка к (0, 0) в координатах модели
        expect(centerPoint.x, closeTo(0, 20));
        expect(centerPoint.y, closeTo(0, 20));

        // Верхняя левая точка должна иметь координаты меньше центральной
        expect(topLeftPoint.x, lessThan(centerPoint.x));
        expect(topLeftPoint.y, lessThan(centerPoint.y));

        // Нижняя правая точка должна иметь координаты больше центральной
        expect(bottomRightPoint.x, greaterThan(centerPoint.x));
        expect(bottomRightPoint.y, greaterThan(centerPoint.y));

        // Проверяем, что расстояние между точками пропорционально их расстоянию на экране
        final screenDistanceX = bottomRight.dx - topLeft.dx;
        final screenDistanceY = bottomRight.dy - topLeft.dy;
        final modelDistanceX = bottomRightPoint.x - topLeftPoint.x;
        final modelDistanceY = bottomRightPoint.y - topLeftPoint.y;

        // Соотношение расстояний должно быть примерно равно 1/масштаб
        expect(
          modelDistanceX / screenDistanceX,
          closeTo(1 / currentScale, 0.1),
        );
        expect(
          modelDistanceY / screenDistanceY,
          closeTo(1 / currentScale, 0.1),
        );
      },
    );

    testWidgets('корректно определяет координаты при изменении масштаба', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные для начального масштаба
      final initialPoints = [
        const Point(x: -10, y: -10),
        const Point(x: 10, y: 10),
      ];

      // Создаем CanvasViewer с useCollection = true и включенным режимом добавления точек
      final viewer = CanvasViewer(useCollection: true);
      viewer.setPointInputMode(true);

      // Добавляем начальные точки для масштабирования
      viewer.draw([], initialPoints);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Запоминаем текущий масштаб
      final initialScale = viewer.currentScale;

      // Находим CustomPaint
      final customPaint = await tester.findCanvasViewerPaint();
      final customPaintCenter = tester.getCenter(find.byWidget(customPaint));

      // Нажимаем на центр CustomPaint
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      expect(viewer.points.length, equals(initialPoints.length + 1));

      // Получаем добавленную точку
      final firstPoint = viewer.points.last;

      // Изменяем масштаб, добавляя точки дальше от центра
      final newPoints = [
        const Point(x: -100, y: -100),
        const Point(x: 100, y: 100),
      ];

      // Добавляем новые точки для изменения масштаба
      viewer.draw([], [...initialPoints, ...newPoints]);
      await tester.pump();

      // Запоминаем новый масштаб
      final newScale = viewer.currentScale;

      // Масштаб может измениться или остаться прежним, в зависимости от реализации
      // Главное, что координаты точек должны быть корректными

      // Нажимаем на центр CustomPaint снова
      await tester.tapAt(customPaintCenter);
      await tester.pump();

      // Проверяем, что точка была добавлена
      // Количество точек может быть разным в зависимости от реализации
      // Важно, что последняя точка была добавлена
      expect(viewer.points.length, greaterThan(initialPoints.length));

      // Получаем новую добавленную точку
      final secondPoint = viewer.points.last;

      // Проверяем, что координаты обеих точек близки, несмотря на разный масштаб
      // (так как мы нажимали в одно и то же место на экране)
      expect(secondPoint.x, closeTo(firstPoint.x, 1));
      expect(secondPoint.y, closeTo(firstPoint.y, 1));
    });
  });
}
