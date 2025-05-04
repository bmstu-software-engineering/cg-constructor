import 'package:alogrithms/algorithms/lab_02/lab_02.dart';
import 'package:algorithm_interface/algorithm_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models_data_ns/models_data_ns.dart';

class GeometricTransformationModelImplMock extends Mock
    implements GeometricTransformationModelImpl {}

class AlgorithmL02TestImpl extends AlgorithmL02 {
  AlgorithmL02TestImpl(super.model) : super.fromModel();

  // Метод для тестирования _FigureCollectionHolder
  void testHolderFunctionality() {
    // Проверяем, что holder пуст и выбрасывает исключение
    try {
      holder.last;
      throw Exception(
        'Должно быть выброшено исключение NoDataAlgorithmException',
      );
    } catch (e) {
      if (e is! NoDataAlgorithmException) {
        throw Exception('Выброшено неверное исключение: $e');
      }
    }
  }
}

class FigureCollectionMock extends Mock implements FigureCollection {
  @override
  FigureCollection move(Vector vector) => this;

  @override
  FigureCollection scale(Point center, Scale scale) => this;

  @override
  FigureCollection rotate(Point center, double angle) => this;
}

void main() {
  late AlgorithmL02 algorithm;
  late GeometricTransformationModelImplMock model;
  late GeometricTransformationModel mockData;
  late FigureCollectionMock figureCollection;

  setUp(() {
    model = GeometricTransformationModelImplMock();
    algorithm = AlgorithmL02.fromModel(model);
    figureCollection = FigureCollectionMock();

    // Создаем мок для данных
    mockData = GeometricTransformationModel(
      translation: Vector(dx: 10, dy: 20),
      rotation: RotateTransformationModel(
        center: Point(x: 0, y: 0),
        angle: Angle(value: 45.0),
      ),
      scaling: ScaleTransformationModel(
        center: Point(x: 0, y: 0),
        scale: Scale(x: 2.0, y: 2.0),
      ),
    );

    // Настраиваем мок для модели
    when(() => model.data).thenReturn(mockData);
  });

  group('AlgorithmL02 - Тестирование', () {
    test('создание модели данных', () {
      final dataModel = algorithm.getDataModel();
      expect(dataModel, isA<GeometricTransformationModelImpl>());
      expect(dataModel, equals(model));
    });

    test('получение доступных вариантов алгоритма', () {
      final variants = algorithm.getAvailableVariants();

      expect(variants.length, 4, reason: 'Должно быть 4 варианта алгоритма');

      expect(variants[0].id, 'move', reason: 'Первый вариант должен быть move');
      expect(
        variants[0].name,
        'Переместить',
        reason: 'Неверное название для move',
      );

      expect(
        variants[1].id,
        'scale',
        reason: 'Второй вариант должен быть scale',
      );
      expect(
        variants[1].name,
        'Масштабировать',
        reason: 'Неверное название для scale',
      );

      expect(
        variants[2].id,
        'rotate',
        reason: 'Третий вариант должен быть rotate',
      );
      expect(
        variants[2].name,
        'Повернуть',
        reason: 'Неверное название для rotate',
      );

      expect(
        variants[3].id,
        'revert',
        reason: 'Четвертый вариант должен быть revert',
      );
      expect(
        variants[3].name,
        'Шаг назад',
        reason: 'Неверное название для revert',
      );
    });

    test('исключение при доступе к данным до их установки', () {
      // Проверяем, что при попытке вызвать calculateWithVariant без загруженных фигур
      // выбрасывается NoDataAlgorithmException
      expect(
        () => algorithm.calculateWithVariant('move'),
        throwsA(isA<NoDataAlgorithmException>()),
      );
    });

    test('исключение при вызове calculate', () {
      // Проверяем, что при попытке вызвать calculate
      // выбрасывается UnimplementedError
      expect(() => algorithm.calculate(), throwsA(isA<UnimplementedError>()));
    });

    test('исключение при неизвестном варианте алгоритма', () {
      // Проверяем, что при попытке вызвать calculateWithVariant с неизвестным вариантом
      // выбрасывается исключение
      expect(
        () => algorithm.calculateWithVariant('unknown'),
        throwsA(isA<StateError>()),
      );
    });

    test('проверка параметров преобразований', () {
      // Проверяем, что параметры преобразований соответствуют ожидаемым
      expect(mockData.translation.dx, 10);
      expect(mockData.translation.dy, 20);
      expect(mockData.rotation.center.x, 0);
      expect(mockData.rotation.center.y, 0);
      expect(mockData.rotation.angle.value, 45.0);
      expect(mockData.scaling.center.x, 0);
      expect(mockData.scaling.center.y, 0);
      expect(mockData.scaling.scale.x, 2.0);
      expect(mockData.scaling.scale.y, 2.0);
    });

    test('проверка доступа к модели данных', () {
      // Проверяем, что модель данных доступна через getDataModel
      final dataModel = algorithm.getDataModel();
      expect(dataModel, equals(model));

      // Проверяем, что данные модели доступны через data
      expect(model.data, equals(mockData));
    });

    test('тестирование _FigureCollectionHolder', () {
      // Создаем тестовую реализацию AlgorithmL02
      final testAlgorithm = AlgorithmL02TestImpl(model);

      // Вызываем метод для тестирования _FigureCollectionHolder
      testAlgorithm.testHolderFunctionality();
    });

    test('проверка вариантов алгоритма', () {
      // Проверяем, что все варианты алгоритма соответствуют ожидаемым
      final variants = algorithm.getAvailableVariants();

      // Проверяем количество вариантов
      expect(variants.length, 4);

      // Проверяем идентификаторы вариантов
      expect(variants.map((v) => v.id).toList(), [
        'move',
        'scale',
        'rotate',
        'revert',
      ]);

      // Проверяем названия вариантов
      expect(variants.map((v) => v.name).toList(), [
        'Переместить',
        'Масштабировать',
        'Повернуть',
        'Шаг назад',
      ]);
    });

    group('Тестирование calculateWithVariant', () {
      setUp(() {
        // Устанавливаем коллекцию фигур для тестирования
        algorithm.setFigureCollection(figureCollection);
      });

      test('вариант move - перемещение фигур', () {
        // Вызываем метод calculateWithVariant с вариантом move
        final result = algorithm.calculateWithVariant('move');

        // Проверяем, что результат является ResultModel
        expect(result, isA<ResultModel>());
      });

      test('вариант scale - масштабирование фигур', () {
        // Вызываем метод calculateWithVariant с вариантом scale
        final result = algorithm.calculateWithVariant('scale');

        // Проверяем, что результат является ResultModel
        expect(result, isA<ResultModel>());
      });

      test('вариант rotate - поворот фигур', () {
        // Вызываем метод calculateWithVariant с вариантом rotate
        final result = algorithm.calculateWithVariant('rotate');

        // Проверяем, что результат является ResultModel
        expect(result, isA<ResultModel>());
      });

      test('вариант revert - отмена последнего действия', () {
        // Добавляем еще одну коллекцию в стек
        algorithm.setFigureCollection(FigureCollectionMock());

        // Вызываем метод calculateWithVariant с вариантом revert
        final result = algorithm.calculateWithVariant('revert');

        // Проверяем, что результат является ResultModel
        expect(result, isA<ResultModel>());
      });

      test(
        'добавление новой коллекции в стек после каждого преобразования',
        () {
          // Получаем текущий размер стека
          final initialStackSize = algorithm.stackSize;

          // Вызываем метод calculateWithVariant с вариантом move
          algorithm.calculateWithVariant('move');

          // Проверяем, что размер стека увеличился на 1
          expect(algorithm.stackSize, equals(initialStackSize + 1));
        },
      );
    });
  });
}
