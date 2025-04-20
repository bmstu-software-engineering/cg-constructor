import 'package:models_ns/models_ns.dart';

void main() {
  // Создаем экземпляр Line
  final line = Line(a: Point(x: 0, y: 0), b: Point(x: 10, y: 10));

  // Выводим информацию о структуре Line
  print('Line properties:');
  print('a: ${line.a}');
  print('b: ${line.b}');

  // Проверяем наличие методов
  print('\nLine methods:');
  print('toString: ${line.toString()}');

  // Проверяем наличие метода validate
  try {
    final validationResult = line.validate();
    print('validate: $validationResult');
  } catch (e) {
    print('validate method not found: $e');
  }

  // Проверяем наличие свойства length
  try {
    final length = line.length;
    print('length: $length');
  } catch (e) {
    print('length property not found: $e');
  }
}
