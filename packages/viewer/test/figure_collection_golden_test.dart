import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

import 'test_utils.dart';

/// Создает виджет для golden тестирования
Widget createGoldenTestWidget({
  required Widget child,
  Size size = const Size(300, 300),
}) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: Scaffold(
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('FigureCollection Golden Tests', () {
    testWidgets('Viewer with points collection', (WidgetTester tester) async {
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_points_collection.png'),
      );
    });

    testWidgets('Viewer with lines collection', (WidgetTester tester) async {
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_lines_collection.png'),
      );
    });

    testWidgets('Viewer with triangles collection', (
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_triangles_collection.png'),
      );
    });

    testWidgets('Viewer with rectangles collection', (
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_rectangles_collection.png'),
      );
    });

    testWidgets('Viewer with squares collection', (WidgetTester tester) async {
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_squares_collection.png'),
      );
    });

    testWidgets('Viewer with circles collection', (WidgetTester tester) async {
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_circles_collection.png'),
      );
    });

    testWidgets('Viewer with ellipses collection', (WidgetTester tester) async {
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
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_ellipses_collection.png'),
      );
    });

    testWidgets('Viewer with arcs collection', (WidgetTester tester) async {
      // Создаем тестовые данные
      final arcs = [
        Arc(
          center: const Point(x: 100, y: 100),
          radius: 50,
          startAngle: 0,
          endAngle: 180,
          color: '#FF0000',
          thickness: 2,
        ),
        Arc(
          center: const Point(x: 150, y: 150),
          radius: 40,
          startAngle: 90,
          endAngle: 270,
          color: '#00FF00',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию фигур только с дугами
      final collection = FigureCollection(arcs: arcs);

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_arcs_collection.png'),
      );
    });

    testWidgets('Viewer with all figures collection', (
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

      final rectangles = [
        Rectangle.fromCorners(
          topLeft: const Point(x: 120, y: 20),
          bottomRight: const Point(x: 170, y: 60),
          color: '#FFFF00',
          thickness: 2,
        ),
      ];

      final squares = [
        Square(
          center: const Point(x: 210, y: 40),
          sideLength: 40,
          color: '#FF00FF',
          thickness: 2,
        ),
      ];

      final circles = [
        Circle(
          center: const Point(x: 40, y: 120),
          radius: 30,
          color: '#00FFFF',
          thickness: 2,
        ),
      ];

      final ellipses = [
        Ellipse(
          center: const Point(x: 120, y: 120),
          semiMajorAxis: 40,
          semiMinorAxis: 20,
          color: '#800080',
          thickness: 2,
        ),
      ];

      final arcs = [
        Arc(
          center: const Point(x: 200, y: 120),
          radius: 30,
          startAngle: 0,
          endAngle: 180,
          color: '#008000',
          thickness: 2,
        ),
      ];

      // Создаем коллекцию со всеми типами фигур
      final collection = FigureCollection(
        points: points,
        lines: lines,
        triangles: triangles,
        rectangles: rectangles,
        squares: squares,
        circles: circles,
        ellipses: ellipses,
        arcs: arcs,
      );

      // Создаем Viewer и отображаем коллекцию
      final viewer = ViewerTestUtils.createTestViewer();
      viewer.drawCollection(collection);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(
          child: viewer.buildWidget(),
          size: const Size(400, 300),
        ),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_all_figures_collection.png'),
      );
    });

    testWidgets('Two viewers with different collections side by side', (
      WidgetTester tester,
    ) async {
      // Создаем две разные коллекции
      final collection1 = FigureCollection(
        points: [
          const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
          const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
          const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
          const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
        ],
        lines: [
          Line(
            a: const Point(x: 50, y: 50),
            b: const Point(x: 150, y: 50),
            color: '#FF0000',
            thickness: 2,
          ),
          Line(
            a: const Point(x: 150, y: 50),
            b: const Point(x: 150, y: 150),
            color: '#00FF00',
            thickness: 2,
          ),
        ],
        rectangles: [
          Rectangle.fromCorners(
            topLeft: const Point(x: 50, y: 50),
            bottomRight: const Point(x: 150, y: 150),
            color: '#0000FF',
            thickness: 2,
          ),
        ],
      );

      final collection2 = FigureCollection(
        triangles: [
          Triangle(
            a: const Point(x: 50, y: 50),
            b: const Point(x: 150, y: 50),
            c: const Point(x: 100, y: 150),
            color: '#FF0000',
            thickness: 2,
          ),
        ],
        circles: [
          Circle(
            center: const Point(x: 100, y: 100),
            radius: 40,
            color: '#00FF00',
            thickness: 2,
          ),
        ],
      );

      // Создаем два Viewer и отображаем коллекции
      final viewer1 = ViewerTestUtils.createTestViewer();
      viewer1.drawCollection(collection1);

      final viewer2 = ViewerTestUtils.createTestViewer();
      viewer2.drawCollection(collection2);

      // Рендерим виджеты рядом
      await tester.pumpWidget(
        createGoldenTestWidget(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: viewer1.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: viewer2.buildWidget(),
                ),
              ),
            ],
          ),
          size: const Size(600, 300),
        ),
      );

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/two_viewers_with_different_collections.png'),
      );
    });
  });
}
