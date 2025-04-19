// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineImpl _$$LineImplFromJson(Map<String, dynamic> json) => _$LineImpl(
  a: Point.fromJson(json['a'] as Map<String, dynamic>),
  b: Point.fromJson(json['b'] as Map<String, dynamic>),
  color: json['color'] as String? ?? '#000000',
  thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$$LineImplToJson(_$LineImpl instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'color': instance.color,
      'thickness': instance.thickness,
    };
