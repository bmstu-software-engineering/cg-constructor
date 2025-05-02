import 'package:flutter/material.dart';
import '../src/fields/enum_select_field.dart';
import 'form_field_widget.dart';

/// Виджет для поля выбора из enum
class EnumSelectFieldWidget<T> extends FormFieldWidget<T, EnumSelectField<T>> {
  /// Создает виджет поля выбора из enum
  ///
  /// [field] - поле выбора
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  const EnumSelectFieldWidget({
    super.key,
    required super.field,
    super.onChanged,
    super.decoration,
  });

  @override
  State<EnumSelectFieldWidget<T>> createState() =>
      _EnumSelectFieldWidgetState<T>();
}

class _EnumSelectFieldWidgetState<T> extends FormFieldWidgetState<T,
    EnumSelectField<T>, EnumSelectFieldWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.decoration?.labelText != null ||
            widget.field.config.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.decoration?.labelText ?? widget.field.config.label ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        DropdownButtonFormField<T>(
          value: widget.field.value,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: widget.field.config.hint,
                errorText: widget.field.error,
              ),
          items: widget.field.options.map((option) {
            return DropdownMenuItem<T>(
              value: option.value,
              child: Text(option.title),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              widget.field.value = value;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            });
          },
        ),
      ],
    );
  }
}
