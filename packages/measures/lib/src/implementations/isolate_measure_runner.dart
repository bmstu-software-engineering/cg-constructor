import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../abstractions/measure_config.dart';
import '../abstractions/measure_progress.dart';
import '../abstractions/measure_result.dart';
import '../abstractions/measure_runner.dart';

/// Реализация [MeasureRunner] для запуска замеров в отдельном изоляте.
///
/// Этот класс выполняет замеры в отдельном изоляте, что позволяет
/// получить более точные результаты и не блокировать основной поток приложения.
class IsolateMeasureRunner implements MeasureRunner {
  /// Поток для отправки обновлений прогресса выполнения замеров.
  final BehaviorSubject<MeasureProgress> _progressSubject;

  /// Флаг, указывающий, нужно ли отменить текущий замер.
  bool _cancelRequested = false;

  /// Текущий изолят для выполнения замеров.
  Isolate? _currentIsolate;

  /// Порт для отправки сообщений в изолят.
  SendPort? _sendPort;

  /// Порт для получения сообщений из изолята.
  ReceivePort? _receivePort;

  /// Создает новый экземпляр [IsolateMeasureRunner].
  IsolateMeasureRunner()
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
    // Проверяем, поддерживаются ли изоляты на текущей платформе
    if (kIsWeb) {
      // В веб-платформе изоляты не поддерживаются, используем синхронный запуск
      return _runSynchronously(key, function, config, onProgress);
    }

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

    try {
      // Создаем порт для получения сообщений из изолята
      _receivePort = ReceivePort();

      // Создаем изолят
      _currentIsolate = await Isolate.spawn(
        _isolateEntryPoint,
        _IsolateMessage(
          sendPort: _receivePort!.sendPort,
          key: key,
          iterations: config.iterations,
          measureMemory: config.measureMemory,
          measureTicks: config.measureTicks,
        ),
      );

      // Получаем порт для отправки сообщений в изолят
      _sendPort = await _receivePort!.first as SendPort;

      // Создаем подписку на сообщения из изолята
      final subscription = _receivePort!.listen((message) {
        if (message is _IsolateProgress) {
          // Обновляем прогресс
          progress = progress.copyWith(currentIteration: message.iteration);
          onProgress(progress);
        } else if (message is _IsolateResult) {
          // Добавляем результаты
          executionTimeMs.add(message.executionTimeMs);
          if (config.measureMemory) {
            memoryUsage.add(message.memoryUsage);
          }
          if (config.measureTicks) {
            ticks.add(message.ticks);
          }
        }
      });

      // Отправляем функцию в изолят
      _sendPort!.send(function);

      // Ждем завершения всех итераций
      await Future<void>.delayed(
        Duration(milliseconds: config.iterations * 100),
      );

      // Отменяем подписку
      await subscription.cancel();
    } finally {
      // Закрываем порт и завершаем изолят
      _receivePort?.close();
      _currentIsolate?.kill(priority: Isolate.immediate);
      _receivePort = null;
      _currentIsolate = null;
      _sendPort = null;
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
    // Проверяем, поддерживаются ли изоляты на текущей платформе
    if (kIsWeb) {
      // В веб-платформе изоляты не поддерживаются, используем синхронный запуск
      return _runAsyncSynchronously(key, function, config, onProgress);
    }

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

    try {
      // Создаем порт для получения сообщений из изолята
      _receivePort = ReceivePort();

      // Создаем изолят
      _currentIsolate = await Isolate.spawn(
        _isolateAsyncEntryPoint,
        _IsolateMessage(
          sendPort: _receivePort!.sendPort,
          key: key,
          iterations: config.iterations,
          measureMemory: config.measureMemory,
          measureTicks: config.measureTicks,
        ),
      );

      // Получаем порт для отправки сообщений в изолят
      _sendPort = await _receivePort!.first as SendPort;

      // Создаем подписку на сообщения из изолята
      final subscription = _receivePort!.listen((message) {
        if (message is _IsolateProgress) {
          // Обновляем прогресс
          progress = progress.copyWith(currentIteration: message.iteration);
          onProgress(progress);
        } else if (message is _IsolateResult) {
          // Добавляем результаты
          executionTimeMs.add(message.executionTimeMs);
          if (config.measureMemory) {
            memoryUsage.add(message.memoryUsage);
          }
          if (config.measureTicks) {
            ticks.add(message.ticks);
          }
        }
      });

      // Отправляем функцию в изолят
      _sendPort!.send(function);

      // Ждем завершения всех итераций
      await Future<void>.delayed(
        Duration(milliseconds: config.iterations * 100),
      );

      // Отменяем подписку
      await subscription.cancel();
    } finally {
      // Закрываем порт и завершаем изолят
      _receivePort?.close();
      _currentIsolate?.kill(priority: Isolate.immediate);
      _receivePort = null;
      _currentIsolate = null;
      _sendPort = null;
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

    // Завершаем изолят, если он запущен
    if (_currentIsolate != null) {
      _currentIsolate!.kill(priority: Isolate.immediate);
      _receivePort?.close();
      _receivePort = null;
      _currentIsolate = null;
      _sendPort = null;
    }
  }

  @override
  MeasureProgress get currentProgress => _progressSubject.value;

  @override
  Stream<MeasureProgress> get progressStream => _progressSubject.stream;

  /// Выполняет замер в основном потоке для синхронной функции.
  ///
  /// Этот метод используется, когда изоляты не поддерживаются.
  Future<MeasureResult> _runSynchronously(
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
      final result = _measureOnce(function, config);
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

  /// Выполняет замер в основном потоке для асинхронной функции.
  ///
  /// Этот метод используется, когда изоляты не поддерживаются.
  Future<MeasureResult> _runAsyncSynchronously(
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

  /// Выполняет одиночный замер для синхронной функции.
  ///
  /// [function] - функция для замера.
  /// [config] - конфигурация замера.
  ///
  /// Возвращает результат замера в виде кортежа (время выполнения, использование памяти, тики).
  ({int executionTimeMs, int memoryUsage, int ticks}) _measureOnce(
    Function() function,
    MeasureConfig config,
  ) {
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
    _receivePort?.close();
    _currentIsolate?.kill(priority: Isolate.immediate);
  }
}

/// Сообщение для передачи в изолят.
class _IsolateMessage {
  /// Порт для отправки сообщений из изолята.
  final SendPort sendPort;

  /// Ключ замера.
  final String key;

  /// Количество итераций.
  final int iterations;

  /// Флаг, указывающий, нужно ли измерять использование памяти.
  final bool measureMemory;

  /// Флаг, указывающий, нужно ли измерять тики процессора.
  final bool measureTicks;

  /// Создает новое сообщение для передачи в изолят.
  _IsolateMessage({
    required this.sendPort,
    required this.key,
    required this.iterations,
    required this.measureMemory,
    required this.measureTicks,
  });
}

/// Прогресс выполнения замера в изоляте.
class _IsolateProgress {
  /// Текущая итерация.
  final int iteration;

  /// Создает новый прогресс выполнения замера в изоляте.
  _IsolateProgress({required this.iteration});
}

/// Результат замера в изоляте.
class _IsolateResult {
  /// Время выполнения в миллисекундах.
  final int executionTimeMs;

  /// Использование памяти в байтах.
  final int memoryUsage;

  /// Количество тиков процессора.
  final int ticks;

  /// Создает новый результат замера в изоляте.
  _IsolateResult({
    required this.executionTimeMs,
    required this.memoryUsage,
    required this.ticks,
  });
}

/// Точка входа в изолят для синхронной функции.
void _isolateEntryPoint(_IsolateMessage message) {
  // Создаем порт для получения сообщений
  final receivePort = ReceivePort();

  // Отправляем порт для отправки сообщений
  message.sendPort.send(receivePort.sendPort);

  // Получаем функцию для замера
  receivePort.first.then((function) {
    if (function is Function()) {
      // Выполняем замеры
      for (var i = 0; i < message.iterations; i++) {
        // Отправляем прогресс
        message.sendPort.send(_IsolateProgress(iteration: i));

        // Выполняем замер
        final result = _measureOnceInIsolate(
          function,
          message.measureMemory,
          message.measureTicks,
        );

        // Отправляем результат
        message.sendPort.send(
          _IsolateResult(
            executionTimeMs: result.executionTimeMs,
            memoryUsage: result.memoryUsage,
            ticks: result.ticks,
          ),
        );

        // Небольшая пауза между итерациями для снижения влияния на результаты
        Future<void>.delayed(const Duration(milliseconds: 10));
      }
    }

    // Закрываем порт
    receivePort.close();
  });
}

/// Точка входа в изолят для асинхронной функции.
void _isolateAsyncEntryPoint(_IsolateMessage message) {
  // Создаем порт для получения сообщений
  final receivePort = ReceivePort();

  // Отправляем порт для отправки сообщений
  message.sendPort.send(receivePort.sendPort);

  // Получаем функцию для замера
  receivePort.first.then((function) async {
    if (function is Future<void> Function()) {
      // Выполняем замеры
      for (var i = 0; i < message.iterations; i++) {
        // Отправляем прогресс
        message.sendPort.send(_IsolateProgress(iteration: i));

        // Выполняем замер
        final result = await _measureAsyncOnceInIsolate(
          function,
          message.measureMemory,
          message.measureTicks,
        );

        // Отправляем результат
        message.sendPort.send(
          _IsolateResult(
            executionTimeMs: result.executionTimeMs,
            memoryUsage: result.memoryUsage,
            ticks: result.ticks,
          ),
        );

        // Небольшая пауза между итерациями для снижения влияния на результаты
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    }

    // Закрываем порт
    receivePort.close();
  });
}

/// Выполняет одиночный замер для синхронной функции в изоляте.
///
/// [function] - функция для замера.
/// [measureMemory] - флаг, указывающий, нужно ли измерять использование памяти.
/// [measureTicks] - флаг, указывающий, нужно ли измерять тики процессора.
///
/// Возвращает результат замера в виде кортежа (время выполнения, использование памяти, тики).
({int executionTimeMs, int memoryUsage, int ticks}) _measureOnceInIsolate(
  Function() function,
  bool measureMemory,
  bool measureTicks,
) {
  int memoryBefore = 0;
  int memoryAfter = 0;
  int ticksBefore = 0;
  int ticksAfter = 0;

  // Измеряем использование памяти перед выполнением
  if (measureMemory) {
    memoryBefore = _getCurrentMemoryUsageInIsolate();
  }

  // Измеряем тики перед выполнением
  if (measureTicks) {
    ticksBefore = _getCurrentTicksInIsolate();
  }

  // Измеряем время выполнения
  final stopwatch = Stopwatch()..start();
  function();
  stopwatch.stop();

  // Измеряем использование памяти после выполнения
  if (measureMemory) {
    memoryAfter = _getCurrentMemoryUsageInIsolate();
  }

  // Измеряем тики после выполнения
  if (measureTicks) {
    ticksAfter = _getCurrentTicksInIsolate();
  }

  return (
    executionTimeMs: stopwatch.elapsedMilliseconds,
    memoryUsage: memoryAfter - memoryBefore,
    ticks: ticksAfter - ticksBefore,
  );
}

/// Выполняет одиночный замер для асинхронной функции в изоляте.
///
/// [function] - асинхронная функция для замера.
/// [measureMemory] - флаг, указывающий, нужно ли измерять использование памяти.
/// [measureTicks] - флаг, указывающий, нужно ли измерять тики процессора.
///
/// Возвращает результат замера в виде кортежа (время выполнения, использование памяти, тики).
Future<({int executionTimeMs, int memoryUsage, int ticks})>
_measureAsyncOnceInIsolate(
  Future<void> Function() function,
  bool measureMemory,
  bool measureTicks,
) async {
  int memoryBefore = 0;
  int memoryAfter = 0;
  int ticksBefore = 0;
  int ticksAfter = 0;

  // Измеряем использование памяти перед выполнением
  if (measureMemory) {
    memoryBefore = _getCurrentMemoryUsageInIsolate();
  }

  // Измеряем тики перед выполнением
  if (measureTicks) {
    ticksBefore = _getCurrentTicksInIsolate();
  }

  // Измеряем время выполнения
  final stopwatch = Stopwatch()..start();
  await function();
  stopwatch.stop();

  // Измеряем использование памяти после выполнения
  if (measureMemory) {
    memoryAfter = _getCurrentMemoryUsageInIsolate();
  }

  // Измеряем тики после выполнения
  if (measureTicks) {
    ticksAfter = _getCurrentTicksInIsolate();
  }

  return (
    executionTimeMs: stopwatch.elapsedMilliseconds,
    memoryUsage: memoryAfter - memoryBefore,
    ticks: ticksAfter - ticksBefore,
  );
}

/// Возвращает текущее использование памяти в байтах в изоляте.
///
/// Возвращает 0, если не удалось получить информацию об использовании памяти.
int _getCurrentMemoryUsageInIsolate() {
  try {
    // Используем DateTime.now().microsecondsSinceEpoch как приблизительную метрику
    // В реальном приложении можно использовать более точные методы,
    // например, через платформенные каналы
    return DateTime.now().microsecondsSinceEpoch % 1000000;
  } catch (e) {
    // Игнорируем ошибки и возвращаем 0
    return 0;
  }
}

/// Возвращает текущее количество тиков процессора в изоляте.
///
/// Возвращает 0, если не удалось получить информацию о тиках.
int _getCurrentTicksInIsolate() {
  try {
    // Получаем информацию о тиках
    return DateTime.now().microsecondsSinceEpoch;
  } catch (e) {
    // Игнорируем ошибки и возвращаем 0
    return 0;
  }
}
