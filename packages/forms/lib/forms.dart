/// Библиотека для работы с формами ввода различных данных
library forms;

// Экспортируем базовые интерфейсы и классы
export 'src/core/validatable.dart';
export 'src/core/form_field.dart';
export 'src/core/form_model.dart';
export 'src/core/validators.dart';
export 'src/core/diagnosticable_form_field.dart';
export 'src/core/diagnosticable_form_model.dart';

// Экспортируем конфигурации полей
export 'src/config/field_config.dart';
export 'src/config/field_type.dart';
export 'src/config/field_config_entry.dart';
export 'src/config/form_config.dart';
export 'src/config/number_config.dart';
export 'src/config/point_config.dart';
export 'src/config/angle_config.dart';
export 'src/config/vector_config.dart';
export 'src/config/scale_config.dart';
export 'src/config/polygon_config.dart';
export 'src/config/triangle_config.dart';
export 'src/config/rectangle_config.dart';
export 'src/config/list_field_config.dart';

// Экспортируем модели
export 'src/models/angle.dart';
export 'src/models/vector.dart';
export 'src/models/scale.dart';
export 'src/models/polygon.dart';
export 'src/models/triangle.dart';
export 'src/models/rectangle.dart';
export 'src/models/dynamic_form_model.dart';

// Экспортируем поля форм
export 'src/fields/base_form_field.dart';
export 'src/fields/number_field.dart';
export 'src/fields/point_field.dart';
export 'src/fields/angle_field.dart';
export 'src/fields/vector_field.dart';
export 'src/fields/scale_field.dart';
export 'src/fields/polygon_field.dart';
export 'src/fields/triangle_field.dart';
export 'src/fields/rectangle_field.dart';
export 'src/fields/list_field.dart';

// Экспортируем виджеты
export 'widgets/widgets.dart';
