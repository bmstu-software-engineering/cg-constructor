import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_46/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01V46DataModelImpl
class AlgorithmL01V46DataModelImplMock extends Mock
    implements AlgorithmL01V46DataModelImpl {}

void main() {
  late AlgorithmL01V46 algorithm;
  late AlgorithmL01V46DataModelImplMock model;

  setUp(() {
    model = AlgorithmL01V46DataModelImplMock();
    algorithm = AlgorithmL01V46.fromModel(model);
  });

  group('AlgorithmL01V46 - Тестирование', () {
    test(
      'базовый тест с треугольником минимальной площади, содержащим точку pB',
      () {
        // Устанавливаем тестовые данные
        when(() => model.data).thenReturn(
          AlgorithmLab0146DataModel(
            points: [
              // Точки для формирования треугольников
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 10),
              Point(x: 20, y: 0),
              Point(x: 25, y: 10),
              Point(x: 30, y: 0),
            ],
            pointB: Point(x: 5, y: 5), // Точка внутри первого треугольника
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки, линии и текстовую информацию
        expect(
          result.points.length,
          greaterThanOrEqualTo(4), // 3 вершины треугольника + точка pB
          reason:
              'Должно быть как минимум 4 точки (3 вершины треугольника + точка pB)',
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
          contains('## Результаты анализа'),
          reason: 'Должен быть заголовок с результатами анализа',
        );
        expect(
          result.markdownInfo,
          contains('### Координаты вершин треугольника минимальной площади'),
          reason:
              'Должна быть информация о координатах вершин треугольника минимальной площади',
        );
        expect(
          result.markdownInfo,
          contains('### Точка pB'),
          reason: 'Должна быть информация о точке pB',
        );
        expect(
          result.markdownInfo,
          contains('### Итоговые результаты'),
          reason: 'Должна быть информация об итоговых результатах',
        );
        expect(
          result.markdownInfo,
          contains('- Площадь треугольника:'),
          reason: 'Должна быть информация о площади треугольника',
        );
        expect(
          result.lines.length,
          3,
          reason: 'Должно быть 3 линии для сторон треугольника',
        );

        // Проверяем цвета точек и линий
        final trianglePoints =
            result.points.where((p) => p.color == '#00FF00').toList();
        final pointBPoint =
            result.points.where((p) => p.color == '#FF0000').toList();
        final triangleLines =
            result.lines.where((l) => l.color == '#00FF00').toList();

        expect(
          trianglePoints.length,
          3,
          reason: 'Должно быть 3 точки для вершин треугольника',
        );
        expect(
          pointBPoint.length,
          1,
          reason: 'Должна быть 1 точка для точки pB',
        );
        expect(
          triangleLines.length,
          3,
          reason: 'Должно быть 3 линии для сторон треугольника',
        );
      },
    );

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          AlgorithmLab0146DataModel(
            points: [
              Point(x: 0, y: 0),
              Point(
                x: 1,
                y: 0,
              ), // Только 2 точки, недостаточно для треугольника
            ],
            pointB: Point(x: 0.5, y: 0.5),
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
      'тест на исключение CalculationException при отсутствии треугольников, содержащих точку pB',
      () {
        // Устанавливаем точки так, чтобы точка pB не находилась внутри ни одного треугольника
        when(() => model.data).thenReturn(
          AlgorithmLab0146DataModel(
            points: [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 5, y: 10)],
            pointB: Point(x: 20, y: 20), // Точка вне треугольника
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
                'Не найдено треугольников, внутри которых находится точка pB',
              ),
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
          AlgorithmLab0146DataModel(
            points: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              Point(x: 2, y: 0), // Точки лежат на одной прямой
            ],
            pointB: Point(x: 1, y: 0), // Точка на прямой
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

    test('тест с несколькими треугольниками, содержащими точку pB', () {
      // Устанавливаем точки так, чтобы точка pB находилась внутри нескольких треугольников
      when(() => model.data).thenReturn(
        AlgorithmLab0146DataModel(
          points: [
            // Точки для формирования треугольников
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 10), // Треугольник 1
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 5), // Треугольник 2 (меньшей площади)
          ],
          pointB: Point(x: 5, y: 2), // Точка внутри обоих треугольников
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        greaterThanOrEqualTo(4),
        reason:
            'Должно быть как минимум 4 точки (3 вершины треугольника + точка pB)',
      );

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );
      expect(
        result.lines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника',
      );

      // Проверяем, что выбран треугольник с минимальной площадью
      expect(
        result.markdownInfo,
        contains('Площадь треугольника:'),
        reason: 'Должна быть информация о площади треугольника',
      );
    });
  });
}
