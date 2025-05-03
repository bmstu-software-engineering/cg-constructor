import 'package:alogrithms/alogrithms.dart';

import '../flow.dart';

/// Универсальная стратегия расчетов для алгоритмов
class GenericCalculateStrategy<DD extends FlowDrawData>
    implements FlowCalculateStrategy<DD> {
  final Algorithm _algorithm;

  GenericCalculateStrategy(this._algorithm);

  @override
  Future<DD> calculate() async {
    try {
      final result = _algorithm.calculate();

      if (result is! ViewerResultModel) {
        throw Exception('Результат должен быть типа ViewerResultModel');
      }

      return FlowDrawData(points: result.points, lines: result.lines) as DD;
    } catch (e) {
      // Ошибка будет обработана в FlowBuilder
      rethrow;
    }
  }
}

/// Фабрика для создания стратегий расчетов
class CalculateStrategyFactory {
  /// Создает стратегию расчетов для указанного алгоритма
  static FlowCalculateStrategy createCalculateStrategy(Algorithm algorithm) {
    return GenericCalculateStrategy(algorithm);
  }
}
