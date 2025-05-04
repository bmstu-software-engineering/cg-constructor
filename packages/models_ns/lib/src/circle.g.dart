// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CircleImpl _$$CircleImplFromJson(Map<String, dynamic> json) => _$CircleImpl(
      center: Point.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$CircleImplToJson(_$CircleImpl instance) =>
    <String, dynamic>{
      'center': instance.center,
      'radius': instance.radius,
      'color': instance.color,
      'thickness': instance.thickness,
    };
