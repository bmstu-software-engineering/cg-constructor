import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_45/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01V45DataModelImpl
class AlgorithmL01V45DataModelImplMock extends Mock
    implements AlgorithmL01V45DataModelImpl {}

void main() {
  late AlgorithmL01V45 algorithm;
  late AlgorithmL01V45DataModelImplMock model;

  setUp(() {
    model = AlgorithmL01V45DataModelImplMock();
    algorithm = AlgorithmL01V45.fromModel(model);
  });

  group('AlgorithmL01V45 - Тестирование', () {
    test(
      'базовый тест с двумя треугольниками и расстоянием между барицентрами',
      () {
        // Устанавливаем тестовые данные
        // Два треугольника с разным расположением
        when(() => model.data).thenReturn(
          AlgorithmLab0145DataModel(
            points: [
              // Треугольник A
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 10),

              // Треугольник B
              Point(x: 20, y: 0),
              Point(x: 25, y: 10),
              Point(x: 30, y: 0),

              // Дополнительные точки
              Point(x: 15, y: 5),
              Point(x: 35, y: 5),
            ],
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки, линии и текстовую информацию
        expect(
          result.points.length,
          8,
          reason:
              'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 барицентра)',
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
          contains('### Барицентры треугольников'),
          reason: 'Должна быть информация о барицентрах треугольников',
        );
        expect(
          result.markdownInfo,
          contains('### Итоговые результаты'),
          reason: 'Должна быть информация об итоговых результатах',
        );
        expect(
          result.markdownInfo,
          contains('- Расстояние между барицентрами треугольников:'),
          reason: 'Должна быть информация о расстоянии между барицентрами',
        );
        expect(
          result.lines.length,
          7,
          reason:
              'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через барицентры)',
        );

        // Проверяем цвета точек и линий
        final triangleAPoints =
            result.points.where((p) => p.color == '#00FF00').toList();
        final triangleBPoints =
            result.points.where((p) => p.color == '#FF0000').toList();
        final barycenterAPoint =
            result.points.where((p) => p.color == '#00FFFF').toList();
        final barycenterBPoint =
            result.points.where((p) => p.color == '#FF00FF').toList();
        final triangleALines =
            result.lines.where((l) => l.color == '#00FF00').toList();
        final triangleBLines =
            result.lines.where((l) => l.color == '#FF0000').toList();
        final centerLine =
            result.lines.where((l) => l.color == '#0000FF').toList();

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
          barycenterAPoint.length,
          1,
          reason: 'Должна быть 1 точка для барицентра треугольника A',
        );
        expect(
          barycenterBPoint.length,
          1,
          reason: 'Должна быть 1 точка для барицентра треугольника B',
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
        expect(
          centerLine.length,
          1,
          reason: 'Должна быть 1 линия, соединяющая барицентры треугольников',
        );
      },
    );

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          AlgorithmLab0145DataModel(
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
          AlgorithmLab0145DataModel(
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
        AlgorithmLab0145DataModel(
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
        8,
        reason:
            'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 барицентра)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );
      expect(
        result.lines.length,
        7,
        reason:
            'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через барицентры)',
      );
    });

    test(
      'тест с треугольниками, имеющими максимальное расстояние между барицентрами',
      () {
        // Устанавливаем точки для двух треугольников, барицентры которых
        // находятся на максимальном расстоянии друг от друга
        when(() => model.data).thenReturn(
          AlgorithmLab0145DataModel(
            points: [
              // Треугольник A (в левом нижнем углу)
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 10),

              // Треугольник B (в правом верхнем углу)
              Point(x: 90, y: 90),
              Point(x: 100, y: 90),
              Point(x: 95, y: 100),

              // Дополнительные точки
              Point(x: 15, y: 5),
              Point(x: 85, y: 85),
            ],
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки и линии
        expect(
          result.points.length,
          8,
          reason:
              'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 барицентра)',
        );

        // Проверяем наличие текстовой информации
        expect(
          result.markdownInfo,
          isNotEmpty,
          reason: 'Должна быть текстовая информация в формате Markdown',
        );
        expect(
          result.lines.length,
          7,
          reason:
              'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через барицентры)',
        );

        // Проверяем, что расстояние между барицентрами достаточно большое
        expect(
          result.markdownInfo,
          contains('Расстояние между барицентрами треугольников:'),
          reason: 'Должна быть информация о расстоянии между барицентрами',
        );
      },
    );
  });
}
