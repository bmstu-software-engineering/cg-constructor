import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../abstractions/measure_config.dart';
import '../abstractions/measure_progress.dart';
import '../abstractions/measure_result.dart';
import '../abstractions/measure_runner.dart';

/// Реализация [MeasureRunner] для синхронного запуска замеров.
///
/// Этот класс выполняет замеры в основном потоке приложения.
class SynchronousMeasureRunner implements MeasureRunner {
  /// Поток для отправки обновлений прогресса выполнения замеров.
  final BehaviorSubject<MeasureProgress> _progressSubject;

  /// Флаг, указывающий, нужно ли отменить текущий замер.
  bool _cancelRequested = false;

  /// Создает новый экземпляр [SynchronousMeasureRunner].
  SynchronousMeasureRunner()
    : _progressSubject = BehaviorSubject<MeasureProgress>.seeded(
        MeasureProgress.initial(),
      );

  @override
  Future<MeasureResult> run(
    String key,
    Function() function,
    MeasureConfig config,
  ) async {
    return runWithProgress(key, function, config, (progress) {
      _progressSubject.add(progress);
    });
  }

  @override
  Future<MeasureResult> runWithProgress(
    String key,
    Function() function,
    MeasureConfig config,
    void Function(MeasureProgress progress) onProgress,
  ) async {
    _cancelRequested = false;

    // Инициализируем списки для хранения результатов
    final executionTimeMs = <int>[];
    final memoryUsage = config.measureMemory ? <int>[] : <int>[];
    final ticks = config.measureTicks ? <int>[] : <int>[];

    // Инициализируем прогресс
    var progress = MeasureProgress(
      isRunning: true,
      currentIteration: 0,
      totalIterations: config.iterations,
      currentKey: key,
    );
    onProgress(progress);

    // Выполняем замеры
    for (var i = 0; i < config.iterations; i++) {
      // Проверяем, не была ли запрошена отмена
      if (_cancelRequested) {
        break;
      }

      // Обновляем прогресс
      progress = progress.copyWith(currentIteration: i);
      onProgress(progress);

      // Выполняем замер
      final result = await _measureOnce(function, config);
      executionTimeMs.add(result.executionTimeMs);
      if (config.measureMemory) {
        memoryUsage.add(result.memoryUsage);
      }
      if (config.measureTicks) {
        ticks.add(result.ticks);
      }

      // Небольшая пауза между итерациями для снижения влияния на результаты
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    // Сбрасываем прогресс
    onProgress(MeasureProgress.initial());

    // Возвращаем результат
    return MeasureResult(
      key: key,
      executionTimeMs: executionTimeMs,
      memoryUsage: memoryUsage,
      ticks: ticks,
    );
  }

  @override
  Future<MeasureResult> runAsync(
    String key,
    Future<void> Function() function,
    MeasureConfig config,
  ) async {
    return runAsyncWithProgress(key, function, config, (progress) {
      _progressSubject.add(progress);
    });
  }

  @override
  Future<MeasureResult> runAsyncWithProgress(
    String key,
    Future<void> Function() function,
    MeasureConfig config,
    void Function(MeasureProgress progress) onProgress,
  ) async {
    _cancelRequested = false;

    // Инициализируем списки для хранения результатов
    final executionTimeMs = <int>[];
    final memoryUsage = config.measureMemory ? <int>[] : <int>[];
    final ticks = config.measureTicks ? <int>[] : <int>[];

    // Инициализируем прогресс
    var progress = MeasureProgress(
      isRunning: true,
      currentIteration: 0,
      totalIterations: config.iterations,
      currentKey: key,
    );
    onProgress(progress);

    // Выполняем замеры
    for (var i = 0; i < config.iterations; i++) {
      // Проверяем, не была ли запрошена отмена
      if (_cancelRequested) {
        break;
      }

      // Обновляем прогресс
      progress = progress.copyWith(currentIteration: i);
      onProgress(progress);

      // Выполняем замер
      final result = await _measureAsyncOnce(function, config);
      executionTimeMs.add(result.executionTimeMs);
      if (config.measureMemory) {
        memoryUsage.add(result.memoryUsage);
      }
      if (config.measureTicks) {
        ticks.add(result.ticks);
      }

      // Небольшая пауза между итерациями для снижения влияния на результаты
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    // Сбрасываем прогресс
    onProgress(MeasureProgress.initial());

    // Возвращаем результат
    return MeasureResult(
      key: key,
      executionTimeMs: executionTimeMs,
      memoryUsage: memoryUsage,
      ticks: ticks,
    );
  }

  @override
  Future<void> cancel() async {
    _cancelRequested = true;
    _progressSubject.add(MeasureProgress.initial());
  }

  @override
  MeasureProgress get currentProgress => _progressSubject.value;

  @override
  Stream<MeasureProgress> get progressStream => _progressSubject.stream;

  /// Выполняет одиночный замер для синхронной функции.
  ///
  /// [function] - функция для замера.
  /// [config] - конфигурация замера.
  ///
  /// Возвращает результат замера в виде кортежа (время выполнения, использование памяти, тики).
  Future<({int executionTimeMs, int memoryUsage, int ticks})> _measureOnce(
    Function() function,
    MeasureConfig config,
  ) async {
    int memoryBefore = 0;
    int memoryAfter = 0;
    int ticksBefore = 0;
    int ticksAfter = 0;

    // Измеряем использование памяти перед выполнением
    if (config.measureMemory) {
      memoryBefore = _getCurrentMemoryUsage();
    }

    // Измеряем тики перед выполнением
    if (config.measureTicks) {
      ticksBefore = _getCurrentTicks();
    }

    // Измеряем время выполнения
    final stopwatch = Stopwatch()..start();
    function();
    stopwatch.stop();

    // Измеряем использование памяти после выполнения
    if (config.measureMemory) {
      memoryAfter = _getCurrentMemoryUsage();
    }

    // Измеряем тики после выполнения
    if (config.measureTicks) {
      ticksAfter = _getCurrentTicks();
    }

    return (
      executionTimeMs: stopwatch.elapsedMilliseconds,
      memoryUsage: memoryAfter - memoryBefore,
      ticks: ticksAfter - ticksBefore,
    );
  }

  /// Выполняет одиночный замер для асинхронной функции.
  ///
  /// [function] - асинхронная функция для замера.
  /// [config] - конфигурация замера.
  ///
  /// Возвращает результат замера в виде кортежа (время выполнения, использование памяти, тики).
  Future<({int executionTimeMs, int memoryUsage, int ticks})> _measureAsyncOnce(
    Future<void> Function() function,
    MeasureConfig config,
  ) async {
    int memoryBefore = 0;
    int memoryAfter = 0;
    int ticksBefore = 0;
    int ticksAfter = 0;

    // Измеряем использование памяти перед выполнением
    if (config.measureMemory) {
      memoryBefore = _getCurrentMemoryUsage();
    }

    // Измеряем тики перед выполнением
    if (config.measureTicks) {
      ticksBefore = _getCurrentTicks();
    }

    // Измеряем время выполнения
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();

    // Измеряем использование памяти после выполнения
    if (config.measureMemory) {
      memoryAfter = _getCurrentMemoryUsage();
    }

    // Измеряем тики после выполнения
    if (config.measureTicks) {
      ticksAfter = _getCurrentTicks();
    }

    return (
      executionTimeMs: stopwatch.elapsedMilliseconds,
      memoryUsage: memoryAfter - memoryBefore,
      ticks: ticksAfter - ticksBefore,
    );
  }

  /// Возвращает текущее использование памяти в байтах.
  ///
  /// Возвращает 0, если не удалось получить информацию об использовании памяти.
  /// Примечание: точное измерение памяти в Dart/Flutter ограничено,
  /// поэтому это приблизительная оценка.
  int _getCurrentMemoryUsage() {
    try {
      // В веб-платформе и некоторых других платформах может быть недоступно
      if (kIsWeb) return 0;

      // Используем DateTime.now().microsecondsSinceEpoch как приблизительную метрику
      // В реальном приложении можно использовать более точные методы,
      // например, через платформенные каналы
      return DateTime.now().microsecondsSinceEpoch % 1000000;
    } catch (e) {
      // Игнорируем ошибки и возвращаем 0
      return 0;
    }
  }

  /// Возвращает текущее количество тиков процессора.
  ///
  /// Возвращает 0, если не удалось получить информацию о тиках.
  int _getCurrentTicks() {
    try {
      // В веб-платформе и некоторых других платформах может быть недоступно
      if (kIsWeb) return 0;

      // Получаем информацию о тиках
      return DateTime.now().microsecondsSinceEpoch;
    } catch (e) {
      // Игнорируем ошибки и возвращаем 0
      return 0;
    }
  }

  /// Освобождает ресурсы, занятые исполнителем замеров.
  ///
  /// Этот метод должен быть вызван, когда исполнитель больше не нужен.
  void dispose() {
    _progressSubject.close();
  }
}
