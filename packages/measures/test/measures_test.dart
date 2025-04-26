import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:measures/measures.dart';

// Моки для тестирования
class MockMeasureRunner extends Mock implements MeasureRunner {}

class MockMeasureStorage extends Mock implements MeasureStorage {}

void main() {
  group('MeasureConfig', () {
    test('создается с правильными значениями по умолчанию', () {
      const config = MeasureConfig();
      expect(config.iterations, 1);
      expect(config.useIsolate, false);
      expect(config.measureMemory, true);
      expect(config.measureTicks, false);
    });

    test('создается с указанными значениями', () {
      const config = MeasureConfig(
        iterations: 10,
        useIsolate: true,
        measureMemory: false,
        measureTicks: true,
      );
      expect(config.iterations, 10);
      expect(config.useIsolate, true);
      expect(config.measureMemory, false);
      expect(config.measureTicks, true);
    });

    test('copyWith создает новый экземпляр с измененными значениями', () {
      const config = MeasureConfig();
      final newConfig = config.copyWith(iterations: 5, useIsolate: true);
      expect(newConfig.iterations, 5);
      expect(newConfig.useIsolate, true);
      expect(newConfig.measureMemory, config.measureMemory);
      expect(newConfig.measureTicks, config.measureTicks);
    });

    test('equals и hashCode работают корректно', () {
      const config1 = MeasureConfig(
        iterations: 10,
        useIsolate: true,
        measureMemory: false,
        measureTicks: true,
      );
      const config2 = MeasureConfig(
        iterations: 10,
        useIsolate: true,
        measureMemory: false,
        measureTicks: true,
      );
      const config3 = MeasureConfig(
        iterations: 5,
        useIsolate: true,
        measureMemory: false,
        measureTicks: true,
      );
      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1, isNot(equals(config3)));
      expect(config1.hashCode, isNot(equals(config3.hashCode)));
    });
  });

  group('MeasureResult', () {
    test('создается с правильными значениями', () {
      const result = MeasureResult(
        key: 'test',
        executionTimeMs: [10, 20, 30],
        memoryUsage: [100, 200, 300],
        ticks: [1000, 2000, 3000],
      );
      expect(result.key, 'test');
      expect(result.executionTimeMs, [10, 20, 30]);
      expect(result.memoryUsage, [100, 200, 300]);
      expect(result.ticks, [1000, 2000, 3000]);
    });

    test(
      'создается с пустыми списками для memoryUsage и ticks по умолчанию',
      () {
        const result = MeasureResult(
          key: 'test',
          executionTimeMs: [10, 20, 30],
        );
        expect(result.key, 'test');
        expect(result.executionTimeMs, [10, 20, 30]);
        expect(result.memoryUsage, isEmpty);
        expect(result.ticks, isEmpty);
      },
    );

    test('вычисляет статистические показатели корректно', () {
      const result = MeasureResult(
        key: 'test',
        executionTimeMs: [10, 20, 30],
        memoryUsage: [100, 200, 300],
        ticks: [1000, 2000, 3000],
      );
      expect(result.averageExecutionTimeMs, 20.0);
      expect(result.medianExecutionTimeMs, 20.0);
      expect(result.minExecutionTimeMs, 10);
      expect(result.maxExecutionTimeMs, 30);
      expect(result.stdDevExecutionTimeMs, closeTo(8.16, 0.01));
      expect(result.averageMemoryUsage, 200.0);
      expect(result.averageTicks, 2000.0);
    });

    test(
      'вычисляет статистические показатели корректно для пустых списков',
      () {
        const result = MeasureResult(key: 'test', executionTimeMs: []);
        expect(result.averageExecutionTimeMs, 0.0);
        expect(result.medianExecutionTimeMs, 0.0);
        expect(result.minExecutionTimeMs, 0);
        expect(result.maxExecutionTimeMs, 0);
        expect(result.stdDevExecutionTimeMs, 0.0);
        expect(result.averageMemoryUsage, 0.0);
        expect(result.averageTicks, 0.0);
      },
    );

    test('copyWith создает новый экземпляр с измененными значениями', () {
      const result = MeasureResult(key: 'test', executionTimeMs: [10, 20, 30]);
      final newResult = result.copyWith(
        key: 'new_test',
        memoryUsage: [100, 200, 300],
      );
      expect(newResult.key, 'new_test');
      expect(newResult.executionTimeMs, result.executionTimeMs);
      expect(newResult.memoryUsage, [100, 200, 300]);
      expect(newResult.ticks, result.ticks);
    });
  });

  group('MeasureProgress', () {
    test('создается с правильными значениями', () {
      const progress = MeasureProgress(
        isRunning: true,
        currentIteration: 5,
        totalIterations: 10,
        currentKey: 'test',
      );
      expect(progress.isRunning, true);
      expect(progress.currentIteration, 5);
      expect(progress.totalIterations, 10);
      expect(progress.currentKey, 'test');
      expect(progress.progress, 0.5);
    });

    test('initial создает начальный экземпляр с пустыми значениями', () {
      final progress = MeasureProgress.initial();
      expect(progress.isRunning, false);
      expect(progress.currentIteration, 0);
      expect(progress.totalIterations, 0);
      expect(progress.currentKey, null);
      expect(progress.progress, 0.0);
    });

    test('copyWith создает новый экземпляр с измененными значениями', () {
      const progress = MeasureProgress(
        isRunning: true,
        currentIteration: 5,
        totalIterations: 10,
        currentKey: 'test',
      );
      final newProgress = progress.copyWith(
        isRunning: false,
        currentIteration: 10,
      );
      expect(newProgress.isRunning, false);
      expect(newProgress.currentIteration, 10);
      expect(newProgress.totalIterations, progress.totalIterations);
      expect(newProgress.currentKey, progress.currentKey);
    });

    test('incrementIteration увеличивает текущую итерацию на 1', () {
      const progress = MeasureProgress(
        isRunning: true,
        currentIteration: 5,
        totalIterations: 10,
        currentKey: 'test',
      );
      final newProgress = progress.incrementIteration();
      expect(newProgress.currentIteration, 6);
      expect(newProgress.isRunning, progress.isRunning);
      expect(newProgress.totalIterations, progress.totalIterations);
      expect(newProgress.currentKey, progress.currentKey);
    });
  });

  group('MeasureService', () {
    late MockMeasureRunner mockRunner;
    late MockMeasureStorage mockStorage;
    late MeasureService service;

    setUp(() {
      mockRunner = MockMeasureRunner();
      mockStorage = MockMeasureStorage();

      // Определяем поведение для progressStream и resultsStream
      when(
        () => mockRunner.progressStream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockStorage.resultsStream).thenAnswer((_) => Stream.value([]));

      service = MeasureService(runner: mockRunner, storage: mockStorage);
    });

    test('measure вызывает runner.run и storage.saveResult', () async {
      // Arrange
      const key = 'test';
      function() => 42;
      const config = MeasureConfig();
      const result = MeasureResult(key: key, executionTimeMs: [10]);

      when(
        () => mockRunner.run(key, function, config),
      ).thenAnswer((_) async => result);
      when(() => mockStorage.saveResult(result)).thenAnswer((_) async => {});
      when(
        () => mockRunner.progressStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act
      final actualResult = await service.measure(key, function, config);

      // Assert
      expect(actualResult, equals(result));
      verify(() => mockRunner.run(key, function, config)).called(1);
      verify(() => mockStorage.saveResult(result)).called(1);
    });

    test(
      'measureAsync вызывает runner.runAsync и storage.saveResult',
      () async {
        // Arrange
        const key = 'test';
        function() async => {};
        const config = MeasureConfig();
        const result = MeasureResult(key: key, executionTimeMs: [10]);

        when(
          () => mockRunner.runAsync(key, function, config),
        ).thenAnswer((_) async => result);
        when(() => mockStorage.saveResult(result)).thenAnswer((_) async => {});
        when(
          () => mockRunner.progressStream,
        ).thenAnswer((_) => const Stream.empty());

        // Act
        final actualResult = await service.measureAsync(key, function, config);

        // Assert
        expect(actualResult, equals(result));
        verify(() => mockRunner.runAsync(key, function, config)).called(1);
        verify(() => mockStorage.saveResult(result)).called(1);
      },
    );

    test('cancel вызывает runner.cancel', () async {
      // Arrange
      when(() => mockRunner.cancel()).thenAnswer((_) async => {});
      when(
        () => mockRunner.progressStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act
      await service.cancel();

      // Assert
      verify(() => mockRunner.cancel()).called(1);
    });

    test('removeResult вызывает storage.removeResult', () async {
      // Arrange
      const key = 'test';
      when(() => mockStorage.removeResult(key)).thenAnswer((_) async => true);
      when(() => mockStorage.resultsStream).thenAnswer((_) => Stream.value([]));
      when(
        () => mockRunner.progressStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act
      final result = await service.removeResult(key);

      // Assert
      expect(result, true);
      verify(() => mockStorage.removeResult(key)).called(1);
    });

    test('clearResults вызывает storage.clearResults', () async {
      // Arrange
      when(() => mockStorage.clearResults()).thenAnswer((_) async => {});
      when(() => mockStorage.resultsStream).thenAnswer((_) => Stream.value([]));
      when(
        () => mockRunner.progressStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act
      await service.clearResults();

      // Assert
      verify(() => mockStorage.clearResults()).called(1);
    });
  });
}
