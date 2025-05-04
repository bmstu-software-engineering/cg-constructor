// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArcImpl _$$ArcImplFromJson(Map<String, dynamic> json) => _$ArcImpl(
      center: Point.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      startAngle: (json['startAngle'] as num).toDouble(),
      endAngle: (json['endAngle'] as num).toDouble(),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$ArcImplToJson(_$ArcImpl instance) => <String, dynamic>{
      'center': instance.center,
      'radius': instance.radius,
      'startAngle': instance.startAngle,
      'endAngle': instance.endAngle,
      'color': instance.color,
      'thickness': instance.thickness,
    };
