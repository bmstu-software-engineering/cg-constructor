import 'package:alogrithms/alogrithms.dart';
import 'package:flow/flow.dart';
import 'package:viewer/viewer.dart';

/// Фабрика для создания FlowBuilder на основе алгоритма
class AlgorithmFlowBuilderFactory implements FlowBuilderFactory {
  final Algorithm _algorithm;
  final String _name;
  final ViewerFactory _viewerFactory;

  /// Создает фабрику для указанного алгоритма
  AlgorithmFlowBuilderFactory(
    this._algorithm, {
    String? name,
    ViewerFactory viewerFactory = const CanvasViewerFactory(),
    String submitButtonText = 'Отправить',
    void Function(Map<String, dynamic>)? onSubmit,
  }) : _name = name ?? _algorithm.runtimeType.toString(),
       _viewerFactory = viewerFactory;

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

    // Создаем и возвращаем FlowBuilder
    return FlowBuilder(
      name: _name,
      dataStrategy: dataStrategy,
      calculateStrategy: calculateStrategy,
      drawStrategy: drawStrategy,
    );
  }
}
