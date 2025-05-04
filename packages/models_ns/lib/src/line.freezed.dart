// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Line _$LineFromJson(Map<String, dynamic> json) {
  return _Line.fromJson(json);
}

/// @nodoc
mixin _$Line {
  Point get a => throw _privateConstructorUsedError;
  Point get b => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Line to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineCopyWith<Line> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineCopyWith<$Res> {
  factory $LineCopyWith(Line value, $Res Function(Line) then) =
      _$LineCopyWithImpl<$Res, Line>;
  @useResult
  $Res call({Point a, Point b, String color, double thickness});

  $PointCopyWith<$Res> get a;
  $PointCopyWith<$Res> get b;
}

/// @nodoc
class _$LineCopyWithImpl<$Res, $Val extends Line>
    implements $LineCopyWith<$Res> {
  _$LineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_value.copyWith(
      a: null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as Point,
      b: null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as Point,
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

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get a {
    return $PointCopyWith<$Res>(_value.a, (value) {
      return _then(_value.copyWith(a: value) as $Val);
    });
  }

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res> get b {
    return $PointCopyWith<$Res>(_value.b, (value) {
      return _then(_value.copyWith(b: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LineImplCopyWith<$Res> implements $LineCopyWith<$Res> {
  factory _$$LineImplCopyWith(
          _$LineImpl value, $Res Function(_$LineImpl) then) =
      __$$LineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Point a, Point b, String color, double thickness});

  @override
  $PointCopyWith<$Res> get a;
  @override
  $PointCopyWith<$Res> get b;
}

/// @nodoc
class __$$LineImplCopyWithImpl<$Res>
    extends _$LineCopyWithImpl<$Res, _$LineImpl>
    implements _$$LineImplCopyWith<$Res> {
  __$$LineImplCopyWithImpl(_$LineImpl _value, $Res Function(_$LineImpl) _then)
      : super(_value, _then);

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? a = null,
    Object? b = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(_$LineImpl(
      a: null == a
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as Point,
      b: null == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as Point,
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
class _$LineImpl extends _Line with DiagnosticableTreeMixin {
  const _$LineImpl(
      {required this.a,
      required this.b,
      this.color = '#000000',
      this.thickness = 1.0})
      : super._();

  factory _$LineImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineImplFromJson(json);

  @override
  final Point a;
  @override
  final Point b;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final double thickness;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Line(a: $a, b: $b, color: $color, thickness: $thickness)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Line'))
      ..add(DiagnosticsProperty('a', a))
      ..add(DiagnosticsProperty('b', b))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('thickness', thickness));
  }

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineImplCopyWith<_$LineImpl> get copyWith =>
      __$$LineImplCopyWithImpl<_$LineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineImplToJson(
      this,
    );
  }
}

abstract class _Line extends Line {
  const factory _Line(
      {required final Point a,
      required final Point b,
      final String color,
      final double thickness}) = _$LineImpl;
  const _Line._() : super._();

  factory _Line.fromJson(Map<String, dynamic> json) = _$LineImpl.fromJson;

  @override
  Point get a;
  @override
  Point get b;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineImplCopyWith<_$LineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
