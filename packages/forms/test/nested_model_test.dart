import 'package:flutter_test/flutter_test.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

part 'nested_model_test.g.dart';

@FormGen()
class AlgorithmLab02DataModelScale {
  @PointFieldGen(label: 'Центр вращения')
  final Point center;

  @ScaleFieldGen(label: 'Коэфициенты масшабирования')
  final Scale scale;

  const AlgorithmLab02DataModelScale({
    required this.center,
    required this.scale,
  });
}

/// Модель данных для алгоритма Lab02
@FormGen()
class AlgorithmLab02DataModel {
  /// Вектор перемещения
  @VectorFieldGen(label: 'Вектор перемещения')
  final Vector move;

  /// Угол поворота
  @AngleFieldGen(label: 'Угол поворота')
  final Angle rotate;

  /// Параметры масштабирования
  @FieldGenAnnotation(label: 'Параметры масштабирования')
  final AlgorithmLab02DataModelScale scale;

  /// Конструктор
  const AlgorithmLab02DataModel({
    required this.move,
    required this.rotate,
    required this.scale,
  });
}

/// Тесты для вложенной кодогенерации
void main() {
  group('Nested Model Tests', () {
    late AlgorithmLab02DataModelFormConfig formConfig;
    late AlgorithmLab02DataModelFormModel formModel;

    setUp(() {
      formConfig = AlgorithmLab02DataModelFormConfig();
      formModel = formConfig.createModel();
    });

    test('Создание конфигурации формы', () {
      expect(formConfig, isNotNull);
      expect(formConfig.fields.length, equals(3));

      // Проверяем поля
      final moveField = formConfig.fields.firstWhere((f) => f.id == 'move');
      expect(moveField.type, equals(FieldType.vector));

      final rotateField = formConfig.fields.firstWhere((f) => f.id == 'rotate');
      expect(rotateField.type, equals(FieldType.angle));

      final scaleField = formConfig.fields.firstWhere((f) => f.id == 'scale');
      expect(scaleField.type, equals(FieldType.form));
    });

    test('Создание модели формы', () {
      expect(formModel, isNotNull);
      expect(formModel.moveField, isNotNull);
      expect(formModel.rotateField, isNotNull);
      expect(formModel.scaleField, isNotNull);
    });

    test('Установка и получение значений', () {
      // Создаем тестовые данные
      final testData = AlgorithmLab02DataModel(
        move: const Vector(dx: 10, dy: 20),
        rotate: const Angle(value: 45),
        scale: const AlgorithmLab02DataModelScale(
          center: Point(x: 5, y: 5),
          scale: Scale(x: 2, y: 3),
        ),
      );

      // Устанавливаем значения
      formModel.values = testData;

      // Проверяем значения полей
      expect(formModel.moveField.value?.dx, equals(10));
      expect(formModel.moveField.value?.dy, equals(20));
      expect(formModel.rotateField.value?.value, equals(45));

      // Проверяем значения вложенной формы через values
      final values = formModel.values;
      expect(values.move.dx, equals(10));
      expect(values.move.dy, equals(20));
      expect(values.rotate.value, equals(45));
      expect(values.scale.center.x, equals(5));
      expect(values.scale.center.y, equals(5));
      expect(values.scale.scale.x, equals(2));
      expect(values.scale.scale.y, equals(3));
    });

    test('Преобразование в Map и обратно', () {
      // Создаем тестовые данные
      const testData = AlgorithmLab02DataModel(
        move: Vector(dx: 10, dy: 20),
        rotate: Angle(value: 45),
        scale: AlgorithmLab02DataModelScale(
          center: Point(x: 5, y: 5),
          scale: Scale(x: 2, y: 3),
        ),
      );

      // Устанавливаем значения
      formModel.values = testData;

      // Преобразуем в Map
      final map = formModel.toMap();
      expect(map['move'], isA<Vector>());
      expect(map['rotate'], isA<Angle>());
      expect(map['scale'], isA<Map<String, dynamic>>());

      // Сбрасываем значения
      formModel.reset();
      expect(formModel.moveField.value, isNull);
      expect(formModel.rotateField.value, isNull);
      expect(formModel.scaleField.value, isNull);

      // Устанавливаем значения из Map
      formModel.fromMap(map);

      // Проверяем значения через values
      final values = formModel.values;
      expect(values.move.dx, equals(10));
      expect(values.move.dy, equals(20));
      expect(values.rotate.value, equals(45));
      expect(values.scale.center.x, equals(5));
      expect(values.scale.center.y, equals(5));
      expect(values.scale.scale.x, equals(2));
      expect(values.scale.scale.y, equals(3));
    });
  });
}
