// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Arc _$ArcFromJson(Map<String, dynamic> json) {
  return _Arc.fromJson(json);
}

/// @nodoc
mixin _$Arc {
  Point get center => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  double get startAngle => throw _privateConstructorUsedError;
  double get endAngle => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Arc to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Arc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArcCopyWith<Arc> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArcCopyWith<$Res> {
  factory $ArcCopyWith(Arc value, $Res Function(Arc) then) =
      _$ArcCopyWithImpl<$Res, Arc>;
  @useResult
  $Res call(
      {Point center,
      double radius,
      double startAngle,
      double endAngle,
      String color,
      double thickness});

  $PointCopyWith<$Res> get center;
}

/// @nodoc
class _$ArcCopyWithImpl<$Res, $Val extends Arc> implements $ArcCopyWith<$Res> {
  _$ArcCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Arc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? radius = null,
    Object? startAngle = null,
    Object? endAngle = null,
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
      startAngle: null == startAngle
          ? _value.startAngle
          : startAngle // ignore: cast_nullable_to_non_nullable
              as double,
      endAngle: null == endAngle
          ? _value.endAngle
          : endAngle // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Arc
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
abstract class _$$ArcImplCopyWith<$Res> implements $ArcCopyWith<$Res> {
  factory _$$ArcImplCopyWith(_$ArcImpl value, $Res Function(_$ArcImpl) then) =
      __$$ArcImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Point center,
      double radius,
      double startAngle,
      double endAngle,
      String color,
      double thickness});

  @override
  $PointCopyWith<$Res> get center;
}

/// @nodoc
class __$$ArcImplCopyWithImpl<$Res> extends _$ArcCopyWithImpl<$Res, _$ArcImpl>
    implements _$$ArcImplCopyWith<$Res> {
  __$$ArcImplCopyWithImpl(_$ArcImpl _value, $Res Function(_$ArcImpl) _then)
      : super(_value, _then);

  /// Create a copy of Arc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? radius = null,
    Object? startAngle = null,
    Object? endAngle = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_$ArcImpl(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      startAngle: null == startAngle
          ? _value.startAngle
          : startAngle // ignore: cast_nullable_to_non_nullable
              as double,
      endAngle: null == endAngle
          ? _value.endAngle
          : endAngle // ignore: cast_nullable_to_non_nullable
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
class _$ArcImpl extends _Arc {
  const _$ArcImpl(
      {required this.center,
      required this.radius,
      required this.startAngle,
      required this.endAngle,
      this.color = '#000000',
      this.thickness = 1.0})
      : super._();

  factory _$ArcImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArcImplFromJson(json);

  @override
  final Point center;
  @override
  final double radius;
  @override
  final double startAngle;
  @override
  final double endAngle;
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
            other is _$ArcImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.startAngle, startAngle) ||
                other.startAngle == startAngle) &&
            (identical(other.endAngle, endAngle) ||
                other.endAngle == endAngle) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, center, radius, startAngle, endAngle, color, thickness);

  /// Create a copy of Arc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArcImplCopyWith<_$ArcImpl> get copyWith =>
      __$$ArcImplCopyWithImpl<_$ArcImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArcImplToJson(
      this,
    );
  }
}

abstract class _Arc extends Arc {
  const factory _Arc(
      {required final Point center,
      required final double radius,
      required final double startAngle,
      required final double endAngle,
      final String color,
      final double thickness}) = _$ArcImpl;
  const _Arc._() : super._();

  factory _Arc.fromJson(Map<String, dynamic> json) = _$ArcImpl.fromJson;

  @override
  Point get center;
  @override
  double get radius;
  @override
  double get startAngle;
  @override
  double get endAngle;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Arc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArcImplCopyWith<_$ArcImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
