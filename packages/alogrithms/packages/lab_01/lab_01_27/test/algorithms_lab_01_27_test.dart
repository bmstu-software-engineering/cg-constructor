import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_27/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для PointSetModelImpl
class PointSetModelImplMock extends Mock implements PointSetModelImpl {}

void main() {
  late AlgorithmL01V27 algorithm;
  late PointSetModelImplMock model;

  setUp(() {
    model = PointSetModelImplMock();
    algorithm = AlgorithmL01V27.fromModel(model);
  });

  group('AlgorithmL01V27 - Тестирование', () {
    test('базовый тест с треугольником и точками внутри подтреугольников', () {
      // Устанавливаем тестовые данные
      // Треугольник с вершинами в (0,0), (10,0), (5,10)
      // и несколько точек внутри треугольника
      when(() => model.data).thenReturn(
        PointSetModel(
          points: [
            Point(x: 0, y: 0), // Вершина треугольника
            Point(x: 10, y: 0), // Вершина треугольника
            Point(x: 5, y: 10), // Вершина треугольника
            Point(x: 2, y: 2), // Точка внутри треугольника
            Point(x: 8, y: 2), // Точка внутри треугольника
            Point(x: 5, y: 5), // Точка внутри треугольника
            Point(x: 3, y: 1), // Точка внутри треугольника
            Point(x: 7, y: 1), // Точка внутри треугольника
            Point(x: 5, y: 2), // Точка внутри треугольника
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки, линии и текстовую информацию
      expect(
        result.points.length,
        4,
        reason: 'Должно быть 4 точки (3 вершины треугольника и центроид)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );

      // Проверяем содержимое текстовой информации
      expect(
        result.markdownInfo,
        contains('## Результаты анализа треугольника'),
        reason: 'Должен быть заголовок с результатами анализа',
      );
      expect(
        result.markdownInfo,
        contains('### Координаты вершин треугольника'),
        reason: 'Должна быть информация о координатах вершин',
      );
      expect(
        result.markdownInfo,
        contains('### Количество точек в подтреугольниках'),
        reason: 'Должна быть информация о количестве точек в подтреугольниках',
      );
      expect(
        result.markdownInfo,
        contains('### Итоговые результаты'),
        reason: 'Должна быть информация об итоговых результатах',
      );
      expect(
        result.markdownInfo,
        contains('- Максимальное количество точек:'),
        reason: 'Должна быть информация о максимальном количестве точек',
      );
      expect(
        result.markdownInfo,
        contains('- Минимальное количество точек:'),
        reason: 'Должна быть информация о минимальном количестве точек',
      );
      expect(
        result.markdownInfo,
        contains('- Разность:'),
        reason: 'Должна быть информация о разности',
      );
      expect(
        result.lines.length,
        12,
        reason:
            'Должно быть 12 линий (3 стороны треугольника, 3 медианы и 6 сторон подтреугольников)',
      );

      // Проверяем цвета точек
      final trianglePoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final centroidPoint =
          result.points.where((p) => p.color == '#000000').toList();

      expect(
        trianglePoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника',
      );
      expect(
        centroidPoint.length,
        1,
        reason: 'Должна быть 1 точка для центроида',
      );

      // Проверяем цвета линий
      final triangleLines =
          result.lines.where((l) => l.color == '#00FF00').toList();
      final medianLines =
          result.lines.where((l) => l.color == '#0000FF').toList();
      final maxSubtriangleLines =
          result.lines.where((l) => l.color == '#FF0000').toList();
      final minSubtriangleLines =
          result.lines.where((l) => l.color == '#FF00FF').toList();

      expect(
        triangleLines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника',
      );
      expect(medianLines.length, 3, reason: 'Должно быть 3 линии для медиан');
      expect(
        maxSubtriangleLines.length,
        3,
        reason:
            'Должно быть 3 линии для подтреугольника с максимальным количеством точек',
      );
      expect(
        minSubtriangleLines.length,
        3,
        reason:
            'Должно быть 3 линии для подтреугольника с минимальным количеством точек',
      );
    });

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          PointSetModel(
            points: [
              Point(x: 0, y: 0),
              Point(
                x: 1,
                y: 0,
              ), // Только 2 точки, недостаточно для треугольника
            ],
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<InsufficientPointsException>().having(
              (e) => e.message,
              'message',
              contains('Множество точек'),
            ),
          ),
        );
      },
    );

    test(
      'тест на исключение CalculationException при вырожденном треугольнике',
      () {
        // Устанавливаем точки, лежащие на одной прямой
        when(() => model.data).thenReturn(
          PointSetModel(
            points: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              Point(x: 2, y: 0), // Все точки лежат на одной прямой
            ],
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение CalculationException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<CalculationException>().having(
              (e) => e.message,
              'message',
              contains('Не удалось найти подходящий треугольник'),
            ),
          ),
        );
      },
    );

    test('тест с равномерным распределением точек в подтреугольниках', () {
      // Устанавливаем точки так, чтобы в каждом подтреугольнике было одинаковое количество точек
      when(() => model.data).thenReturn(
        PointSetModel(
          points: [
            Point(x: 0, y: 0), // Вершина треугольника
            Point(x: 10, y: 0), // Вершина треугольника
            Point(x: 5, y: 10), // Вершина треугольника
            Point(x: 2, y: 2), // Точка внутри треугольника
            Point(x: 8, y: 2), // Точка внутри треугольника
            Point(x: 5, y: 5), // Точка внутри треугольника
            Point(x: 3, y: 1), // Точка внутри треугольника
            Point(x: 7, y: 1), // Точка внутри треугольника
            Point(x: 5, y: 2), // Точка внутри треугольника
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        4,
        reason: 'Должно быть 4 точки (3 вершины треугольника и центроид)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );
      expect(
        result.lines.length,
        12,
        reason:
            'Должно быть 12 линий (3 стороны треугольника, 3 медианы и 6 сторон подтреугольников)',
      );
    });
  });
}
