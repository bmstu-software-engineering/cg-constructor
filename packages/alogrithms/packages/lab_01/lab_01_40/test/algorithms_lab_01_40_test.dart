import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_40/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

// Создаем мок для AlgorithmL01VBasicDataModelImpl
class AlgorithmL01VBasicDataModelImplMock extends Mock
    implements AlgorithmL01VBasicDataModelImpl {}

void main() {
  late AlgorithmL01V40 algorithm;
  late AlgorithmL01VBasicDataModelImplMock model;

  setUp(() {
    model = AlgorithmL01VBasicDataModelImplMock();
    algorithm = AlgorithmL01V40.fromModel(model);
  });

  group('AlgorithmL01V40 - Тестирование', () {
    test(
      'базовый тест с двумя множествами точек, содержащими треугольники с тупыми углами',
      () {
        // Устанавливаем тестовые данные
        // Первое множество содержит треугольник с тупым углом при вершине (5, -1)
        // Второе множество содержит треугольник с тупым углом при вершине (5, 6)
        when(() => model.data).thenReturn(
          AlgorithmLab01V40DataModel(
            pointsFirst: [
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: -1), // Вершина с тупым углом
            ],
            pointsSecond: [
              Point(x: 0, y: 5),
              Point(x: 10, y: 5),
              Point(x: 5, y: 6), // Вершина с тупым углом
            ],
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки и линии
        expect(
          result.points.length,
          6,
          reason:
              'Должно быть 6 точек (3 для первого треугольника и 3 для второго)',
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
          contains('## Результаты анализа треугольников с тупыми углами'),
          reason: 'Должен быть заголовок с результатами анализа',
        );
        expect(
          result.markdownInfo,
          contains('### Первый треугольник (зеленый)'),
          reason: 'Должна быть информация о первом треугольнике',
        );
        expect(
          result.markdownInfo,
          contains('### Второй треугольник (синий)'),
          reason: 'Должна быть информация о втором треугольнике',
        );
        expect(
          result.markdownInfo,
          contains('### Результирующая линия (красная)'),
          reason: 'Должна быть информация о результирующей линии',
        );
        expect(
          result.markdownInfo,
          contains('- Угол с осью абсцисс:'),
          reason: 'Должна быть информация об угле с осью абсцисс',
        );
        expect(
          result.lines.length,
          7,
          reason:
              'Должно быть 7 линий (3 для первого треугольника, 3 для второго и 1 результирующая)',
        );

        // Проверяем цвета точек
        final greenPoints =
            result.points.where((p) => p.color == '#00FF00').toList();
        final bluePoints =
            result.points.where((p) => p.color == '#0000FF').toList();

        expect(
          greenPoints.length,
          3,
          reason: 'Должно быть 3 зеленые точки для первого треугольника',
        );
        expect(
          bluePoints.length,
          3,
          reason: 'Должно быть 3 синие точки для второго треугольника',
        );

        // Проверяем цвета линий
        final greenLines =
            result.lines.where((l) => l.color == '#00FF00').toList();
        final blueLines =
            result.lines.where((l) => l.color == '#0000FF').toList();
        final redLines =
            result.lines.where((l) => l.color == '#FF0000').toList();

        expect(
          greenLines.length,
          3,
          reason: 'Должно быть 3 зеленые линии для первого треугольника',
        );
        expect(
          blueLines.length,
          3,
          reason: 'Должно быть 3 синие линии для второго треугольника',
        );
        expect(
          redLines.length,
          1,
          reason:
              'Должна быть 1 красная линия, соединяющая вершины с тупыми углами',
        );

        // Проверяем, что красная линия соединяет вершины с тупыми углами
        final redLine = redLines[0];
        expect(
          redLine.a,
          Point(x: 5, y: -1),
          reason:
              'Начало линии должно быть в вершине с тупым углом из первого множества',
        );
        expect(
          redLine.b,
          Point(x: 5, y: 6),
          reason:
              'Конец линии должен быть в вершине с тупым углом из второго множества',
        );
      },
    );

    test('тест на исключение NoObtuseAnglesException в первом множестве', () {
      // Устанавливаем тестовые данные с остроугольными треугольниками в первом множестве
      // и треугольниками с тупыми углами во втором множестве
      when(() => model.data).thenReturn(
        AlgorithmLab01V40DataModel(
          pointsFirst: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(
              x: 0.5,
              y: 0.866,
            ), // Равносторонний треугольник (все углы 60°)
          ],
          pointsSecond: [
            Point(x: 0, y: 5),
            Point(x: 10, y: 5),
            Point(x: 5, y: 6), // Треугольник с тупым углом
          ],
        ),
      );

      // Проверяем, что при вызове calculate выбрасывается исключение NoObtuseAnglesException
      expect(
        () => algorithm.calculate(),
        throwsA(
          isA<NoObtuseAnglesException>().having(
            (e) => e.message,
            'message',
            contains('Первое множество'),
          ),
        ),
      );
    });

    test('тест на исключение NoObtuseAnglesException во втором множестве', () {
      // Устанавливаем тестовые данные с треугольниками с тупыми углами в первом множестве
      // и остроугольными треугольниками во втором множестве
      when(() => model.data).thenReturn(
        AlgorithmLab01V40DataModel(
          pointsFirst: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: -1), // Треугольник с тупым углом
          ],
          pointsSecond: [
            Point(x: 3, y: 0),
            Point(x: 4, y: 0),
            Point(
              x: 3.5,
              y: 0.866,
            ), // Равносторонний треугольник (все углы 60°)
          ],
        ),
      );

      // Проверяем, что при вызове calculate выбрасывается исключение NoObtuseAnglesException
      expect(
        () => algorithm.calculate(),
        throwsA(
          isA<NoObtuseAnglesException>().having(
            (e) => e.message,
            'message',
            contains('Второе множество'),
          ),
        ),
      );
    });

    test('тест с несколькими треугольниками с тупыми углами', () {
      // Устанавливаем тестовые данные с несколькими треугольниками с тупыми углами
      when(() => model.data).thenReturn(
        AlgorithmLab01V40DataModel(
          pointsFirst: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: -1), // Треугольник с тупым углом при вершине (5, -1)
            Point(
              x: 5,
              y: 10,
            ), // Добавляем еще одну точку для образования новых треугольников
          ],
          pointsSecond: [
            Point(x: 0, y: 5),
            Point(x: 10, y: 5),
            Point(x: 5, y: 6), // Треугольник с тупым углом при вершине (5, 6)
            Point(
              x: 5,
              y: 15,
            ), // Добавляем еще одну точку для образования новых треугольников
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        6,
        reason:
            'Должно быть 6 точек (3 для первого треугольника и 3 для второго)',
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
            'Должно быть 7 линий (3 для первого треугольника, 3 для второго и 1 результирующая)',
      );

      // Проверяем цвета линий
      final greenLines =
          result.lines.where((l) => l.color == '#00FF00').toList();
      final blueLines =
          result.lines.where((l) => l.color == '#0000FF').toList();
      final redLines = result.lines.where((l) => l.color == '#FF0000').toList();

      expect(
        greenLines.length,
        3,
        reason: 'Должно быть 3 зеленые линии для первого треугольника',
      );
      expect(
        blueLines.length,
        3,
        reason: 'Должно быть 3 синие линии для второго треугольника',
      );
      expect(
        redLines.length,
        1,
        reason:
            'Должна быть 1 красная линия, соединяющая вершины с тупыми углами',
      );
    });

    test('тест на исключение InsufficientPointsException в первом множестве', () {
      // Устанавливаем недостаточное количество точек в первом множестве
      when(() => model.data).thenReturn(
        AlgorithmLab01V40DataModel(
          pointsFirst: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0), // Только 2 точки, недостаточно для треугольника
          ],
          pointsSecond: [
            Point(x: 0, y: 5),
            Point(x: 10, y: 5),
            Point(x: 5, y: 6),
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
            contains('Первое множество'),
          ),
        ),
      );
    });

    test(
      'тест на исключение InsufficientPointsException во втором множестве',
      () {
        // Устанавливаем недостаточное количество точек во втором множестве
        when(() => model.data).thenReturn(
          AlgorithmLab01V40DataModel(
            pointsFirst: [
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: -1),
            ],
            pointsSecond: [
              Point(
                x: 3,
                y: 0,
              ), // Только 1 точка, недостаточно для треугольника
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
              contains('Второе множество'),
            ),
          ),
        );
      },
    );

    test(
      'тест на исключение CalculationException при одинаковых множествах точек',
      () {
        // Устанавливаем одинаковые множества точек
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 5, y: -1), // Треугольник с тупым углом при вершине (5, -1)
        ];

        when(() => model.data).thenReturn(
          AlgorithmLab01V40DataModel(pointsFirst: points, pointsSecond: points),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение CalculationException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<CalculationException>().having(
              (e) => e.message,
              'message',
              contains('Не удалось найти линию с максимальным углом'),
            ),
          ),
        );
      },
    );
  });
}
