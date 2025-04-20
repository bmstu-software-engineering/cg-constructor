import 'package:alogrithms/algorithms/registry.dart';
import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:viewer/viewer.dart';

import '../flow.dart';
import 'calculate_strategies.dart';
import 'data_model_adapters.dart';
import 'data_strategies.dart';

/// Универсальная фабрика для создания FlowBuilder на основе алгоритма
class GenericAlgorithmFlowFactory implements FlowBuilderFactory {
  final String _algorithmId;
  final String _name;
  final ViewerFactory _viewerFactory;
  final String _submitButtonText;
  final void Function(Map<String, dynamic>)? _onSubmit;

  /// Создает фабрику для указанного алгоритма
  GenericAlgorithmFlowFactory(
    String algorithmId, {
    String? name,
    ViewerFactory viewerFactory = const CanvasViewerFactory(),
    String submitButtonText = 'Отправить',
    void Function(Map<String, dynamic>)? onSubmit,
  }) : _algorithmId = algorithmId,
       _name = name ?? algorithmId,
       _viewerFactory = viewerFactory,
       _submitButtonText = submitButtonText,
       _onSubmit = onSubmit;

  @override
  FlowBuilder create() {
    // Создаем экземпляр алгоритма
    final algorithm = AlgorithmRegistry.createAlgorithm(_algorithmId);

    // Получаем модель данных
    final dataModel = algorithm.getDataModel();

    // Создаем адаптер для модели данных
    final dataModelAdapter = DataModelAdapterFactory.createAdapter(dataModel);

    // Создаем стратегию данных
    final dataStrategy = DataStrategyFactory.createDataStrategy(
      dataModelAdapter,
      submitButtonText: _submitButtonText,
      onSubmit: _onSubmit,
    );

    // Создаем стратегию расчетов
    final calculateStrategy = CalculateStrategyFactory.createCalculateStrategy(
      algorithm,
    );

    // Создаем Viewer
    final viewer = _viewerFactory.create(showCoordinates: true);

    // Создаем стратегию отрисовки
    final drawStrategy = ViewerFlowDrawStrategy(viewer);

    // Создаем и возвращаем FlowBuilder
    return FlowBuilder(
      name: _name,
      dataStrategy: dataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: drawStrategy,
    );
  }
}
