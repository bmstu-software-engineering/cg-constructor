// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'angle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Angle _$AngleFromJson(Map<String, dynamic> json) {
  return _Angle.fromJson(json);
}

/// @nodoc
mixin _$Angle {
  double get value => throw _privateConstructorUsedError;

  /// Serializes this Angle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Angle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AngleCopyWith<Angle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AngleCopyWith<$Res> {
  factory $AngleCopyWith(Angle value, $Res Function(Angle) then) =
      _$AngleCopyWithImpl<$Res, Angle>;
  @useResult
  $Res call({double value});
}

/// @nodoc
class _$AngleCopyWithImpl<$Res, $Val extends Angle>
    implements $AngleCopyWith<$Res> {
  _$AngleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Angle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _value.copyWith(
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AngleImplCopyWith<$Res> implements $AngleCopyWith<$Res> {
  factory _$$AngleImplCopyWith(
    _$AngleImpl value,
    $Res Function(_$AngleImpl) then,
  ) = __$$AngleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$$AngleImplCopyWithImpl<$Res>
    extends _$AngleCopyWithImpl<$Res, _$AngleImpl>
    implements _$$AngleImplCopyWith<$Res> {
  __$$AngleImplCopyWithImpl(
    _$AngleImpl _value,
    $Res Function(_$AngleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Angle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _$AngleImpl(
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable()
class _$AngleImpl extends _Angle {
  const _$AngleImpl({required this.value}) : super._();

  factory _$AngleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AngleImplFromJson(json);

  @override
  final double value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AngleImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of Angle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AngleImplCopyWith<_$AngleImpl> get copyWith =>
      __$$AngleImplCopyWithImpl<_$AngleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AngleImplToJson(this);
  }
}

abstract class _Angle extends Angle {
  const factory _Angle({required final double value}) = _$AngleImpl;
  const _Angle._() : super._();

  factory _Angle.fromJson(Map<String, dynamic> json) = _$AngleImpl.fromJson;

  @override
  double get value;

  /// Create a copy of Angle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AngleImplCopyWith<_$AngleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
