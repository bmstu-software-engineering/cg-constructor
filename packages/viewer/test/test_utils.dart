import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

/// Вспомогательные функции для тестирования CanvasViewer
class ViewerTestUtils {
  /// Создает тестовый экземпляр CanvasViewer с заданными линиями и точками
  static CanvasViewer createTestViewer({
    List<Line> lines = const [],
    List<Point> points = const [],
    bool showCoordinates = false,
    bool pointInputModeEnabled = false,
    void Function(Point point)? onPointAdded,
    double padding = 40.0,
  }) {
    final viewer =
        CanvasViewerFactory(padding: padding).create(
              showCoordinates: showCoordinates,
              pointInputModeEnabled: pointInputModeEnabled,
              onPointAdded: onPointAdded,
            )
            as CanvasViewer;
    viewer.draw(lines, points);
    return viewer;
  }

  /// Создает тестовый виджет с CanvasViewer
  static Widget createTestWidget({
    required CanvasViewer viewer,
    Size size = const Size(300, 300),
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: viewer.buildWidget(),
        ),
      ),
    );
  }
}

/// Расширение для WidgetTester, добавляющее методы для тестирования CanvasViewer
extension ViewerTestExtensions on WidgetTester {
  /// Находит CustomPaint в дереве виджетов по ключу, начинающемуся с 'canvas_viewer_'
  Future<CustomPaint> findCanvasViewerPaint() async {
    // Ищем по ключу, который начинается с 'canvas_viewer_'
    final finder = find.byWidgetPredicate((widget) {
      if (widget is CustomPaint && widget.key is ValueKey) {
        final key = widget.key as ValueKey;
        if (key.value is String &&
            (key.value as String).startsWith('canvas_viewer_')) {
          return true;
        }
      }
      return false;
    });

    expect(
      finder,
      findsOneWidget,
      reason: 'Не найден CustomPaint с ключом canvas_viewer_*',
    );
    return widget(finder);
  }

  /// Проверяет, что виджет CanvasViewer корректно отображается
  Future<void> expectCanvasViewerRendered() async {
    final customPaint = await findCanvasViewerPaint();
    // Проверяем, что у CustomPaint есть ключ, начинающийся с 'canvas_viewer_'
    expect(customPaint.key, isA<ValueKey>());
    final key = customPaint.key as ValueKey;
    expect(key.value, isA<String>());
    expect((key.value as String).startsWith('canvas_viewer_'), isTrue);
  }
}

/// Пример использования тестовых утилит:
///
/// ```dart
/// testWidgets('CanvasViewer correctly scales content', (WidgetTester tester) async {
///   // Создаем тестовые данные
///   final points = [
///     Point(x: 0, y: 0),
///     Point(x: 100, y: 100),
///   ];
///   
///   final lines = [
///     Line(a: points[0], b: points[1]),
///   ];
///   
///   // Создаем виджет для тестирования
///   final factory = CanvasViewerFactory();
///   final viewer = factory.create();
///   viewer.draw(lines, points);
///   
///   // Рендерим виджет
///   await tester.pumpWidget(
///     MaterialApp(
///       home: Scaffold(
///         body: SizedBox(
///           width: 300,
///           height: 300,
///           child: viewer.buildWidget(),
///         ),
///       ),
///     ),
///   );
///   
///   // Находим CanvasViewer
///   final canvasViewer = await tester.findCanvasViewer();
///   
///   // Проверяем, что все элементы видимы
///   await tester.expectAllElementsVisible(canvasViewer);
///   
///   // Проверяем содержимое
///   await tester.expectCanvasViewerContent(canvasViewer, lineCount: 1, pointCount: 2);
/// });
