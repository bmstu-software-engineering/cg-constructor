import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../src/fields/nested_form_field.dart';
import 'form_field_widget.dart';

/// Виджет для вложенной формы
class NestedFormFieldWidget extends FormFieldWidget<dynamic, NestedFormField> {
  /// Создает виджет вложенной формы
  ///
  /// [field] - поле вложенной формы
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const NestedFormFieldWidget({
    super.key,
    required super.field,
    super.onChanged,
    super.decoration,
  });

  @override
  State<NestedFormFieldWidget> createState() => _NestedFormFieldWidgetState();
}

class _NestedFormFieldWidgetState extends FormFieldWidgetState<dynamic,
    NestedFormField, NestedFormFieldWidget> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('value', widget.field.value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок вложенной формы
        Text(
          widget.field.config.label ?? 'Вложенная форма',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Ошибка, если есть
        if (widget.field.error != null)
          Text(
            widget.field.error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),

        // Содержимое вложенной формы
        // Здесь должен быть виджет для отображения вложенной формы
        // Но поскольку мы не знаем, какой именно виджет использовать,
        // просто отображаем текст с информацией о вложенной форме
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Вложенная форма: ${widget.field.formModel.runtimeType}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
