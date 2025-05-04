import 'package:alogrithms/alogrithms.dart';

import '../flow.dart';

/// Универсальная стратегия расчетов для алгоритмов
class GenericCalculateStrategy<DD extends FlowDrawData>
    implements FlowCalculateStrategy<DD> {
  final Algorithm _algorithm;

  GenericCalculateStrategy(this._algorithm);

  @override
  Future<DD> calculate({String? variant}) async {
    try {
      // Проверяем, поддерживает ли алгоритм вариации
      final result =
          _algorithm is VariatedAlgorithm
              ? _algorithm.calculateWithVariant(variant)
              : _algorithm.calculate();

      if (result is ViewerResultModel) {
        return FlowDrawData(
              points: result.points,
              lines: result.lines,
              markdownInfo: result.markdownInfo,
            )
            as DD;
      } else if (result is ViewerResultModelV2) {
        return FlowDrawData(
              figureCollection: result.figureCollection,
              markdownInfo: result.markdownInfo,
            )
            as DD;
      } else {
        throw Exception(
          'Результат должен быть типа ViewerResultModel или ViewerResultModelV2',
        );
      }
    } catch (e) {
      // Ошибка будет обработана в FlowBuilder
      rethrow;
    }
  }

  /// Возвращает алгоритм, используемый этой стратегией
  Algorithm get algorithm => _algorithm;
}

/// Фабрика для создания стратегий расчетов
class CalculateStrategyFactory {
  /// Создает стратегию расчетов для указанного алгоритма
  static FlowCalculateStrategy createCalculateStrategy(Algorithm algorithm) {
    return GenericCalculateStrategy(algorithm);
  }
}
