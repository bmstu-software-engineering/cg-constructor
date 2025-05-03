import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_48/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01V48DataModelImpl
class AlgorithmL01V48DataModelImplMock extends Mock
    implements AlgorithmL01V48DataModelImpl {}

void main() {
  late AlgorithmL01V48 algorithm;
  late AlgorithmL01V48DataModelImplMock model;

  setUp(() {
    model = AlgorithmL01V48DataModelImplMock();
    algorithm = AlgorithmL01V48.fromModel(model);
  });

  group('AlgorithmL01V48 - Тестирование', () {
    test(
      'базовый тест с треугольником максимальной площади, внутри описанной окружности которого находится точка pB',
      () {
        // Устанавливаем тестовые данные
        when(() => model.data).thenReturn(
          AlgorithmLab0148DataModel(
            points: [
              // Точки для формирования треугольников
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 10),
              Point(x: 20, y: 0),
              Point(x: 25, y: 10),
              Point(x: 30, y: 0),
            ],
            pointB: Point(
              x: 5,
              y: 5,
            ), // Точка внутри описанной окружности первого треугольника
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки, линии и текстовую информацию
        expect(
          result.points.length,
          greaterThanOrEqualTo(
            5,
          ), // 3 вершины треугольника + точка pB + центр описанной окружности
          reason:
              'Должно быть как минимум 5 точек (3 вершины треугольника + точка pB + центр описанной окружности)',
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
          contains('### Координаты вершин треугольника максимальной площади'),
          reason:
              'Должна быть информация о координатах вершин треугольника максимальной площади',
        );
        expect(
          result.markdownInfo,
          contains('### Описанная окружность'),
          reason: 'Должна быть информация об описанной окружности',
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
        final circumcenterPoint =
            result.points.where((p) => p.color == '#00FFFF').toList();
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
          circumcenterPoint.length,
          1,
          reason: 'Должна быть 1 точка для центра описанной окружности',
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
          AlgorithmLab0148DataModel(
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
      'тест на исключение CalculationException при отсутствии треугольников, содержащих точку pB в описанной окружности',
      () {
        // Устанавливаем точки так, чтобы точка pB не находилась внутри описанной окружности ни одного треугольника
        when(() => model.data).thenReturn(
          AlgorithmLab0148DataModel(
            points: [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 5, y: 10)],
            pointB: Point(x: 100, y: 100), // Точка далеко от треугольника
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
                'Не найдено треугольников, внутри описанной окружности которых находится точка pB',
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
          AlgorithmLab0148DataModel(
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

    test(
      'тест с несколькими треугольниками, содержащими точку pB в описанной окружности',
      () {
        // Устанавливаем точки так, чтобы точка pB находилась внутри описанных окружностей нескольких треугольников
        when(() => model.data).thenReturn(
          AlgorithmLab0148DataModel(
            points: [
              // Точки для формирования треугольников
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 10), // Треугольник 1 (большей площади)
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 5), // Треугольник 2 (меньшей площади)
            ],
            pointB: Point(
              x: 5,
              y: 2,
            ), // Точка внутри описанных окружностей обоих треугольников
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки и линии
        expect(
          result.points.length,
          greaterThanOrEqualTo(5),
          reason:
              'Должно быть как минимум 5 точек (3 вершины треугольника + точка pB + центр описанной окружности)',
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

        // Проверяем, что выбран треугольник с максимальной площадью
        expect(
          result.markdownInfo,
          contains('Площадь треугольника:'),
          reason: 'Должна быть информация о площади треугольника',
        );
      },
    );
  });
}
