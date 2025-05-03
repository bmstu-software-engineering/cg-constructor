import '../core/form_field.dart';
import '../fields/nested_form_field.dart';
import '../typed_form_base.dart';

import 'field_config.dart';

/// Конфигурация для поля вложенной формы
class FormFieldConfig<T> extends FieldConfig<T> {
  /// Функция для создания модели формы
  final TypedFormModel<T> Function() createFormModel;

  /// Создает конфигурацию для поля вложенной формы
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [createFormModel] - функция для создания модели формы
  const FormFieldConfig({
    super.label,
    super.hint,
    super.isRequired,
    super.validator,
    required this.createFormModel,
  });

  @override
  FormField<T> createField() {
    return NestedFormField<T>(config: this);
  }
}
