import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_52/algorithm.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_data_ns/models_data_ns.dart';

// Создаем мок для модели данных
class DualPointSetModelImplMock extends Mock implements DualPointSetModelImpl {}

void main() {
  late AlgorithmL01V52 algorithm;
  late DualPointSetModelImplMock model;

  setUp(() {
    model = DualPointSetModelImplMock();
    algorithm = AlgorithmL01V52.fromModel(model);
  });

  group('AlgorithmL01V52 - Тестирование', () {
    test(
      'базовый тест с точкой из первого множества и двумя точками из второго',
      () {
        // Устанавливаем тестовые данные
        when(() => model.data).thenReturn(
          DualPointSetModel(
            firstPoints: [
              Point(x: 0, y: 0), // Точка из первого множества
              Point(x: 10, y: 0), // Точка из первого множества
            ],
            secondPoints: [
              Point(x: 5, y: 10), // Точка из второго множества
              Point(x: 5, y: 5), // Точка из второго множества
              Point(x: 15, y: 5), // Точка из второго множества
            ],
          ),
        );

        // Вызываем метод calculate
        final result = algorithm.calculate();

        // Проверяем, что результат содержит точки, линии и текстовую информацию
        expect(
          result.points.length,
          5, // 2 точки из первого множества + 3 точки из второго множества
          reason: 'Должно быть 5 точек (2 из первого множества и 3 из второго)',
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
          contains('- Площадь:'),
          reason: 'Должна быть информация о площади треугольника',
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
        final firstSetPoints =
            result.points.where((p) => p.color == '#FF0000').toList();
        final secondSetPoints =
            result.points.where((p) => p.color == '#0000FF').toList();

        expect(
          trianglePoints.length,
          3,
          reason: 'Должно быть 3 точки для вершин треугольника',
        );
        expect(
          firstSetPoints.length + secondSetPoints.length,
          2,
          reason: 'Должно быть 2 точки, не входящие в треугольник',
        );

        // Проверяем цвета линий
        final triangleLines =
            result.lines.where((l) => l.color == '#00FF00').toList();

        expect(
          triangleLines.length,
          3,
          reason: 'Должно быть 3 линии для сторон треугольника',
        );
      },
    );

    test(
      'тест на исключение InsufficientPointsException при недостаточном количестве точек в первом множестве',
      () {
        // Устанавливаем недостаточное количество точек в первом множестве
        when(() => model.data).thenReturn(
          DualPointSetModel(
            firstPoints: [], // Нет точек в первом множестве
            secondPoints: [Point(x: 5, y: 10), Point(x: 5, y: 5)],
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
            firstPoints: [Point(x: 0, y: 0), Point(x: 10, y: 0)],
            secondPoints: [
              Point(
                x: 5,
                y: 10,
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
            firstPoints: [Point(x: 0, y: 0)],
            secondPoints: [
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
  });
}
