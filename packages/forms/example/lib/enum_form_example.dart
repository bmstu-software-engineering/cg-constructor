import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:forms_annotations/forms_annotations.dart';

// Подключаем сгенерированный код
part 'enum_form_example.g.dart';

/// Перечисление для выбора пола
@FormGen(name: 'Форма выбора пола')
enum Gender implements EnumSelectEnum {
  male,
  female,
  other;

  @override
  String get title {
    switch (this) {
      case Gender.male:
        return 'Мужской';
      case Gender.female:
        return 'Женский';
      case Gender.other:
        return 'Другой';
    }
  }
}

/// Пример использования сгенерированного кода с UI для enum
class EnumFormExampleScreen extends StatefulWidget {
  const EnumFormExampleScreen({super.key});

  @override
  State<EnumFormExampleScreen> createState() => _EnumFormExampleScreenState();
}

class _EnumFormExampleScreenState extends State<EnumFormExampleScreen> {
  late GenderFormConfig formConfig;
  late GenderFormModel formModel;
  String? validationError;

  @override
  void initState() {
    super.initState();
    // Создаем конфигурацию формы
    formConfig = GenderFormConfig();
    // Создаем модель формы
    formModel = formConfig.createModel();
    // Устанавливаем начальное значение
    formModel.values = Gender.male;
  }

  void _validateForm() {
    formModel.validate();
    setState(() {
      validationError = formModel.isValid() ? null : 'Форма содержит ошибки';
    });
  }

  void _resetForm() {
    setState(() {
      formModel.values = Gender.male;
      validationError = null;
    });
  }

  void _saveForm() {
    _validateForm();
    if (formModel.isValid()) {
      final value = formModel.values;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Форма сохранена: Пол=${value.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример формы с enum')),
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
    final value = formModel.values;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Пол: ${value.title}'),
      ),
    );
  }
}

/// Основная функция для запуска примера
void main() {
  runApp(const MaterialApp(home: EnumFormExampleScreen()));
}
