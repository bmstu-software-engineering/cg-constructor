// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vector _$VectorFromJson(Map<String, dynamic> json) {
  return _Vector.fromJson(json);
}

/// @nodoc
mixin _$Vector {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;

  /// Serializes this Vector to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VectorCopyWith<Vector> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VectorCopyWith<$Res> {
  factory $VectorCopyWith(Vector value, $Res Function(Vector) then) =
      _$VectorCopyWithImpl<$Res, Vector>;
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class _$VectorCopyWithImpl<$Res, $Val extends Vector>
    implements $VectorCopyWith<$Res> {
  _$VectorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_value.copyWith(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VectorImplCopyWith<$Res> implements $VectorCopyWith<$Res> {
  factory _$$VectorImplCopyWith(
          _$VectorImpl value, $Res Function(_$VectorImpl) then) =
      __$$VectorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class __$$VectorImplCopyWithImpl<$Res>
    extends _$VectorCopyWithImpl<$Res, _$VectorImpl>
    implements _$$VectorImplCopyWith<$Res> {
  __$$VectorImplCopyWithImpl(
      _$VectorImpl _value, $Res Function(_$VectorImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vector
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_$VectorImpl(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VectorImpl extends _Vector {
  const _$VectorImpl({required this.dx, required this.dy}) : super._();

  factory _$VectorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VectorImplFromJson(json);

  @override
  final double dx;
  @override
  final double dy;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VectorImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dx, dy);

  /// Create a copy of Vector
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VectorImplCopyWith<_$VectorImpl> get copyWith =>
      __$$VectorImplCopyWithImpl<_$VectorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VectorImplToJson(
      this,
    );
  }
}

abstract class _Vector extends Vector {
  const factory _Vector({required final double dx, required final double dy}) =
      _$VectorImpl;
  const _Vector._() : super._();

  factory _Vector.fromJson(Map<String, dynamic> json) = _$VectorImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;

  /// Create a copy of Vector
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VectorImplCopyWith<_$VectorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
