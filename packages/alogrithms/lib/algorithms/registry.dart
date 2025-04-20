import 'package:alogrithms/src/algorithm_interface.dart';

/// Фабрика для создания экземпляров алгоритмов
abstract class AlgorithmFactory<T extends Algorithm> {
  /// Создает новый экземпляр алгоритма
  T create();

  /// Возвращает имя алгоритма
  String get name;

  /// Возвращает описание алгоритма
  String get description;
}

/// Реестр доступных алгоритмов
class AlgorithmRegistry {
  AlgorithmRegistry._();

  /// Карта зарегистрированных фабрик алгоритмов
  static final Map<String, AlgorithmFactory> _factories = {};

  /// Регистрирует новую фабрику алгоритма
  static void register(String id, AlgorithmFactory factory) {
    _factories[id] = factory;
  }

  /// Возвращает список идентификаторов доступных алгоритмов
  static List<String> getAvailableAlgorithms() {
    return _factories.keys.toList();
  }

  /// Возвращает информацию о всех зарегистрированных алгоритмах
  static List<AlgorithmInfo> getAlgorithmsInfo() {
    return _factories.entries
        .map(
          (entry) => AlgorithmInfo(
            id: entry.key,
            name: entry.value.name,
            description: entry.value.description,
          ),
        )
        .toList();
  }

  /// Создает экземпляр алгоритма по его идентификатору
  static Algorithm createAlgorithm(String id) {
    final factory = _factories[id];
    if (factory == null) {
      throw Exception('Алгоритм с идентификатором $id не найден');
    }
    return factory.create();
  }

  /// Проверяет, зарегистрирован ли алгоритм с указанным идентификатором
  static bool hasAlgorithm(String id) {
    return _factories.containsKey(id);
  }
}

/// Информация об алгоритме
class AlgorithmInfo {
  /// Уникальный идентификатор алгоритма
  final String id;

  /// Название алгоритма
  final String name;

  /// Описание алгоритма
  final String description;

  const AlgorithmInfo({
    required this.id,
    required this.name,
    required this.description,
  });
}
