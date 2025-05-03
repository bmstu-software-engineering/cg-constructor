import 'package:flutter/material.dart' hide FormField;
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';
import 'package:models_ns/models_ns.dart';

// Подключаем сгенерированный код
part 'color_form_example.g.dart';

/// Пример класса формы с аннотациями для генерации кода с поддержкой выбора цвета
@FormGenAnnotation(name: 'Форма с выбором цвета')
class ColorForm {
  /// Точка с возможностью выбора цвета
  @PointFieldAnnotation(
    label: 'Точка с цветом',
    xConfig: NumberFieldAnnotation(label: 'X', min: 0, max: 100),
    yConfig: NumberFieldAnnotation(label: 'Y', min: 0, max: 100),
    canSetColor: true,
    defaultColor: '#FF0000',
  )
  final Point coloredPoint;

  /// Линия с возможностью выбора цвета и толщины
  @LineFieldAnnotation(
    label: 'Линия с цветом',
    aConfig: PointFieldAnnotation(label: 'Начало'),
    bConfig: PointFieldAnnotation(label: 'Конец'),
    canSetColor: true,
    defaultColor: '#0000FF',
    canSetThickness: true,
    defaultThickness: 2.0,
  )
  final Line coloredLine;

  /// Создает форму с выбором цвета
  const ColorForm({
    required this.coloredPoint,
    required this.coloredLine,
  });
}

/// Пример использования сгенерированного кода с UI
class ColorFormExampleScreen extends StatefulWidget {
  const ColorFormExampleScreen({super.key});

  @override
  State<ColorFormExampleScreen> createState() => _ColorFormExampleScreenState();
}

class _ColorFormExampleScreenState extends State<ColorFormExampleScreen> {
  late ColorFormFormConfig formConfig;
  late ColorFormFormModel formModel;
  String? validationError;

  @override
  void initState() {
    super.initState();
    // Создаем конфигурацию формы
    formConfig = ColorFormFormConfig();
    // Создаем модель формы
    formModel = formConfig.createModel();
    // Устанавливаем начальные значения
    formModel.values = ColorForm(
      coloredPoint: const Point(x: 10, y: 20),
      coloredLine: Line(
        a: const Point(x: 0, y: 0),
        b: const Point(x: 50, y: 50),
      ),
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
      formModel.values = ColorForm(
        coloredPoint: const Point(x: 10, y: 20),
        coloredLine: Line(
          a: const Point(x: 0, y: 0),
          b: const Point(x: 50, y: 50),
        ),
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
            'Форма сохранена: Точка=(${values.coloredPoint.x}, ${values.coloredPoint.y}), '
            'Линия=((${values.coloredLine.a.x}, ${values.coloredLine.a.y}), '
            '(${values.coloredLine.b.x}, ${values.coloredLine.b.y}))',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример формы с выбором цвета')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Используем DynamicFormWidget для автоматического создания виджетов полей
            Expanded(
              child: SingleChildScrollView(
                child: DynamicFormWidget(model: formModel.toDynamicFormModel()),
              ),
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
            Text('Точка: (${values.coloredPoint.x}, ${values.coloredPoint.y})'),
            Text(
                'Линия: ((${values.coloredLine.a.x}, ${values.coloredLine.a.y}), '
                '(${values.coloredLine.b.x}, ${values.coloredLine.b.y}))'),
          ],
        ),
      ),
    );
  }
}

/// Основная функция для запуска примера
void main() {
  runApp(const MaterialApp(home: ColorFormExampleScreen()));
}
