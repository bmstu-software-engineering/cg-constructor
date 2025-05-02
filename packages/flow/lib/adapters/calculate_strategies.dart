import 'package:alogrithms/alogrithms.dart';

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
    final dataType = data.runtimeType.toString();

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
