import 'package:alogrithms/algorithms/lab_01_40.dart';
import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';

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
      home: const DynamicFormDemoPage(),
    );
  }
}

void main(List<String> args) {
  runApp(MyApp());
}

/// Демонстрация использования динамической формы
class DynamicFormDemoPage extends StatefulWidget {
  const DynamicFormDemoPage({super.key});

  @override
  State<DynamicFormDemoPage> createState() => _DynamicFormDemoPageState();
}

class _DynamicFormDemoPageState extends State<DynamicFormDemoPage> {
  late DynamicFormModel _formModel;
  Map<String, dynamic>? _formValues;
  late final FormsDataModel _dataModel;
  late final Algorithm<FormsDataModel, ViewerResultModel> _algorithm;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  /// Инициализация формы
  void _initForm() {
    // Создаем конфигурацию формы
    _algorithm = AlgorithmL01V40();
    _dataModel = _algorithm.getDataModel();
    _formModel = DynamicFormModel(config: _dataModel.config);
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
                print(values);
                _dataModel.rawData = values;
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
                    children:
                        _formValues!.entries.map((entry) {
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
              Text(
                _algorithm
                    .calculate(_dataModel)
                    .points
                    .map((e) => e.toString())
                    .join(', '),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
