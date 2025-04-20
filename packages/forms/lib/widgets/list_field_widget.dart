import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../src/core/form_field.dart' as forms;
import '../src/fields/list_field.dart';
import 'form_field_widget.dart';

/// Виджет для поля списка
class ListFieldWidget<T, F extends forms.FormField<T>>
    extends FormFieldWidget<List<T>, ListField<T, F>> {
  /// Создает виджет поля списка
  ///
  /// [field] - поле списка
  /// [onChanged] - обработчик изменения значения
  /// [decoration] - декорация поля ввода
  /// [spacing] - расстояние между полями
  /// [itemBuilder] - построитель виджета для элемента списка
  /// [addButtonLabel] - текст кнопки добавления элемента
  /// [removeButtonTooltip] - подсказка кнопки удаления элемента
  /// [itemLabelBuilder] - построитель метки для элемента списка
  const ListFieldWidget({
    super.key,
    required ListField<T, F> field,
    ValueChanged<List<T>?>? onChanged,
    InputDecoration? decoration,
    this.spacing = 16.0,
    required this.itemBuilder,
    this.addButtonLabel = 'Добавить элемент',
    this.removeButtonTooltip = 'Удалить элемент',
    this.itemLabelBuilder,
  }) : super(field: field, onChanged: onChanged, decoration: decoration);

  /// Расстояние между полями
  final double spacing;

  /// Построитель виджета для элемента списка
  final Widget Function(
    BuildContext context,
    F field,
    ValueChanged<T?> onChanged,
  ) itemBuilder;

  /// Текст кнопки добавления элемента
  final String addButtonLabel;

  /// Подсказка кнопки удаления элемента
  final String removeButtonTooltip;

  /// Построитель метки для элемента списка
  final String Function(int index)? itemLabelBuilder;

  @override
  State<ListFieldWidget<T, F>> createState() => _ListFieldWidgetState<T, F>();
}

class _ListFieldWidgetState<T, F extends forms.FormField<T>>
    extends FormFieldWidgetState<List<T>, ListField<T, F>,
        ListFieldWidget<T, F>> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spacing', widget.spacing));
    properties.add(StringProperty('addButtonLabel', widget.addButtonLabel));
    properties
        .add(StringProperty('removeButtonTooltip', widget.removeButtonTooltip));
    properties.add(IntProperty('fieldsCount', widget.field.fields.length));
    properties.add(IntProperty('minItems', widget.field.config.minItems));
    properties.add(IntProperty('maxItems', widget.field.config.maxItems ?? -1));
    properties.add(FlagProperty('hasItemLabelBuilder',
        value: widget.itemLabelBuilder != null,
        ifTrue: 'custom item labels',
        ifFalse: 'default item labels'));

    if (widget.field.value != null) {
      properties
          .add(IntProperty('valueCount', widget.field.value?.length ?? 0));
      properties.add(IterableProperty<T>('value', widget.field.value));
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

        // Список элементов
        ...List.generate(widget.field.fields.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        widget.itemLabelBuilder?.call(index) ??
                            'Элемент ${index + 1}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  // Кнопка удаления элемента
                  if (widget.field.fields.length > widget.field.config.minItems)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: widget.removeButtonTooltip,
                      onPressed: () {
                        setState(() {
                          widget.field.removeField(index);
                          if (widget.onChanged != null) {
                            widget.onChanged!(widget.field.value);
                          }
                        });
                      },
                    ),
                ],
              ),
              widget.itemBuilder(context, widget.field.fields[index], (value) {
                setState(() {
                  print('validate');
                  widget.field.validate();
                });

                if (widget.onChanged != null) {
                  widget.onChanged!(widget.field.value);
                }
              }),
              if (index < widget.field.fields.length - 1)
                SizedBox(height: widget.spacing),
            ],
          );
        }),

        // Кнопка добавления элемента
        if (widget.field.config.maxItems == null ||
            widget.field.fields.length < widget.field.config.maxItems!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(widget.addButtonLabel),
              onPressed: () {
                setState(() {
                  widget.field.addField();
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.field.value);
                  }
                });
              },
            ),
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
