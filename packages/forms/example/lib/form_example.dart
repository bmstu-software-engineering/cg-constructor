import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

// Подключаем сгенерированный код
// Раскомментируйте после генерации кода
part 'form_example.g.dart';

/// Пример класса формы с аннотациями для генерации кода
@FormGenAnnotation(name: 'Пользовательская форма')
class UserForm {
  /// Имя пользователя
  @NumberFieldAnnotation(label: 'Возраст', min: 18, max: 100, isRequired: true)
  final double age;

  /// Координаты пользователя
  @PointFieldAnnotation(
    label: 'Координаты',
    xConfig: NumberFieldAnnotation(label: 'X', min: 0, max: 100),
    yConfig: NumberFieldAnnotation(label: 'Y', min: 0, max: 100),
  )
  final Point location;

  /// Угол поворота
  @AngleFieldAnnotation(
    label: 'Угол поворота',
    min: 0,
    max: 360,
    normalize: true,
  )
  final Angle rotation;

  /// Создает форму пользователя
  const UserForm({
    required this.age,
    required this.location,
    required this.rotation,
  });
}

/// Пример использования сгенерированного кода
/// Примечание: Для генерации кода необходимо запустить:
/// flutter pub run build_runner build
void main() {
  // Создаем конфигурацию формы
  // UserFormConfig будет доступен после генерации кода
  final formConfig = UserFormFormConfig();

  // Создаем модель формы
  final formModel = formConfig.createModel();

  // Устанавливаем значения формы
  formModel.values = UserForm(
    age: 25,
    location: const Point(x: 10, y: 20),
    rotation: Angle(value: 45),
  );

  // Получаем значения формы
  final values = formModel.values;
  print('Возраст: ${values.age}');
  print('Координаты: ${values.location}');
  print('Угол поворота: ${values.rotation}');

  // Валидируем форму
  formModel.validate();
  print('Форма валидна: ${formModel.isValid()}');

  // Получаем значения в виде Map
  final map = formModel.toMap();
  print('Map: $map');

  // Устанавливаем значения из Map
  formModel.fromMap({
    'age': 30,
    'location': const Point(x: 15, y: 25),
    'rotation': Angle(value: 90),
  });

  // Получаем обновленные значения
  final updatedValues = formModel.values;
  print('Обновленный возраст: ${updatedValues.age}');
}
