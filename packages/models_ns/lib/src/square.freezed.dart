// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'square.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Square _$SquareFromJson(Map<String, dynamic> json) {
  return _Square.fromJson(json);
}

/// @nodoc
mixin _$Square {
  Point get center => throw _privateConstructorUsedError;
  double get sideLength => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Square to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Square
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SquareCopyWith<Square> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquareCopyWith<$Res> {
  factory $SquareCopyWith(Square value, $Res Function(Square) then) =
      _$SquareCopyWithImpl<$Res, Square>;
  @useResult
  $Res call({Point center, double sideLength, String color, double thickness});

  $PointCopyWith<$Res> get center;
}

/// @nodoc
class _$SquareCopyWithImpl<$Res, $Val extends Square>
    implements $SquareCopyWith<$Res> {
  _$SquareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Square
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? sideLength = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_value.copyWith(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      sideLength: null == sideLength
          ? _value.sideLength
          : sideLength // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Square
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
abstract class _$$SquareImplCopyWith<$Res> implements $SquareCopyWith<$Res> {
  factory _$$SquareImplCopyWith(
          _$SquareImpl value, $Res Function(_$SquareImpl) then) =
      __$$SquareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Point center, double sideLength, String color, double thickness});

  @override
  $PointCopyWith<$Res> get center;
}

/// @nodoc
class __$$SquareImplCopyWithImpl<$Res>
    extends _$SquareCopyWithImpl<$Res, _$SquareImpl>
    implements _$$SquareImplCopyWith<$Res> {
  __$$SquareImplCopyWithImpl(
      _$SquareImpl _value, $Res Function(_$SquareImpl) _then)
      : super(_value, _then);

  /// Create a copy of Square
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = null,
    Object? sideLength = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_$SquareImpl(
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as Point,
      sideLength: null == sideLength
          ? _value.sideLength
          : sideLength // ignore: cast_nullable_to_non_nullable
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
class _$SquareImpl extends _Square {
  const _$SquareImpl(
      {required this.center,
      required this.sideLength,
      this.color = '#000000',
      this.thickness = 1.0})
      : super._();

  factory _$SquareImpl.fromJson(Map<String, dynamic> json) =>
      _$$SquareImplFromJson(json);

  @override
  final Point center;
  @override
  final double sideLength;
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
            other is _$SquareImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.sideLength, sideLength) ||
                other.sideLength == sideLength) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, center, sideLength, color, thickness);

  /// Create a copy of Square
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SquareImplCopyWith<_$SquareImpl> get copyWith =>
      __$$SquareImplCopyWithImpl<_$SquareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SquareImplToJson(
      this,
    );
  }
}

abstract class _Square extends Square {
  const factory _Square(
      {required final Point center,
      required final double sideLength,
      final String color,
      final double thickness}) = _$SquareImpl;
  const _Square._() : super._();

  factory _Square.fromJson(Map<String, dynamic> json) = _$SquareImpl.fromJson;

  @override
  Point get center;
  @override
  double get sideLength;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Square
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SquareImplCopyWith<_$SquareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
