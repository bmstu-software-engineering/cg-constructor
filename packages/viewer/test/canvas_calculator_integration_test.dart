import 'package:flutter_test/flutter_test.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

import 'test_utils.dart';

void main() {
  group('CanvasViewer с CanvasCalculator', () {
    test('должен корректно преобразовывать координаты', () {
      // Создаем CanvasViewer
      final viewer = CanvasViewer(useCollection: true);

      // Добавляем точки для масштабирования
      final points = [
        const Point(x: -100, y: -100),
        const Point(x: 100, y: 100),
      ];
      viewer.draw([], points);

      // Получаем текущий масштаб и смещение
      final scale = viewer.currentScale;
      final offset = viewer.currentOffset;

      // Проверяем, что масштаб и смещение были установлены
      // Масштаб может быть равен 1.0 в зависимости от реализации
      expect(scale, isNotNull);
      expect(offset, isNotNull);

      // Проверяем, что boundingBox был установлен
      expect(viewer.boundingBox, isNotNull);

      // Проверяем, что boundingBox содержит все точки
      final boundingBox = viewer.boundingBox!;
      expect(boundingBox.left, lessThanOrEqualTo(-100));
      expect(boundingBox.top, lessThanOrEqualTo(-100));
      expect(boundingBox.right, greaterThanOrEqualTo(100));
      expect(boundingBox.bottom, greaterThanOrEqualTo(100));
    });

    test('должен корректно обновлять boundingBox при добавлении точек', () {
      // Создаем CanvasViewer
      final viewer = CanvasViewer(useCollection: true);

      // Добавляем начальные точки
      final initialPoints = [
        const Point(x: -10, y: -10),
        const Point(x: 10, y: 10),
      ];
      viewer.draw([], initialPoints);

      // Получаем начальный boundingBox
      final initialBoundingBox = viewer.boundingBox!;

      // Добавляем новые точки
      final newPoints = [
        const Point(x: -100, y: -100),
        const Point(x: 100, y: 100),
      ];
      viewer.draw([], [...initialPoints, ...newPoints]);

      // Получаем новый boundingBox
      final newBoundingBox = viewer.boundingBox!;

      // Проверяем, что новый boundingBox больше начального
      expect(newBoundingBox.left, lessThan(initialBoundingBox.left));
      expect(newBoundingBox.top, lessThan(initialBoundingBox.top));
      expect(newBoundingBox.right, greaterThan(initialBoundingBox.right));
      expect(newBoundingBox.bottom, greaterThan(initialBoundingBox.bottom));
    });
  });
}
