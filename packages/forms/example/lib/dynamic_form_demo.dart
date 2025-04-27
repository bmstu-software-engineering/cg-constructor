import 'package:flutter/material.dart';
import 'package:forms/forms.dart';

import 'package:models_ns/models_ns.dart';

/// Демонстрация использования динамической формы
class DynamicFormDemoPage extends StatefulWidget {
  const DynamicFormDemoPage({super.key});

  @override
  State<DynamicFormDemoPage> createState() => _DynamicFormDemoPageState();
}

class _DynamicFormDemoPageState extends State<DynamicFormDemoPage> {
  late DynamicFormModel _formModel;
  Map<String, dynamic>? _formValues;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  /// Инициализация формы
  void _initForm() {
    // Создаем конфигурацию формы
    final formConfig = FormConfig(
      name: 'Демонстрационная форма',
      fields: [
        // Числовое поле
        FieldConfigEntry(
          id: 'number',
          type: FieldType.number,
          config: NumberFieldConfig(
            label: 'Число',
            min: 0,
            max: 100,
            isRequired: true,
          ),
        ),

        // Поле точки
        FieldConfigEntry(
          id: 'point',
          type: FieldType.point,
          config: PointFieldConfig(
            label: 'Точка',
            xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
            yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
          ),
        ),

        // Поле угла
        FieldConfigEntry(
          id: 'angle',
          type: FieldType.angle,
          config: AngleFieldConfig(
            label: 'Угол',
            min: 0,
            max: 360,
            normalize: true,
          ),
        ),

        // Поле вектора
        FieldConfigEntry(
          id: 'vector',
          type: FieldType.vector,
          config: VectorFieldConfig(
            label: 'Вектор',
            dxConfig: NumberFieldConfig(label: 'dX', min: -100, max: 100),
            dyConfig: NumberFieldConfig(label: 'dY', min: -100, max: 100),
          ),
        ),

        // Поле масштаба
        FieldConfigEntry(
          id: 'scale',
          type: FieldType.scale,
          config: ScaleFieldConfig(
            label: 'Масштаб',
            uniform: true,
            xConfig: NumberFieldConfig(label: 'X', min: 0.1, max: 10),
            yConfig: NumberFieldConfig(label: 'Y', min: 0.1, max: 10),
          ),
        ),

        // Список чисел
        FieldConfigEntry(
          id: 'numberList',
          type: FieldType.list,
          config: ListFieldConfig<double>(
            label: 'Список чисел',
            minItems: 1,
            maxItems: 5,
            createItemField: () => NumberField(
              config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
            ),
          ),
        ),
      ],
      validator: (values) {
        // Дополнительная валидация всей формы
        return null;
      },
    );

    // Создаем модель формы
    _formModel = DynamicFormModel(config: formConfig);

    // Устанавливаем начальные значения
    _formModel.setValues({
      'number': 42, // Будет автоматически преобразовано в double
      'point': const Point(x: 10, y: 20),
      'angle': Angle(value: 45),
      'vector': Vector(dx: 5, dy: 10),
      'scale': Scale(x: 2, y: 2),
      'numberList': [
        10,
        20,
        30,
      ], // Будет автоматически преобразовано в List<double>
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Динамическая форма
            DynamicFormWidget(
              model: _formModel,
              onSubmit: (values) {
                setState(() {
                  _formValues = values;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Форма отправлена')),
                );
              },
              submitButtonText: 'Отправить форму',
            ),

            const SizedBox(height: 32),

            // Отображение значений формы
            if (_formValues != null) ...[
              const Text(
                'Значения формы:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _formValues!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
