import '../core/form_field.dart';

/// Базовый класс для конфигурации поля формы
abstract class FieldConfig<T> {
  /// Метка поля
  final String? label;

  /// Подсказка для поля
  final String? hint;

  /// Является ли поле обязательным
  final bool isRequired;

  /// Функция валидации
  final String? Function(T?)? validator;

  FieldConfig({this.label, this.hint, this.isRequired = true, this.validator});

  /// Создает поле формы на основе конфигурации
  FormField<T> createField();
}
