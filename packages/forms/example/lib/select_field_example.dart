import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';

// Подключаем сгенерированный код
part 'select_field_example.g.dart';

/// Класс для представления варианта выбора
class Option {
  final String id;

  final String title;

  const Option({required this.id, required this.title});

  @override
  String toString() => title;
}

/// Список доступных вариантов выбора
final List<Option> availableOptions = [
  const Option(id: '1', title: 'Вариант 1'),
  const Option(id: '2', title: 'Вариант 2'),
  const Option(id: '3', title: 'Вариант 3'),
  const Option(id: '4', title: 'Вариант 4'),
  const Option(id: '5', title: 'Вариант 5'),
];

/// Функция для получения названия варианта
String getOptionTitle(dynamic option) {
  return (option as Option).title;
}

/// Пример класса формы с полем выбора из списка значений
@FormGen(name: 'Форма с выбором из списка')
class SelectForm {
  /// Выбранный вариант
  @EnumSelectFieldGen(
    label: 'Выбранный вариант',
    titleBuilder: getOptionTitle,
  )
  final Option selectedOption;

  /// Создает форму с выбором из списка
  SelectForm({required this.selectedOption});
}

/// Пример использования сгенерированного кода с UI
class SelectFieldExampleScreen extends StatefulWidget {
  const SelectFieldExampleScreen({super.key});

  @override
  State<SelectFieldExampleScreen> createState() =>
      _SelectFieldExampleScreenState();
}

class _SelectFieldExampleScreenState extends State<SelectFieldExampleScreen> {
  late SelectFormFormConfig formConfig;
  late SelectFormFormModel formModel;
  String? validationError;

  @override
  void initState() {
    super.initState();
    // Создаем конфигурацию формы
    formConfig = SelectFormFormConfig();

    // Устанавливаем список значений для поля выбора
    final selectConfig =
        formConfig.fields.first.config as EnumSelectConfig<Option>;
    selectConfig.values = availableOptions;

    // Создаем модель формы
    formModel = formConfig.createModel();

    // Устанавливаем список значений для поля в модели
    final selectField =
        formModel.selectedOptionField as EnumSelectField<Option>;
    selectField.config.values = availableOptions;

    // Устанавливаем начальное значение
    formModel.values = SelectForm(selectedOption: availableOptions.first);
  }

  void _validateForm() {
    formModel.validate();
    setState(() {
      validationError = formModel.isValid() ? null : 'Форма содержит ошибки';
    });
  }

  void _resetForm() {
    setState(() {
      formModel.values = SelectForm(selectedOption: availableOptions.first);
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
            'Форма сохранена: Выбран вариант ${values.selectedOption.title}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример формы с выбором из списка')),
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
            const Text('Текущее значение:'),
            const SizedBox(height: 8),
            _buildCurrentValue(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentValue() {
    final values = formModel.values;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Выбранный вариант: ${values.selectedOption.title} (ID: ${values.selectedOption.id})',
        ),
      ),
    );
  }
}

/// Основная функция для запуска примера
void main() {
  runApp(const MaterialApp(home: SelectFieldExampleScreen()));
}
