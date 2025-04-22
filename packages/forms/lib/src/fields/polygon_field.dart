import 'package:models_ns/models_ns.dart';

import '../config/polygon_config.dart';

import 'base_form_field.dart';
import 'point_field.dart';

/// Поле формы для ввода многоугольника
class PolygonField extends BaseFormField<Polygon> {
  /// Конфигурация поля
  final PolygonFieldConfig config;

  /// Список полей для ввода точек
  final List<PointField> _pointFields = [];

  /// Создает поле для ввода многоугольника
  ///
  /// [config] - конфигурация поля
  /// [initialValue] - начальное значение поля
  PolygonField({required this.config, Polygon? initialValue})
      : super(
          initialValue: initialValue,
          validator: _createValidator(config),
          isRequired: config.isRequired,
        ) {
    // Инициализируем поля для точек
    if (initialValue != null && initialValue.points.isNotEmpty) {
      for (final point in initialValue.points) {
        _pointFields.add(
          PointField(config: config.pointConfig, initialValue: point),
        );
      }
    } else {
      // Создаем минимальное количество полей
      for (int i = 0; i < config.minPoints; i++) {
        _pointFields.add(PointField(config: config.pointConfig));
      }
    }
  }

  /// Создает валидатор на основе конфигурации
  static String? Function(Polygon?)? _createValidator(
    PolygonFieldConfig config,
  ) {
    return (Polygon? polygon) {
      if (polygon == null) return null;

      if (polygon.points.length < config.minPoints) {
        return 'Многоугольник должен иметь не менее ${config.minPoints} точек';
      }

      if (config.maxPoints != null &&
          polygon.points.length > config.maxPoints!) {
        return 'Многоугольник должен иметь не более ${config.maxPoints} точек';
      }

      if (config.validator != null) {
        return config.validator!(polygon);
      }

      return polygon.validate();
    };
  }

  /// Получает список полей для ввода точек
  List<PointField> get pointFields => _pointFields;

  /// Добавляет новую точку
  void addPoint() {
    if (config.maxPoints != null && _pointFields.length >= config.maxPoints!) {
      return;
    }

    _pointFields.add(PointField(config: config.pointConfig));

    validate();
  }

  /// Удаляет точку по индексу
  void removePoint(int index) {
    if (index < 0 || index >= _pointFields.length) {
      return;
    }

    if (_pointFields.length <= config.minPoints) {
      return;
    }

    _pointFields.removeAt(index);

    validate();
  }

  @override
  Polygon? get value {
    final points = <Point>[];

    for (final field in _pointFields) {
      final point = field.value;
      if (point == null) return null;
      points.add(point);
    }

    if (points.isEmpty) return null;

    return Polygon(
      points: points,
      color: config.defaultColor,
      thickness: config.defaultThickness,
    );
  }

  @override
  set value(Polygon? newValue) {
    _pointFields.clear();

    if (newValue == null || newValue.points.isEmpty) {
      // Создаем минимальное количество полей
      for (int i = 0; i < config.minPoints; i++) {
        _pointFields.add(PointField(config: config.pointConfig));
      }
    } else {
      // Создаем поля для каждой точки
      for (final point in newValue.points) {
        _pointFields.add(
          PointField(config: config.pointConfig, initialValue: point),
        );
      }
    }

    validate();
  }

  @override
  String? validate() {
    // Валидируем каждое поле точки
    for (int i = 0; i < _pointFields.length; i++) {
      final field = _pointFields[i];
      final error = field.validate();
      if (error != null) {
        setError('Ошибка в точке ${i + 1}: $error');
        return error;
      }
    }

    // Затем валидируем многоугольник
    return super.validate();
  }

  @override
  void reset() {
    for (final field in _pointFields) {
      field.reset();
    }

    _pointFields.clear();

    // Создаем минимальное количество полей
    for (int i = 0; i < config.minPoints; i++) {
      _pointFields.add(PointField(config: config.pointConfig));
    }

    super.reset();
  }
}
