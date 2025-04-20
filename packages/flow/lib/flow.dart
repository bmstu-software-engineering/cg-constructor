import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models_ns/models_ns.dart';
import 'package:viewer/viewer.dart';

export 'adapters/adapters.dart';

final class FlowBuilder<D extends FlowData, DD extends FlowDrawData> {
  final String name;
  final FlowDataStrategy<D> _dataStrategy;
  final FlowCalculateStrategy<D, DD> _calculateStrategy;
  final FlowDrawStrategy<DD> _drawStrategy;

  D? _data;
  DD? _drawData;

  FlowBuilder({
    this.name = '<no name>',
    required FlowDataStrategy<D> dataStrategy,
    required FlowCalculateStrategy<D, DD> calculateStrategy,
    required FlowDrawStrategy<DD> drawStrategy,
  }) : _dataStrategy = dataStrategy,
       _calculateStrategy = calculateStrategy,
       _drawStrategy = drawStrategy;

  /// Получает данные о точках
  Future<void> reciveData() async => _data = await _dataStrategy.getData();

  /// Производит расчёты,
  /// Расчитывает набор точек для рисования
  Future<void> calculate() async =>
      _drawData = await _calculateStrategy.calculate(
        _data ?? (throw Exception('Данные для расчётов отсутствуют')),
      );

  /// Производит расчёты,
  /// Рисует на точки на Viewer-е
  Future<void> draw() => _drawStrategy.draw(
    _drawData ?? (throw Exception('Данные для рисования отсутствуют')),
  );

  Widget buildDataWidget() => _dataStrategy.buildWidget();
  Widget buildViewerWidget() => _drawStrategy.buildWidget();
}

abstract interface class FlowBuilderFactory {
  FlowBuilder create();
}

abstract interface class FlowData {}

class ViewerDataModel implements FlowData {
  final List<Point> points;
  final List<Line> lines;

  const ViewerDataModel({this.points = const [], this.lines = const []});
}

abstract interface class FlowDataStrategy<D extends FlowData> {
  Future<D> getData();

  Widget buildWidget();
}

final class FlowDrawData {
  final List<Point> points;
  final List<Line> lines;

  const FlowDrawData({this.points = const [], this.lines = const []});
}

abstract interface class FlowCalculateStrategy<
  D extends FlowData,
  DD extends FlowDrawData
> {
  Future<DD> calculate(D data);
}

abstract interface class FlowDrawStrategy<DD extends FlowDrawData> {
  Future<void> draw(DD drawData);

  Widget buildWidget();
}

class ViewerFlowDrawStrategy implements FlowDrawStrategy {
  final Viewer _viewer;

  ViewerFlowDrawStrategy(this._viewer);

  @override
  Future<void> draw(FlowDrawData drawData) async =>
      _viewer.draw(drawData.lines, drawData.points);

  @override
  Widget buildWidget() => _viewer.buildWidget();
}
