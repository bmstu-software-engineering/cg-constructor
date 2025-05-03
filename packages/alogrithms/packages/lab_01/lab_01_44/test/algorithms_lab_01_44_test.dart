import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_44/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01V44DataModelImpl
class AlgorithmL01V44DataModelImplMock extends Mock
    implements AlgorithmL01V44DataModelImpl {}

void main() {
  late AlgorithmL01V44 algorithm;
  late AlgorithmL01V44DataModelImplMock model;

  setUp(() {
    model = AlgorithmL01V44DataModelImplMock();
    algorithm = AlgorithmL01V44.fromModel(model);
  });

  group('AlgorithmL01V44 - Тестирование', () {
    test(
      'базовый тест с двумя треугольниками и углом между центрами описанных окружностей',
      () {
        // Устанавливаем тестовые данные
        // Два треугольника с разным расположением
        when(() => model.data).thenReturn(
          AlgorithmLab0144DataModel(
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
              'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 центра описанных окружностей)',
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
          contains('### Центры описанных окружностей'),
          reason: 'Должна быть информация о центрах описанных окружностей',
        );
        expect(
          result.markdownInfo,
          contains('### Итоговые результаты'),
          reason: 'Должна быть информация об итоговых результатах',
        );
        expect(
          result.markdownInfo,
          contains(
            '- Угол между прямой через центры описанных окружностей и осью ординат:',
          ),
          reason: 'Должна быть информация об угле между прямой и осью ординат',
        );
        expect(
          result.lines.length,
          7,
          reason:
              'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через центры)',
        );

        // Проверяем цвета точек и линий
        final triangleAPoints =
            result.points.where((p) => p.color == '#00FF00').toList();
        final triangleBPoints =
            result.points.where((p) => p.color == '#FF0000').toList();
        final circumcenterAPoint =
            result.points.where((p) => p.color == '#00FFFF').toList();
        final circumcenterBPoint =
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
          circumcenterAPoint.length,
          1,
          reason:
              'Должна быть 1 точка для центра описанной окружности треугольника A',
        );
        expect(
          circumcenterBPoint.length,
          1,
          reason:
              'Должна быть 1 точка для центра описанной окружности треугольника B',
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
          reason:
              'Должна быть 1 линия, соединяющая центры описанных окружностей',
        );
      },
    );

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          AlgorithmLab0144DataModel(
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
          AlgorithmLab0144DataModel(
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
        AlgorithmLab0144DataModel(
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
            'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 центра описанных окружностей)',
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
            'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через центры)',
      );
    });

    test('тест с треугольниками, образующими вертикальную линию между центрами', () {
      // Устанавливаем точки для двух треугольников, центры описанных окружностей которых
      // образуют вертикальную линию (угол 90 градусов с осью ординат)
      when(() => model.data).thenReturn(
        AlgorithmLab0144DataModel(
          points: [
            // Треугольник A
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 10),

            // Треугольник B (расположен справа от треугольника A)
            Point(x: 20, y: 0),
            Point(x: 30, y: 0),
            Point(x: 25, y: 10),

            // Дополнительные точки
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
            'Должно быть 8 точек (по 3 вершины для каждого треугольника + 2 центра описанных окружностей)',
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
            'Должно быть 7 линий (по 3 стороны для каждого треугольника + 1 линия через центры)',
      );

      // Проверяем, что угол близок к 90 градусам (π/2 радиан)
      expect(
        result.markdownInfo,
        contains('90'),
        reason: 'Угол должен быть близок к 90 градусам',
      );
    });
  });
}
