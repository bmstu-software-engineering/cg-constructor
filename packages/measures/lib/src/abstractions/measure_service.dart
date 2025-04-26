import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'measure_config.dart';
import 'measure_progress.dart';
import 'measure_result.dart';
import 'measure_runner.dart';
import 'measure_storage.dart';

/// Сервис для управления замерами производительности.
///
/// Этот класс предоставляет высокоуровневый интерфейс для выполнения замеров
/// производительности, хранения результатов и отслеживания прогресса выполнения.
class MeasureService {
  /// Исполнитель замеров.
  final MeasureRunner _runner;

  /// Хранилище результатов замеров.
  final MeasureStorage _storage;

  /// Поток для результатов замеров.
  final BehaviorSubject<Map<String, MeasureResult>> _resultsSubject;

  /// Поток для прогресса выполнения замеров.
  final BehaviorSubject<MeasureProgress> _progressSubject;

  /// Создает новый экземпляр [MeasureService].
  ///
  /// [runner] - исполнитель замеров.
  /// [storage] - хранилище результатов замеров.
  MeasureService({
    required MeasureRunner runner,
    required MeasureStorage storage,
  }) : _runner = runner,
       _storage = storage,
       _resultsSubject = BehaviorSubject<Map<String, MeasureResult>>.seeded({}),
       _progressSubject = BehaviorSubject<MeasureProgress>.seeded(
         MeasureProgress.initial(),
       ) {
    _initFromStorage();
    _subscribeToRunnerProgress();
  }

  /// Инициализирует сервис данными из хранилища.
  Future<void> _initFromStorage() async {
    try {
      final allResults = await _storage.getAllResults();
      final resultsMap = {for (var result in allResults) result.key: result};
      _resultsSubject.add(resultsMap);
    } catch (e) {
      // Игнорируем ошибки при инициализации из хранилища
    }
  }

  /// Подписывается на поток прогресса исполнителя замеров.
  void _subscribeToRunnerProgress() {
    _runner.progressStream.listen((progress) {
      _progressSubject.add(progress);
    });
  }

  /// Выполняет замер производительности для указанной функции.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера, по умолчанию используется [MeasureConfig()].
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> measure(
    String key,
    Function() function, [
    MeasureConfig config = const MeasureConfig(),
  ]) async {
    try {
      final result = await _runner.run(key, function, config);
      await _storage.saveResult(result);

      final updatedResults = Map<String, MeasureResult>.from(
        _resultsSubject.value,
      );
      updatedResults[key] = result;
      _resultsSubject.add(updatedResults);

      return result;
    } finally {
      // Сбрасываем прогресс после завершения замера
      if (_progressSubject.value.currentKey == key) {
        _progressSubject.add(MeasureProgress.initial());
      }
    }
  }

  /// Выполняет замер производительности для указанной асинхронной функции.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - асинхронная функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера, по умолчанию используется [MeasureConfig()].
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> measureAsync(
    String key,
    Future<void> Function() function, [
    MeasureConfig config = const MeasureConfig(),
  ]) async {
    try {
      final result = await _runner.runAsync(key, function, config);
      await _storage.saveResult(result);

      final updatedResults = Map<String, MeasureResult>.from(
        _resultsSubject.value,
      );
      updatedResults[key] = result;
      _resultsSubject.add(updatedResults);

      return result;
    } finally {
      // Сбрасываем прогресс после завершения замера
      if (_progressSubject.value.currentKey == key) {
        _progressSubject.add(MeasureProgress.initial());
      }
    }
  }

  /// Отменяет текущий замер, если он выполняется.
  ///
  /// Возвращает [Future], который завершается, когда замер отменен.
  Future<void> cancel() async {
    await _runner.cancel();
    _progressSubject.add(MeasureProgress.initial());
  }

  /// Удаляет результат замера по ключу.
  ///
  /// [key] - ключ замера.
  ///
  /// Возвращает [Future] с булевым значением, указывающим, был ли удален результат.
  Future<bool> removeResult(String key) async {
    final removed = await _storage.removeResult(key);
    if (removed) {
      final updatedResults = Map<String, MeasureResult>.from(
        _resultsSubject.value,
      );
      updatedResults.remove(key);
      _resultsSubject.add(updatedResults);
    }
    return removed;
  }

  /// Очищает все сохраненные результаты замеров.
  ///
  /// Возвращает [Future], который завершается, когда все результаты удалены.
  Future<void> clearResults() async {
    await _storage.clearResults();
    _resultsSubject.add({});
  }

  /// Получает результат замера по ключу.
  ///
  /// [key] - ключ замера.
  ///
  /// Возвращает результат замера [MeasureResult] или null,
  /// если результат с указанным ключом не найден.
  MeasureResult? getResult(String key) {
    return _resultsSubject.value[key];
  }

  /// Получает все сохраненные результаты замеров.
  ///
  /// Возвращает карту, где ключ - это ключ замера, а значение - результат замера.
  Map<String, MeasureResult> get results =>
      Map.unmodifiable(_resultsSubject.value);

  /// Поток, который отправляет обновления при изменении результатов замеров.
  ///
  /// Подписчики получают обновленную карту результатов в реальном времени.
  Stream<Map<String, MeasureResult>> get resultsStream =>
      _resultsSubject.stream;

  /// Текущий прогресс выполнения замера.
  MeasureProgress get progress => _progressSubject.value;

  /// Поток, который отправляет обновления прогресса выполнения замера.
  ///
  /// Подписчики получают обновления прогресса в реальном времени.
  Stream<MeasureProgress> get progressStream => _progressSubject.stream;

  /// Освобождает ресурсы, занятые сервисом.
  ///
  /// Этот метод должен быть вызван, когда сервис больше не нужен.
  void dispose() {
    _resultsSubject.close();
    _progressSubject.close();
  }
}
