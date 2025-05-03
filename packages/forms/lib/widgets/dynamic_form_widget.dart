import 'package:flutter/material.dart' hide FormField;
import 'package:forms/forms.dart';

/// Виджет для отображения динамической формы
class DynamicFormWidget extends StatefulWidget {
  /// Модель формы
  final DynamicFormModel model;

  /// Обработчик отправки формы
  final void Function(Map<String, dynamic>)? onSubmit;

  /// Текст кнопки отправки
  final String submitButtonText;

  /// Отступы между полями
  final double fieldSpacing;

  /// Создает виджет динамической формы
  ///
  /// [model] - модель формы
  /// [onSubmit] - обработчик отправки формы
  /// [submitButtonText] - текст кнопки отправки
  /// [fieldSpacing] - отступы между полями
  const DynamicFormWidget({
    super.key,
    required this.model,
    this.onSubmit,
    this.submitButtonText = 'Отправить',
    this.fieldSpacing = 16.0,
  });

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок формы
        Text(
          widget.model.config.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: widget.fieldSpacing),

        // Поля формы
        ...widget.model.config.fields.map((fieldEntry) {
          final widget = _buildFieldWidget(fieldEntry);
          return Padding(
            padding: EdgeInsets.only(bottom: this.widget.fieldSpacing),
            child: widget,
          );
        }),

        // Кнопка отправки
        if (widget.onSubmit != null)
          ElevatedButton(
            onPressed: () {
              if (widget.model.isValid()) {
                final values = widget.model.getValues();
                widget.onSubmit?.call(values);
              } else {
                widget.model.validate();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пожалуйста, исправьте ошибки в форме'),
                  ),
                );
              }
            },
            child: Text(widget.submitButtonText),
          ),
      ],
    );
  }

  /// Создает виджет для поля формы
  Widget _buildFieldWidget(FieldConfigEntry entry) {
    final field = widget.model.getField(entry.id);
    if (field == null) return const SizedBox();

    switch (entry.type) {
      case FieldType.number:
        return NumberFieldWidget(
          field: field as NumberField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.string:
        return StringFieldWidget(
          field: field as StringField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.point:
        return PointFieldWidget(
          field: field as PointField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.angle:
        return AngleFieldWidget(
          field: field as AngleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.vector:
        return VectorFieldWidget(
          field: field as VectorField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.scale:
        return ScaleFieldWidget(
          field: field as ScaleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.polygon:
        return PolygonFieldWidget(
          field: field as PolygonField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.triangle:
        return TriangleFieldWidget(
          field: field as TriangleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.rectangle:
        return RectangleFieldWidget(
          field: field as RectangleField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.list:
        return ListFieldWidget(
          field: field as ListField,
          onChanged: (_) => setState(() {}),
          itemBuilder: (context, itemField, onChanged) =>
              itemField.buildWidget((value) {
            setState(() {});
            onChanged(value);
          }),
        );
      case FieldType.line:
        return LineFieldWidget(
          field: field as LineField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.enumSelect:
        return EnumSelectFieldWidget(
          field: field as EnumSelectField,
          onChanged: (_) => setState(() {}),
        );
      case FieldType.form:
        return NestedFormFieldWidget(
          field: field as NestedFormField,
          onChanged: (_) => setState(() {}),
        );
    }
  }
}

extension on FormField {
  Widget buildWidget(void Function(dynamic value) onChanged) {
    switch (this) {
      case PointField field:
        return PointFieldWidget(
          field: field,
          onChanged: (value) => onChanged(value),
        );
      case LineField field:
        return LineFieldWidget(
          field: field,
          onChanged: (value) => onChanged(value),
        );
      case VectorField field:
        return VectorFieldWidget(
          field: field,
          onChanged: (value) => onChanged(value),
        );
      case EnumSelectField field:
        return EnumSelectFieldWidget(
          field: field,
          onChanged: (value) => onChanged(value),
        );
    }

    throw UnimplementedError();
  }
}
