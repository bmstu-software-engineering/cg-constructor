import 'package:alogrithms/algorithms/lab_01_40.dart';
import 'package:alogrithms/alogrithms.dart';
import 'package:flutter/widgets.dart';
import 'package:forms/forms.dart';
import 'package:viewer/viewer.dart';

import 'flow.dart';

typedef _Algorithm =
    Algorithm<AlgorithmL01V40FormsDataModelImpl, ViewerResultModel>;

class AlgorithmFlowFactory implements FlowBuilderFactory {
  final _Algorithm _algorithm = AlgorithmL01V40();
  final String name;
  final ViewerFactory _viewerFactory;

  AlgorithmFlowFactory(
    // this._algorithm,
    this.name, {
    ViewerFactory viewerFactory = const CanvasViewerFactory(),
  }) : _viewerFactory = viewerFactory;

  @override
  FlowBuilder<FlowData, FlowDrawData> create() {
    final dataModel = _algorithm.getDataModel();
    final viewer = _viewerFactory.create();

    return FlowBuilder(
      name: name,
      dataStrategy: _FlowDataStrategyImpl(
        _AlgorithmL01V40FormsDataModelImpl(dataModel),
      ),
      calculateStrategy: _FlowCalculateStrategyImpl(_algorithm),
      drawStrategy: ViewerFlowDrawStrategy(viewer),
    );
  }
}

class _AlgorithmL01V40FormsDataModelImpl
    implements FlowData, AlgorithmL01V40FormsDataModelImpl {
  final AlgorithmL01V40FormsDataModelImpl _origin;

  const _AlgorithmL01V40FormsDataModelImpl(this._origin);

  @override
  get data => _origin.data;

  @override
  FormConfig get config => _origin.config;

  @override
  set rawData(Map<String, dynamic>? rawData) => _origin.rawData = rawData;
}

class _FlowDataStrategyImpl
    implements FlowDataStrategy<_AlgorithmL01V40FormsDataModelImpl> {
  final DynamicFormModel _formModel;
  final _AlgorithmL01V40FormsDataModelImpl _dataModel;

  _FlowDataStrategyImpl(this._dataModel)
    : _formModel = DynamicFormModel(config: _dataModel.config);

  @override
  Widget buildWidget() => DynamicFormWidget(
    model: _formModel,
    // onSubmit: (values) {
    //   print(values);
    //   _dataModel.rawData = values;
    //   setState(() {
    //     _formValues = values;
    //   });
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Форма отправлена')));
    // },
    // submitButtonText: 'Отправить форму',
  );

  @override
  Future<_AlgorithmL01V40FormsDataModelImpl> getData() async {
    _dataModel.rawData = _formModel.getValues();
    return _dataModel;
  }
}

class _FlowCalculateStrategyImpl
    implements
        FlowCalculateStrategy<
          _AlgorithmL01V40FormsDataModelImpl,
          FlowDrawData
        > {
  final _Algorithm _algorithm;

  _FlowCalculateStrategyImpl(this._algorithm);

  @override
  Future<FlowDrawData> calculate(
    _AlgorithmL01V40FormsDataModelImpl data,
  ) async {
    final result = _algorithm.calculate(data);

    return FlowDrawData(lines: result.lines, points: result.points);
  }
}
