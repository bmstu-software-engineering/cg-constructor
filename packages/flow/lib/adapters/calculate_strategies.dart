import 'package:alogrithms/src/algorithm_interface.dart';

import '../flow.dart';

/// Универсальная стратегия расчетов для алгоритмов
class GenericCalculateStrategy<D extends FlowData, DD extends FlowDrawData>
    implements FlowCalculateStrategy<D, DD> {
  final Algorithm _algorithm;

  GenericCalculateStrategy(this._algorithm);

  @override
  Future<DD> calculate(D data) async {
    if (data is! DataModel) {
      throw Exception('Данные должны реализовывать интерфейс DataModel');
    }

    // Проверяем, что алгоритм может работать с данным типом данных
    final algorithmType = _algorithm.runtimeType.toString();
    final dataType = data.runtimeType.toString();

    // Получаем ожидаемый тип данных из типа алгоритма
    // Например, для Algorithm<AlgorithmL01V40FormsDataModelImpl, ViewerResultModel>
    // ожидаемый тип данных - AlgorithmL01V40FormsDataModelImpl
    final expectedDataType =
        algorithmType.contains('<')
            ? algorithmType.substring(
              algorithmType.indexOf('<') + 1,
              algorithmType.indexOf(','),
            )
            : 'DataModel';

    // Пытаемся привести к FormsDataModel
    if (data is! FormsDataModel) {
      throw Exception(
        'Неверный тип модели данных: ожидается FormsDataModel, получен $dataType',
      );
    }

    final adapter = data as FormsDataModelAdapter;
    final result = _algorithm.calculate(adapter.dataModel);

    if (result is! ViewerResultModel) {
      throw Exception('Результат должен быть типа ViewerResultModel');
    }

    return FlowDrawData(points: result.points, lines: result.lines) as DD;
  }
}

/// Фабрика для создания стратегий расчетов
class CalculateStrategyFactory {
  /// Создает стратегию расчетов для указанного алгоритма
  static FlowCalculateStrategy createCalculateStrategy(Algorithm algorithm) {
    return GenericCalculateStrategy(algorithm);
  }
}
