import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'point.dart';

part 'line.freezed.dart';
part 'line.g.dart';

@freezed
class Line with _$Line {
  const Line._();

  const factory Line({
    required Point a,
    required Point b,
    @Default('#000000') String color,
    @Default(1.0) double thickness,
  }) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  @override
  bool operator ==(covariant Line other) => other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);
}
