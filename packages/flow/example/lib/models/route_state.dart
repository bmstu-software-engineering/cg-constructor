import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viewer/viewer.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const factory RouteState.home() = HomeRoute;

  const factory RouteState.viewer(Viewer viewer) = ViewerRoute;
}
