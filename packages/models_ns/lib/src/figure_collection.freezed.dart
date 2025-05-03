// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'figure_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FigureCollection _$FigureCollectionFromJson(Map<String, dynamic> json) {
  return _FigureCollection.fromJson(json);
}

/// @nodoc
mixin _$FigureCollection {
  /// Список точек
  List<Point> get points => throw _privateConstructorUsedError;

  /// Список линий
  List<Line> get lines => throw _privateConstructorUsedError;

  /// Список треугольников
  List<Triangle> get triangles => throw _privateConstructorUsedError;

  /// Serializes this FigureCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FigureCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FigureCollectionCopyWith<FigureCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FigureCollectionCopyWith<$Res> {
  factory $FigureCollectionCopyWith(
    FigureCollection value,
    $Res Function(FigureCollection) then,
  ) = _$FigureCollectionCopyWithImpl<$Res, FigureCollection>;
  @useResult
  $Res call({List<Point> points, List<Line> lines, List<Triangle> triangles});
}

/// @nodoc
class _$FigureCollectionCopyWithImpl<$Res, $Val extends FigureCollection>
    implements $FigureCollectionCopyWith<$Res> {
  _$FigureCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FigureCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? lines = null,
    Object? triangles = null,
  }) {
    return _then(
      _value.copyWith(
            points:
                null == points
                    ? _value.points
                    : points // ignore: cast_nullable_to_non_nullable
                        as List<Point>,
            lines:
                null == lines
                    ? _value.lines
                    : lines // ignore: cast_nullable_to_non_nullable
                        as List<Line>,
            triangles:
                null == triangles
                    ? _value.triangles
                    : triangles // ignore: cast_nullable_to_non_nullable
                        as List<Triangle>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FigureCollectionImplCopyWith<$Res>
    implements $FigureCollectionCopyWith<$Res> {
  factory _$$FigureCollectionImplCopyWith(
    _$FigureCollectionImpl value,
    $Res Function(_$FigureCollectionImpl) then,
  ) = __$$FigureCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Point> points, List<Line> lines, List<Triangle> triangles});
}

/// @nodoc
class __$$FigureCollectionImplCopyWithImpl<$Res>
    extends _$FigureCollectionCopyWithImpl<$Res, _$FigureCollectionImpl>
    implements _$$FigureCollectionImplCopyWith<$Res> {
  __$$FigureCollectionImplCopyWithImpl(
    _$FigureCollectionImpl _value,
    $Res Function(_$FigureCollectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FigureCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? lines = null,
    Object? triangles = null,
  }) {
    return _then(
      _$FigureCollectionImpl(
        points:
            null == points
                ? _value._points
                : points // ignore: cast_nullable_to_non_nullable
                    as List<Point>,
        lines:
            null == lines
                ? _value._lines
                : lines // ignore: cast_nullable_to_non_nullable
                    as List<Line>,
        triangles:
            null == triangles
                ? _value._triangles
                : triangles // ignore: cast_nullable_to_non_nullable
                    as List<Triangle>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FigureCollectionImpl extends _FigureCollection {
  const _$FigureCollectionImpl({
    final List<Point> points = const [],
    final List<Line> lines = const [],
    final List<Triangle> triangles = const [],
  }) : _points = points,
       _lines = lines,
       _triangles = triangles,
       super._();

  factory _$FigureCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FigureCollectionImplFromJson(json);

  /// Список точек
  final List<Point> _points;

  /// Список точек
  @override
  @JsonKey()
  List<Point> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// Список линий
  final List<Line> _lines;

  /// Список линий
  @override
  @JsonKey()
  List<Line> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Список треугольников
  final List<Triangle> _triangles;

  /// Список треугольников
  @override
  @JsonKey()
  List<Triangle> get triangles {
    if (_triangles is EqualUnmodifiableListView) return _triangles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triangles);
  }

  @override
  String toString() {
    return 'FigureCollection(points: $points, lines: $lines, triangles: $triangles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FigureCollectionImpl &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            const DeepCollectionEquality().equals(
              other._triangles,
              _triangles,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_points),
    const DeepCollectionEquality().hash(_lines),
    const DeepCollectionEquality().hash(_triangles),
  );

  /// Create a copy of FigureCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FigureCollectionImplCopyWith<_$FigureCollectionImpl> get copyWith =>
      __$$FigureCollectionImplCopyWithImpl<_$FigureCollectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FigureCollectionImplToJson(this);
  }
}

abstract class _FigureCollection extends FigureCollection {
  const factory _FigureCollection({
    final List<Point> points,
    final List<Line> lines,
    final List<Triangle> triangles,
  }) = _$FigureCollectionImpl;
  const _FigureCollection._() : super._();

  factory _FigureCollection.fromJson(Map<String, dynamic> json) =
      _$FigureCollectionImpl.fromJson;

  /// Список точек
  @override
  List<Point> get points;

  /// Список линий
  @override
  List<Line> get lines;

  /// Список треугольников
  @override
  List<Triangle> get triangles;

  /// Create a copy of FigureCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FigureCollectionImplCopyWith<_$FigureCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
