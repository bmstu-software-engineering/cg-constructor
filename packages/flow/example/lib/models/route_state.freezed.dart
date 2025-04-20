// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RouteState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() home,
    required TResult Function(Viewer viewer) viewer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? home,
    TResult? Function(Viewer viewer)? viewer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? home,
    TResult Function(Viewer viewer)? viewer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeRoute value) home,
    required TResult Function(ViewerRoute value) viewer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeRoute value)? home,
    TResult? Function(ViewerRoute value)? viewer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeRoute value)? home,
    TResult Function(ViewerRoute value)? viewer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStateCopyWith<$Res> {
  factory $RouteStateCopyWith(
    RouteState value,
    $Res Function(RouteState) then,
  ) = _$RouteStateCopyWithImpl<$Res, RouteState>;
}

/// @nodoc
class _$RouteStateCopyWithImpl<$Res, $Val extends RouteState>
    implements $RouteStateCopyWith<$Res> {
  _$RouteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HomeRouteImplCopyWith<$Res> {
  factory _$$HomeRouteImplCopyWith(
    _$HomeRouteImpl value,
    $Res Function(_$HomeRouteImpl) then,
  ) = __$$HomeRouteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeRouteImplCopyWithImpl<$Res>
    extends _$RouteStateCopyWithImpl<$Res, _$HomeRouteImpl>
    implements _$$HomeRouteImplCopyWith<$Res> {
  __$$HomeRouteImplCopyWithImpl(
    _$HomeRouteImpl _value,
    $Res Function(_$HomeRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeRouteImpl with DiagnosticableTreeMixin implements HomeRoute {
  const _$HomeRouteImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RouteState.home()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'RouteState.home'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeRouteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() home,
    required TResult Function(Viewer viewer) viewer,
  }) {
    return home();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? home,
    TResult? Function(Viewer viewer)? viewer,
  }) {
    return home?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? home,
    TResult Function(Viewer viewer)? viewer,
    required TResult orElse(),
  }) {
    if (home != null) {
      return home();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeRoute value) home,
    required TResult Function(ViewerRoute value) viewer,
  }) {
    return home(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeRoute value)? home,
    TResult? Function(ViewerRoute value)? viewer,
  }) {
    return home?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeRoute value)? home,
    TResult Function(ViewerRoute value)? viewer,
    required TResult orElse(),
  }) {
    if (home != null) {
      return home(this);
    }
    return orElse();
  }
}

abstract class HomeRoute implements RouteState {
  const factory HomeRoute() = _$HomeRouteImpl;
}

/// @nodoc
abstract class _$$ViewerRouteImplCopyWith<$Res> {
  factory _$$ViewerRouteImplCopyWith(
    _$ViewerRouteImpl value,
    $Res Function(_$ViewerRouteImpl) then,
  ) = __$$ViewerRouteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Viewer viewer});
}

/// @nodoc
class __$$ViewerRouteImplCopyWithImpl<$Res>
    extends _$RouteStateCopyWithImpl<$Res, _$ViewerRouteImpl>
    implements _$$ViewerRouteImplCopyWith<$Res> {
  __$$ViewerRouteImplCopyWithImpl(
    _$ViewerRouteImpl _value,
    $Res Function(_$ViewerRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? viewer = null}) {
    return _then(
      _$ViewerRouteImpl(
        null == viewer
            ? _value.viewer
            : viewer // ignore: cast_nullable_to_non_nullable
                as Viewer,
      ),
    );
  }
}

/// @nodoc

class _$ViewerRouteImpl with DiagnosticableTreeMixin implements ViewerRoute {
  const _$ViewerRouteImpl(this.viewer);

  @override
  final Viewer viewer;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RouteState.viewer(viewer: $viewer)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RouteState.viewer'))
      ..add(DiagnosticsProperty('viewer', viewer));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ViewerRouteImpl &&
            (identical(other.viewer, viewer) || other.viewer == viewer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, viewer);

  /// Create a copy of RouteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ViewerRouteImplCopyWith<_$ViewerRouteImpl> get copyWith =>
      __$$ViewerRouteImplCopyWithImpl<_$ViewerRouteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() home,
    required TResult Function(Viewer viewer) viewer,
  }) {
    return viewer(this.viewer);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? home,
    TResult? Function(Viewer viewer)? viewer,
  }) {
    return viewer?.call(this.viewer);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? home,
    TResult Function(Viewer viewer)? viewer,
    required TResult orElse(),
  }) {
    if (viewer != null) {
      return viewer(this.viewer);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeRoute value) home,
    required TResult Function(ViewerRoute value) viewer,
  }) {
    return viewer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeRoute value)? home,
    TResult? Function(ViewerRoute value)? viewer,
  }) {
    return viewer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeRoute value)? home,
    TResult Function(ViewerRoute value)? viewer,
    required TResult orElse(),
  }) {
    if (viewer != null) {
      return viewer(this);
    }
    return orElse();
  }
}

abstract class ViewerRoute implements RouteState {
  const factory ViewerRoute(final Viewer viewer) = _$ViewerRouteImpl;

  Viewer get viewer;

  /// Create a copy of RouteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ViewerRouteImplCopyWith<_$ViewerRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
