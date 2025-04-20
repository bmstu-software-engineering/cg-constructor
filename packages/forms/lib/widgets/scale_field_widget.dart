import 'package:flutter/material.dart';
import '../src/fields/scale_field.dart';
import '../src/models/scale.dart';
import 'form_field_widget.dart';
import 'number_field_widget.dart';

/// Виджет для поля масштабирования
class ScaleFieldWidget extends FormFieldWidget<Scale, ScaleField> {
  /// Создает виджет поля масштабирования
  ///
  /// [field] - поле масштабирования
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями X и Y (если uniform = false)
  const ScaleFieldWidget({
    super.key,
    required ScaleField field,
    ValueChanged<Scale?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 8.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями X и Y
  final double spacing;

  @override
  State<ScaleFieldWidget> createState() => _ScaleFieldWidgetState();
}

class _ScaleFieldWidgetState
    extends FormFieldWidgetState<Scale, ScaleField, ScaleFieldWidget> {
  @override
  Widget build(BuildContext context) {
    // Если масштабирование равномерное, показываем только одно поле
    if (widget.field.isUniform) {
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
          NumberFieldWidget(
            field: widget.field.xField,
            onChanged: (_) {
              widget.field.syncValues(true);
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(widget.field.value);
              }
            },
            decoration: getDecoration(
              labelText: 'Масштаб',
              errorText: widget.field.error,
            ),
          ),
        ],
      );
    }

    // Если масштабирование неравномерное, показываем два поля
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
        Row(
          children: [
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.xField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.xField.config.label,
                  errorText: widget.field.xField.error,
                ),
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.yField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.yField.config.label,
                  errorText: widget.field.yField.error,
                ),
              ),
            ),
          ],
        ),
        if (widget.field.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.field.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12.0,
              ),
            ),
          ),
      ],
    );
  }
}
