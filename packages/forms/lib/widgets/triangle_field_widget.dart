import 'package:flutter/material.dart';
import '../src/fields/triangle_field.dart';
import '../src/models/triangle.dart';
import 'form_field_widget.dart';
import 'point_field_widget.dart';

/// Виджет для поля треугольника
class TriangleFieldWidget extends FormFieldWidget<Triangle, TriangleField> {
  /// Создает виджет поля треугольника
  ///
  /// [field] - поле треугольника
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями точек
  const TriangleFieldWidget({
    super.key,
    required TriangleField field,
    ValueChanged<Triangle?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 16.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями точек
  final double spacing;

  @override
  State<TriangleFieldWidget> createState() => _TriangleFieldWidgetState();
}

class _TriangleFieldWidgetState
    extends FormFieldWidgetState<Triangle, TriangleField, TriangleFieldWidget> {
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
        // Точка A
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text('Точка A', style: Theme.of(context).textTheme.titleSmall),
        ),
        PointFieldWidget(
          field: widget.field.aField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
        ),
        SizedBox(height: widget.spacing),

        // Точка B
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text('Точка B', style: Theme.of(context).textTheme.titleSmall),
        ),
        PointFieldWidget(
          field: widget.field.bField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
        ),
        SizedBox(height: widget.spacing),

        // Точка C
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text('Точка C', style: Theme.of(context).textTheme.titleSmall),
        ),
        PointFieldWidget(
          field: widget.field.cField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
        ),

        if (widget.field.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
