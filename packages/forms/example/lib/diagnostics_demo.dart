import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

/// Демонстрация использования DiagnosticableNode для отображения
/// диагностической информации в пользовательском интерфейсе
class DiagnosticsDemoPage extends StatefulWidget {
  const DiagnosticsDemoPage({super.key});

  @override
  State<DiagnosticsDemoPage> createState() => _DiagnosticsDemoPageState();
}

class _DiagnosticsDemoPageState extends State<DiagnosticsDemoPage> {
  // Создаем поля для демонстрации
  final numberField = NumberField(
    config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
  );

  final numberListField = ListField<double, NumberField>(
    config: ListFieldConfig<double>(
      label: 'Список чисел',
      minItems: 1,
      maxItems: 5,
      createField:
          () => NumberField(
            config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
          ),
    ),
  );

  final pointField = PointField(
    config: PointFieldConfig(
      label: 'Точка',
      xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
      yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
    ),
  );

  final angleField = AngleField(
    config: AngleFieldConfig(label: 'Угол', min: 0, max: 360, normalize: true),
  );

  final vectorField = VectorField(
    config: VectorFieldConfig(
      label: 'Вектор',
      dxConfig: NumberFieldConfig(label: 'dX', min: -100, max: 100),
      dyConfig: NumberFieldConfig(label: 'dY', min: -100, max: 100),
    ),
  );

  final scaleField = ScaleField(
    config: ScaleFieldConfig(
      label: 'Масштаб',
      uniform: true,
      xConfig: NumberFieldConfig(label: 'X', min: 0.1, max: 10),
      yConfig: NumberFieldConfig(label: 'Y', min: 0.1, max: 10),
    ),
  );

  final triangleField = TriangleField(
    config: TriangleFieldConfig(
      label: 'Треугольник',
      aConfig: PointFieldConfig(label: 'A'),
      bConfig: PointFieldConfig(label: 'B'),
      cConfig: PointFieldConfig(label: 'C'),
    ),
  );

  @override
  void initState() {
    super.initState();

    // Устанавливаем начальные значения
    numberField.value = 42;
    numberListField.value = [10, 20, 30];
    pointField.value = const Point(x: 10, y: 20);
    angleField.value = Angle(value: 45);
    vectorField.value = Vector(dx: 5, dy: 10);
    scaleField.value = Scale(x: 2, y: 2);
    triangleField.value = Triangle(
      a: const Point(x: 0, y: 0),
      b: const Point(x: 10, y: 0),
      c: const Point(x: 5, y: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Демонстрация DiagnosticableNode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Числовое поле
            const Text('Числовое поле:'),
            NumberFieldWidget(
              field: numberField,
              onChanged: (_) => setState(() {}),
            ),
            DiagnosticsNodeWidget(
              diagnosticsNode: numberField,
              title: 'Диагностика числового поля',
            ),
            const SizedBox(height: 16),

            // Список чисел
            const Text('Список чисел:'),
            ListFieldWidget<double, NumberField>(
              field: numberListField,
              onChanged: (_) => setState(() {}),
              addButtonLabel: 'Добавить число',
              removeButtonTooltip: 'Удалить число',
              itemLabelBuilder: (index) => 'Число ${index + 1}',
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
            DiagnosticsNodeWidget(
              diagnosticsNode: numberListField,
              title: 'Диагностика списка чисел',
            ),
            const SizedBox(height: 16),

            // Поле точки
            const Text('Поле точки:'),
            PointFieldWidget(
              field: pointField,
              onChanged: (_) => setState(() {}),
            ),
            DiagnosticsNodeWidget(
              diagnosticsNode: pointField,
              title: 'Диагностика поля точки',
            ),
            const SizedBox(height: 16),

            // Поле угла
            const Text('Поле угла:'),
            AngleFieldWidget(
              field: angleField,
              onChanged: (_) => setState(() {}),
            ),
            if (angleField.value != null)
              DiagnosticsNodeWidget(
                diagnosticsNode: angleField.value!,
                title: 'Диагностика угла',
              ),
            const SizedBox(height: 16),

            // Поле вектора
            const Text('Поле вектора:'),
            VectorFieldWidget(
              field: vectorField,
              onChanged: (_) => setState(() {}),
            ),
            if (vectorField.value != null)
              DiagnosticsNodeWidget(
                diagnosticsNode: vectorField.value!,
                title: 'Диагностика вектора',
              ),
            const SizedBox(height: 16),

            // Поле масштаба
            const Text('Поле масштаба:'),
            ScaleFieldWidget(
              field: scaleField,
              onChanged: (_) => setState(() {}),
            ),
            if (scaleField.value != null)
              DiagnosticsNodeWidget(
                diagnosticsNode: scaleField.value!,
                title: 'Диагностика масштаба',
              ),
            const SizedBox(height: 16),

            // Поле треугольника
            const Text('Поле треугольника:'),
            TriangleFieldWidget(
              field: triangleField,
              onChanged: (_) => setState(() {}),
            ),
            if (triangleField.value != null)
              DiagnosticsNodeWidget(
                diagnosticsNode: triangleField.value!,
                title: 'Диагностика треугольника',
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Виджет для отображения диагностической информации
class DiagnosticsNodeWidget extends StatelessWidget {
  /// Диагностический узел для отображения
  final DiagnosticableTree diagnosticsNode;

  /// Заголовок
  final String title;

  /// Создает виджет для отображения диагностической информации
  const DiagnosticsNodeWidget({
    super.key,
    required this.diagnosticsNode,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Получаем диагностические свойства
    final builder = DiagnosticPropertiesBuilder();
    diagnosticsNode.debugFillProperties(builder);
    final properties = builder.properties;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'toString(): ${diagnosticsNode.toString()}',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const Divider(),
            const Text(
              'Свойства:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...properties.map((property) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${property.name}:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        property.value?.toString() ?? 'null',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
