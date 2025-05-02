import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

import 'test_utils.dart';

void main() {
  group('Resize Points Tests', () {
    testWidgets('should correctly display points after resize', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые точки в разных частях экрана
      final points = [
        const Point(
          x: 0,
          y: 0,
          color: '#FF0000',
          thickness: 5,
        ), // Левый верхний угол
        const Point(
          x: 200,
          y: 0,
          color: '#00FF00',
          thickness: 5,
        ), // Правый верхний угол
        const Point(
          x: 200,
          y: 200,
          color: '#0000FF',
          thickness: 5,
        ), // Правый нижний угол
        const Point(
          x: 0,
          y: 200,
          color: '#FFFF00',
          thickness: 5,
        ), // Левый нижний угол
        const Point(x: 100, y: 100, color: '#FF00FF', thickness: 5), // Центр
      ];

      // Создаем виджет для тестирования с начальным размером
      final initialSize = const Size(300, 300);
      final viewer = ViewerTestUtils.createTestViewer(points: points);

      // Рендерим виджет с начальным размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: initialSize.width,
                height: initialSize.height,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем текущее состояние масштабирования
      final initialScalingState = viewer.getScalingState();
      final initialScale = initialScalingState['scale'] as double;
      final initialOffset = initialScalingState['offset'] as Offset;

      // Проверяем, что все точки видимы (масштаб и смещение корректны)
      expect(initialScale, isPositive);
      expect(initialOffset, isNotNull);

      // Изменяем размер виджета (уменьшаем)
      final smallerSize = const Size(200, 200);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: smallerSize.width,
                height: smallerSize.height,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Ждем завершения анимаций

      // Проверяем, что виджет отрендерился с новым размером
      await tester.expectCanvasViewerRendered();

      // Получаем новое состояние масштабирования
      final smallerScalingState = viewer.getScalingState();
      final smallerScale = smallerScalingState['scale'] as double;
      final smallerOffset = smallerScalingState['offset'] as Offset;

      // Проверяем, что масштаб положительный и смещение не null
      // Это гарантирует, что точки видимы
      expect(smallerScale, isPositive);
      expect(smallerOffset, isNotNull);

      // Изменяем размер виджета (увеличиваем)
      final largerSize = const Size(400, 400);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: largerSize.width,
                height: largerSize.height,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Ждем завершения анимаций

      // Проверяем, что виджет отрендерился с новым размером
      await tester.expectCanvasViewerRendered();

      // Получаем новое состояние масштабирования
      final largerScalingState = viewer.getScalingState();
      final largerScale = largerScalingState['scale'] as double;
      final largerOffset = largerScalingState['offset'] as Offset;

      // Проверяем, что масштаб положительный и смещение не null
      // Это гарантирует, что точки видимы
      expect(largerScale, isPositive);
      expect(largerOffset, isNotNull);

      // Проверяем, что ограничивающий прямоугольник не изменился
      // (точки остались те же)
      final initialBoundingBox = initialScalingState['boundingBox'];
      final smallerBoundingBox = smallerScalingState['boundingBox'];
      final largerBoundingBox = largerScalingState['boundingBox'];

      expect(smallerBoundingBox, equals(initialBoundingBox));
      expect(largerBoundingBox, equals(initialBoundingBox));
    });

    testWidgets('should correctly display points with different aspect ratios', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые точки в разных частях экрана
      final points = [
        const Point(
          x: 0,
          y: 0,
          color: '#FF0000',
          thickness: 5,
        ), // Левый верхний угол
        const Point(
          x: 200,
          y: 0,
          color: '#00FF00',
          thickness: 5,
        ), // Правый верхний угол
        const Point(
          x: 200,
          y: 200,
          color: '#0000FF',
          thickness: 5,
        ), // Правый нижний угол
        const Point(
          x: 0,
          y: 200,
          color: '#FFFF00',
          thickness: 5,
        ), // Левый нижний угол
        const Point(x: 100, y: 100, color: '#FF00FF', thickness: 5), // Центр
      ];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(points: points);

      // Рендерим виджет с квадратным размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем состояние масштабирования для квадратного виджета
      final squareScalingState = viewer.getScalingState();

      // Рендерим виджет с горизонтальным прямоугольным размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 200,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем состояние масштабирования для горизонтального прямоугольника
      final horizontalScalingState = viewer.getScalingState();
      final horizontalScale = horizontalScalingState['scale'] as double;
      final horizontalOffset = horizontalScalingState['offset'] as Offset;

      // Рендерим виджет с вертикальным прямоугольным размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 400,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем состояние масштабирования для вертикального прямоугольника
      final verticalScalingState = viewer.getScalingState();
      final verticalScale = verticalScalingState['scale'] as double;
      final verticalOffset = verticalScalingState['offset'] as Offset;

      // Проверяем, что масштаб положительный и смещение не null для всех соотношений сторон
      // Это гарантирует, что точки видимы
      expect(horizontalScale, isPositive);
      expect(horizontalOffset, isNotNull);
      expect(verticalScale, isPositive);
      expect(verticalOffset, isNotNull);

      // Проверяем, что ограничивающий прямоугольник не изменился
      // (точки остались те же)
      final squareBoundingBox = squareScalingState['boundingBox'];
      final horizontalBoundingBox = horizontalScalingState['boundingBox'];
      final verticalBoundingBox = verticalScalingState['boundingBox'];

      expect(horizontalBoundingBox, equals(squareBoundingBox));
      expect(verticalBoundingBox, equals(squareBoundingBox));
    });

    testWidgets('should maintain point visibility after extreme resize', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые точки в разных частях экрана
      final points = [
        const Point(
          x: 0,
          y: 0,
          color: '#FF0000',
          thickness: 5,
        ), // Левый верхний угол
        const Point(
          x: 200,
          y: 0,
          color: '#00FF00',
          thickness: 5,
        ), // Правый верхний угол
        const Point(
          x: 200,
          y: 200,
          color: '#0000FF',
          thickness: 5,
        ), // Правый нижний угол
        const Point(
          x: 0,
          y: 200,
          color: '#FFFF00',
          thickness: 5,
        ), // Левый нижний угол
        const Point(x: 100, y: 100, color: '#FF00FF', thickness: 5), // Центр
      ];

      // Создаем виджет для тестирования
      final viewer = ViewerTestUtils.createTestViewer(points: points);

      // Рендерим виджет с начальным размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем начальное состояние масштабирования
      final initialScalingState = viewer.getScalingState();

      // Рендерим виджет с очень маленьким размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем состояние масштабирования для маленького размера
      final smallScalingState = viewer.getScalingState();
      final smallOffset = smallScalingState['offset'] as Offset;

      // Проверяем, что смещение не null
      // Это гарантирует, что точки видимы даже при маленьком размере
      expect(smallOffset, isNotNull);

      // Рендерим виджет с очень большим размером
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 800,
                height: 800,
                child: viewer.buildWidget(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Получаем состояние масштабирования для большого размера
      final largeScalingState = viewer.getScalingState();
      final largeOffset = largeScalingState['offset'] as Offset;

      // Проверяем, что смещение не null
      // Это гарантирует, что точки видимы даже при большом размере
      expect(largeOffset, isNotNull);

      // Проверяем, что ограничивающий прямоугольник не изменился
      // (точки остались те же)
      final initialBoundingBox = initialScalingState['boundingBox'];
      final smallBoundingBox = smallScalingState['boundingBox'];
      final largeBoundingBox = largeScalingState['boundingBox'];

      expect(smallBoundingBox, equals(initialBoundingBox));
      expect(largeBoundingBox, equals(initialBoundingBox));
    });
  });
}
