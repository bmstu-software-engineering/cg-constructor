/// Библиотека для замеров времени работы алгоритма и отображения результатов.
library measures;

// Абстракции
export 'src/abstractions/measure_config.dart';
export 'src/abstractions/measure_progress.dart';
export 'src/abstractions/measure_result.dart';
export 'src/abstractions/measure_runner.dart';
export 'src/abstractions/measure_service.dart';
export 'src/abstractions/measure_storage.dart';

// Реализации
export 'src/implementations/isolate_measure_runner.dart';
export 'src/implementations/memory_measure_storage.dart';
export 'src/implementations/synchronous_measure_runner.dart';

// UI компоненты
export 'src/ui/measure_inherited_widget.dart';
export 'src/ui/measure_view_type.dart';
export 'src/ui/measure_widget.dart';
export 'src/ui/views/measure_bar_chart_view.dart';
export 'src/ui/views/measure_line_chart_view.dart';
export 'src/ui/views/measure_table_view.dart';
