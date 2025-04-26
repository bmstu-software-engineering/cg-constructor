import 'dart:async';

import 'measure_config.dart';
import 'measure_progress.dart';
import 'measure_result.dart';

/// Абстрактный класс для запуска замеров производительности.
///
/// Этот класс определяет интерфейс для запуска замеров производительности
/// с возможностью отслеживания прогресса выполнения.
abstract class MeasureRunner {
  /// Запускает замер производительности для указанной функции.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера.
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> run(
    String key,
    Function() function,
    MeasureConfig config,
  );

  /// Запускает замер производительности для указанной функции с возможностью
  /// отслеживания прогресса выполнения.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера.
  /// [onProgress] - функция обратного вызова для отслеживания прогресса выполнения.
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> runWithProgress(
    String key,
    Function() function,
    MeasureConfig config,
    void Function(MeasureProgress progress) onProgress,
  );

  /// Запускает замер производительности для указанной асинхронной функции.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - асинхронная функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера.
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> runAsync(
    String key,
    Future<void> Function() function,
    MeasureConfig config,
  );

  /// Запускает замер производительности для указанной асинхронной функции с возможностью
  /// отслеживания прогресса выполнения.
  ///
  /// [key] - уникальный ключ для идентификации замера.
  /// [function] - асинхронная функция, производительность которой нужно измерить.
  /// [config] - конфигурация замера.
  /// [onProgress] - функция обратного вызова для отслеживания прогресса выполнения.
  ///
  /// Возвращает [Future] с результатом замера [MeasureResult].
  Future<MeasureResult> runAsyncWithProgress(
    String key,
    Future<void> Function() function,
    MeasureConfig config,
    void Function(MeasureProgress progress) onProgress,
  );

  /// Отменяет текущий замер, если он выполняется.
  ///
  /// Возвращает [Future], который завершается, когда замер отменен.
  Future<void> cancel();

  /// Возвращает текущий прогресс выполнения замера.
  ///
  /// Если замер не выполняется, возвращает [MeasureProgress.initial()].
  MeasureProgress get currentProgress;

  /// Поток, который отправляет обновления прогресса выполнения замера.
  ///
  /// Подписчики получают обновления прогресса в реальном времени.
  Stream<MeasureProgress> get progressStream;
}
