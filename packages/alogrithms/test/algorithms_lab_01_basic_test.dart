import 'package:flutter_test/flutter_test.dart';
import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic.dart';
import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

void main() {
  late AlgorithmL01VBasic algorithm;

  setUp(() {
    algorithm = AlgorithmL01VBasic();
  });

  group('AlgorithmL01VBasic - Тестирование', () {
    test('создание модели данных', () {
      final dataModel = algorithm.getDataModel();
      expect(dataModel, isA<AlgorithmL01VBasicCodegenDataModelImpl>());

      final formsDataModel = dataModel;
      expect(formsDataModel.config.name, '');
      expect(formsDataModel.config.fields.length, 1);
      expect(formsDataModel.config.fields[0].id, 'points');
      expect(formsDataModel.config.fields[0].type, FieldType.list);
    });

    test('базовая функциональность calculate с корректными данными', () {
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем тестовые данные
      dataModel.rawData = {
        'points': [Point(x: 0, y: 0), Point(x: 10, y: 0), Point(x: 5, y: 5)],
      };

      // Вызываем метод calculate
      final result = algorithm.calculate(dataModel);

      // Проверяем, что результат содержит точки и линии
      expect(result.points.length, 3, reason: 'Должно быть 3 точки');
      expect(result.lines.length, 0, reason: 'Не должно быть линий');

      // Проверяем, что все точки имеют красный цвет и толщину 1.0
      for (final point in result.points) {
        expect(
          point.color,
          '#FF0000',
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
    });

    test('исключение InvalidDataException при неверном типе модели данных', () {
      // Создаем фиктивную модель данных неверного типа
      final invalidDataModel = _MockFormsDataModel();

      // Проверяем, что при вызове calculate с неверным типом модели данных
      // выбрасывается исключение InvalidDataException
      expect(
        () => algorithm.calculate(invalidDataModel),
        throwsA(
          isA<InvalidDataException>().having(
            (e) => e.message,
            'message',
            'Неверный тип модели данных',
          ),
        ),
      );
    });

    test('исключение InvalidDataException при отсутствии данных', () {
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Проверяем, что при установке null в качестве данных
      // выбрасывается исключение InvalidDataException
      expect(
        () => dataModel.rawData = null,
        throwsA(
          isA<InvalidDataException>().having(
            (e) => e.message,
            'message',
            'Данные не предоставлены',
          ),
        ),
      );
    });

    test('исключение при доступе к данным до их установки', () {
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Проверяем, что при попытке доступа к данным до их установки
      // выбрасывается исключение
      expect(
        () => dataModel.data,
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
      // Создаем модель данных
      final dataModel = algorithm.getDataModel();

      // Устанавливаем некорректные данные в поле points
      expect(
        () => dataModel.rawData = {'points': 'не список'},
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

// Мок-класс для тестирования неверного типа модели данных
class _MockFormsDataModel implements FormsDataModel {
  @override
  FormConfig get config => throw UnimplementedError();

  @override
  AlgorithmData get data => throw UnimplementedError();

  @override
  set rawData(Map<String, dynamic>? rawData) => throw UnimplementedError();
}
