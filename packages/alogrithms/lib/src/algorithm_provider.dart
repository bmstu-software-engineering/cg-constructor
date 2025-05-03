import 'package:alogrithms/algorithms/registry.dart';
import 'package:alogrithms/src/algorithm_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:alogrithms/algorithms/lab_01_40/lab_01_40_factory.dart';
import 'package:alogrithms/algorithms/lab_01_basic/lab_01_basic_factory.dart';
import 'package:alogrithms/algorithms/lab_01_27/lab_01_27_factory.dart';

class _AlgorithmsHolderImpl implements AlgorithmsHolder {
  final Map<String, AlgorithmFactory> _map = {};

  _AlgorithmsHolderImpl();

  @override
  List<AlgorithmInfo> get algorithmsInfo =>
      _map.values.map((e) => AlgorithmInfo.fromFactory(e)).toList();

  @override
  AlgorithmFactory get(String name) =>
      _map[name] ?? (throw Exception('Algorithm $name not registered'));

  @override
  bool has(String name) => _map.containsKey(name);

  @override
  void registerAll(List<AlgorithmFactory> algorithmsFactories) =>
      _map.addAll(Map.fromIterable(algorithmsFactories, key: (e) => e.name));

  @override
  void unregister(
    AlgorithmFactory<Algorithm<DataModel, ResultModel>> algorithmFactory,
  ) => _map.remove(algorithmFactory.name);
}

/// Провайдер алгоритмов, который хранит зарегистрированные алгоритмы в дереве виджетов
class AlgorithmProvider extends InheritedWidget {
  final AlgorithmsHolder _holder;

  /// Конструктор
  const AlgorithmProvider(this._holder, {super.key, required super.child});

  /// Создает экземпляр алгоритма по его идентификатору
  Algorithm createAlgorithm(String name) => _holder.get(name).create();

  List<AlgorithmInfo> get algorithmsInfo => _holder.algorithmsInfo;

  /// Проверяет, зарегистрирован ли алгоритм с указанным идентификатором
  bool hasAlgorithm(String name) => _holder.has(name);

  /// Возвращает список идентификаторов доступных алгоритмов
  List<String> getAvailableAlgorithms() =>
      _holder.algorithmsInfo.map((e) => e.name).toList();

  /// Получает провайдер алгоритмов из контекста
  static AlgorithmProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AlgorithmProvider>();
    if (provider == null) {
      throw Exception('AlgorithmProvider не найден в дереве виджетов');
    }
    return provider;
  }

  /// Получает провайдер алгоритмов из контекста без создания зависимости
  static AlgorithmProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AlgorithmProvider>();
  }

  @override
  bool updateShouldNotify(AlgorithmProvider oldWidget) =>
      _holder.algorithmsInfo != oldWidget._holder.algorithmsInfo;
}

/// Виджет, который инициализирует провайдер алгоритмов
class AlgorithmProviderScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Конструктор
  const AlgorithmProviderScope({super.key, required this.child});

  @override
  State<AlgorithmProviderScope> createState() => _AlgorithmProviderScopeState();
}

class _AlgorithmProviderScopeState extends State<AlgorithmProviderScope> {
  /// Карта зарегистрированных фабрик алгоритмов
  final _AlgorithmsHolderImpl _holder = _AlgorithmsHolderImpl();

  @override
  void initState() {
    super.initState();

    // Регистрируем алгоритмы
    _registerAlgorithms();
  }

  /// Регистрирует алгоритмы
  void _registerAlgorithms() => _holder.registerAll([
    AlgorithmL01VBasicFactory(),
    AlgorithmL01V40Factory(),
    AlgorithmL01V27Factory(),
  ]);

  @override
  Widget build(BuildContext context) =>
      AlgorithmProvider(_holder, child: widget.child);
}

/// Расширение для BuildContext для удобного доступа к провайдеру алгоритмов
extension AlgorithmProviderExtension on BuildContext {
  /// Получает провайдер алгоритмов из контекста
  AlgorithmProvider get algorithmProvider => AlgorithmProvider.of(this);

  /// Получает список информации о доступных алгоритмах
  List<AlgorithmInfo> get algorithms => algorithmProvider.algorithmsInfo;

  /// Создает экземпляр алгоритма по его идентификатору
  Algorithm createAlgorithm(String name) =>
      algorithmProvider.createAlgorithm(name);

  /// Проверяет, зарегистрирован ли алгоритм с указанным идентификатором
  bool hasAlgorithm(String name) => algorithmProvider.hasAlgorithm(name);
}
