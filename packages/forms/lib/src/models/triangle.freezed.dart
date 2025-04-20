// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'triangle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Triangle _$TriangleFromJson(Map<String, dynamic> json) {
  return _Triangle.fromJson(json);
}

/// @nodoc
mixin _$Triangle {
  Point get a => throw _privateConstructorUsedError;
  Point get b => throw _privateConstructorUsedError;
  Point get c => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Triangle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TriangleCopyWith<Triangle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriangleCopyWith<$Res> {
  factory $TriangleCopyWith(Triangle value, $Res Function(Triangle) then) =
      _$TriangleCopyWithImpl<$Res, Triangle>;
  @useResult
  $Res call({Point a, Point b, Point c, String color, double thickness});

  $PointCopyWith<$Res> get a;
  $PointCopyWith<$Res> get b;
  $PointCopyWith<$Res> get c;
}

/// @nodoc
class _$TriangleCopyWithImpl<$Res, $Val extends Triangle>
    implements $TriangleCopyWith<$Res> {
  _$TriangleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? c = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(
      _value.copyWith(
            a:
                null == a
                    ? _value.a
                    : a // ignore: cast_nullable_to_non_nullable
                        as Point,
            b:
                null == b
                    ? _value.b
                    : b // ignore: cast_nullable_to_non_nullable
                        as Point,
            c:
                null == c
                    ? _value.c
                    : c // ignore: cast_nullable_to_non_nullable
                        as Point,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String,
            thickness:
                null == thickness
                    ? _value.thickness
                    : thickness // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get a {
    return $PointCopyWith<$Res>(_value.a, (value) {
      return _then(_value.copyWith(a: value) as $Val);
    });
  }

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get b {
    return $PointCopyWith<$Res>(_value.b, (value) {
      return _then(_value.copyWith(b: value) as $Val);
    });
  }

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get c {
    return $PointCopyWith<$Res>(_value.c, (value) {
      return _then(_value.copyWith(c: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TriangleImplCopyWith<$Res>
    implements $TriangleCopyWith<$Res> {
  factory _$$TriangleImplCopyWith(
    _$TriangleImpl value,
    $Res Function(_$TriangleImpl) then,
  ) = __$$TriangleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Point a, Point b, Point c, String color, double thickness});

  @override
  $PointCopyWith<$Res> get a;
  @override
  $PointCopyWith<$Res> get b;
  @override
  $PointCopyWith<$Res> get c;
}

/// @nodoc
class __$$TriangleImplCopyWithImpl<$Res>
    extends _$TriangleCopyWithImpl<$Res, _$TriangleImpl>
    implements _$$TriangleImplCopyWith<$Res> {
  __$$TriangleImplCopyWithImpl(
    _$TriangleImpl _value,
    $Res Function(_$TriangleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? c = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(
      _$TriangleImpl(
        a:
            null == a
                ? _value.a
                : a // ignore: cast_nullable_to_non_nullable
                    as Point,
        b:
            null == b
                ? _value.b
                : b // ignore: cast_nullable_to_non_nullable
                    as Point,
        c:
            null == c
                ? _value.c
                : c // ignore: cast_nullable_to_non_nullable
                    as Point,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String,
        thickness:
            null == thickness
                ? _value.thickness
                : thickness // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable()
class _$TriangleImpl extends _Triangle {
  const _$TriangleImpl({
    required this.a,
    required this.b,
    required this.c,
    this.color = '#000000',
    this.thickness = 1.0,
  }) : super._();

  factory _$TriangleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriangleImplFromJson(json);

  @override
  final Point a;
  @override
  final Point b;
  @override
  final Point c;
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
            other is _$TriangleImpl &&
            (identical(other.a, a) || other.a == a) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.c, c) || other.c == c) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, a, b, c, color, thickness);

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TriangleImplCopyWith<_$TriangleImpl> get copyWith =>
      __$$TriangleImplCopyWithImpl<_$TriangleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriangleImplToJson(this);
  }
}

abstract class _Triangle extends Triangle {
  const factory _Triangle({
    required final Point a,
    required final Point b,
    required final Point c,
    final String color,
    final double thickness,
  }) = _$TriangleImpl;
  const _Triangle._() : super._();

  factory _Triangle.fromJson(Map<String, dynamic> json) =
      _$TriangleImpl.fromJson;

  @override
  Point get a;
  @override
  Point get b;
  @override
  Point get c;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Triangle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TriangleImplCopyWith<_$TriangleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
