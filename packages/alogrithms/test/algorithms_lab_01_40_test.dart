import 'package:flutter_test/flutter_test.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:alogrithms/algorithms/lab_01_40.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  late AlgorithmL01V40 algorithm;

  setUp(() {
    algorithm = AlgorithmL01V40();
  });

  group('AlgorithmL01V40 - Тестирование', () {
    test(
      'базовый тест с двумя множествами точек, содержащими треугольники с тупыми углами',
      () {
        // Создаем модель данных
        final dataModel = algorithm.getDataModel();

        // Устанавливаем тестовые данные
        // Первое множество содержит треугольник с тупым углом при вершине (5, -1)
        // Второе множество содержит треугольник с тупым углом при вершине (5, 6)
        dataModel.rawData = {
          'points_first': [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: -1), // Вершина с тупым углом
          ],
          'points_second': [
            Point(x: 0, y: 5),
            Point(x: 10, y: 5),
            Point(x: 5, y: 6), // Вершина с тупым углом
          ],
        };

        // Вызываем метод calculate
        final result = algorithm.calculate(dataModel);

        // Проверяем, что результат содержит точки и линии
        expect(
          result.points.length,
          6,
          reason:
              'Должно быть 6 точек (3 для первого треугольника и 3 для второго)',
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
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем тестовые данные с остроугольными треугольниками в первом множестве
      // и треугольниками с тупыми углами во втором множестве
      dataModel.rawData = {
        'points_first': [
          Point(x: 0, y: 0),
          Point(x: 1, y: 0),
          Point(x: 0.5, y: 0.866), // Равносторонний треугольник (все углы 60°)
        ],
        'points_second': [
          Point(x: 0, y: 5),
          Point(x: 10, y: 5),
          Point(x: 5, y: 6), // Треугольник с тупым углом
        ],
      };

      // Проверяем, что при вызове calculate выбрасывается исключение NoObtuseAnglesException
      expect(
        () => algorithm.calculate(dataModel),
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
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем тестовые данные с треугольниками с тупыми углами в первом множестве
      // и остроугольными треугольниками во втором множестве
      dataModel.rawData = {
        'points_first': [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 5, y: -1), // Треугольник с тупым углом
        ],
        'points_second': [
          Point(x: 3, y: 0),
          Point(x: 4, y: 0),
          Point(x: 3.5, y: 0.866), // Равносторонний треугольник (все углы 60°)
        ],
      };

      // Проверяем, что при вызове calculate выбрасывается исключение NoObtuseAnglesException
      expect(
        () => algorithm.calculate(dataModel),
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
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем тестовые данные с несколькими треугольниками с тупыми углами
      dataModel.rawData = {
        'points_first': [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 5, y: -1), // Треугольник с тупым углом при вершине (5, -1)
          Point(
            x: 5,
            y: 10,
          ), // Добавляем еще одну точку для образования новых треугольников
        ],
        'points_second': [
          Point(x: 0, y: 5),
          Point(x: 10, y: 5),
          Point(x: 5, y: 6), // Треугольник с тупым углом при вершине (5, 6)
          Point(
            x: 5,
            y: 15,
          ), // Добавляем еще одну точку для образования новых треугольников
        ],
      };

      // Вызываем метод calculate
      final result = algorithm.calculate(dataModel);

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        6,
        reason:
            'Должно быть 6 точек (3 для первого треугольника и 3 для второго)',
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
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем недостаточное количество точек в первом множестве
      dataModel.rawData = {
        'points_first': [
          Point(x: 0, y: 0),
          Point(x: 1, y: 0), // Только 2 точки, недостаточно для треугольника
        ],
        'points_second': [
          Point(x: 0, y: 5),
          Point(x: 10, y: 5),
          Point(x: 5, y: 6),
        ],
      };

      // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
      expect(
        () => algorithm.calculate(dataModel),
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
        // Создаем модель данных
        final dataModel = algorithm.getDataModel();

        // Устанавливаем недостаточное количество точек во втором множестве
        dataModel.rawData = {
          'points_first': [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: -1),
          ],
          'points_second': [
            Point(x: 3, y: 0), // Только 1 точка, недостаточно для треугольника
          ],
        };

        // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
        expect(
          () => algorithm.calculate(dataModel),
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

    test('тест на исключение InvalidDataException при отсутствии данных', () {
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Проверяем, что при установке null в качестве данных выбрасывается исключение InvalidDataException
      expect(
        () => dataModel.rawData = null,
        throwsA(
          isA<InvalidDataException>().having(
            (e) => e.message,
            'message',
            contains('Данные не предоставлены'),
          ),
        ),
      );
    });

    test(
      'тест на исключение InvalidDataException при отсутствии обязательных полей',
      () {
        // Создаем модель данных
        final dataModel = algorithm.getDataModel();

        // Устанавливаем данные без обязательных полей
        expect(
          () => dataModel.rawData = {'some_field': 'some_value'},
          throwsA(
            isA<InvalidDataException>().having(
              (e) => e.message,
              'message',
              contains('Отсутствуют обязательные поля данных'),
            ),
          ),
        );
      },
    );

    test(
      'тест на исключение CalculationException при одинаковых множествах точек',
      () {
        // Создаем модель данных
        final dataModel = algorithm.getDataModel();

        // Устанавливаем одинаковые множества точек
        final points = [
          Point(x: 0, y: 0),
          Point(x: 10, y: 0),
          Point(x: 5, y: -1), // Треугольник с тупым углом при вершине (5, -1)
        ];

        dataModel.rawData = {'points_first': points, 'points_second': points};

        // Проверяем, что при вызове calculate выбрасывается исключение CalculationException
        expect(
          () => algorithm.calculate(dataModel),
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
