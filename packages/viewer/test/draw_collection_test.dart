import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer.drawCollection', () {
    testWidgets('correctly processes points collection', (
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

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что точки были корректно добавлены
      expect(viewer.points.length, equals(points.length));
      for (int i = 0; i < points.length; i++) {
        expect(viewer.points[i].x, equals(points[i].x));
        expect(viewer.points[i].y, equals(points[i].y));
        expect(viewer.points[i].color, equals(points[i].color));
        expect(viewer.points[i].thickness, equals(points[i].thickness));
      }

      // Проверяем, что линий нет
      expect(viewer.lines.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final pointCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'pointCount',
        orElse: () => throw Exception('pointCount property not found'),
      );
      expect(pointCountProperty.value, equals(points.length));
    });

    testWidgets('correctly processes lines collection', (
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

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

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

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(lines.length));
    });

    testWidgets('correctly processes triangles collection', (
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

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (3 линии на треугольник)
      expect(viewer.lines.length, equals(triangles.length * 3));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(triangles.length * 3));
    });

    testWidgets('correctly processes rectangles collection', (
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

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (4 линии на прямоугольник)
      expect(viewer.lines.length, equals(rectangles.length * 4));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(rectangles.length * 4));
    });

    testWidgets('correctly processes squares collection', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final squares = [
        Square(
          center: const Point(x: 75, y: 75),
          sideLength: 50,
          color: '#FF0000',
          thickness: 2,
        ),
        Square(
          center: const Point(x: 145, y: 95),
          sideLength: 50,
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с квадратами
      final collection = FigureCollection(squares: squares);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (4 линии на квадрат)
      expect(viewer.lines.length, equals(squares.length * 4));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(squares.length * 4));
    });

    testWidgets('correctly processes circles collection', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final circles = [
        Circle(
          center: const Point(x: 80, y: 80),
          radius: 40,
          color: '#FF0000',
          thickness: 2,
        ),
        Circle(
          center: const Point(x: 150, y: 120),
          radius: 30,
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с кругами
      final collection = FigureCollection(circles: circles);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (36 сегментов на круг)
      expect(viewer.lines.length, equals(circles.length * 36));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(circles.length * 36));
    });

    testWidgets('correctly processes ellipses collection', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final ellipses = [
        Ellipse(
          center: const Point(x: 80, y: 80),
          semiMajorAxis: 50,
          semiMinorAxis: 30,
          color: '#FF0000',
          thickness: 2,
        ),
        Ellipse(
          center: const Point(x: 150, y: 150),
          semiMajorAxis: 40,
          semiMinorAxis: 20,
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с эллипсами
      final collection = FigureCollection(ellipses: ellipses);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (36 сегментов на эллипс)
      expect(viewer.lines.length, equals(ellipses.length * 36));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(ellipses.length * 36));
    });

    testWidgets('correctly processes arcs collection', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final arcs = [
        Arc(
          center: const Point(x: 100, y: 100),
          radius: 50,
          startAngle: 0,
          endAngle: 3.14159, // полукруг (π радиан = 180 градусов)
          color: '#FF0000',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с дугами
      final collection = FigureCollection(arcs: arcs);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что линии были корректно добавлены (примерно 18 сегментов на полукруг)
      expect(viewer.lines.length, equals(18));

      // Проверяем, что точек нет
      expect(viewer.points.length, equals(0));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(18));
    });

    testWidgets('correctly processes mixed collection', (
      WidgetTester tester,
    ) async {
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

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что точки были корректно добавлены
      expect(viewer.points.length, equals(points.length));

      // Проверяем, что линии были корректно добавлены (1 линия + 3 линии для треугольника)
      expect(viewer.lines.length, equals(lines.length + triangles.length * 3));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final pointCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'pointCount',
        orElse: () => throw Exception('pointCount property not found'),
      );
      expect(pointCountProperty.value, equals(points.length));

      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(
        lineCountProperty.value,
        equals(lines.length + triangles.length * 3),
      );
    });

    testWidgets('correctly updates bounding box', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = [const Point(x: 10, y: 10), const Point(x: 100, y: 100)];

      final collection = FigureCollection(points: points);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что ограничивающий прямоугольник был корректно обновлен
      expect(viewer.boundingBox, isNotNull);
      expect(viewer.boundingBox!.left, equals(10));
      expect(viewer.boundingBox!.top, equals(10));
      expect(viewer.boundingBox!.right, equals(100));
      expect(viewer.boundingBox!.bottom, equals(100));

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getChildren();
      final boundingBoxProperty = diagnostics.firstWhere(
        (node) => node.name == 'boundingBox',
        orElse: () => throw Exception('boundingBox property not found'),
      );
      expect(boundingBoxProperty, isNotNull);
    });

    testWidgets('correctly handles empty collection', (
      WidgetTester tester,
    ) async {
      // Создаем пустую коллекцию
      final collection = FigureCollection();

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer() as CanvasViewer;
      viewer.drawCollection(collection);

      // Проверяем, что точек и линий нет
      expect(viewer.points.length, equals(0));
      expect(viewer.lines.length, equals(0));

      // Проверяем, что ограничивающий прямоугольник null
      expect(viewer.boundingBox, isNull);

      // Проверяем DiagnosticableTree
      final diagnostics = viewer.toDiagnosticsNode().getProperties();
      final pointCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'pointCount',
        orElse: () => throw Exception('pointCount property not found'),
      );
      expect(pointCountProperty.value, equals(0));

      final lineCountProperty = diagnostics.firstWhere(
        (node) => node.name == 'lineCount',
        orElse: () => throw Exception('lineCount property not found'),
      );
      expect(lineCountProperty.value, equals(0));
    });
  });
}
