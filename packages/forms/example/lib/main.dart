import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

import 'diagnostics_demo.dart';
import 'dynamic_form_demo.dart';
import 'form_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Forms Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Создаем поля для ввода
  final NumberField _numberField = NumberField(
    config: NumberFieldConfig(
      label: 'Число',
      min: 0,
      max: 100,
      isRequired: true,
    ),
  );

  final ListField<double, NumberField> _numberListField =
      ListField<double, NumberField>(
    config: ListFieldConfig<double>(
      label: 'Список чисел',
      minItems: 1,
      maxItems: 5,
      isRequired: true,
      createItemField: () => NumberField(
        config: NumberFieldConfig(label: 'Число', min: 0, max: 100),
      ),
    ),
    initialValue: [10, 20, 30],
  );

  final PointField _pointField = PointField(
    config: PointFieldConfig(
      label: 'Точка',
      xConfig: NumberFieldConfig(label: 'X', min: 0, max: 100),
      yConfig: NumberFieldConfig(label: 'Y', min: 0, max: 100),
    ),
  );

  final AngleField _angleField = AngleField(
    config: AngleFieldConfig(label: 'Угол', min: 0, max: 360, normalize: true),
  );

  final VectorField _vectorField = VectorField(
    config: VectorFieldConfig(
      label: 'Вектор',
      dxConfig: NumberFieldConfig(label: 'dX', min: -100, max: 100),
      dyConfig: NumberFieldConfig(label: 'dY', min: -100, max: 100),
    ),
  );

  final ScaleField _scaleField = ScaleField(
    config: ScaleFieldConfig(
      label: 'Масштаб',
      xConfig: NumberFieldConfig(label: 'X', min: 0.1, max: 10),
      yConfig: NumberFieldConfig(label: 'Y', min: 0.1, max: 10),
    ),
  );

  final TriangleField _triangleField = TriangleField(
    config: TriangleFieldConfig(
      label: 'Треугольник',
      aConfig: PointFieldConfig(label: 'A'),
      bConfig: PointFieldConfig(label: 'B'),
      cConfig: PointFieldConfig(label: 'C'),
    ),
  );

  // Результаты валидации
  String _validationResult = '';

  @override
  void initState() {
    super.initState();

    // Устанавливаем начальные значения
    _numberField.value = 42;
    _pointField.value = const Point(x: 10, y: 20);
    _angleField.value = Angle(value: 45);
    _vectorField.value = Vector(dx: 5, dy: 10);
    _scaleField.value = Scale(x: 2, y: 2);
    _triangleField.value = Triangle(
      a: const Point(x: 0, y: 0),
      b: const Point(x: 10, y: 0),
      c: const Point(x: 5, y: 10),
    );
  }

  void _validateAll() {
    setState(() {
      final errors = <String>[];

      final numberError = _numberField.validate();
      if (numberError != null) {
        errors.add('Ошибка в числе: $numberError');
      }

      final numberListError = _numberListField.validate();
      if (numberListError != null) {
        errors.add('Ошибка в списке чисел: $numberListError');
      }

      final pointError = _pointField.validate();
      if (pointError != null) {
        errors.add('Ошибка в точке: $pointError');
      }

      final angleError = _angleField.validate();
      if (angleError != null) {
        errors.add('Ошибка в угле: $angleError');
      }

      final vectorError = _vectorField.validate();
      if (vectorError != null) {
        errors.add('Ошибка в векторе: $vectorError');
      }

      final scaleError = _scaleField.validate();
      if (scaleError != null) {
        errors.add('Ошибка в масштабе: $scaleError');
      }

      final triangleError = _triangleField.validate();
      if (triangleError != null) {
        errors.add('Ошибка в треугольнике: $triangleError');
      }

      if (errors.isEmpty) {
        _validationResult = 'Все поля валидны!';
      } else {
        _validationResult = errors.join('\n');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Демонстрация полей ввода',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Числовое поле
            const Text('Числовое поле:'),
            NumberFieldWidget(
              field: _numberField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Список чисел
            const Text('Список чисел:'),
            ListFieldWidget<double, NumberField>(
              field: _numberListField,
              onChanged: (_) => setState(() {}),
              addButtonLabel: 'Добавить число',
              removeButtonTooltip: 'Удалить число',
              itemLabelBuilder: (index) => 'Число ${index + 1}',
              itemBuilder: (context, field, onChanged) {
                return NumberFieldWidget(field: field, onChanged: onChanged);
              },
            ),
            const SizedBox(height: 16),

            // Поле точки
            const Text('Поле точки:'),
            PointFieldWidget(
              field: _pointField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Поле угла
            const Text('Поле угла:'),
            AngleFieldWidget(
              field: _angleField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Поле вектора
            const Text('Поле вектора:'),
            VectorFieldWidget(
              field: _vectorField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Поле масштаба
            const Text('Поле масштаба:'),
            ScaleFieldWidget(
              field: _scaleField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Поле треугольника
            const Text('Поле треугольника:'),
            TriangleFieldWidget(
              field: _triangleField,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Результаты валидации
            const Text(
              'Результаты валидации:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_validationResult),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _validateAll,
            tooltip: 'Validate',
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'diagnostics_demo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DiagnosticsDemoPage(),
                ),
              );
            },
            tooltip: 'Diagnostics Demo',
            child: const Icon(Icons.bug_report),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'dynamic_form_demo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DynamicFormDemoPage(),
                ),
              );
            },
            tooltip: 'Dynamic Form Demo',
            child: const Icon(Icons.dynamic_form),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'form_example',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormExampleScreen(),
                ),
              );
            },
            tooltip: 'Typed Form Example',
            child: const Icon(Icons.code),
          ),
        ],
      ),
    );
  }
}
