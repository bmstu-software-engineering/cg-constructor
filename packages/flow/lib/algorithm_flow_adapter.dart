import 'package:alogrithms/algorithms/lab_01_40.dart';
import 'package:alogrithms/algorithms/lab_01_40_factory.dart';
import 'package:alogrithms/algorithms/registry.dart';
import 'package:alogrithms/alogrithms.dart';
import 'package:viewer/viewer.dart';

import 'flow.dart';

/// Фабрика для создания FlowBuilder на основе алгоритма AlgorithmL01V40
/// @deprecated Используйте GenericAlgorithmFlowFactory вместо этого класса
class AlgorithmFlowFactory implements FlowBuilderFactory {
  final String name;
  final ViewerFactory _viewerFactory;

  AlgorithmFlowFactory(
    this.name, {
    ViewerFactory viewerFactory = const CanvasViewerFactory(),
  }) : _viewerFactory = viewerFactory {
    // Регистрируем алгоритм в реестре, если он еще не зарегистрирован
    if (!AlgorithmRegistry.hasAlgorithm('lab_01_40')) {
      registerAlgorithmL01V40();
    }
  }

  @override
  FlowBuilder create() {
    return GenericAlgorithmFlowFactory(
      'lab_01_40',
      name: name,
      viewerFactory: _viewerFactory,
    ).create();
  }
}
