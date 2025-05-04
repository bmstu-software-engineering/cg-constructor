// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TriangleImpl _$$TriangleImplFromJson(Map<String, dynamic> json) =>
    _$TriangleImpl(
      a: Point.fromJson(json['a'] as Map<String, dynamic>),
      b: Point.fromJson(json['b'] as Map<String, dynamic>),
      c: Point.fromJson(json['c'] as Map<String, dynamic>),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$TriangleImplToJson(_$TriangleImpl instance) =>
    <String, dynamic>{
      'a': instance.a.toJson(),
      'b': instance.b.toJson(),
      'c': instance.c.toJson(),
      'color': instance.color,
      'thickness': instance.thickness,
    };
