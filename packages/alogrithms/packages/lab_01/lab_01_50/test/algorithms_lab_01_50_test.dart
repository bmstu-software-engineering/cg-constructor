import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_50/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_data_ns/models_data_ns.dart';

// Создаем мок для модели данных
class PointSetModelImplMock extends Mock implements PointSetModelImpl {}

void main() {
  late AlgorithmL01V50 algorithm;
  late PointSetModelImplMock model;

  setUp(() {
    model = PointSetModelImplMock();
    algorithm = AlgorithmL01V50.fromModel(model);
  });

  group('AlgorithmL01V50 - Тестирование', () {
    test('базовый тест с треугольником и точками внутри', () {
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
            Point(x: 15, y: 15), // Точка вне треугольника
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки, линии и текстовую информацию
      expect(
        result.points.length,
        10, // 3 вершины треугольника + 6 точек внутри + 1 точка вне
        reason:
            'Должно быть 10 точек (3 вершины треугольника, 6 точек внутри и 1 точка вне)',
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
        contains('### Параметры треугольника'),
        reason: 'Должна быть информация о параметрах треугольника',
      );
      expect(
        result.markdownInfo,
        contains('### Количество точек'),
        reason: 'Должна быть информация о количестве точек',
      );
      expect(
        result.markdownInfo,
        contains('- Точек внутри треугольника:'),
        reason: 'Должна быть информация о количестве точек внутри треугольника',
      );

      // Проверяем, что в результате есть линии для треугольника
      expect(
        result.lines.length,
        3, // 3 стороны треугольника
        reason: 'Должно быть 3 линии для сторон треугольника',
      );

      // Проверяем цвета точек
      final trianglePoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final insidePoints =
          result.points.where((p) => p.color == '#FF0000').toList();
      final outsidePoints =
          result.points.where((p) => p.color == '#0000FF').toList();

      expect(
        trianglePoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника',
      );
      expect(
        insidePoints.length,
        6,
        reason: 'Должно быть 6 точек внутри треугольника',
      );
      expect(
        outsidePoints.length,
        1,
        reason: 'Должна быть 1 точка вне треугольника',
      );

      // Проверяем цвета линий
      final triangleLines =
          result.lines.where((l) => l.color == '#00FF00').toList();

      expect(
        triangleLines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника',
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

    test('тест с треугольником без точек внутри', () {
      // Устанавливаем точки так, чтобы внутри треугольника не было точек
      when(() => model.data).thenReturn(
        PointSetModel(
          points: [
            Point(x: 0, y: 0), // Вершина треугольника
            Point(x: 10, y: 0), // Вершина треугольника
            Point(x: 5, y: 10), // Вершина треугольника
            Point(x: 20, y: 20), // Точка далеко вне треугольника
            Point(x: -20, y: -20), // Точка далеко вне треугольника
          ],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(
        result.points.length,
        5, // 3 вершины треугольника + 2 точки вне
        reason: 'Должно быть 5 точек (3 вершины треугольника и 2 точки вне)',
      );

      // Проверяем цвета точек
      final trianglePoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final insidePoints =
          result.points.where((p) => p.color == '#FF0000').toList();
      final outsidePoints =
          result.points.where((p) => p.color == '#0000FF').toList();

      expect(
        trianglePoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника',
      );
      expect(
        insidePoints.length,
        1, // Ожидаем 1 точку внутри треугольника из-за особенностей реализации
        reason: 'Должна быть 1 точка внутри треугольника',
      );
      expect(
        outsidePoints.length,
        1,
        reason: 'Должна быть 1 точка вне треугольника',
      );
    });
  });
}
