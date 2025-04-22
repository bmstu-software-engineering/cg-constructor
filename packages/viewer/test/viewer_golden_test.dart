import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';

import 'test_utils.dart';

/// Создает тестовые данные для точек
List<Point> createTestPoints() {
  return [
    const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
    const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
    const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
    const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
    const Point(x: 100, y: 200, color: '#FF00FF', thickness: 5),
  ];
}

/// Создает тестовые данные для линий
List<Line> createTestLines(List<Point> points) {
  return [
    Line(a: points[0], b: points[1], color: '#FF0000', thickness: 2),
    Line(a: points[1], b: points[2], color: '#00FF00', thickness: 2),
    Line(a: points[2], b: points[3], color: '#0000FF', thickness: 2),
    Line(a: points[3], b: points[0], color: '#FFFF00', thickness: 2),
  ];
}

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
  group('Viewer Golden Tests', () {
    testWidgets('Empty viewer', (WidgetTester tester) async {
      // Создаем пустой Viewer
      final viewer = ViewerTestUtils.createTestViewer();

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/empty_viewer.png'),
      );
    });

    testWidgets('Viewer with points', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = createTestPoints();

      // Создаем Viewer с точками
      final viewer = ViewerTestUtils.createTestViewer(points: points);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_points.png'),
      );
    });

    testWidgets('Viewer with lines', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = createTestPoints();
      final lines = createTestLines(points);

      // Создаем Viewer с линиями
      final viewer = ViewerTestUtils.createTestViewer(lines: lines);

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_lines.png'),
      );
    });

    testWidgets('Viewer with points and lines', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = createTestPoints();
      final lines = createTestLines(points);

      // Создаем Viewer с точками и линиями
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
      );

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_points_and_lines.png'),
      );
    });

    testWidgets('Two empty viewers side by side', (WidgetTester tester) async {
      // Создаем два пустых Viewer
      final viewer1 = ViewerTestUtils.createTestViewer();
      final viewer2 = ViewerTestUtils.createTestViewer();

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
        matchesGoldenFile('goldens/two_empty_viewers.png'),
      );
    });

    testWidgets('Two viewers with points side by side', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      final points1 = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
      ];

      final points2 = [
        const Point(x: 50, y: 50, color: '#FFFF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#FF00FF', thickness: 5),
        const Point(x: 100, y: 200, color: '#00FFFF', thickness: 5),
      ];

      // Создаем два Viewer с точками
      final viewer1 = ViewerTestUtils.createTestViewer(points: points1);
      final viewer2 = ViewerTestUtils.createTestViewer(points: points2);

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
        matchesGoldenFile('goldens/two_viewers_with_points.png'),
      );
    });

    testWidgets('Two viewers with lines side by side', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      // Точки для первого Viewer
      final points1 = [
        const Point(x: 50, y: 50),
        const Point(x: 150, y: 50),
        const Point(x: 150, y: 150),
        const Point(x: 50, y: 150),
      ];

      // Линии для первого Viewer
      final lines1 = [
        Line(a: points1[0], b: points1[1], color: '#FF0000', thickness: 2),
        Line(a: points1[1], b: points1[2], color: '#00FF00', thickness: 2),
        Line(a: points1[2], b: points1[3], color: '#0000FF', thickness: 2),
        Line(a: points1[3], b: points1[0], color: '#FFFF00', thickness: 2),
      ];

      // Точки для второго Viewer
      final points2 = [
        const Point(x: 50, y: 50),
        const Point(x: 150, y: 50),
        const Point(x: 100, y: 150),
      ];

      // Линии для второго Viewer
      final lines2 = [
        Line(a: points2[0], b: points2[1], color: '#FF00FF', thickness: 2),
        Line(a: points2[1], b: points2[2], color: '#00FFFF', thickness: 2),
        Line(a: points2[2], b: points2[0], color: '#FF0000', thickness: 2),
      ];

      // Создаем два Viewer с линиями
      final viewer1 = ViewerTestUtils.createTestViewer(lines: lines1);
      final viewer2 = ViewerTestUtils.createTestViewer(lines: lines2);

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
        matchesGoldenFile('goldens/two_viewers_with_lines.png'),
      );
    });

    testWidgets('Two viewers with points and lines side by side', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные
      // Данные для первого Viewer
      final points1 = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      ];

      final lines1 = [
        Line(a: points1[0], b: points1[1], color: '#FF0000', thickness: 2),
        Line(a: points1[1], b: points1[2], color: '#00FF00', thickness: 2),
        Line(a: points1[2], b: points1[3], color: '#0000FF', thickness: 2),
        Line(a: points1[3], b: points1[0], color: '#FFFF00', thickness: 2),
      ];

      // Данные для второго Viewer
      final points2 = [
        const Point(x: 50, y: 50, color: '#FF00FF', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FFFF', thickness: 5),
        const Point(x: 100, y: 150, color: '#FF0000', thickness: 5),
      ];

      final lines2 = [
        Line(a: points2[0], b: points2[1], color: '#FF00FF', thickness: 2),
        Line(a: points2[1], b: points2[2], color: '#00FFFF', thickness: 2),
        Line(a: points2[2], b: points2[0], color: '#FF0000', thickness: 2),
      ];

      // Создаем два Viewer с точками и линиями
      final viewer1 = ViewerTestUtils.createTestViewer(
        points: points1,
        lines: lines1,
      );
      final viewer2 = ViewerTestUtils.createTestViewer(
        points: points2,
        lines: lines2,
      );

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
        matchesGoldenFile('goldens/two_viewers_with_points_and_lines.png'),
      );
    });

    testWidgets('Three viewers with points and lines side by side', (
      WidgetTester tester,
    ) async {
      // Создаем тестовые данные для трех виджетов
      // Первый виджет - квадрат
      final points1 = [
        const Point(x: 50, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FF00', thickness: 5),
        const Point(x: 150, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 50, y: 150, color: '#FFFF00', thickness: 5),
      ];

      final lines1 = [
        Line(a: points1[0], b: points1[1], color: '#FF0000', thickness: 2),
        Line(a: points1[1], b: points1[2], color: '#00FF00', thickness: 2),
        Line(a: points1[2], b: points1[3], color: '#0000FF', thickness: 2),
        Line(a: points1[3], b: points1[0], color: '#FFFF00', thickness: 2),
      ];

      // Второй виджет - треугольник
      final points2 = [
        const Point(x: 50, y: 50, color: '#FF00FF', thickness: 5),
        const Point(x: 150, y: 50, color: '#00FFFF', thickness: 5),
        const Point(x: 100, y: 150, color: '#FF0000', thickness: 5),
      ];

      final lines2 = [
        Line(a: points2[0], b: points2[1], color: '#FF00FF', thickness: 2),
        Line(a: points2[1], b: points2[2], color: '#00FFFF', thickness: 2),
        Line(a: points2[2], b: points2[0], color: '#FF0000', thickness: 2),
      ];

      // Третий виджет - пятиугольник
      final points3 = [
        const Point(x: 100, y: 50, color: '#FF0000', thickness: 5),
        const Point(x: 150, y: 100, color: '#00FF00', thickness: 5),
        const Point(x: 125, y: 150, color: '#0000FF', thickness: 5),
        const Point(x: 75, y: 150, color: '#FFFF00', thickness: 5),
        const Point(x: 50, y: 100, color: '#FF00FF', thickness: 5),
      ];

      final lines3 = [
        Line(a: points3[0], b: points3[1], color: '#FF0000', thickness: 2),
        Line(a: points3[1], b: points3[2], color: '#00FF00', thickness: 2),
        Line(a: points3[2], b: points3[3], color: '#0000FF', thickness: 2),
        Line(a: points3[3], b: points3[4], color: '#FFFF00', thickness: 2),
        Line(a: points3[4], b: points3[0], color: '#FF00FF', thickness: 2),
      ];

      // Создаем три Viewer
      final viewer1 = ViewerTestUtils.createTestViewer(
        points: points1,
        lines: lines1,
      );
      final viewer2 = ViewerTestUtils.createTestViewer(
        points: points2,
        lines: lines2,
      );
      final viewer3 = ViewerTestUtils.createTestViewer(
        points: points3,
        lines: lines3,
      );

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
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: viewer2.buildWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: viewer3.buildWidget(),
                ),
              ),
            ],
          ),
          size: const Size(900, 300),
        ),
      );

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/three_viewers_with_points_and_lines.png'),
      );
    });

    // Новый тест с дефолтными значениями padding
    testWidgets('Viewer with default padding', (WidgetTester tester) async {
      // Создаем тестовые данные
      final points = createTestPoints();
      final lines = createTestLines(points);

      // Создаем Viewer с точками и линиями и дефолтными значениями padding
      final viewer = ViewerTestUtils.createTestViewer(
        points: points,
        lines: lines,
        padding: 40.0, // Дефолтное значение padding
      );

      // Рендерим виджет
      await tester.pumpWidget(
        createGoldenTestWidget(child: viewer.buildWidget()),
      );

      // Проверяем, что виджет отрендерился
      await tester.expectCanvasViewerRendered();

      // Сравниваем с эталонным изображением
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/viewer_with_points_and_lines.png'),
      );
    });
  });
}
