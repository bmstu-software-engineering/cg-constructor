import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', widget.spacing));
    properties.add(DiagnosticsProperty('aField', widget.field.aField));
    properties.add(DiagnosticsProperty('bField', widget.field.bField));
    properties.add(DiagnosticsProperty('cField', widget.field.cField));

    if (widget.field.value != null) {
      properties.add(DiagnosticsProperty('a', widget.field.value?.a));
      properties.add(DiagnosticsProperty('b', widget.field.value?.b));
      properties.add(DiagnosticsProperty('c', widget.field.value?.c));
      properties.add(DoubleProperty('sideAB', widget.field.value?.sideAB));
      properties.add(DoubleProperty('sideBC', widget.field.value?.sideBC));
      properties.add(DoubleProperty('sideCA', widget.field.value?.sideCA));
      properties
          .add(DoubleProperty('perimeter', widget.field.value?.perimeter));
      properties.add(DoubleProperty('area', widget.field.value?.area));
      properties.add(DiagnosticsProperty('center', widget.field.value?.center));
      properties.add(DiagnosticsProperty(
          'isEquilateral', widget.field.value?.isEquilateral));
      properties.add(
          DiagnosticsProperty('isIsosceles', widget.field.value?.isIsosceles));
      properties.add(DiagnosticsProperty(
          'isRightAngled', widget.field.value?.isRightAngled));
    }
  }

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
