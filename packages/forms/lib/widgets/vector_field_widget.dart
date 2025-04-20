import 'package:flutter/material.dart';
import '../src/fields/vector_field.dart';
import '../src/models/vector.dart';
import 'form_field_widget.dart';
import 'number_field_widget.dart';

/// Виджет для поля вектора
class VectorFieldWidget extends FormFieldWidget<Vector, VectorField> {
  /// Создает виджет поля вектора
  ///
  /// [field] - поле вектора
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями dX и dY
  const VectorFieldWidget({
    super.key,
    required VectorField field,
    ValueChanged<Vector?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 8.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями dX и dY
  final double spacing;

  @override
  State<VectorFieldWidget> createState() => _VectorFieldWidgetState();
}

class _VectorFieldWidgetState
    extends FormFieldWidgetState<Vector, VectorField, VectorFieldWidget> {
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
        Row(
          children: [
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.dxField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.dxField.config.label,
                  errorText: widget.field.dxField.error,
                ),
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: NumberFieldWidget(
                field: widget.field.dyField,
                onChanged: (_) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                },
                decoration: getDecoration(
                  labelText: widget.field.dyField.config.label,
                  errorText: widget.field.dyField.error,
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
