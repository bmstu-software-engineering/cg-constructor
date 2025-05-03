/// Библиотека для работы с формами ввода различных данных
library forms;

// Экспортируем базовые интерфейсы и классы
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
export 'src/config/line_config.dart';
export 'src/config/enum_select_config.dart';
export 'src/config/string_config.dart';
export 'src/config/form_field_config.dart';

// Экспортируем модели, которые остались в пакете forms
export 'src/models/models.dart';

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
export 'src/fields/line_field.dart';
export 'src/fields/enum_select_field.dart';
export 'src/fields/string_field.dart';
export 'src/fields/nested_form_field.dart';

// Экспортируем виджеты
export 'widgets/widgets.dart';

// Экспортируем генератор типизированных форм
export 'src/typed_form_base.dart';
