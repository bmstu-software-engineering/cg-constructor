import 'package:alogrithms/alogrithms.dart';
import 'package:flow/flow.dart';
import 'package:viewer/viewer.dart';

/// Фабрика для создания FlowBuilder на основе алгоритма
class AlgorithmFlowBuilderFactory implements FlowBuilderFactory {
  final Algorithm _algorithm;
  final String _name;
  final ViewerFactory _viewerFactory;
  final bool _useAlgorithmActions;
  final List<FlowAction>? _customActions;

  /// Создает фабрику для указанного алгоритма
  AlgorithmFlowBuilderFactory(
    this._algorithm, {
    String? name,
    ViewerFactory viewerFactory = const CanvasViewerFactory(),
    List<FlowAction>? actions,
    bool useAlgorithmActions = true,
  }) : _name = name ?? _algorithm.runtimeType.toString(),
       _viewerFactory = viewerFactory,
       _customActions = actions,
       _useAlgorithmActions = useAlgorithmActions;

  @override
  FlowBuilder create() {
    // Получаем модель данных
    final dataModel = _algorithm.getDataModel();

    // Создаем адаптер для модели данных
    final dataModelAdapter = DataModelAdapterFactory.createAdapter(dataModel);

    // Создаем стратегию данных
    final dataStrategy = DataStrategyFactory.createDataStrategy(
      dataModelAdapter,
    );

    // Создаем стратегию расчетов
    final calculateStrategy = CalculateStrategyFactory.createCalculateStrategy(
      _algorithm,
    );

    // Создаем Viewer
    final viewer = _viewerFactory.create(showCoordinates: true);

    // Создаем стратегию отрисовки
    final drawStrategy = ViewerFlowDrawStrategy(viewer);

    // Создаем FlowBuilder
    final flowBuilder = FlowBuilder(
      name: _name,
      dataStrategy: dataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: drawStrategy,
    );

    // Добавляем действия из алгоритма, если это требуется
    if (_useAlgorithmActions) {
      final algorithmActions = flowBuilder.getActionsFromAlgorithm();
      for (final action in algorithmActions) {
        flowBuilder.addAction(action);
      }
    }

    // Добавляем пользовательские действия, если они указаны
    if (_customActions != null) {
      for (final action in _customActions) {
        flowBuilder.addAction(action);
      }
    }

    return flowBuilder;
  }
}
