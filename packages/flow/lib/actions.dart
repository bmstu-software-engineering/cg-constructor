import 'package:flutter/material.dart';
import 'flow.dart';

/// Класс, представляющий действие для FlowBuilder
class FlowAction {
  /// Текст, отображаемый на кнопке
  final String label;

  /// Иконка для кнопки (опционально)
  final IconData? icon;

  /// Цвет кнопки (опционально)
  final Color? color;

  /// Функция, выполняемая при нажатии на кнопку
  final Future<void> Function(FlowBuilder) action;

  const FlowAction({
    required this.label,
    required this.action,
    this.icon,
    this.color,
  });
}
