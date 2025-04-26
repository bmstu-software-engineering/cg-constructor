import 'dart:math';

import 'package:flutter/material.dart';
import 'package:measures/measures.dart';

void main() {
  runApp(const MeasuresExampleApp());
}

class MeasuresExampleApp extends StatelessWidget {
  const MeasuresExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Создаем экземпляры MeasureRunner и MeasureStorage
    final runner = SynchronousMeasureRunner();
    final storage = MemoryMeasureStorage();
    final service = MeasureService(runner: runner, storage: storage);

    // Создаем конфигурацию по умолчанию
    const config = MeasureConfig(iterations: 10);

    return MaterialApp(
      title: 'Measures Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MeasureInheritedWidget(
        measureService: service,
        config: config,
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MeasureViewType _viewType = MeasureViewType.table;
  bool _useIsolate = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Сортировка'),
            Tab(text: 'Поиск'),
            Tab(text: 'Fibonacci'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _viewType == MeasureViewType.table
                  ? Icons.table_chart
                  : _viewType == MeasureViewType.barChart
                  ? Icons.bar_chart
                  : Icons.show_chart,
            ),
            onPressed: () {
              setState(() {
                _viewType =
                    MeasureViewType.values[(_viewType.index + 1) %
                        MeasureViewType.values.length];
              });
            },
            tooltip: 'Изменить тип отображения',
          ),
          IconButton(
            icon: Icon(_useIsolate ? Icons.bolt : Icons.bolt_outlined),
            onPressed: () {
              setState(() {
                _useIsolate = !_useIsolate;
              });
            },
            tooltip:
                _useIsolate
                    ? 'Использовать изоляты (включено)'
                    : 'Использовать изоляты (выключено)',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SortingTab(viewType: _viewType, useIsolate: _useIsolate),
          _SearchTab(viewType: _viewType, useIsolate: _useIsolate),
          _FibonacciTab(viewType: _viewType, useIsolate: _useIsolate),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          service.clearResults();
        },
        tooltip: 'Очистить результаты',
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class _SortingTab extends StatelessWidget {
  final MeasureViewType viewType;
  final bool useIsolate;

  const _SortingTab({required this.viewType, required this.useIsolate});

  @override
  Widget build(BuildContext context) {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(
      context,
    ).copyWith(useIsolate: useIsolate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сравнение алгоритмов сортировки',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'bubble_sort',
                    () => _bubbleSort(
                      List.generate(5000, (_) => Random().nextInt(10000)),
                    ),
                    config,
                  );
                },
                child: const Text('Bubble Sort'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'insertion_sort',
                    () => _insertionSort(
                      List.generate(3000, (_) => Random().nextInt(10000)),
                    ),
                    config,
                  );
                },
                child: const Text('Insertion Sort'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'selection_sort',
                    () => _selectionSort(
                      List.generate(3000, (_) => Random().nextInt(10000)),
                    ),
                    config,
                  );
                },
                child: const Text('Selection Sort'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure('quick_sort', () {
                    final list = List.generate(
                      10000,
                      (_) => Random().nextInt(10000),
                    );
                    _quickSort(list, 0, list.length - 1);
                  }, config);
                },
                child: const Text('Quick Sort'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure('merge_sort', () {
                    final list = List.generate(
                      10000,
                      (_) => Random().nextInt(10000),
                    );
                    _mergeSort(list);
                  }, config);
                },
                child: const Text('Merge Sort'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure('dart_sort', () {
                    final list = List.generate(
                      10000,
                      (_) => Random().nextInt(10000),
                    );
                    list.sort();
                  }, config);
                },
                child: const Text('Dart Sort'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MeasureWidget(
              title: 'Результаты сортировки',
              keysToCompare: const [
                'bubble_sort',
                'insertion_sort',
                'selection_sort',
                'quick_sort',
                'merge_sort',
                'dart_sort',
              ],
              viewType: viewType,
            ),
          ),
        ],
      ),
    );
  }

  // Реализации алгоритмов сортировки
  List<int> _bubbleSort(List<int> list) {
    final result = List<int>.from(list);
    for (var i = 0; i < result.length; i++) {
      for (var j = 0; j < result.length - i - 1; j++) {
        if (result[j] > result[j + 1]) {
          final temp = result[j];
          result[j] = result[j + 1];
          result[j + 1] = temp;
        }
      }
    }
    return result;
  }

  List<int> _insertionSort(List<int> list) {
    final result = List<int>.from(list);
    for (var i = 1; i < result.length; i++) {
      final key = result[i];
      var j = i - 1;
      while (j >= 0 && result[j] > key) {
        result[j + 1] = result[j];
        j--;
      }
      result[j + 1] = key;
    }
    return result;
  }

  List<int> _selectionSort(List<int> list) {
    final result = List<int>.from(list);
    for (var i = 0; i < result.length; i++) {
      var minIndex = i;
      for (var j = i + 1; j < result.length; j++) {
        if (result[j] < result[minIndex]) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        final temp = result[i];
        result[i] = result[minIndex];
        result[minIndex] = temp;
      }
    }
    return result;
  }

  void _quickSort(List<int> list, int low, int high) {
    if (low < high) {
      final pivotIndex = _partition(list, low, high);
      _quickSort(list, low, pivotIndex - 1);
      _quickSort(list, pivotIndex + 1, high);
    }
  }

  int _partition(List<int> list, int low, int high) {
    final pivot = list[high];
    var i = low - 1;
    for (var j = low; j < high; j++) {
      if (list[j] <= pivot) {
        i++;
        final temp = list[i];
        list[i] = list[j];
        list[j] = temp;
      }
    }
    final temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;
    return i + 1;
  }

  List<int> _mergeSort(List<int> list) {
    if (list.length <= 1) return list;

    final middle = list.length ~/ 2;
    final left = _mergeSort(list.sublist(0, middle));
    final right = _mergeSort(list.sublist(middle));

    return _merge(left, right);
  }

  List<int> _merge(List<int> left, List<int> right) {
    final result = <int>[];
    var leftIndex = 0;
    var rightIndex = 0;

    while (leftIndex < left.length && rightIndex < right.length) {
      if (left[leftIndex] <= right[rightIndex]) {
        result.add(left[leftIndex]);
        leftIndex++;
      } else {
        result.add(right[rightIndex]);
        rightIndex++;
      }
    }

    result.addAll(left.sublist(leftIndex));
    result.addAll(right.sublist(rightIndex));

    return result;
  }
}

class _SearchTab extends StatelessWidget {
  final MeasureViewType viewType;
  final bool useIsolate;

  const _SearchTab({required this.viewType, required this.useIsolate});

  @override
  Widget build(BuildContext context) {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(
      context,
    ).copyWith(useIsolate: useIsolate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сравнение алгоритмов поиска',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final list = List.generate(1000000, (i) => i);
                  final target = Random().nextInt(1000000);
                  await service.measure(
                    'linear_search',
                    () => _linearSearch(list, target),
                    config,
                  );
                },
                child: const Text('Linear Search'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final list = List.generate(1000000, (i) => i);
                  final target = Random().nextInt(1000000);
                  await service.measure(
                    'binary_search',
                    () => _binarySearch(list, target),
                    config,
                  );
                },
                child: const Text('Binary Search'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final list = List.generate(1000000, (i) => i);
                  final target = Random().nextInt(1000000);
                  await service.measure(
                    'jump_search',
                    () => _jumpSearch(list, target),
                    config,
                  );
                },
                child: const Text('Jump Search'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final list = List.generate(1000000, (i) => i);
                  final target = Random().nextInt(1000000);
                  await service.measure(
                    'interpolation_search',
                    () => _interpolationSearch(list, target),
                    config,
                  );
                },
                child: const Text('Interpolation Search'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MeasureWidget(
              title: 'Результаты поиска',
              keysToCompare: const [
                'linear_search',
                'binary_search',
                'jump_search',
                'interpolation_search',
              ],
              viewType: viewType,
            ),
          ),
        ],
      ),
    );
  }

  // Реализации алгоритмов поиска
  int _linearSearch(List<int> list, int target) {
    for (var i = 0; i < list.length; i++) {
      if (list[i] == target) {
        return i;
      }
    }
    return -1;
  }

  int _binarySearch(List<int> list, int target) {
    var left = 0;
    var right = list.length - 1;

    while (left <= right) {
      final middle = left + (right - left) ~/ 2;

      if (list[middle] == target) {
        return middle;
      }

      if (list[middle] < target) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }

    return -1;
  }

  int _jumpSearch(List<int> list, int target) {
    final n = list.length;
    var step = sqrt(n).floor();
    var prev = 0;

    while (list[min(step, n) - 1] < target) {
      prev = step;
      step += sqrt(n).floor();
      if (prev >= n) {
        return -1;
      }
    }

    while (list[prev] < target) {
      prev++;
      if (prev == min(step, n)) {
        return -1;
      }
    }

    if (list[prev] == target) {
      return prev;
    }

    return -1;
  }

  int _interpolationSearch(List<int> list, int target) {
    var low = 0;
    var high = list.length - 1;

    while (low <= high && target >= list[low] && target <= list[high]) {
      if (low == high) {
        if (list[low] == target) {
          return low;
        }
        return -1;
      }

      final pos =
          low +
          ((target - list[low]) * (high - low) ~/ (list[high] - list[low]));

      if (list[pos] == target) {
        return pos;
      }

      if (list[pos] < target) {
        low = pos + 1;
      } else {
        high = pos - 1;
      }
    }

    return -1;
  }
}

class _FibonacciTab extends StatelessWidget {
  final MeasureViewType viewType;
  final bool useIsolate;

  const _FibonacciTab({required this.viewType, required this.useIsolate});

  @override
  Widget build(BuildContext context) {
    final service = MeasureInheritedWidget.getService(context);
    final config = MeasureInheritedWidget.getConfig(
      context,
    ).copyWith(useIsolate: useIsolate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сравнение алгоритмов вычисления чисел Фибоначчи',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'fibonacci_recursive',
                    () => _fibonacciRecursive(35),
                    config,
                  );
                },
                child: const Text('Recursive'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'fibonacci_iterative',
                    () => _fibonacciIterative(45),
                    config,
                  );
                },
                child: const Text('Iterative'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'fibonacci_dynamic',
                    () => _fibonacciDynamic(45),
                    config,
                  );
                },
                child: const Text('Dynamic Programming'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.measure(
                    'fibonacci_matrix',
                    () => _fibonacciMatrix(45),
                    config,
                  );
                },
                child: const Text('Matrix'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MeasureWidget(
              title: 'Результаты вычисления чисел Фибоначчи',
              keysToCompare: const [
                'fibonacci_recursive',
                'fibonacci_iterative',
                'fibonacci_dynamic',
                'fibonacci_matrix',
              ],
              viewType: viewType,
            ),
          ),
        ],
      ),
    );
  }

  // Реализации алгоритмов вычисления чисел Фибоначчи
  int _fibonacciRecursive(int n) {
    if (n <= 1) return n;
    return _fibonacciRecursive(n - 1) + _fibonacciRecursive(n - 2);
  }

  int _fibonacciIterative(int n) {
    if (n <= 1) return n;

    var a = 0;
    var b = 1;
    var c = 1;

    for (var i = 2; i <= n; i++) {
      c = a + b;
      a = b;
      b = c;
    }

    return c;
  }

  int _fibonacciDynamic(int n) {
    if (n <= 1) return n;

    final dp = List<int>.filled(n + 1, 0);
    dp[0] = 0;
    dp[1] = 1;

    for (var i = 2; i <= n; i++) {
      dp[i] = dp[i - 1] + dp[i - 2];
    }

    return dp[n];
  }

  int _fibonacciMatrix(int n) {
    if (n <= 1) return n;

    var result = [1, 0, 0, 1];
    var fibonacci = [1, 1, 1, 0];
    var temp = [0, 0, 0, 0];

    for (var i = 2; i <= n; i++) {
      // Умножение матриц
      temp[0] = result[0] * fibonacci[0] + result[1] * fibonacci[2];
      temp[1] = result[0] * fibonacci[1] + result[1] * fibonacci[3];
      temp[2] = result[2] * fibonacci[0] + result[3] * fibonacci[2];
      temp[3] = result[2] * fibonacci[1] + result[3] * fibonacci[3];

      result[0] = temp[0];
      result[1] = temp[1];
      result[2] = temp[2];
      result[3] = temp[3];
    }

    return result[1];
  }
}
