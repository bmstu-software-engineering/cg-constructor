import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_42/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01V42DataModelImpl
class AlgorithmL01V42DataModelImplMock extends Mock
    implements AlgorithmL01V42DataModelImpl {}

void main() {
  late AlgorithmL01V42 algorithm;
  late AlgorithmL01V42DataModelImplMock model;

  setUp(() {
    model = AlgorithmL01V42DataModelImplMock();
    algorithm = AlgorithmL01V42.fromModel(model);
  });

  group('AlgorithmL01V42 - Тестирование', () {
    test('базовый тест с двумя треугольниками разного периметра', () {
      // Устанавливаем тестовые данные
      // Два треугольника с разными периметрами
      when(() => model.data).thenReturn(
        AlgorithmLab0142DataModel(
          points: [
            // Треугольник A (большой периметр)
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 10),

            // Треугольник B (малый периметр)
            Point(x: 20, y: 0),
            Point(x: 22, y: 0),
            Point(x: 21, y: 2),

            // Дополнительные точки
            Point(x: 15, y: 5),
            Point(x: 25, y: 5),
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки, линии и текстовую информацию
      expect(
        result.points.length,
        6,
        reason: 'Должно быть 6 точек (по 3 вершины для каждого треугольника)',
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
        contains('## Результаты анализа треугольников'),
        reason: 'Должен быть заголовок с результатами анализа',
      );
      expect(
        result.markdownInfo,
        contains('### Координаты вершин треугольника A'),
        reason: 'Должна быть информация о координатах вершин треугольника A',
      );
      expect(
        result.markdownInfo,
        contains('### Координаты вершин треугольника B'),
        reason: 'Должна быть информация о координатах вершин треугольника B',
      );
      expect(
        result.markdownInfo,
        contains('### Итоговые результаты'),
        reason: 'Должна быть информация об итоговых результатах',
      );
      expect(
        result.markdownInfo,
        contains('- Периметр треугольника A:'),
        reason: 'Должна быть информация о периметре треугольника A',
      );
      expect(
        result.markdownInfo,
        contains('- Периметр треугольника B:'),
        reason: 'Должна быть информация о периметре треугольника B',
      );
      expect(
        result.markdownInfo,
        contains('- Отношение периметров (Pa/Pb):'),
        reason: 'Должна быть информация об отношении периметров',
      );
      expect(
        result.lines.length,
        6,
        reason: 'Должно быть 6 линий (по 3 стороны для каждого треугольника)',
      );

      // Проверяем цвета точек и линий
      final triangleAPoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final triangleBPoints =
          result.points.where((p) => p.color == '#FF0000').toList();
      final triangleALines =
          result.lines.where((l) => l.color == '#00FF00').toList();
      final triangleBLines =
          result.lines.where((l) => l.color == '#FF0000').toList();

      expect(
        triangleAPoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника A',
      );
      expect(
        triangleBPoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника B',
      );
      expect(
        triangleALines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника A',
      );
      expect(
        triangleBLines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника B',
      );
    });

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          AlgorithmLab0142DataModel(
            points: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              Point(x: 0, y: 1),
              Point(x: 2, y: 2),
              Point(
                x: 3,
                y: 3,
              ), // Только 5 точек, недостаточно для двух треугольников
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
      'тест на исключение CalculationException при вырожденных треугольниках',
      () {
        // Устанавливаем точки, лежащие на одной прямой
        when(() => model.data).thenReturn(
          AlgorithmLab0142DataModel(
            points: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              Point(x: 2, y: 0), // Точки лежат на одной прямой
              Point(x: 3, y: 0),
              Point(x: 4, y: 0),
              Point(x: 5, y: 0), // Все точки лежат на одной прямой
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
              contains(
                'Недостаточно невырожденных треугольников для решения задачи',
              ),
            ),
          ),
        );
      },
    );

    // Примечание: этот тест может быть нестабильным, так как зависит от конкретной реализации
    // алгоритма и порядка перебора треугольников. В реальном приложении лучше использовать
    // более надежные методы тестирования.
    test('тест с треугольниками, имеющими общие вершины', () {
      // Устанавливаем точки так, чтобы некоторые треугольники имели общие вершины
      when(() => model.data).thenReturn(
        AlgorithmLab0142DataModel(
          points: [
            // Общие вершины
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 10),

            // Дополнительные точки для формирования треугольников
            Point(x: 20, y: 0),
            Point(x: 25, y: 10),
            Point(x: 30, y: 0),
            Point(x: 15, y: 5),
            Point(x: 35, y: 5),
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        6,
        reason: 'Должно быть 6 точек (по 3 вершины для каждого треугольника)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );
      expect(
        result.lines.length,
        6,
        reason: 'Должно быть 6 линий (по 3 стороны для каждого треугольника)',
      );
    });

    test('тест с треугольниками разного периметра', () {
      // Устанавливаем точки для двух треугольников с разным периметром
      when(() => model.data).thenReturn(
        AlgorithmLab0142DataModel(
          points: [
            // Треугольник A (большой периметр)
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 10),

            // Треугольник B (малый периметр)
            Point(x: 20, y: 0),
            Point(x: 22, y: 0),
            Point(x: 21, y: 2),

            // Дополнительные точки
            Point(x: 15, y: 5),
            Point(x: 25, y: 5),
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        6,
        reason: 'Должно быть 6 точек (по 3 вершины для каждого треугольника)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );
      expect(
        result.lines.length,
        6,
        reason: 'Должно быть 6 линий (по 3 стороны для каждого треугольника)',
      );
    });
  });
}
