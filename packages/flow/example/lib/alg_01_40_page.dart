import 'dart:async';

import 'package:alogrithms/algorithms/exceptions.dart';
import 'package:flow/flow.dart';
import 'package:flow/algorithm_flow_adapter.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models_ns/models_ns.dart';

/// Домашняя страница со списком элементов
class AlgL01V40 extends StatefulWidget {
  const AlgL01V40({super.key});

  @override
  State<AlgL01V40> createState() => _HomePageState();
}

class _HomePageState extends State<AlgL01V40> {
  static const _memuSize = 0.3;
  String? _error;
  late final FlowBuilder _flowBuilder;
  final FlowBuilderFactory _flowFactory = AlgorithmFlowFactory('alg name');

  @override
  void initState() {
    super.initState();
    _flowBuilder = _flowFactory.create();

    // // Получаем доступ к RouterDelegate через Router.of
    // // final delegate = Router.of(context).routerDelegate as MyRouterDelegate;
    // final viewer = CanvasViewer();
    // // Создаем стратегию для отображения данных
    // final drawStrategy = ViewerFlowDrawStrategy(viewer);

    // // Создаем стратегию для получения данных
    // final dataStrategy = ViewerDataModelStrategy();

    // // Создаем стратегию для расчетов
    // final calculateStrategy = _TestFlowCalculateStrategy();

    // // Создаем FlowBuilder
    // _flowBuilder = FlowBuilder(
    //   name: 'Test Flow',
    //   dataStrategy: dataStrategy,
    //   calculateStrategy: calculateStrategy,
    //   drawStrategy: drawStrategy,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder:
            (context, constrains) => Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: constrains.maxWidth * _memuSize,
                  height: constrains.maxHeight,
                  child: ColoredBox(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (error != null) ...[Text(error)],
                          Expanded(
                            child: SingleChildScrollView(
                              child: _flowBuilder.buildDataWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constrains.maxWidth * (1 - _memuSize),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: _flowBuilder.buildViewerWidget(),
                  ),
                ),
              ],
            ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          String? error;
          try {
            // Запускаем процесс получения данных, расчета и отображения
            await _flowBuilder.reciveData();
            await _flowBuilder.calculate();
            await _flowBuilder.draw();
          } on AlgorithmException catch (e) {
            error = e.message;
            print(e.toString());
          } finally {
            setState(() => _error = error);
          }
        },
        icon: Icon(Icons.calculate),
        label: Text('Расчитать'), // const Text('Показать Viewer'),
      ),
    );
  }
}

class ValidationException implements Exception {
  final List<({String error, String fieldLabel})> errors;

  const ValidationException(this.errors);
}

/// Тестовая стратегия для получения данных
class ViewerDataModelStrategy implements FlowDataStrategy<ViewerDataModel> {
  ViewerDataModelStrategy();

  @override
  Future<ViewerDataModel> getData() async {
    if (_hasError) {
      throw ValidationException(_errors);
    }

    return ViewerDataModel(points: _pointsField.value ?? []);
  }

  late final List<BaseFormField> _fields = [
    ..._pointsField.fields,
    _pointsField,
  ];

  List<({String error, String fieldLabel})> get _errors =>
      _fields
          .map(
            (field) => (error: field.error, fieldLabel: 'field.config.label'),
          )
          .whereType<({String error, String fieldLabel})>()
          .toList();

  bool get _hasError => _errors.isNotEmpty;

  final _pointsField = ListField<Point, PointField>(
    config: ListFieldConfig<Point>(
      label: 'Список точек',
      minItems: 0,
      maxItems: 5,
      isRequired: false,
      createItemField:
          () => PointField(config: PointFieldConfig(isRequired: false)),
    ),
  );

  final _lineField = ListField<Line, LineField>(
    config: ListFieldConfig<Line>(
      label: 'Линии',
      minItems: 0,
      maxItems: 5,
      isRequired: false,
      createItemField: () => LineField(config: LineFieldConfig()),
    ),
  );

  final _stateStreamController = StreamController<void>.broadcast();

  @override
  Widget buildWidget() => StreamBuilder(
    stream: _stateStreamController.stream,
    builder: (context, _) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListFieldWidget<Point, PointField>(
            field: _pointsField,
            addButtonLabel: 'Добавить число',
            removeButtonTooltip: 'Удалить число',
            itemLabelBuilder: (index) => 'Точка ${index + 1}',
            itemBuilder: (context, field, onChanged) {
              return PointFieldWidget(field: field, onChanged: onChanged);
            },
          ),
          ListFieldWidget(
            field: _lineField,
            addButtonLabel: 'Добавить линию',
            removeButtonTooltip: 'Удалить линию',
            itemLabelBuilder: (index) => 'Линия ${index + 1}',
            itemBuilder: (context, field, onChanged) {
              return LineFieldWidget(field: field, onChanged: onChanged);
            },
          ),
        ],
      );
    },
  );
}

/// Тестовая стратегия для расчетов
class _TestFlowCalculateStrategy
    implements FlowCalculateStrategy<ViewerDataModel, FlowDrawData> {
  const _TestFlowCalculateStrategy();

  @override
  Future<FlowDrawData> calculate(ViewerDataModel data) async =>
  // В реальном приложении здесь могут быть сложные расчеты
  FlowDrawData(points: data.points, lines: data.lines);
}
