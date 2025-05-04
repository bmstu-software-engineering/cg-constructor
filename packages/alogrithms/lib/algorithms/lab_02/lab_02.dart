import 'package:alogrithms/alogrithms.dart';
import 'package:figure_io/figure_io.dart';
import 'package:flutter/material.dart';
import 'package:models_data_ns/models_data_ns.dart';

enum _AlgorithmVariant {
  move,
  scale,
  rotate;

  String get title => switch (this) {
    move => 'Переместить',
    scale => 'Масштабировать',
    rotate => 'Повернуть',
  };

  static _AlgorithmVariant fromString(String string) =>
      _AlgorithmVariant.values.firstWhere((t) => t.name == string);
}

class NoDataAlgorithmException implements AlgorithmException {
  @override
  String get message => 'Данные не загружены';
}

class _FigureCollectionHolder {
  final List<FigureCollection> _stack = [];

  void add(FigureCollection collection) => _stack.add(collection);
  FigureCollection get last =>
      _stack.lastOrNull ?? (throw NoDataAlgorithmException());
  void revert() => _stack.removeLast();
}

class AlgorithmL02
    with BaseAlgorithmWithCustomElement
    implements VariatedAlgorithm {
  final _holder = _FigureCollectionHolder();
  final GeometricTransformationModelImpl _model;

  factory AlgorithmL02() =>
      AlgorithmL02.fromModel(GeometricTransformationModelImpl());

  AlgorithmL02.fromModel(this._model);

  @override
  Widget buildTopMenuWidget() =>
      FigureReaderWidget(onFiguresLoaded: (p) => _holder.add(p));

  @override
  ResultModel calculate() =>
      throw UnimplementedError('Не применимо к данному алгоритму');

  @override
  ResultModel calculateWithVariant(
    String? variant,
  ) => switch (_AlgorithmVariant.fromString(
    variant ?? (throw UnimplementedError('Не применимо к данному алгоритму')),
  )) {
    _AlgorithmVariant.move => throw UnimplementedError(),
    _AlgorithmVariant.scale => throw UnimplementedError(),
    _AlgorithmVariant.rotate => throw UnimplementedError(),
  };

  @override
  List<AlgorithmVariant> getAvailableVariants() =>
      _AlgorithmVariant.values
          .map((e) => AlgorithmVariant(id: e.name, name: e.title))
          .toList();

  @override
  FormsDataModel getDataModel() => _model;
}
