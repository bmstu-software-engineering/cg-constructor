// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ellipse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ellipse _$EllipseFromJson(Map<String, dynamic> json) {
  return _Ellipse.fromJson(json);
}

/// @nodoc
mixin _$Ellipse {
  Point get center => throw _privateConstructorUsedError;
  double get semiMajorAxis => throw _privateConstructorUsedError;
  double get semiMinorAxis => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Ellipse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EllipseCopyWith<Ellipse> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EllipseCopyWith<$Res> {
  factory $EllipseCopyWith(Ellipse value, $Res Function(Ellipse) then) =
      _$EllipseCopyWithImpl<$Res, Ellipse>;
  @useResult
  $Res call(
      {Point center,
      double semiMajorAxis,
      double semiMinorAxis,
      String color,
      double thickness});

  $PointCopyWith<$Res> get center;
}

/// @nodoc
class _$EllipseCopyWithImpl<$Res, $Val extends Ellipse>
    implements $EllipseCopyWith<$Res> {
  _$EllipseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? semiMajorAxis = null,
    Object? semiMinorAxis = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_value.copyWith(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      semiMajorAxis: null == semiMajorAxis
          ? _value.semiMajorAxis
          : semiMajorAxis // ignore: cast_nullable_to_non_nullable
              as double,
      semiMinorAxis: null == semiMinorAxis
          ? _value.semiMinorAxis
          : semiMinorAxis // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      thickness: null == thickness
          ? _value.thickness
          : thickness // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get center {
    return $PointCopyWith<$Res>(_value.center, (value) {
      return _then(_value.copyWith(center: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EllipseImplCopyWith<$Res> implements $EllipseCopyWith<$Res> {
  factory _$$EllipseImplCopyWith(
          _$EllipseImpl value, $Res Function(_$EllipseImpl) then) =
      __$$EllipseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Point center,
      double semiMajorAxis,
      double semiMinorAxis,
      String color,
      double thickness});

  @override
  $PointCopyWith<$Res> get center;
}

/// @nodoc
class __$$EllipseImplCopyWithImpl<$Res>
    extends _$EllipseCopyWithImpl<$Res, _$EllipseImpl>
    implements _$$EllipseImplCopyWith<$Res> {
  __$$EllipseImplCopyWithImpl(
      _$EllipseImpl _value, $Res Function(_$EllipseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? semiMajorAxis = null,
    Object? semiMinorAxis = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_$EllipseImpl(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      semiMajorAxis: null == semiMajorAxis
          ? _value.semiMajorAxis
          : semiMajorAxis // ignore: cast_nullable_to_non_nullable
              as double,
      semiMinorAxis: null == semiMinorAxis
          ? _value.semiMinorAxis
          : semiMinorAxis // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      thickness: null == thickness
          ? _value.thickness
          : thickness // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EllipseImpl extends _Ellipse {
  const _$EllipseImpl(
      {required this.center,
      required this.semiMajorAxis,
      required this.semiMinorAxis,
      this.color = '#000000',
      this.thickness = 1.0})
      : super._();

  factory _$EllipseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EllipseImplFromJson(json);

  @override
  final Point center;
  @override
  final double semiMajorAxis;
  @override
  final double semiMinorAxis;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final double thickness;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EllipseImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.semiMajorAxis, semiMajorAxis) ||
                other.semiMajorAxis == semiMajorAxis) &&
            (identical(other.semiMinorAxis, semiMinorAxis) ||
                other.semiMinorAxis == semiMinorAxis) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, center, semiMajorAxis, semiMinorAxis, color, thickness);

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EllipseImplCopyWith<_$EllipseImpl> get copyWith =>
      __$$EllipseImplCopyWithImpl<_$EllipseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EllipseImplToJson(
      this,
    );
  }
}

abstract class _Ellipse extends Ellipse {
  const factory _Ellipse(
      {required final Point center,
      required final double semiMajorAxis,
      required final double semiMinorAxis,
      final String color,
      final double thickness}) = _$EllipseImpl;
  const _Ellipse._() : super._();

  factory _Ellipse.fromJson(Map<String, dynamic> json) = _$EllipseImpl.fromJson;

  @override
  Point get center;
  @override
  double get semiMajorAxis;
  @override
  double get semiMinorAxis;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Ellipse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EllipseImplCopyWith<_$EllipseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
