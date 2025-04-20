import 'package:flutter/material.dart';
import '../src/fields/rectangle_field.dart';
import '../src/models/rectangle.dart';
import 'form_field_widget.dart';
import 'point_field_widget.dart';

/// Виджет для поля прямоугольника
class RectangleFieldWidget extends FormFieldWidget<Rectangle, RectangleField> {
  /// Создает виджет поля прямоугольника
  ///
  /// [field] - поле прямоугольника
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями точек
  const RectangleFieldWidget({
    super.key,
    required RectangleField field,
    ValueChanged<Rectangle?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 16.0,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями точек
  final double spacing;

  @override
  State<RectangleFieldWidget> createState() => _RectangleFieldWidgetState();
}

class _RectangleFieldWidgetState
    extends
        FormFieldWidgetState<Rectangle, RectangleField, RectangleFieldWidget> {
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

        // Верхняя левая точка
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Верхняя левая точка',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        PointFieldWidget(
          field: widget.field.topLeftField,
          onChanged: (_) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(widget.field.value);
            }
          },
        ),
        SizedBox(height: widget.spacing),

        // Если используется конструктор fromCorners
        if (widget.field.useCorners &&
            widget.field.bottomRightField != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Нижняя правая точка',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          PointFieldWidget(
            field: widget.field.bottomRightField!,
            onChanged: (_) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(widget.field.value);
              }
            },
          ),
        ]
        // Если используется конструктор с четырьмя точками
        else ...[
          if (widget.field.topRightField != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Верхняя правая точка',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            PointFieldWidget(
              field: widget.field.topRightField!,
              onChanged: (_) {
                setState(() {});
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.field.value);
                }
              },
            ),
            SizedBox(height: widget.spacing),
          ],

          if (widget.field.bottomLeftField != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Нижняя левая точка',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            PointFieldWidget(
              field: widget.field.bottomLeftField!,
              onChanged: (_) {
                setState(() {});
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.field.value);
                }
              },
            ),
            SizedBox(height: widget.spacing),
          ],

          if (widget.field.bottomRightField != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Нижняя правая точка',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            PointFieldWidget(
              field: widget.field.bottomRightField!,
              onChanged: (_) {
                setState(() {});
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.field.value);
                }
              },
            ),
          ],
        ],

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
