// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'polygon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Polygon _$PolygonFromJson(Map<String, dynamic> json) {
  return _Polygon.fromJson(json);
}

/// @nodoc
mixin _$Polygon {
  List<Point> get points => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get thickness => throw _privateConstructorUsedError;

  /// Serializes this Polygon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Polygon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolygonCopyWith<Polygon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolygonCopyWith<$Res> {
  factory $PolygonCopyWith(Polygon value, $Res Function(Polygon) then) =
      _$PolygonCopyWithImpl<$Res, Polygon>;
  @useResult
  $Res call({List<Point> points, String color, double thickness});
}

/// @nodoc
class _$PolygonCopyWithImpl<$Res, $Val extends Polygon>
    implements $PolygonCopyWith<$Res> {
  _$PolygonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Polygon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(
      _value.copyWith(
            points:
                null == points
                    ? _value.points
                    : points // ignore: cast_nullable_to_non_nullable
                        as List<Point>,
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
}

/// @nodoc
abstract class _$$PolygonImplCopyWith<$Res> implements $PolygonCopyWith<$Res> {
  factory _$$PolygonImplCopyWith(
    _$PolygonImpl value,
    $Res Function(_$PolygonImpl) then,
  ) = __$$PolygonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Point> points, String color, double thickness});
}

/// @nodoc
class __$$PolygonImplCopyWithImpl<$Res>
    extends _$PolygonCopyWithImpl<$Res, _$PolygonImpl>
    implements _$$PolygonImplCopyWith<$Res> {
  __$$PolygonImplCopyWithImpl(
    _$PolygonImpl _value,
    $Res Function(_$PolygonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Polygon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? color = null,
    Object? thickness = null,
  }) {
    return _then(
      _$PolygonImpl(
        points:
            null == points
                ? _value._points
                : points // ignore: cast_nullable_to_non_nullable
                    as List<Point>,
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
class _$PolygonImpl extends _Polygon {
  const _$PolygonImpl({
    required final List<Point> points,
    this.color = '#000000',
    this.thickness = 1.0,
  }) : _points = points,
       super._();

  factory _$PolygonImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolygonImplFromJson(json);

  final List<Point> _points;
  @override
  List<Point> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

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
            other is _$PolygonImpl &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_points),
    color,
    thickness,
  );

  /// Create a copy of Polygon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolygonImplCopyWith<_$PolygonImpl> get copyWith =>
      __$$PolygonImplCopyWithImpl<_$PolygonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolygonImplToJson(this);
  }
}

abstract class _Polygon extends Polygon {
  const factory _Polygon({
    required final List<Point> points,
    final String color,
    final double thickness,
  }) = _$PolygonImpl;
  const _Polygon._() : super._();

  factory _Polygon.fromJson(Map<String, dynamic> json) = _$PolygonImpl.fromJson;

  @override
  List<Point> get points;
  @override
  String get color;
  @override
  double get thickness;

  /// Create a copy of Polygon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolygonImplCopyWith<_$PolygonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
