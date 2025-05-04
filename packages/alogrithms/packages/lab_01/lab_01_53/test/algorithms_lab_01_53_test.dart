import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_53/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_data_ns/models_data_ns.dart';

// Создаем мок для DualPointSetModelImpl
class DualPointSetModelImplMock extends Mock implements DualPointSetModelImpl {}

void main() {
  late AlgorithmL01V53 algorithm;
  late DualPointSetModelImplMock model;

  setUp(() {
    model = DualPointSetModelImplMock();
    algorithm = AlgorithmL01V53.fromModel(model);
  });

  group('AlgorithmL01V53 - Тестирование', () {
    test('базовый тест с двумя точками из первого множества и точкой из второго', () {
      // Устанавливаем тестовые данные
      when(() => model.data).thenReturn(
        DualPointSetModel(
          firstPoints: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0),
            Point(x: 5, y: 5),
          ],
          secondPoints: [Point(x: 5, y: 10), Point(x: 15, y: 5)],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки, линии и текстовую информацию
      expect(
        result.points.length,
        6, // 3 точки из первого множества + 2 точки из второго + 1 барицентр
        reason:
            'Должно быть 6 точек (3 из первого множества, 2 из второго и барицентр)',
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
        contains('### Барицентр треугольника'),
        reason: 'Должна быть информация о барицентре треугольника',
      );
      expect(
        result.markdownInfo,
        contains('- Азимут:'),
        reason: 'Должна быть информация об азимуте барицентра',
      );

      // Проверяем, что в результате есть линии для треугольника и азимута
      expect(
        result.lines.length,
        4, // 3 стороны треугольника + 1 линия азимута
        reason:
            'Должно быть 4 линии (3 стороны треугольника и 1 линия азимута)',
      );

      // Проверяем цвета точек
      final trianglePoints =
          result.points.where((p) => p.color == '#00FF00').toList();
      final firstSetPoints =
          result.points.where((p) => p.color == '#0000FF').toList();
      final secondSetPoints =
          result.points.where((p) => p.color == '#FF0000').toList();
      final barycenterPoint =
          result.points.where((p) => p.color == '#FF00FF').toList();

      expect(
        trianglePoints.length,
        3,
        reason: 'Должно быть 3 точки для вершин треугольника',
      );
      expect(
        firstSetPoints.length +
            2, // 2 точки из первого множества в треугольнике
        3,
        reason:
            'Должно быть 3 точки из первого множества (включая 2 вершины треугольника)',
      );
      expect(
        secondSetPoints.length +
            1, // 1 точка из второго множества в треугольнике
        2,
        reason:
            'Должно быть 2 точки из второго множества (включая 1 вершину треугольника)',
      );
      expect(
        barycenterPoint.length,
        1,
        reason: 'Должна быть 1 точка для барицентра',
      );

      // Проверяем цвета линий
      final triangleLines =
          result.lines.where((l) => l.color == '#00FF00').toList();
      final azimuthLine =
          result.lines.where((l) => l.color == '#FFA500').toList();

      expect(
        triangleLines.length,
        3,
        reason: 'Должно быть 3 линии для сторон треугольника',
      );
      expect(azimuthLine.length, 1, reason: 'Должна быть 1 линия для азимута');
    });

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек в первом множестве',
      () {
        // Устанавливаем недостаточное количество точек в первом множестве
        when(() => model.data).thenReturn(
          DualPointSetModel(
            firstPoints: [
              Point(
                x: 0,
                y: 0,
              ), // Только 1 точка, недостаточно для треугольника
            ],
            secondPoints: [Point(x: 5, y: 10), Point(x: 15, y: 5)],
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<InsufficientPointsException>().having(
              (e) => e.message,
              'message',
              contains('Первое множество точек'),
            ),
          ),
        );
      },
    );

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек во втором множестве',
      () {
        // Устанавливаем недостаточное количество точек во втором множестве
        when(() => model.data).thenReturn(
          DualPointSetModel(
            firstPoints: [
              Point(x: 0, y: 0),
              Point(x: 10, y: 0),
              Point(x: 5, y: 5),
            ],
            secondPoints: [], // Нет точек во втором множестве
          ),
        );

        // Проверяем, что при вызове calculate выбрасывается исключение InsufficientPointsException
        expect(
          () => algorithm.calculate(),
          throwsA(
            isA<InsufficientPointsException>().having(
              (e) => e.message,
              'message',
              contains('Второе множество точек'),
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
          DualPointSetModel(
            firstPoints: [
              Point(x: 0, y: 0),
              Point(x: 1, y: 0),
              Point(x: 2, y: 0), // Все точки лежат на одной прямой
            ],
            secondPoints: [
              Point(x: 3, y: 0), // Точка на той же прямой
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
  });
}
