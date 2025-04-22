// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolygonImpl _$$PolygonImplFromJson(Map<String, dynamic> json) =>
    _$PolygonImpl(
      points: (json['points'] as List<dynamic>)
          .map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$PolygonImplToJson(_$PolygonImpl instance) =>
    <String, dynamic>{
      'points': instance.points,
      'color': instance.color,
      'thickness': instance.thickness,
    };
