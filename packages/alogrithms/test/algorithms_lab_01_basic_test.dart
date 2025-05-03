import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic.dart';
import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_01_common/lab_01_common.dart';
import 'package:mocktail/mocktail.dart';

class AlgorithmL01VBasicDataModelImplMock extends Mock
    implements AlgorithmL01VBasicDataModelImpl {}

void main() {
  late AlgorithmL01VBasic algorithm;
  late AlgorithmL01VBasicDataModelImplMock model;

  setUp(() {
    model = AlgorithmL01VBasicDataModelImplMock();
    algorithm = AlgorithmL01VBasic.fromModel(model);
  });

  group('AlgorithmL01VBasic - Тестирование', () {
    test('создание модели данных', () {
      final dataModel = algorithm.getDataModel();
      expect(dataModel, isA<AlgorithmL01VBasicDataModelImplMock>());
    });

    test('базовая функциональность calculate с корректными данными', () {
      // Устанавливаем тестовые данные
      when(() => model.data).thenReturn(
        AlgorithmLab01BasicDataModel(
          points: [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 5, y: 5)],
        ),
      );

      // Вызываем метод calculate
      final result = algorithm.calculate();

      // Проверяем, что результат содержит точки и линии
      expect(result.points.length, 3, reason: 'Должно быть 3 точки');
      expect(result.lines.length, 0, reason: 'Не должно быть линий');

      // Проверяем, что все точки имеют красный цвет и толщину 1.0
      for (final point in result.points) {
        expect(
          point.color,
          '#000000',
          reason: 'Точка должна быть красного цвета',
        );
        expect(point.thickness, 1.0, reason: 'Толщина точки должна быть 1.0');
      }

      // Проверяем, что координаты точек сохранены
      expect(result.points[0].x, 0);
      expect(result.points[0].y, 0);
      expect(result.points[1].x, 10);
      expect(result.points[1].y, 0);
      expect(result.points[2].x, 5);
      expect(result.points[2].y, 5);

      // Проверяем наличие текстовой информации
      expect(
        result.markdownInfo,
        isNotEmpty,
        reason: 'Должна быть текстовая информация в формате Markdown',
      );

      // Проверяем содержимое текстовой информации
      expect(
        result.markdownInfo,
        contains('## Результаты базового алгоритма'),
        reason: 'Должен быть заголовок с результатами анализа',
      );
      expect(
        result.markdownInfo,
        contains('### Количество точек'),
        reason: 'Должна быть информация о количестве точек',
      );
      expect(
        result.markdownInfo,
        contains('Всего точек: **3**'),
        reason: 'Должно быть указано количество точек',
      );
      expect(
        result.markdownInfo,
        contains('### Координаты точек'),
        reason: 'Должна быть информация о координатах точек',
      );
      expect(
        result.markdownInfo,
        contains('- Точка 1: (0.0, 0.0)'),
        reason: 'Должна быть информация о первой точке',
      );
      expect(
        result.markdownInfo,
        contains('- Точка 2: (10.0, 0.0)'),
        reason: 'Должна быть информация о второй точке',
      );
      expect(
        result.markdownInfo,
        contains('- Точка 3: (5.0, 5.0)'),
        reason: 'Должна быть информация о третьей точке',
      );
    });

    test('исключение при доступе к данным до их установки', () {
      // Проверяем, что при попытке доступа к данным до их установки
      // выбрасывается исключение
      when(() => model.data).thenThrow(Exception('Данные не установлены'));

      expect(
        () => algorithm.calculate(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Данные не установлены'),
          ),
        ),
      );
    });

    test('обработка некорректных данных в поле points', () {
      // Устанавливаем некорректные данные в поле points
      when(
        () => model.data,
      ).thenThrow(InvalidDataException('Ошибка при обработке данных'));

      expect(
        () => algorithm.calculate(),
        throwsA(
          isA<InvalidDataException>().having(
            (e) => e.message,
            'message',
            contains('Ошибка при обработке данных'),
          ),
        ),
      );
    });
  });
}
