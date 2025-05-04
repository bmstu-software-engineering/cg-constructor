// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Circle _$CircleFromJson(Map<String, dynamic> json) {
  return _Circle.fromJson(json);
}

/// @nodoc
mixin _$Circle {
  Point get center => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Circle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Circle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CircleCopyWith<Circle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleCopyWith<$Res> {
  factory $CircleCopyWith(Circle value, $Res Function(Circle) then) =
      _$CircleCopyWithImpl<$Res, Circle>;
  @useResult
  $Res call({Point center, double radius, String color, double thickness});

  $PointCopyWith<$Res> get center;
}

/// @nodoc
class _$CircleCopyWithImpl<$Res, $Val extends Circle>
    implements $CircleCopyWith<$Res> {
  _$CircleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Circle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? radius = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_value.copyWith(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Circle
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
abstract class _$$CircleImplCopyWith<$Res> implements $CircleCopyWith<$Res> {
  factory _$$CircleImplCopyWith(
          _$CircleImpl value, $Res Function(_$CircleImpl) then) =
      __$$CircleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Point center, double radius, String color, double thickness});

  @override
  $PointCopyWith<$Res> get center;
}

/// @nodoc
class __$$CircleImplCopyWithImpl<$Res>
    extends _$CircleCopyWithImpl<$Res, _$CircleImpl>
    implements _$$CircleImplCopyWith<$Res> {
  __$$CircleImplCopyWithImpl(
      _$CircleImpl _value, $Res Function(_$CircleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Circle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? radius = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_$CircleImpl(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
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
class _$CircleImpl extends _Circle {
  const _$CircleImpl(
      {required this.center,
      required this.radius,
      this.color = '#000000',
      this.thickness = 1.0})
      : super._();

  factory _$CircleImpl.fromJson(Map<String, dynamic> json) =>
      _$$CircleImplFromJson(json);

  @override
  final Point center;
  @override
  final double radius;
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
            other is _$CircleImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, center, radius, color, thickness);

  /// Create a copy of Circle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleImplCopyWith<_$CircleImpl> get copyWith =>
      __$$CircleImplCopyWithImpl<_$CircleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CircleImplToJson(
      this,
    );
  }
}

abstract class _Circle extends Circle {
  const factory _Circle(
      {required final Point center,
      required final double radius,
      final String color,
      final double thickness}) = _$CircleImpl;
  const _Circle._() : super._();

  factory _Circle.fromJson(Map<String, dynamic> json) = _$CircleImpl.fromJson;

  @override
  Point get center;
  @override
  double get radius;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Circle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CircleImplCopyWith<_$CircleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
