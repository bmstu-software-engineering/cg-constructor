import 'package:alogrithms/alogrithms.dart';
import 'package:figure_io/figure_io.dart';
import 'package:flutter/material.dart';

enum _AlgorithmVariant {
  move,
  scale,
  rotate,
  revert;

  String get title => switch (this) {
    move => 'Переместить',
    scale => 'Масштабировать',
    rotate => 'Повернуть',
    revert => 'Шаг назад',
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

  /// Возвращает текущий держатель коллекций фигур
  /// Используется только для тестирования
  @visibleForTesting
  // ignore: library_private_types_in_public_api
  _FigureCollectionHolder get holder => _holder;

  /// Возвращает размер стека коллекций фигур
  /// Используется только для тестирования
  @visibleForTesting
  int get stackSize => _holder._stack.length;

  /// Устанавливает коллекцию фигур для тестирования
  /// Используется только для тестирования
  @visibleForTesting
  void setFigureCollection(FigureCollection collection) {
    _holder.add(collection);
  }

  @override
  Widget buildTopMenuWidget() =>
      FigureReaderWidget(onFiguresLoaded: (p) => _holder.add(p));

  @override
  ResultModel calculate() =>
      throw UnimplementedError('Не применимо к данному алгоритму');

  @override
  ResultModel calculateWithVariant(String? variant) =>
      switch (_AlgorithmVariant.fromString(
        variant ??
            (throw UnimplementedError('Не применимо к данному алгоритму')),
      )) {
        _AlgorithmVariant.move => ViewerResultModelV2(
          figureCollection: _holder.last.move(_model.data.translation),
        ),
        _AlgorithmVariant.scale => ViewerResultModelV2(
          figureCollection: _holder.last.scale(
            _model.data.scaling.center,
            _model.data.scaling.scale,
          ),
        ),
        _AlgorithmVariant.rotate => ViewerResultModelV2(
          figureCollection: _holder.last.rotate(
            _model.data.rotation.center,
            _model.data.rotation.angle.value,
          ),
        ),
        _AlgorithmVariant.revert => ViewerResultModelV2(
          figureCollection: _holder.last.let((_) {
            _holder.revert();
            return _holder.last;
          }),
        ),
      }..let((result) => _holder.add(result.figureCollection));

  @override
  List<AlgorithmVariant> getAvailableVariants() =>
      _AlgorithmVariant.values
          .map((e) => AlgorithmVariant(id: e.name, name: e.title))
          .toList();

  @override
  FormsDataModel getDataModel() => _model;
}

extension<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
