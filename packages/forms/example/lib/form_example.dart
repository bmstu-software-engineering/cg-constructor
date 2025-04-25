import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

// Подключаем сгенерированный код
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

/// Пример использования сгенерированного кода с UI
class FormExampleScreen extends StatefulWidget {
  const FormExampleScreen({super.key});

  @override
  State<FormExampleScreen> createState() => _FormExampleScreenState();
}

class _FormExampleScreenState extends State<FormExampleScreen> {
  late UserFormFormConfig formConfig;
  late UserFormFormModel formModel;
  String? validationError;

  @override
  void initState() {
    super.initState();
    // Создаем конфигурацию формы
    formConfig = UserFormFormConfig();
    // Создаем модель формы
    formModel = formConfig.createModel();
    // Устанавливаем начальные значения
    formModel.values = UserForm(
      age: 25,
      location: const Point(x: 10, y: 20),
      rotation: Angle(value: 45),
    );
  }

  void _validateForm() {
    formModel.validate();
    setState(() {
      validationError = formModel.isValid() ? null : 'Форма содержит ошибки';
    });
  }

  void _resetForm() {
    setState(() {
      formModel.values = UserForm(
        age: 25,
        location: const Point(x: 10, y: 20),
        rotation: Angle(value: 45),
      );
      validationError = null;
    });
  }

  void _saveForm() {
    _validateForm();
    if (formModel.isValid()) {
      final values = formModel.values;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Форма сохранена: Возраст=${values.age}, '
            'Координаты=(${values.location.x}, ${values.location.y}), ',
            // 'Угол=${values.rotation.value}°',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример типизированной формы')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Используем DynamicFormWidget для автоматического создания виджетов полей
            Expanded(
              child: DynamicFormWidget(model: formModel.toDynamicFormModel()),
            ),

            // Отображение ошибки валидации
            if (validationError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  validationError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Кнопки действий
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _resetForm,
                  child: const Text('Сбросить'),
                ),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Сохранить'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Текущие значения:'),
            const SizedBox(height: 8),
            _buildCurrentValues(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentValues() {
    final values = formModel.values;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Возраст: ${values.age}'),
            Text('Координаты: (${values.location.x}, ${values.location.y})'),
            // Text('Угол поворота: ${values.rotation.value}°'),
          ],
        ),
      ),
    );
  }
}

/// Основная функция для запуска примера
void main() {
  runApp(const MaterialApp(home: FormExampleScreen()));
}
