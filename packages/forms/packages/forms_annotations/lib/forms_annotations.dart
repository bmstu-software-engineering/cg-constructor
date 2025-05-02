/// Библиотека аннотаций для генерации типизированных форм
library forms_annotations;

/// Аннотация для генерации типизированной формы
class FormGenAnnotation {
  /// Название формы
  final String? name;

  /// Создает аннотацию для генерации формы
  ///
  /// [name] - название формы (если не указано, будет использовано имя класса)
  const FormGenAnnotation({this.name});
}

/// Базовая аннотация для всех полей формы
class FieldGenAnnotation {
  /// Метка поля
  final String? label;

  /// Подсказка для поля
  final String? hint;

  /// Является ли поле обязательным
  final bool isRequired;

  /// Создает базовую аннотацию для поля формы
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  const FieldGenAnnotation({this.label, this.hint, this.isRequired = true});
}

/// Аннотация для числового поля
class NumberFieldAnnotation extends FieldGenAnnotation {
  /// Минимальное значение
  final double? min;

  /// Максимальное значение
  final double? max;

  /// Создает аннотацию для числового поля
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [min] - минимальное значение
  /// [max] - максимальное значение
  const NumberFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.min,
    this.max,
  });
}

/// Аннотация для поля точки
class PointFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для поля X
  final NumberFieldAnnotation? xConfig;

  /// Конфигурация для поля Y
  final NumberFieldAnnotation? yConfig;

  /// Можно ли задать цвет для точки
  final bool canSetColor;

  /// Цвет точки по умолчанию
  final String defaultColor;

  /// Создает аннотацию для поля точки
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [xConfig] - конфигурация для поля X
  /// [yConfig] - конфигурация для поля Y
  /// [canSetColor] - можно ли задать цвет для точки
  /// [defaultColor] - цвет точки по умолчанию
  const PointFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.xConfig,
    this.yConfig,
    this.canSetColor = false,
    this.defaultColor = '#000000',
  });
}

/// Аннотация для поля угла
class AngleFieldAnnotation extends FieldGenAnnotation {
  /// Минимальное значение угла
  final double? min;

  /// Максимальное значение угла
  final double? max;

  /// Нормализовать ли угол в диапазон [0, 360)
  final bool normalize;

  /// Создает аннотацию для поля угла
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [min] - минимальное значение угла
  /// [max] - максимальное значение угла
  /// [normalize] - нормализовать ли угол в диапазон [0, 360)
  const AngleFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.min,
    this.max,
    this.normalize = false,
  });
}

/// Аннотация для поля вектора
class VectorFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для поля dX
  final NumberFieldAnnotation? dxConfig;

  /// Конфигурация для поля dY
  final NumberFieldAnnotation? dyConfig;

  /// Создает аннотацию для поля вектора
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [dxConfig] - конфигурация для поля dX
  /// [dyConfig] - конфигурация для поля dY
  const VectorFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.dxConfig,
    this.dyConfig,
  });
}

/// Аннотация для поля масштаба
class ScaleFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для поля X
  final NumberFieldAnnotation? xConfig;

  /// Конфигурация для поля Y
  final NumberFieldAnnotation? yConfig;

  /// Использовать ли одинаковый масштаб по X и Y
  final bool uniform;

  /// Создает аннотацию для поля масштаба
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [xConfig] - конфигурация для поля X
  /// [yConfig] - конфигурация для поля Y
  /// [uniform] - использовать ли одинаковый масштаб по X и Y
  const ScaleFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.xConfig,
    this.yConfig,
    this.uniform = false,
  });
}

/// Аннотация для поля многоугольника
class PolygonFieldAnnotation extends FieldGenAnnotation {
  /// Минимальное количество точек
  final int? minPoints;

  /// Максимальное количество точек
  final int? maxPoints;

  /// Конфигурация для полей точек
  final PointFieldAnnotation? pointConfig;

  /// Создает аннотацию для поля многоугольника
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [minPoints] - минимальное количество точек
  /// [maxPoints] - максимальное количество точек
  /// [pointConfig] - конфигурация для полей точек
  const PolygonFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.minPoints,
    this.maxPoints,
    this.pointConfig,
  });
}

/// Аннотация для поля треугольника
class TriangleFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для точки A
  final PointFieldAnnotation? aConfig;

  /// Конфигурация для точки B
  final PointFieldAnnotation? bConfig;

  /// Конфигурация для точки C
  final PointFieldAnnotation? cConfig;

  /// Создает аннотацию для поля треугольника
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [aConfig] - конфигурация для точки A
  /// [bConfig] - конфигурация для точки B
  /// [cConfig] - конфигурация для точки C
  const TriangleFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.aConfig,
    this.bConfig,
    this.cConfig,
  });
}

/// Аннотация для поля прямоугольника
class RectangleFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для точки верхнего левого угла
  final PointFieldAnnotation? topLeftConfig;

  /// Конфигурация для точки нижнего правого угла
  final PointFieldAnnotation? bottomRightConfig;

  /// Создает аннотацию для поля прямоугольника
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [topLeftConfig] - конфигурация для точки верхнего левого угла
  /// [bottomRightConfig] - конфигурация для точки нижнего правого угла
  const RectangleFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.topLeftConfig,
    this.bottomRightConfig,
  });
}

/// Аннотация для поля линии
class LineFieldAnnotation extends FieldGenAnnotation {
  /// Конфигурация для точки A
  final PointFieldAnnotation? aConfig;

  /// Конфигурация для точки B
  final PointFieldAnnotation? bConfig;

  /// Можно ли задать цвет для линии
  final bool canSetColor;

  /// Цвет линии по умолчанию
  final String defaultColor;

  /// Можно ли задать толщину линии
  final bool canSetThickness;

  /// Толщина линии по умолчанию
  final double defaultThickness;

  /// Создает аннотацию для поля линии
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [aConfig] - конфигурация для точки A
  /// [bConfig] - конфигурация для точки B
  /// [canSetColor] - можно ли задать цвет для линии
  /// [defaultColor] - цвет линии по умолчанию
  /// [canSetThickness] - можно ли задать толщину линии
  /// [defaultThickness] - толщина линии по умолчанию
  const LineFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.aConfig,
    this.bConfig,
    this.canSetColor = false,
    this.defaultColor = '#000000',
    this.canSetThickness = false,
    this.defaultThickness = 1.0,
  });
}

/// Аннотация для поля списка
class ListFieldAnnotation extends FieldGenAnnotation {
  /// Минимальное количество элементов
  final int? minItems;

  /// Максимальное количество элементов
  final int? maxItems;

  /// Конфигурация для элементов списка
  final FieldGenAnnotation? itemConfig;

  /// Создает аннотацию для поля списка
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [minItems] - минимальное количество элементов
  /// [maxItems] - максимальное количество элементов
  /// [itemConfig] - конфигурация для элементов списка
  const ListFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.minItems,
    this.maxItems,
    this.itemConfig,
  });
}

/// Аннотация для поля выбора из списка значений
class EnumSelectFieldAnnotation extends FieldGenAnnotation {
  /// Список возможных значений
  final List<dynamic>? values;

  /// Функция для получения названия значения
  final String Function(dynamic)? titleBuilder;

  /// Создает аннотацию для поля выбора из списка значений
  ///
  /// [label] - метка поля
  /// [hint] - подсказка для поля
  /// [isRequired] - является ли поле обязательным
  /// [values] - список возможных значений (если не указан, будет использован enum.values)
  /// [titleBuilder] - функция для получения названия значения
  const EnumSelectFieldAnnotation({
    super.label,
    super.hint,
    super.isRequired,
    this.values,
    this.titleBuilder,
  });
}

// Алиасы для обратной совместимости
typedef FormGen = FormGenAnnotation;
typedef FieldGen = FieldGenAnnotation;
typedef NumberFieldGen = NumberFieldAnnotation;
typedef PointFieldGen = PointFieldAnnotation;
typedef AngleFieldGen = AngleFieldAnnotation;
typedef VectorFieldGen = VectorFieldAnnotation;
typedef ScaleFieldGen = ScaleFieldAnnotation;
typedef PolygonFieldGen = PolygonFieldAnnotation;
typedef TriangleFieldGen = TriangleFieldAnnotation;
typedef RectangleFieldGen = RectangleFieldAnnotation;
typedef LineFieldGen = LineFieldAnnotation;
typedef ListFieldGen = ListFieldAnnotation;
typedef EnumSelectFieldGen = EnumSelectFieldAnnotation;
