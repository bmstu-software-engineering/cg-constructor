import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_49/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_data_ns/models_data_ns.dart';

// Создаем мок для PointSetWithReferencePointModelImpl
class PointSetWithReferencePointModelImplMock extends Mock
    implements PointSetWithReferencePointModelImpl {}

void main() {
  late AlgorithmL01V49 algorithm;
  late PointSetWithReferencePointModelImplMock model;

  setUp(() {
    model = PointSetWithReferencePointModelImplMock();
    algorithm = AlgorithmL01V49.fromModel(model);
  });

  group('AlgorithmL01V49 - Тестирование', () {
    test('базовый тест с треугольником и точкой внутри описанной окружности', () {
      // Устанавливаем тестовые данные
      // Треугольник с вершинами в (0,0), (10,0), (5,10)
      // и контрольная точка внутри описанной окружности
      when(() => model.data).thenReturn(
        PointSetWithReferencePointModel(
          points: [
            Point(x: 0, y: 0), // Вершина треугольника
            Point(x: 10, y: 0), // Вершина треугольника
            Point(x: 5, y: 10), // Вершина треугольника
            Point(x: 2, y: 2), // Дополнительная точка
            Point(x: 8, y: 2), // Дополнительная точка
          ],
          referencePoint: Point(
            x: 5,
            y: 3,
          ), // Точка внутри описанной окружности
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки, линии и текстовую информацию
      expect(
        result.points.length,
        greaterThanOrEqualTo(5),
        reason:
            'Должно быть минимум 5 точек (3 вершины треугольника, контрольная точка и центр описанной окружности)',
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
        contains('### Координаты вершин треугольника'),
        reason: 'Должна быть информация о координатах вершин',
      );
      expect(
        result.markdownInfo,
        contains('### Параметры треугольника'),
        reason: 'Должна быть информация о параметрах треугольника',
      );
      expect(
        result.markdownInfo,
        contains('- Периметр:'),
        reason: 'Должна быть информация о периметре треугольника',
      );
      expect(
        result.markdownInfo,
        contains('### Контрольная точка'),
        reason: 'Должна быть информация о контрольной точке',
      );

      // Проверяем цвета точек
      final trianglePoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final referencePoint =
          result.points.where((p) => p.color == '#FF0000').toList();
      final circumcenterPoint =
          result.points.where((p) => p.color == '#0000FF').toList();

      expect(
        trianglePoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника',
      );
      expect(
        referencePoint.length,
        1,
        reason: 'Должна быть 1 точка для контрольной точки',
      );
      expect(
        circumcenterPoint.length,
        1,
        reason: 'Должна быть 1 точка для центра описанной окружности',
      );

      // Проверяем цвета линий
      final triangleLines =
          result.lines.where((l) => l.color == '#00FF00').toList();
      final circumcircleLines =
          result.lines.where((l) => l.color == '#0000FF').toList();

      expect(
        triangleLines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника',
      );
      expect(
        circumcircleLines.length,
        greaterThan(0),
        reason: 'Должны быть линии для описанной окружности',
      );
    });

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек',
      () {
        // Устанавливаем недостаточное количество точек
        when(() => model.data).thenReturn(
          PointSetWithReferencePointModel(
            points: [
              Point(x: 0, y: 0),
              Point(
                x: 1,
                y: 0,
              ), // Только 2 точки, недостаточно для треугольника
            ],
            referencePoint: Point(x: 0.5, y: 0.5),
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
      'тест на исключение CalculationException при отсутствии подходящего треугольника',
      () {
        // Устанавливаем точки так, чтобы контрольная точка не попадала внутрь описанной окружности ни одного треугольника
        when(() => model.data).thenReturn(
          PointSetWithReferencePointModel(
            points: [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1)],
            referencePoint: Point(
              x: 100,
              y: 100,
            ), // Точка далеко от треугольника
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение CalculationException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<CalculationException>().having(
              (e) => e.message,
              'message',
              contains('Не удалось найти треугольник'),
            ),
          ),
        );
      },
    );
  });
}
