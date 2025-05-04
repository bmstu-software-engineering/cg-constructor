import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer с useCollection', () {
    testWidgets('создается с параметром useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);

      // Проверяем, что виджет создан
      expect(viewer, isA<CanvasViewer>());

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();
    });

    testWidgets('корректно отображает точки при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      ];

      // Создаем коллекцию фигур только с точками
      final collection = FigureCollection(points: points);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что точки были корректно добавлены
      expect(viewer.points.length, equals(points.length));
      for (int i = 0; i < points.length; i++) {
        expect(viewer.points[i].x, equals(points[i].x));
        expect(viewer.points[i].y, equals(points[i].y));
        expect(viewer.points[i].color, equals(points[i].color));
        expect(viewer.points[i].thickness, equals(points[i].thickness));
      }
    });

    testWidgets('корректно отображает линии при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 50, y: 50),
        const Point(x: 150, y: 50),
        const Point(x: 150, y: 150),
        const Point(x: 50, y: 150),
      ];

      final lines = [
        Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
        Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
        Line(a: points[2], b: points[3], color: '#0000FF', thickness: 2),
        Line(a: points[3], b: points[0], color: '#FFFF00', thickness: 2),
      ];

      // Создаем коллекцию фигур только с линиями
      final collection = FigureCollection(lines: lines);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что линии были корректно добавлены
      expect(viewer.lines.length, equals(lines.length));
      for (int i = 0; i < lines.length; i++) {
        expect(viewer.lines[i].a.x, equals(lines[i].a.x));
        expect(viewer.lines[i].a.y, equals(lines[i].a.y));
        expect(viewer.lines[i].b.x, equals(lines[i].b.x));
        expect(viewer.lines[i].b.y, equals(lines[i].b.y));
        expect(viewer.lines[i].color, equals(lines[i].color));
        expect(viewer.lines[i].thickness, equals(lines[i].thickness));
      }
    });

    testWidgets('корректно отображает треугольники при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final triangles = [
        Triangle(
          a: const Point(x: 50, y: 50),
          b: const Point(x: 150, y: 50),
          c: const Point(x: 100, y: 150),
          color: '#FF0000',
          thickness: 2,
        ),
        Triangle(
          a: const Point(x: 70, y: 70),
          b: const Point(x: 130, y: 70),
          c: const Point(x: 100, y: 130),
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с треугольниками
      final collection = FigureCollection(triangles: triangles);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что линии были корректно добавлены (3 линии на треугольник)
      expect(viewer.lines.length, equals(triangles.length * 3));
    });

    testWidgets('корректно отображает прямоугольники при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final rectangles = [
        Rectangle.fromCorners(
          topLeft: const Point(x: 30, y: 30),
          bottomRight: const Point(x: 120, y: 80),
          color: '#FF0000',
          thickness: 2,
        ),
        Rectangle.fromCorners(
          topLeft: const Point(x: 50, y: 100),
          bottomRight: const Point(x: 150, y: 170),
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с прямоугольниками
      final collection = FigureCollection(rectangles: rectangles);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что линии были корректно добавлены (4 линии на прямоугольник)
      expect(viewer.lines.length, equals(rectangles.length * 4));
    });

    testWidgets(
      'корректно отображает смешанную коллекцию при useCollection = true',
      (WidgetTester tester) async {
        // Создаем тестовые данные
        final points = [
          const Point(x: 20, y: 20, color: '#FF0000', thickness: 5),
          const Point(x: 40, y: 20, color: '#00FF00', thickness: 5),
        ];

        final lines = [
          Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
        ];

        final triangles = [
          Triangle(
            a: const Point(x: 60, y: 20),
            b: const Point(x: 100, y: 20),
            c: const Point(x: 80, y: 60),
            color: '#0000FF',
            thickness: 2,
          ),
        ];

        // Создаем коллекцию с разными типами фигур
        final collection = FigureCollection(
          points: points,
          lines: lines,
          triangles: triangles,
        );

        // Создаем CanvasViewer с useCollection = true
        final viewer = CanvasViewer(useCollection: true);
        viewer.drawCollection(collection);

        // Рендерим виджет
        await tester.pumpWidget(
          ViewerTestUtils.createTestWidget(viewer: viewer),
        );

        // Проверяем, что виджет отрендерился
        await tester.expectCanvasViewerRendered();

        // Проверяем, что точки были корректно добавлены
        expect(viewer.points.length, equals(points.length));

        // Проверяем, что линии были корректно добавлены (1 линия + 3 линии для треугольника)
        expect(
          viewer.lines.length,
          equals(lines.length + triangles.length * 3),
        );
      },
    );

    testWidgets('корректно обновляет коллекцию при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final initialPoints = [
        const Point(x: 20, y: 20, color: '#FF0000', thickness: 5),
        const Point(x: 40, y: 20, color: '#00FF00', thickness: 5),
      ];

      final initialCollection = FigureCollection(points: initialPoints);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(initialCollection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что точки были корректно добавлены
      expect(viewer.points.length, equals(initialPoints.length));

      // Создаем новые данные
      final newPoints = [
        const Point(x: 60, y: 60, color: '#0000FF', thickness: 5),
        const Point(x: 80, y: 60, color: '#FFFF00', thickness: 5),
        const Point(x: 100, y: 60, color: '#FF00FF', thickness: 5),
      ];

      final newCollection = FigureCollection(points: newPoints);

      // Обновляем коллекцию
      viewer.drawCollection(newCollection);
      await tester.pump();

      // Проверяем, что точки были корректно обновлены
      expect(viewer.points.length, equals(newPoints.length));
      for (int i = 0; i < newPoints.length; i++) {
        expect(viewer.points[i].x, equals(newPoints[i].x));
        expect(viewer.points[i].y, equals(newPoints[i].y));
        expect(viewer.points[i].color, equals(newPoints[i].color));
        expect(viewer.points[i].thickness, equals(newPoints[i].thickness));
      }
    });

    testWidgets('корректно очищает коллекцию при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 20, y: 20, color: '#FF0000', thickness: 5),
        const Point(x: 40, y: 20, color: '#00FF00', thickness: 5),
      ];

      final collection = FigureCollection(points: points);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что точки были корректно добавлены
      expect(viewer.points.length, equals(points.length));

      // Очищаем коллекцию
      viewer.clean();
      await tester.pump();

      // Проверяем, что коллекция пуста
      expect(viewer.points.length, equals(0));
      expect(viewer.lines.length, equals(0));
    });

    testWidgets('корректно отображает координаты при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      ];

      final collection = FigureCollection(points: points);

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);
      viewer.drawCollection(collection);
      viewer.setShowCoordinates(true);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что координаты отображаются
      expect(viewer.showCoordinates, isTrue);
    });

    testWidgets(
      'сравнение результатов с useCollection = true и useCollection = false',
      (WidgetTester tester) async {
        // Создаем тестовые данные
        final points = [
          const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
          const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        ];

        final lines = [
          Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
        ];

        final collection = FigureCollection(points: points, lines: lines);

        // Создаем CanvasViewer с useCollection = true
        final viewerWithCollection = CanvasViewer(useCollection: true);
        viewerWithCollection.drawCollection(collection);

        // Создаем CanvasViewer с useCollection = false
        final viewerWithoutCollection = CanvasViewer(useCollection: false);
        viewerWithoutCollection.drawCollection(collection);

        // Проверяем, что оба viewer имеют одинаковое количество точек и линий
        expect(
          viewerWithCollection.points.length,
          equals(viewerWithoutCollection.points.length),
        );
        expect(
          viewerWithCollection.lines.length,
          equals(viewerWithoutCollection.lines.length),
        );

        // Проверяем, что точки идентичны
        for (int i = 0; i < points.length; i++) {
          expect(
            viewerWithCollection.points[i].x,
            equals(viewerWithoutCollection.points[i].x),
          );
          expect(
            viewerWithCollection.points[i].y,
            equals(viewerWithoutCollection.points[i].y),
          );
          expect(
            viewerWithCollection.points[i].color,
            equals(viewerWithoutCollection.points[i].color),
          );
          expect(
            viewerWithCollection.points[i].thickness,
            equals(viewerWithoutCollection.points[i].thickness),
          );
        }

        // Проверяем, что линии идентичны
        for (int i = 0; i < lines.length; i++) {
          expect(
            viewerWithCollection.lines[i].a.x,
            equals(viewerWithoutCollection.lines[i].a.x),
          );
          expect(
            viewerWithCollection.lines[i].a.y,
            equals(viewerWithoutCollection.lines[i].a.y),
          );
          expect(
            viewerWithCollection.lines[i].b.x,
            equals(viewerWithoutCollection.lines[i].b.x),
          );
          expect(
            viewerWithCollection.lines[i].b.y,
            equals(viewerWithoutCollection.lines[i].b.y),
          );
          expect(
            viewerWithCollection.lines[i].color,
            equals(viewerWithoutCollection.lines[i].color),
          );
          expect(
            viewerWithCollection.lines[i].thickness,
            equals(viewerWithoutCollection.lines[i].thickness),
          );
        }
      },
    );

    testWidgets('метод draw работает корректно при useCollection = true', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
      ];

      final lines = [
        Line(a: points[0], b: points[1], color: '#0000FF', thickness: 2),
      ];

      // Создаем CanvasViewer с useCollection = true
      final viewer = CanvasViewer(useCollection: true);

      // Используем метод draw вместо drawCollection
      viewer.draw(lines, points);

      // Рендерим виджет
      await tester.pumpWidget(ViewerTestUtils.createTestWidget(viewer: viewer));

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Проверяем, что точки и линии были корректно добавлены
      expect(viewer.points.length, equals(points.length));
      expect(viewer.lines.length, equals(lines.length));

      // Проверяем, что точки идентичны
      for (int i = 0; i < points.length; i++) {
        expect(viewer.points[i].x, equals(points[i].x));
        expect(viewer.points[i].y, equals(points[i].y));
        expect(viewer.points[i].color, equals(points[i].color));
        expect(viewer.points[i].thickness, equals(points[i].thickness));
      }

      // Проверяем, что линии идентичны
      for (int i = 0; i < lines.length; i++) {
        expect(viewer.lines[i].a.x, equals(lines[i].a.x));
        expect(viewer.lines[i].a.y, equals(lines[i].a.y));
        expect(viewer.lines[i].b.x, equals(lines[i].b.x));
        expect(viewer.lines[i].b.y, equals(lines[i].b.y));
        expect(viewer.lines[i].color, equals(lines[i].color));
        expect(viewer.lines[i].thickness, equals(lines[i].thickness));
      }
    });
  });
}
