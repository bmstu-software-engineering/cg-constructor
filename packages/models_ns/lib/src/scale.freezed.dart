// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Scale _$ScaleFromJson(Map<String, dynamic> json) {
  return _Scale.fromJson(json);
}

/// @nodoc
mixin _$Scale {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Serializes this Scale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Scale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScaleCopyWith<Scale> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScaleCopyWith<$Res> {
  factory $ScaleCopyWith(Scale value, $Res Function(Scale) then) =
      _$ScaleCopyWithImpl<$Res, Scale>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$ScaleCopyWithImpl<$Res, $Val extends Scale>
    implements $ScaleCopyWith<$Res> {
  _$ScaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScaleImplCopyWith<$Res> implements $ScaleCopyWith<$Res> {
  factory _$$ScaleImplCopyWith(
          _$ScaleImpl value, $Res Function(_$ScaleImpl) then) =
      __$$ScaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$ScaleImplCopyWithImpl<$Res>
    extends _$ScaleCopyWithImpl<$Res, _$ScaleImpl>
    implements _$$ScaleImplCopyWith<$Res> {
  __$$ScaleImplCopyWithImpl(
      _$ScaleImpl _value, $Res Function(_$ScaleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Scale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$ScaleImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScaleImpl extends _Scale {
  const _$ScaleImpl({required this.x, required this.y}) : super._();

  factory _$ScaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScaleImplFromJson(json);

  @override
  final double x;
  @override
  final double y;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScaleImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of Scale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScaleImplCopyWith<_$ScaleImpl> get copyWith =>
      __$$ScaleImplCopyWithImpl<_$ScaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScaleImplToJson(
      this,
    );
  }
}

abstract class _Scale extends Scale {
  const factory _Scale({required final double x, required final double y}) =
      _$ScaleImpl;
  const _Scale._() : super._();

  factory _Scale.fromJson(Map<String, dynamic> json) = _$ScaleImpl.fromJson;

  @override
  double get x;
  @override
  double get y;

  /// Create a copy of Scale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScaleImplCopyWith<_$ScaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
