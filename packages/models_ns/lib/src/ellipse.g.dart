// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ellipse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EllipseImpl _$$EllipseImplFromJson(Map<String, dynamic> json) =>
    _$EllipseImpl(
      center: Point.fromJson(json['center'] as Map<String, dynamic>),
      semiMajorAxis: (json['semiMajorAxis'] as num).toDouble(),
      semiMinorAxis: (json['semiMinorAxis'] as num).toDouble(),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$EllipseImplToJson(_$EllipseImpl instance) =>
    <String, dynamic>{
      'center': instance.center,
      'semiMajorAxis': instance.semiMajorAxis,
      'semiMinorAxis': instance.semiMinorAxis,
      'color': instance.color,
      'thickness': instance.thickness,
    };
